//
//  RSOptionTableViewDelegate.h
//  Cookbook
//
//  Created by Raksha Singhania on 05/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSOptionsTableViewController;

@protocol RSOptionTableViewDelegate <NSObject>

- (void)viewOptionsDidCancel:(RSOptionsTableViewController *)view;
- (void)viewOptionsDidDone:(RSOptionsTableViewController *)view;

@end
