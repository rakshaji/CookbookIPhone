//
//  RSDataExchange.h
//  Cookbook
//
//  Created by Raksha Singhania on 05/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSearchCriteria.h"
#import "RSRecipe.h"
#import "RSCollection.h"

@interface RSDataExchange : NSObject

+ (NSMutableArray*)fetchAllRecipes;
+ (NSMutableArray*)fetchAllCuisines;
+ (NSMutableArray*)fetchAllCollections ;
+ (NSMutableArray*)fetchAllRecipesByCollectionId:(NSInteger)collectionId ;
+ (NSInteger)fetchLastRecipeId;
+ (RSRecipe*)fetchRecipeWithRecipeId:(NSInteger)recipeId ;

+ (BOOL)addRecipe:(RSRecipe *)recipe;
+ (BOOL)addCollection:(RSCollection *)aCollection;

+ (BOOL)deleteRecipes:(NSMutableArray *)recipes fromCollection:(NSInteger)collectionId;
+ (BOOL)addCollection:(NSMutableArray *)collections forRecipes:(NSMutableArray *)recipes;

+ (NSMutableArray*)searchRecipes:(RSSearchCriteria *)criteria;

@end
