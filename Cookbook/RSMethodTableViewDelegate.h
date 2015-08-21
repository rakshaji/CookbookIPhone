//
//  RSMethodTableViewDelegate.h
//  Cookbook
//
//  Created by Raksha Singhania on 09/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSMethodTableViewController;

@protocol RSMethodTableViewDelegate <NSObject>

- (void)viewMethodDidCancel:(RSMethodTableViewController *)view;
- (void)viewMethodDidDone:(RSMethodTableViewController *)view;

@end
