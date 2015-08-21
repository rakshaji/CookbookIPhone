//
//  RSAddRecipeToOptionsTableViewController.h
//  Cookbook
//
//  Created by Raksha Singhania on 05/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSAddRecipeToOptionsDelegate.h"
#import "RSCuisine.h"

@interface RSAddRecipeToOptionsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property BOOL isViewMode;
@property (weak, nonatomic) id<RSAddRecipeToOptionsDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITableView *optionsTableView;
@property (strong, nonatomic) IBOutlet UINavigationItem *optionsNavigationItem;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

/*
 Accessor methods to exchange data between the two screens
 */
- (void)setIdentifier:(NSString *)identifier;
- (NSString *)identifier;

- (void)setSelectedCollections:(NSMutableArray *)selectedCollection;
- (NSMutableArray *)selectedCollections;

- (void)setSelectedCuisine:(RSCuisine *)selectedCuisine;
- (RSCuisine *)selectedCuisine;

@end
