//
//  RSAddRecipeToOptionsDelegate
//  Cookbook
//
//  Created by Raksha Singhania on 05/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSAddRecipeToOptionsTableViewController;

@protocol RSAddRecipeToOptionsDelegate <NSObject>

@optional
- (void)viewOptionsDidCancel:(RSAddRecipeToOptionsTableViewController *)view;
- (void)viewOptionsDidDone:(RSAddRecipeToOptionsTableViewController *)view;

- (void)viewCollectionDidCancel:(RSAddRecipeToOptionsTableViewController *)view;
- (void)viewCollectionDidDone:(RSAddRecipeToOptionsTableViewController *)view;

@end
