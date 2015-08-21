//
//  RSSearchViewController.h
//  Cookbook
//
//  Created by Raksha Singhania on 04/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSConditionTableViewControllerDelegate.h"
#import "RSOptionTableViewDelegate.h"

@interface RSSearchViewController : UITableViewController <RSOptionTableViewDelegate,RSConditionTableViewControllerDelegate, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIButton *userRate1;
@property (strong, nonatomic) IBOutlet UIButton *userRate2;
@property (strong, nonatomic) IBOutlet UIButton *userRate3;
@property (strong, nonatomic) IBOutlet UIButton *userRate4;
@property (strong, nonatomic) IBOutlet UIButton *userRate5;

@property (strong, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *cookTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *prepTimeLabel;
@property (strong, nonatomic) IBOutlet UITableViewCell *cookTimePickerCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *prepTimePickerCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *totalTimePickerCell;
@property (strong, nonatomic) IBOutlet UITextField *yieldsTextField;
@property (strong, nonatomic) IBOutlet UITextField *caloriesTextField;
@property (strong, nonatomic) IBOutlet UITextField *websiteTextField;
@property (strong, nonatomic) IBOutlet UITextField *recipeNameTextField;

@property (strong, nonatomic) IBOutlet UITextField *ingredientTextField;

@property (strong, nonatomic) IBOutlet UITableView *addRecipeTableView;
@property (strong, nonatomic) IBOutlet UIButton *yeildsConditionButton;
@property (strong, nonatomic) IBOutlet UIButton *caloriesConditionButton;
@property (strong, nonatomic) IBOutlet UIButton *totalTimeConditionButton;
@property (strong, nonatomic) IBOutlet UIButton *cookTimeConditionButton;
@property (strong, nonatomic) IBOutlet UIButton *prepTimeConditionButton;
@property (strong, nonatomic) IBOutlet UIButton *collectionButton;
@property (strong, nonatomic) IBOutlet UIButton *cuisineButton;

- (IBAction)enableRating:(UIButton *)sender;
- (IBAction)resetSearch:(UIBarButtonItem *)sender;


@end
