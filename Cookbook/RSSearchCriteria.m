//
//  RSSearchCriteria.m
//  Cookbook
//
//  Created by Raksha Singhania on 05/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import "RSSearchCriteria.h"

@implementation RSSearchCriteria

- (void)reset {
    self.collection = nil;
    self.cookTime = nil;
    self.cookTimeCondition = nil;
    self.cuisine = nil;
    self.ingredient = nil;
    self.recipeTitle = nil;
    self.website = nil;
    self.notes = nil;
    self.totalTime = nil;
    self.totalTimeCondition = nil;
    self.prepTime = nil;
    self.prepTimeCondition = nil;
    self.rating = nil;
    self.calories = nil;
    self.caloriesCondition = nil;
    self.yeildsCondition = nil;
    self.yields = nil;
}

@end
