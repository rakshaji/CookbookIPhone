;//
//  RSDatabaseAccess.m
//  Cookbook
//
//  Created by Raksha Singhania on 28/11/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import "RSDatabaseAccess.h"
#import "sqlite3.h"
#import "RSRecipe.h"
#import "RSUtility.h"

@implementation RSDatabaseAccess

static NSString * const databaseName = @"Cookbook.sqlite";

static NSString * const selectAllRecipes = @"SELECT RecipeId, RecipeTitle, ImagePath FROM Recipe ORDER BY RecipeTitle ASC";
static NSString * const selectLastRecipeId = @"SELECT max(RecipeId) FROM Recipe";
static NSString * const selectAllCuisines = @"SELECT CuisineId, CuisineName FROM Cuisine ORDER BY CuisineName ASC";
static NSString * const selectAllCollections = @"SELECT CollectionId, CollectionName FROM Collection ORDER BY CollectionName ASC";

static NSString * const insertRecipe = @"INSERT OR REPLACE INTO Recipe (RecipeTitle, CuisineId, Website, Rating, CookTime, PrepTime, TotalTime, Calories, ImagePath, Yields, Notes, RecipeId) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)";

static NSString * const insertToIngredients = @"INSERT OR REPLACE INTO Ingredients (Amount, Unit, Item, IngredientId) VALUES (?,?,?,?)";

static NSString * const insertToIngredientLookup = @"INSERT OR REPLACE INTO Lookup_Recipe_Ingredients (ingredientId, recipeId) VALUES (?, ?)";

static NSString * const insertCollection = @"INSERT OR REPLACE INTO Collection (CollectionName, CollectionId) VALUES(?, ?)";

static NSString * const deleteRecipeFromCollection = @"DELETE FROM Lookup_Recipe_Collection WHERE CollectionId = ? and RecipeId in (?)";

static sqlite3 *database;

static RSDatabaseAccess * instance = NULL;

+ (RSDatabaseAccess *)instance {
    if (instance == NULL) {
        instance = [self new];
    }
    return instance;
}

-(void)copyDatabaseIntoDocumentsDirectory{
    // Check if the database file exists in the documents directory.
    NSString *destinationPath = [self databasePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        // Check if any error occurred during copying and display it.
        if (error != nil) {
            NSLog(@"Error while copying database - %@", [error localizedDescription]);
        }
    }
}

- (BOOL)open {
    if (self.isOpen) {
        return YES;
    }
    self.isOpen = YES;
    
    // copy database if does not exists
    [self copyDatabaseIntoDocumentsDirectory];
    
    if (sqlite3_open([[self databasePath] UTF8String], &database) != SQLITE_OK) {
        [self close];
        self.isOpen = NO;
    }
    return self.isOpen;
}

- (void)close {
    if (!self.isOpen) return;
    sqlite3_close(database);
    database = nil;
}

- (NSString * ) databasePath {
    NSString * appHome = NSHomeDirectory();
    NSString * documents = [appHome stringByAppendingPathComponent:@"Documents"];
    return [documents stringByAppendingPathComponent: databaseName];
}

#pragma mark - Fetch all queries

- (NSInteger)fetchLastRecipeId {
    if (![self open]) {
        return -1;
    }
    
    NSInteger lastId = -1;
    sqlite3_stmt *read;
    
    if (sqlite3_prepare_v2(database, [selectLastRecipeId UTF8String], -1, &read, nil) == SQLITE_OK) {
        while (sqlite3_step(read) == SQLITE_ROW) {
            const char* lastId_tmp = (const char*) sqlite3_column_text(read, 0);
            
            lastId = lastId_tmp == nil ? 0 : [[[NSString alloc] initWithUTF8String:lastId_tmp] integerValue];
        }
    }
    sqlite3_finalize(read);
    
    return lastId;
}

- (NSMutableArray*)fetchAllRecipes {
    if (![self open]) {
        return nil;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *read;
    
    if (sqlite3_prepare_v2(database, [selectAllRecipes UTF8String], -1, &read, nil) == SQLITE_OK) {
        while (sqlite3_step(read) == SQLITE_ROW) {
            @autoreleasepool {
                
                RSRecipe *recipe = [RSRecipe new];
                recipe.recipeId = sqlite3_column_int(read, 0);

                recipe.recipeTitle = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(read, 1)];
                
                const char* path_tmp = (const char*)sqlite3_column_text(read, 2);
                recipe.imagePath = path_tmp == NULL ? nil : [[NSString alloc] initWithUTF8String:path_tmp];
                
                [array addObject:recipe];
            }
        }
    }
    sqlite3_finalize(read);
    return array;
}

- (RSRecipe*)fetchRecipeWithRecipeId:(NSInteger)recipeId {
    if (![self open]) {
        return nil;
    }
    
    RSRecipe *recipe = [RSRecipe new];
    
    sqlite3_stmt *read;
    
    NSString *selectRecipe = [NSString stringWithFormat:@"SELECT recipeId, recipeTitle, website, rating, cooktime, preptime, totaltime, calories, yields, notes, imagepath FROM RECIPE where recipeid = %ld", (long)recipeId];
    
    if (sqlite3_prepare_v2(database, [selectRecipe UTF8String], -1, &read, nil) == SQLITE_OK) {
        while (sqlite3_step(read) == SQLITE_ROW) {
            
            recipe.recipeId = [[[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(read, 0)] integerValue];
            
            const char* path_tmp = (const char*)sqlite3_column_text(read, 1);
            recipe.recipeTitle = path_tmp == NULL ? nil : [[NSString alloc] initWithUTF8String:path_tmp];
            
            path_tmp = (const char*)sqlite3_column_text(read, 2);
            recipe.website = path_tmp == NULL ? nil : [[NSString alloc] initWithUTF8String:path_tmp];
            
            path_tmp = (const char*)sqlite3_column_text(read, 3);
            recipe.rating = path_tmp == NULL ? nil : [[NSString alloc] initWithUTF8String:path_tmp];
            
            path_tmp = (const char*)sqlite3_column_text(read, 4);
            recipe.cookTime = path_tmp == NULL ? nil : [[NSString alloc] initWithUTF8String:path_tmp];
            
            path_tmp = (const char*)sqlite3_column_text(read, 5);
            recipe.prepTime = path_tmp == NULL ? nil : [[NSString alloc] initWithUTF8String:path_tmp];
            
            path_tmp = (const char*)sqlite3_column_text(read, 6);
            recipe.totalTime = path_tmp == NULL ? nil : [[NSString alloc] initWithUTF8String:path_tmp];
            
            path_tmp = (const char*)sqlite3_column_text(read, 7);
            recipe.calories = path_tmp == NULL ? nil : [[NSString alloc] initWithUTF8String:path_tmp];
            
            path_tmp = (const char*)sqlite3_column_text(read, 8);
            recipe.yields = path_tmp == NULL ? nil : [[NSString alloc] initWithUTF8String:path_tmp];
            
            path_tmp = (const char*)sqlite3_column_text(read, 9);
            recipe.notes = path_tmp == NULL ? nil : [[NSString alloc] initWithUTF8String:path_tmp];
            
            path_tmp = (const char*)sqlite3_column_text(read, 10);
            recipe.imagePath = path_tmp == NULL ? nil : [[NSString alloc] initWithUTF8String:path_tmp];
            
        }
    }
    sqlite3_finalize(read);
    
    recipe.collection = [self fetchCollectionForRecipeId:recipeId];
    recipe.steps = [self fetchStepsForRecipeId:recipeId];
    recipe.ingredient = [self fetchIngredientsForRecipeId:recipeId];
    recipe.cuisine = [self fetchCuisineForRecipeId:recipeId];
    
    return recipe;
}

- (NSMutableArray*)fetchAllCuisines {
    if (![self open]) {
        return nil;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *read;
    
    if (sqlite3_prepare_v2(database, [selectAllCuisines UTF8String], -1, &read, nil) == SQLITE_OK) {
        while (sqlite3_step(read) == SQLITE_ROW) {
            RSCuisine *cuisine = [RSCuisine new];
            
            cuisine.cuisineId = [[[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(read, 0)] integerValue];
            cuisine.cuisineName = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(read, 1)];
            [array addObject:cuisine];
        }
    }
    sqlite3_finalize(read);
    return array;
}


- (NSMutableArray*)fetchAllCollections {
    if (![self open]) {
        return nil;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *read;
    
    if (sqlite3_prepare_v2(database, [selectAllCollections UTF8String], -1, &read, nil) == SQLITE_OK) {
        while (sqlite3_step(read) == SQLITE_ROW) {
            RSCollection *collection = [RSCollection new];
            collection.collectionId = [[[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(read, 0)] integerValue];
            collection.collectionName = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(read, 1)];
            [array addObject:collection];
        }
    }
    sqlite3_finalize(read);
    return array;
}

- (RSCuisine*)fetchCuisineForRecipeId:(NSInteger)recipeId {
    if (![self open]) {
        return nil;
    }
    
    RSCuisine *cuisine = [RSCuisine new];
    
    sqlite3_stmt *read;
    
    NSString *query =[NSString stringWithFormat:@"SELECT c.cuisineid, c.cuisinename FROM RECIPE AS r inner join cuisine as c on r.cuisineid = c.cuisineid where r.recipeid = %ld", (long)recipeId];
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &read, nil) == SQLITE_OK) {
        while (sqlite3_step(read) == SQLITE_ROW) {
            
            const char* path_tmp = (const char*)sqlite3_column_text(read, 0);
            cuisine.cuisineId = path_tmp == NULL ? -1 : [[[NSString alloc] initWithUTF8String:path_tmp] integerValue];
            
            path_tmp = (const char*)sqlite3_column_text(read, 1);
            cuisine.cuisineName = path_tmp == NULL ? nil : [[NSString alloc] initWithUTF8String:path_tmp];
        }
    }
    sqlite3_finalize(read);
    return cuisine;
}

- (NSMutableArray*)fetchCollectionForRecipeId:(NSInteger)recipeId {
    if (![self open]) {
        return nil;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *read;
    
    NSString *query =[NSString stringWithFormat:@"SELECT C.COLLECTIONID, C.COLLECTIONNAME FROM COLLECTION AS C INNER JOIN LOOKUP_RECIPE_COLLECTION AS LKC ON LKC.collectionid = c.collectionid where lkc.RECIPEID = %ld", (long)recipeId];
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &read, nil) == SQLITE_OK) {
        while (sqlite3_step(read) == SQLITE_ROW) {
            RSCollection *collection = [RSCollection new];
            collection.collectionId = [[[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(read, 0)] integerValue];
            collection.collectionName = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(read, 1)];
            [array addObject:collection];
        }
    }
    sqlite3_finalize(read);
    return array;
}

- (NSMutableArray*)fetchIngredientsForRecipeId:(NSInteger)recipeId {
    if (![self open]) {
        return nil;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *read;
    
    NSString *query =[NSString stringWithFormat:@"SELECT i.ingredientId, i.amount, i.unit, i.item FROM ingredients as i INNER JOIN Lookup_Recipe_Ingredients as lki on lki.ingredientId = i.ingredientId INNER JOIN Recipe as r on r.recipeid = lki.recipeId where r.recipeId = %ld", (long)recipeId];
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &read, nil) == SQLITE_OK) {
        while (sqlite3_step(read) == SQLITE_ROW) {
            RSIngredient *ingredient = [RSIngredient new];
            ingredient.ingredientId = sqlite3_column_int(read, 0);
            
            const char* path_tmp = (const char*)sqlite3_column_text(read, 1);
            ingredient.amount = path_tmp == NULL ? nil : [[NSString alloc] initWithUTF8String:path_tmp];
            
            path_tmp = (const char*)sqlite3_column_text(read, 2);
            ingredient.unit = path_tmp == NULL ? nil : [[NSString alloc] initWithUTF8String:path_tmp];
            
            path_tmp = (const char*)sqlite3_column_text(read, 3);
            ingredient.itemName = path_tmp == NULL ? nil : [[NSString alloc] initWithUTF8String:path_tmp];
            
            [array addObject:ingredient];
        }
    }
    sqlite3_finalize(read);
    return array;
}

- (NSMutableArray*)fetchStepsForRecipeId:(NSInteger)recipeId {
    if (![self open]) {
        return nil;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *read;
    
    NSString *query =[NSString stringWithFormat:@"SELECT s.stepId, s.instruction FROM Steps as s INNER JOIN Lookup_Recipe_Steps as lks on lks.stepid = s.stepid INNER JOIN Recipe as r on r.recipeid = lks.recipeId where r.recipeId = %ld", (long)recipeId];
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &read, nil) == SQLITE_OK) {
        while (sqlite3_step(read) == SQLITE_ROW) {
            RSSteps *step = [RSSteps new];
            step.stepId = sqlite3_column_int(read, 0);
            
            const char* path_tmp = (const char*)sqlite3_column_text(read, 1);
            step.instruction = path_tmp == NULL ? nil : [[NSString alloc] initWithUTF8String:path_tmp];
            
            [array addObject:step];
        }
    }
    sqlite3_finalize(read);
    return array;
}
    
- (NSNumber *)fetchCuisineIdForCuisine:(NSString*)name {
    if (![self open]) {
        return nil;
    }
    
    NSInteger cuisineId = -1;
    
    sqlite3_stmt *read;
    NSString *query = [NSString stringWithFormat:@"Select cuisineId from cuisine where cuisinename = %@", name];
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &read, nil) == SQLITE_OK) {
        while (sqlite3_step(read) == SQLITE_ROW) {
            cuisineId = [[[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(read, 0)] integerValue];
        }
    }
    sqlite3_finalize(read);
    
    return [NSNumber numberWithInteger:cuisineId];
}

- (NSMutableArray*)fetchAllRecipesByCollectionId:(NSInteger)collectionId {
    if (![self open]) {
        return nil;
    }
    
    sqlite3_stmt *read;
    NSString *query = [NSString stringWithFormat:@"SELECT r.recipeId, r.recipeTitle, r.imagepath FROM recipe as r INNER JOIN Lookup_Recipe_Collection AS lkc ON r.recipeId = lkc.recipeId INNER JOIN collection AS c on c.collectionId = lkc.collectionid WHERE c.collectionId = %ld", (long)collectionId];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &read, nil) == SQLITE_OK) {
        while (sqlite3_step(read) == SQLITE_ROW) {
            RSRecipe *recipe = [RSRecipe new];
            
            recipe.recipeId = [[[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(read, 0)] integerValue];
            recipe.recipeTitle = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(read, 1)];
            
            const char* path_tmp = (const char*)sqlite3_column_text(read, 2);
            recipe.imagePath = path_tmp == NULL ? nil : [[NSString alloc] initWithUTF8String:path_tmp];
            
            [array addObject:recipe];
        }
    }
    
    sqlite3_finalize(read);
    
    return array;
}

#pragma mark - Search

- (NSMutableArray *)searchRecipeBySearchCriteria:(NSString *)criteria {
    if ([RSUtility checkIfBlankOrNil:criteria]) {
        return nil;
    }
    
    if (![self open]) {
        return nil;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *read;
    
    NSString *searchQuery = [NSString stringWithFormat:@"SELECT distinct recipetitle, imagepath, recipeid FROM V_ALL_RECIPE_DETAILS WHERE %@ ", criteria];
    
    if (sqlite3_prepare_v2(database, [searchQuery UTF8String], -1, &read, nil) == SQLITE_OK) {
        
        sqlite3_bind_text(read, 1, [criteria UTF8String], -1, NULL);
        
        while (sqlite3_step(read) == SQLITE_ROW) {
            RSRecipe *recipe = [RSRecipe new];
            recipe.recipeTitle = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(read, 0)];
            
            const char* path_tmp = (const char*)sqlite3_column_text(read, 1);
            recipe.imagePath = path_tmp == NULL ? nil : [[NSString alloc] initWithUTF8String:path_tmp];
            
            path_tmp = (const char*)sqlite3_column_text(read, 2);
            recipe.recipeId = path_tmp == NULL ? -1 : [[[NSString alloc] initWithUTF8String:path_tmp] integerValue];
            
            [array addObject:recipe];
        }
    }
    sqlite3_finalize(read);
    return array;
}

#pragma mark - Recipe Table
- (BOOL)deleteRecipes:(NSMutableArray *)recipes fromCollection:(NSInteger)collectionId {
    if (![self open]) {
        return NO;
    }
    
    NSMutableString *recipesCommaSeparated = [NSMutableString string];
    for (RSRecipe *recipe in recipes) {
        if ([RSUtility checkIfBlankOrNil:recipesCommaSeparated]) {
            [recipesCommaSeparated appendString:@(recipe.recipeId).stringValue];
        }
        else {
            [recipesCommaSeparated appendFormat:@", %@", @(recipe.recipeId).stringValue];
        }
    }
    
    NSString *query = [NSString stringWithFormat:@"DELETE FROM Lookup_Recipe_Collection WHERE CollectionId = %@ and RecipeId in (%@)", @(collectionId).stringValue, recipesCommaSeparated];
    
    char * errMsg;
    int rc = 0;
    rc = sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg);
    if(SQLITE_OK != rc)
    {
        NSLog(@"Failed to delete record  rc:%d, msg=%s",rc,errMsg);
    }
    
    return YES;
}

- (BOOL)deleteCollectionsForRecipes:(NSMutableArray *)recipes {
    
    NSMutableString *recipesCommaSeparated = [NSMutableString string];
    for (RSRecipe *recipe in recipes) {
        if ([RSUtility checkIfBlankOrNil:recipesCommaSeparated]) {
            [recipesCommaSeparated appendString:@(recipe.recipeId).stringValue];
        }
        else {
            [recipesCommaSeparated appendFormat:@", %@", @(recipe.recipeId).stringValue];
        }
    }
    
    NSString *query = [NSString stringWithFormat:@"Delete from Lookup_Recipe_Collection where recipeid in (%@)", recipesCommaSeparated];
    
    char * errMsg;
    int rc = 0;
    rc = sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg);
    if(SQLITE_OK != rc)
     {
        NSLog(@"Failed to delete record  rc:%d, msg=%s",rc,errMsg);
     }
    
    return YES;
}

- (BOOL)addCollection:(NSMutableArray *)collections forRecipes:(NSMutableArray *)recipes {
    if (![self open])
        return NO;
    
    if (![self deleteCollectionsForRecipes:recipes]) {
        return NO;
    }
    
    NSString *query = @"INSERT OR REPLACE INTO Lookup_Recipe_Collection (collectionid, recipeid) VALUES (?, ?)";
    
    for (RSCollection *collection in collections) {
        for (RSRecipe *recipe in recipes) {
            @autoreleasepool {
                sqlite3_stmt *insert;
                if (sqlite3_prepare_v2(database, [query UTF8String], -1, &insert, nil) == SQLITE_OK) {
                    sqlite3_bind_int(insert, 1, @(collection.collectionId).intValue);
                    sqlite3_bind_text(insert, 2, [@(recipe.recipeId).stringValue UTF8String], -1, NULL);
                }
                
                if (sqlite3_step(insert) != SQLITE_DONE) {
                    NSLog(@"ERROR: SQL FAILED - %s", sqlite3_errmsg(database));
                    return NO;
                }
                sqlite3_finalize(insert);
            }
        }
    }
        
    return YES;
}

- (BOOL)addCollection:(NSMutableArray *)collections forRecipeId:(NSInteger)recipeId {
    if (![self open])
        return NO;
    
    if (![self deleteCollection:collections forRecipeId:recipeId]) {
        return NO;
    }
    
    NSString *query = @"INSERT OR REPLACE INTO Lookup_Recipe_Collection (collectionid, recipeid) VALUES (?, ?)";
    
    for (RSCollection *collection in collections) {
        sqlite3_stmt *insert;
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &insert, nil) == SQLITE_OK) {
            sqlite3_bind_int(insert, 1, @(collection.collectionId).intValue);
            sqlite3_bind_int(insert, 2, @(recipeId).intValue);
        }
        
        if (sqlite3_step(insert) != SQLITE_DONE) {
            NSLog(@"ERROR: SQL FAILED - %s", sqlite3_errmsg(database));
            return NO;
        }
        sqlite3_finalize(insert);
    }
    
    return YES;
}


- (BOOL)deleteCollection:(NSMutableArray *)collections forRecipeId:(NSInteger)recipeId {
    if (![self open])
        return NO;
    
    NSMutableString *collectionsCommaSeparated = [NSMutableString string];
    for (RSCollection *collection in collections) {
        if (collectionsCommaSeparated == nil) {
            [collectionsCommaSeparated appendString:@(collection.collectionId).stringValue];
        }
        else {
            [collectionsCommaSeparated appendFormat:@", %@", @(collection.collectionId).stringValue];
        }
    }
    
    sqlite3_stmt *delete;
    NSString *query = @"DELETE FROM Lookup_Recipe_Collection WHERE collectionid NOT IN (?) and recipeid = ? ";
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &delete, nil) == SQLITE_OK) {
        sqlite3_bind_text(delete, 1, [collectionsCommaSeparated UTF8String], -1, NULL);
        sqlite3_bind_int(delete, 2, @(recipeId).intValue);
    }
    
    if (sqlite3_step(delete) != SQLITE_DONE) {
        NSLog(@"ERROR: SQL FAILED - %s", sqlite3_errmsg(database));
        return NO;
    }
    sqlite3_finalize(delete);

    return YES;
}


- (BOOL)addSteps:(NSMutableArray *)steps forRecipeId:(NSInteger)recipeId {
    if (![self open])
        return NO;

    NSString *insertToSteps = @"INSERT OR REPLACE INTO Steps (stepid, instruction) VALUES (?,?)";
    
    for (RSSteps *step in steps) {
        @autoreleasepool {
            sqlite3_stmt *insert;
            if (sqlite3_prepare_v2(database, [insertToSteps UTF8String], -1, &insert, nil) == SQLITE_OK) {
                NSString *stepId;
                if (step.stepId != 0) {
                    stepId = @(step.stepId).stringValue;
                }
                sqlite3_bind_text(insert, 1, [stepId UTF8String] , -1, NULL);
                sqlite3_bind_text(insert, 2, [step.instruction UTF8String], -1, NULL);
            }
            
            if (sqlite3_step(insert) != SQLITE_DONE) {
                NSLog(@"ERROR: SQL FAILED - %s", sqlite3_errmsg(database));
                return NO;
            }
            sqlite3_finalize(insert);
            
            if (step.stepId <= 0) {
                step.stepId = (int)sqlite3_last_insert_rowid(database);
                if(step.stepId < 1) {
                    return NO;
                }
            }
            
            NSString *insertToStepLookup = @"INSERT OR REPLACE INTO Lookup_Recipe_Steps (stepId, recipeId) VALUES (?, ?)";
            
            sqlite3_stmt *insertInLookup;
            
            if (sqlite3_prepare_v2(database, [insertToStepLookup UTF8String], -1, &insertInLookup, nil) == SQLITE_OK) {
                sqlite3_bind_int(insertInLookup, 1, @(step.stepId).intValue);
                sqlite3_bind_int(insertInLookup, 2, @(recipeId).intValue);
            }
            
            if (sqlite3_step(insertInLookup) != SQLITE_DONE) {
                NSLog(@"ERROR: SQL FAILED - %s", sqlite3_errmsg(database));
                return NO;
            }
            sqlite3_finalize(insertInLookup);
        }
    }
    
    return YES;
}

- (BOOL)addIngredients:(NSMutableArray *)ingredients forRecipeId:(NSInteger)recipeId {
    if (![self open])
        return NO;
    
    BOOL isSuccess = NO;
    for (RSIngredient *ingredient in ingredients) {
        isSuccess = [self addIngredientsInIngredients:ingredient forRecipeId:recipeId];
    }
    
    return isSuccess;
}

- (BOOL)addIngredientsInIngredients:(RSIngredient *)ingredient forRecipeId:(NSInteger)recipeId {
    if (![self open])
        return NO;

    sqlite3_stmt *insert;
    
    if (sqlite3_prepare_v2(database, [insertToIngredients UTF8String], -1, &insert, nil) == SQLITE_OK) {
        sqlite3_bind_text(insert, 1, [ingredient.amount UTF8String], -1, NULL);
        sqlite3_bind_text(insert, 2, [ingredient.unit UTF8String], -1, NULL);
        sqlite3_bind_text(insert, 3, [ingredient.itemName UTF8String], -1, NULL);
        NSString *ingredientId;
        if (ingredient.ingredientId != 0) {
            ingredientId = @(ingredient.ingredientId).stringValue;
        }
        sqlite3_bind_text(insert, 4, [ingredientId UTF8String] , -1, NULL);
    }

    if (sqlite3_step(insert) != SQLITE_DONE) {
        NSLog(@"ERROR: SQL FAILED - %s", sqlite3_errmsg(database));
        return NO;
    }
    
    sqlite3_finalize(insert);
    
    if (ingredient.ingredientId <= 0) {
        ingredient.ingredientId = (int)sqlite3_last_insert_rowid(database);
        if(ingredient.ingredientId < 1) {
            return NO;
        }
    }
    
    BOOL isSuccess = [self addIngredientsInLookup:ingredient forRecipeId:recipeId];
    if (!isSuccess) {
        return NO;
    }
    
    return YES;
}

- (BOOL)addIngredientsInLookup:(RSIngredient *)ingredient forRecipeId:(NSInteger)recipeId {
    if (![self open])
        return NO;

    sqlite3_stmt *insertInLookup;
    
    if (sqlite3_prepare_v2(database, [insertToIngredientLookup UTF8String], -1, &insertInLookup, nil) == SQLITE_OK) {
        sqlite3_bind_text(insertInLookup, 1, [@(ingredient.ingredientId).stringValue UTF8String], -1, NULL);
        sqlite3_bind_text(insertInLookup, 2, [@(recipeId).stringValue UTF8String], -1, NULL);
    }
    
    if (sqlite3_step(insertInLookup) != SQLITE_DONE) {
        NSLog(@"ERROR: SQL FAILED - %s", sqlite3_errmsg(database));
        return NO;
    }
    sqlite3_finalize(insertInLookup);
    
    
    return YES;
}

- (BOOL)addRecipe:(RSRecipe *)aRecipe {
    if (![self open])
        return NO;
    
    sqlite3_stmt *insert;
    
    if (sqlite3_prepare_v2(database, [insertRecipe UTF8String], -1, &insert, nil) == SQLITE_OK) {
        sqlite3_bind_text(insert, 1, [aRecipe.recipeTitle UTF8String], -1, NULL);
        if (aRecipe.cuisine != nil && aRecipe.cuisine.cuisineId > 0) {
            sqlite3_bind_int(insert, 2, @(aRecipe.cuisine.cuisineId).intValue);
        } else {
            sqlite3_bind_text(insert, 2, nil, -1, NULL);
        }
        sqlite3_bind_text(insert, 3, [aRecipe.website UTF8String], -1, NULL);
        sqlite3_bind_text(insert, 4, [aRecipe.rating UTF8String], -1, NULL);
        sqlite3_bind_text(insert, 5, [aRecipe.cookTime UTF8String], -1, NULL);
        sqlite3_bind_text(insert, 6, [aRecipe.prepTime UTF8String], -1, NULL);
        sqlite3_bind_text(insert, 7, [aRecipe.totalTime UTF8String], -1, NULL);
        sqlite3_bind_text(insert, 8, [aRecipe.calories UTF8String], -1, NULL);
        sqlite3_bind_text(insert, 9, [aRecipe.imagePath UTF8String], -1, NULL);
        sqlite3_bind_text(insert, 10, [aRecipe.yields UTF8String], -1, NULL);
        sqlite3_bind_text(insert, 11, [aRecipe.notes UTF8String], -1, NULL);
        NSString *recipeId;
        if (aRecipe.recipeId != 0) {
            recipeId = @(aRecipe.recipeId).stringValue;
        }
        sqlite3_bind_text(insert, 12, [recipeId UTF8String] , -1, NULL);
                                           
    }
    
    if (sqlite3_step(insert) != SQLITE_DONE) {
        NSLog(@"ERROR: SQL FAILED - %s", sqlite3_errmsg(database));
        return NO;
    }
    
    sqlite3_finalize(insert);
    if (aRecipe.recipeId == 0) {
        aRecipe.recipeId = (int)sqlite3_last_insert_rowid(database);
        if(aRecipe.recipeId < 1) {
            return NO;
        }
    }
    if (aRecipe.collection.count > 0) {
        if (![self addCollection:aRecipe.collection forRecipeId:aRecipe.recipeId]) {
            return NO;
        }
    }
    
    if (aRecipe.steps.count > 0) {
        // insert steps
        if (![self addSteps:aRecipe.steps forRecipeId:aRecipe.recipeId]) {
            return NO;
        }
    }
    
    if (aRecipe.ingredient.count > 0) {
        // insert ingredient
        if (![self addIngredients:aRecipe.ingredient forRecipeId:aRecipe.recipeId]) {
            return NO;
        }
    }
    
    return YES;
}


#pragma mark - Collection

- (BOOL)addCollection:(RSCollection *)aCollection  {
    if (![self open])
        return NO;
    
    sqlite3_stmt *insert;
    
    if (sqlite3_prepare_v2(database, [insertCollection UTF8String], -1, &insert, nil) == SQLITE_OK) {
        sqlite3_bind_text(insert, 1, [aCollection.collectionName UTF8String], -1, NULL);
    }
    
    if (sqlite3_step(insert) != SQLITE_DONE) {
        NSLog(@"ERROR: SQL FAILED - %s", sqlite3_errmsg(database));
        return NO;
    }
    
    sqlite3_finalize(insert);
    return YES;
}

@end
