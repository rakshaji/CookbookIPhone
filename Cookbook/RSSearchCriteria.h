//
//  RSSearchCriteria.h
//  Cookbook
//
//  Created by Raksha Singhania on 05/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSearchCriteria : NSObject

@property (strong, nonatomic) NSString *recipeTitle;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSString *notes;
@property (strong, nonatomic) NSString *cuisine;
@property (strong, nonatomic) NSString *collection;
@property (strong, nonatomic) NSString *ingredient;
@property (strong, nonatomic) NSString *totalTime;
@property (strong, nonatomic) NSString *totalTimeCondition;
@property (strong, nonatomic) NSString *cookTime;
@property (strong, nonatomic) NSString *cookTimeCondition;
@property (strong, nonatomic) NSString *prepTime;
@property (strong, nonatomic) NSString *prepTimeCondition;
@property (strong, nonatomic) NSString *rating;
@property (strong, nonatomic) NSString *calories;
@property (strong, nonatomic) NSString *caloriesCondition;
@property (strong, nonatomic) NSString *yields;
@property (strong, nonatomic) NSString *yeildsCondition;

- (void)reset;

@end
