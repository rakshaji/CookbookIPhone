//
//  RSIngredientsTableViewController.h
//  Cookbook
//
//  Created by Raksha Singhania on 09/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSUnitTableViewDelegate.h"
#import "RSUnitTableViewController.h"
#import "RSIngredientsTableViewDelegate.h"

@interface RSIngredientsTableViewController : UITableViewController <RSUnitTableViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property BOOL isViewMode;
@property (strong, nonatomic) IBOutlet UITableView *ingredientsTableView;
@property (weak, nonatomic) id<RSIngredientsTableViewDelegate> delegate;

- (IBAction)selectUnit:(UIButton *)sender;
- (IBAction)saveAmount:(UITextField *)sender;
- (IBAction)saveItemName:(UITextField *)sender;
- (IBAction)saveIngredients:(UIBarButtonItem *)sender;
- (IBAction)cancel:(UIBarButtonItem *)sender;

/*
 Accessor methods to exchange data between the two screens
 */
- (void)setSelectedIngredients:(NSMutableArray *)ingredients;
- (NSMutableArray *)selectedIngredients;

@end
