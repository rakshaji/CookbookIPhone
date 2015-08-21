//
//  RSIngredient.h
//  Cookbook
//
//  Created by Raksha Singhania on 28/11/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSIngredient : NSObject

@property NSInteger ingredientId;
@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *unit;

@end
