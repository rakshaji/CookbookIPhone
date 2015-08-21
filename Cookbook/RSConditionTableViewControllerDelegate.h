//
//  RSConditionTableViewControllerDelegate.h
//  Cookbook
//
//  Created by Raksha Singhania on 04/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSConditionTableViewController;

@protocol RSConditionTableViewControllerDelegate <NSObject>

- (void)viewDidCancel:(RSConditionTableViewController *)view;
- (void)viewDidDone:(RSConditionTableViewController *)view;
- (void)changeCondition:(NSString *)newCondition;

@end
