//
//  RSAddRecipeToOptionsDelegate
//  Cookbook
//
//  Created by Raksha Singhania on 05/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSUnitTableViewController;

@protocol RSUnitTableViewDelegate <NSObject>

- (void)viewUnitOptionsDidCancel:(RSUnitTableViewController *)view;
- (void)viewUnitOptionsDidDone:(RSUnitTableViewController *)view;

@end
