//
//  RSAllCollectionsTableViewController.h
//  Cookbook
//
//  Created by Raksha Singhania on 07/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSCollectionRecipesViewDelegate.h"
#import "RSCollectionRecipesViewController.h"

@interface RSAllCollectionsTableViewController : UITableViewController <RSCollectionRecipesViewDelegate,
UITableViewDataSource, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *collectionTableView;

- (IBAction)addCollection:(UIBarButtonItem *)sender;

@end
