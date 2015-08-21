//
//  RSDatabaseAccess.h
//  Cookbook
//
//  Created by Raksha Singhania on 28/11/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSRecipe.h"
#import "RSCollection.h"
#import "RSIngredient.h"
#import "RSSteps.h"
#import "RSCuisine.h"

@interface RSDatabaseAccess : NSObject 

@property BOOL isOpen;

+ (RSDatabaseAccess *) instance ;

- (BOOL) open;
- (void) close;
- (NSString * ) databasePath;
- (void)copyDatabaseIntoDocumentsDirectory;

- (NSInteger)fetchLastRecipeId ;
- (NSMutableArray*)fetchAllRecipes;
- (NSMutableArray*)fetchAllCollections;
- (NSMutableArray*)fetchAllCuisines;
- (NSMutableArray*)fetchAllRecipesByCollectionId:(NSInteger)collectionId;
- (NSMutableArray*)fetchStepsForRecipeId:(NSInteger)recipeId;
- (NSMutableArray*)fetchIngredientsForRecipeId:(NSInteger)recipeId;
- (NSMutableArray*)fetchCollectionForRecipeId:(NSInteger)recipeId;
- (RSRecipe*)fetchRecipeWithRecipeId:(NSInteger)recipeId;

- (BOOL)deleteRecipes:(NSMutableArray *)recipes fromCollection:(NSInteger)collectionId;
- (BOOL)addCollection:(NSMutableArray *)collections forRecipes:(NSMutableArray *)recipes;

// Recipe Table
- (BOOL)addRecipe:(RSRecipe *)aRecipe;
- (BOOL)addCollection:(RSCollection *)aCollection;

// Search
- (NSMutableArray *)searchRecipeBySearchCriteria:(NSString *)query;


@end
