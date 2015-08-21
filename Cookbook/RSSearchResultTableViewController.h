//
//  RSSearchResultTableViewController.h
//  Cookbook
//
//  Created by Raksha Singhania on 05/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSearchCriteria.h"
#import "RSAddRecipeViewDelegate.h"
#import "RSAddRecipeViewController.h"

@interface RSSearchResultTableViewController : UITableViewController <RSAddRecipeViewDelegate, UITableViewDelegate, UITableViewDataSource>

/*
 Accessor methods to exchange data between the two screens
 */
- (void)setSearchCriteria:(RSSearchCriteria *)recipe;
- (RSSearchCriteria *)searchCriteria;

@end
