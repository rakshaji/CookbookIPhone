//
//  RSDataExchange.m
//  Cookbook
//
//  Created by Raksha Singhania on 05/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import "RSDataExchange.h"
#import "RSDatabaseAccess.h"
#import "RSUtility.h"

@implementation RSDataExchange

+ (NSMutableArray*)fetchAllRecipes {
    NSMutableArray *recipes = [[RSDatabaseAccess instance] fetchAllRecipes];
    return recipes;
}

+ (NSMutableArray*)fetchAllCuisines {
    NSMutableArray *cuisines = [[RSDatabaseAccess instance] fetchAllCuisines];
    return cuisines;
}

+ (NSMutableArray*)fetchAllCollections {
    NSMutableArray *colections = [[RSDatabaseAccess instance] fetchAllCollections];
    return colections;
}

+ (RSRecipe*)fetchRecipeWithRecipeId:(NSInteger)recipeId {
    return [[RSDatabaseAccess instance] fetchRecipeWithRecipeId:recipeId];
}

+ (NSInteger)fetchLastRecipeId {
    return [[RSDatabaseAccess instance] fetchLastRecipeId];
}

+ (NSMutableArray*)fetchAllRecipesByCollectionId:(NSInteger)collectionId {
    NSMutableArray *recipes = [[RSDatabaseAccess instance] fetchAllRecipesByCollectionId:collectionId];
    return recipes;
}

+ (BOOL)deleteRecipes:(NSMutableArray *)recipes fromCollection:(NSInteger)collectionId {
    return [[RSDatabaseAccess instance] deleteRecipes:recipes fromCollection:collectionId];
}

+ (BOOL)addRecipe:(RSRecipe *)aRecipe {
    return [[RSDatabaseAccess instance] addRecipe:aRecipe];
}

+ (BOOL)addCollection:(RSCollection *)aCollection {
    return [[RSDatabaseAccess instance] addCollection:aCollection];
}

+ (BOOL)addCollection:(NSMutableArray *)collections forRecipes:(NSMutableArray *)recipes {
    return [[RSDatabaseAccess instance] addCollection:collections forRecipes:recipes];
}

+ (NSMutableArray*)searchRecipes:(RSSearchCriteria *)criteria {
    
    NSMutableString *searchCriteriaQuery = [NSMutableString stringWithString:@""];
    
    if (![RSUtility checkIfBlankOrNil:criteria.recipeTitle]) {
        [searchCriteriaQuery appendFormat:@"%@ LIKE '%%%@%%'", RSColumnRecipeTitle, criteria.recipeTitle];
    }
    
    if (![RSUtility checkIfBlankOrNil:criteria.ingredient]) {
        if (![RSUtility checkIfBlankOrNil:searchCriteriaQuery]) {
            [searchCriteriaQuery appendString:@" AND "];
        }
        [searchCriteriaQuery appendFormat:@" %@ LIKE '%%%@%%'", RSColumnIngredientItem, criteria.ingredient];
    }
    
    
    if (![RSUtility checkIfBlankOrNil:criteria.rating]) {
        if (![RSUtility checkIfBlankOrNil:searchCriteriaQuery]) {
             [searchCriteriaQuery appendString:@" AND "];
        }
        [searchCriteriaQuery appendFormat:@" %@ = %@", RSColumnRating, criteria.rating];
    }
    
    if (![RSUtility checkIfBlankOrNil:criteria.yields]) {
        if (![RSUtility checkIfBlankOrNil:searchCriteriaQuery]) {
             [searchCriteriaQuery appendString:@" AND "];
        }
        [searchCriteriaQuery appendFormat:@" %@ %@ %@", RSColumnYields, criteria.yeildsCondition, criteria.yields];
    }
    
    if (![RSUtility checkIfBlankOrNil:criteria.calories]) {
        if (![RSUtility checkIfBlankOrNil:searchCriteriaQuery]) {
             [searchCriteriaQuery appendString:@" AND "];
        }
         [searchCriteriaQuery appendFormat:@" %@ %@ %@", RSColumnCalories, criteria.caloriesCondition, criteria.calories];
    }
    
    if (![RSUtility checkIfBlankOrNil:criteria.totalTime]
        && ![criteria.totalTime isEqualToString:RSDefaultTimeText]) {
        if (![RSUtility checkIfBlankOrNil:searchCriteriaQuery]) {
             [searchCriteriaQuery appendString:@" AND "];
        }
         [searchCriteriaQuery appendFormat:@" strftime('%%H:%%M',%@) %@ strftime('%%H:%%M','%@')", RSColumnTotalTime, criteria.totalTimeCondition, criteria.totalTime];
    }
    
    if (![RSUtility checkIfBlankOrNil:criteria.cookTime]
        && ![criteria.cookTime isEqualToString:RSDefaultTimeText]) {
        if (![RSUtility checkIfBlankOrNil:searchCriteriaQuery]) {
             [searchCriteriaQuery appendString:@" AND "];
        }
         [searchCriteriaQuery appendFormat:@" strftime('%%H:%%M',%@) %@ strftime('%%H:%%M','%@')", RSColumnCooktime, criteria.cookTimeCondition, criteria.cookTime];
    }
    
    if (![RSUtility checkIfBlankOrNil:criteria.prepTime]
        && ![criteria.prepTime isEqualToString:RSDefaultTimeText]) {
        if (![RSUtility checkIfBlankOrNil:searchCriteriaQuery]) {
             [searchCriteriaQuery appendString:@" AND "];
        }
         [searchCriteriaQuery appendFormat:@" strftime('%%H:%%M',%@) %@ strftime('%%H:%%M','%@')", RSColumnPrepTime, criteria.prepTimeCondition, criteria.prepTime];
    }
    
    if (![RSUtility checkIfBlankOrNil:criteria.collection]) {
        if (![RSUtility checkIfBlankOrNil:searchCriteriaQuery]) {
             [searchCriteriaQuery appendString:@" AND "];
        }
         [searchCriteriaQuery appendFormat:@" %@ LIKE '%%%@%%'", RSColumnCollectionName, criteria.collection];
    }
    
    if (![RSUtility checkIfBlankOrNil:criteria.cuisine]) {
        if (![RSUtility checkIfBlankOrNil:searchCriteriaQuery]) {
             [searchCriteriaQuery appendString:@" AND "];
        }
         [searchCriteriaQuery appendFormat:@" %@ LIKE '%%%@%%'", RSColumnCuisineName, criteria.cuisine];
    }
    
    if (![RSUtility checkIfBlankOrNil:criteria.website]) {
        if (![RSUtility checkIfBlankOrNil:searchCriteriaQuery]) {
             [searchCriteriaQuery appendString:@" AND "];
        }
         [searchCriteriaQuery appendFormat:@" %@ LIKE '%%%@%%'", RSColumnWebsite, criteria.website];
    }
    
    return [[RSDatabaseAccess instance] searchRecipeBySearchCriteria:searchCriteriaQuery];
    
}

@end
