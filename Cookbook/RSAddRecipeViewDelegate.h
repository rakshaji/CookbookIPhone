//
//  RSAddRecipeViewDelegate
//  Cookbook
//
//  Created by Raksha Singhania on 05/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSAddRecipeViewController;

@protocol RSAddRecipeViewDelegate <NSObject>

- (void)viewDidCancel:(RSAddRecipeViewController *)view;
- (void)viewDidDone:(RSAddRecipeViewController *)view;

@end
