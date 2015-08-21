//
//  RSAddRecipeToOptionsTableViewController.h
//  Cookbook
//
//  Created by Raksha Singhania on 05/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSUnitTableViewDelegate.h"
#import "RSIngredientsTableViewController.h"

@interface RSUnitTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) id<RSUnitTableViewDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

/*
 Accessor methods to exchange data between the two screens
 */
- (void)setSelectedUnit:(NSString *)selectedUnit;
- (NSString *)selectedUnit;

@end
