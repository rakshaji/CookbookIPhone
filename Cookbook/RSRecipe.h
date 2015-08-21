//
//  RSRecipe.h
//  Cookbook
//
//  Created by Raksha Singhania on 28/11/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSCuisine.h"

@interface RSRecipe : NSObject

@property NSInteger recipeId;
@property (strong, nonatomic) NSString *recipeTitle;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSString *notes;
@property (strong, nonatomic) RSCuisine *cuisine;
@property (strong, nonatomic) NSMutableArray *steps;
@property (strong, nonatomic) NSMutableArray *collection;
@property (strong, nonatomic) NSMutableArray *ingredient;
@property (strong, nonatomic) NSString *totalTime;
@property (strong, nonatomic) NSString *cookTime;
@property (strong, nonatomic) NSString *prepTime;
@property (strong, nonatomic) NSString *rating;
@property (strong, nonatomic) NSString *calories;
@property (strong, nonatomic) NSString *yields;
@property (strong, nonatomic) NSString *imagePath;

@end
