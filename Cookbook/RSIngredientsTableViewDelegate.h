//
//  RSIngredientsTableViewDelegate.h
//
//  Created by Raksha Singhania on 05/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSIngredientsTableViewController;

@protocol RSIngredientsTableViewDelegate <NSObject>

- (void)viewIngredientsDidCancel:(RSIngredientsTableViewController *)view;
- (void)viewIngredientsDidDone:(RSIngredientsTableViewController *)view;

@end
