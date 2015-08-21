//
//  RSCollectionRecipesViewDelegate.h
//  Cookbook
//
//  Created by Raksha Singhania on 07/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSCollectionRecipesViewController;

@protocol RSCollectionRecipesViewDelegate <NSObject>

- (void)viewDidCancel:(RSCollectionRecipesViewController *)view;
- (void)viewDidDone:(RSCollectionRecipesViewController *)view;

@end