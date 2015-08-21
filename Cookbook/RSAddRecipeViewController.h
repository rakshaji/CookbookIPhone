//
//  RSAddRecipeViewController.h
//  Cookbook
//
//  Created by Raksha Singhania on 30/11/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSAddRecipeViewDelegate.h"
#import "RSAddRecipeToOptionsDelegate.h"
#import "RSAddRecipeToOptionsTableViewController.h"
#import "RSIngredientsTableViewDelegate.h"
#import "RSIngredientsTableViewController.h"
#import "RSMethodTableViewDelegate.h"
#import "RSMethodTableViewController.h"
#import "RSRecipe.h"

@interface RSAddRecipeViewController : UITableViewController <RSIngredientsTableViewDelegate, RSAddRecipeToOptionsDelegate, RSMethodTableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) id<RSAddRecipeViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *recipeImage;
@property (strong, nonatomic) IBOutlet UIButton *userRate1;
@property (strong, nonatomic) IBOutlet UIButton *userRate2;
@property (strong, nonatomic) IBOutlet UIButton *userRate3;
@property (strong, nonatomic) IBOutlet UIButton *userRate4;
@property (strong, nonatomic) IBOutlet UIButton *userRate5;
@property (strong, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *editPhotoButton;
@property (strong, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *cookTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *prepTimeLabel;
@property (strong, nonatomic) IBOutlet UITableViewCell *cookTimePickerCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *prepTimePickerCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *totalTimePickerCell;
@property (strong, nonatomic) IBOutlet UITextField *yieldsTextField;
@property (strong, nonatomic) IBOutlet UITextField *caloriesTextField;
@property (strong, nonatomic) IBOutlet UITextField *websiteTextField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *cuisineButton;
@property (strong, nonatomic) IBOutlet UIButton *collectionButton;
@property (strong, nonatomic) IBOutlet UITextField *recipeNameTextField;
@property (strong, nonatomic) IBOutlet UITableView *addRecipeTableView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *ingredientsCountButton;
@property (strong, nonatomic) IBOutlet UIButton *stepsCountButton;
@property (strong, nonatomic) IBOutlet UITextView *notesTextView;

- (IBAction)editRecipeImage:(UIButton *)sender;
- (IBAction)addRecipeImage:(UIButton *)sender;
- (IBAction)rateRecipe:(UIButton *)sender;
- (IBAction)cancel:(id)sender ;
- (IBAction)done:(id)sender ;

/*
 Accessor methods to exchange data between the two screens
 */
- (void)setAllRecipes:(NSMutableArray *)recipes;
- (NSMutableArray *)allRecipes;

- (void)setRecipe:(RSRecipe *)recipe;
- (RSRecipe *)recipe;


@end
