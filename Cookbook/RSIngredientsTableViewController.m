//
//  RSIngredientsTableViewController.m
//  Cookbook
//
//  Created by Raksha Singhania on 09/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import "RSIngredientsTableViewController.h"
#import "RSIngredient.h"
#import "RSUtility.h"

@interface RSIngredientsTableViewController ()

@property (strong, nonatomic) NSMutableArray *selectedIngredients;
@property (strong, nonatomic) UIButton *clickedButton;
@property (strong, nonatomic) UIBarButtonItem *oldButton;

@end

@implementation RSIngredientsTableViewController

static NSString *const RSAddIngredientsCellReuseIdentifier = @"addIngredientsCell";
static NSString *const RSCustomAddIngredientsReuseIdentifier = @"CustomAddIngredientsCell";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    [self setEditing:!self.isViewMode animated:!self.isViewMode];
    if (self.oldButton == nil) {
        self.oldButton = self.navigationItem.rightBarButtonItem;
    }
    
    if (self.isViewMode) {
        self.navigationItem.rightBarButtonItem = nil;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender {
    RSUnitTableViewController *optionsController = [[[segue destinationViewController] viewControllers]
                                                    objectAtIndex:0];
    // set the delegate
    optionsController.delegate = self;
    optionsController.selectedUnit = [self.selectedIngredients[sender.tag] unit];
    
}

#pragma mark - Table view data source and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isViewMode) {
        return self.selectedIngredients.count;
    }
    
    NSInteger rowCount = self.selectedIngredients == nil? 1 :self.selectedIngredients.count+1;
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowNumber = @(indexPath.row).intValue;
    
    if (self.isViewMode) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RSAddIngredientsCellReuseIdentifier forIndexPath:indexPath];
        
        NSString *unit = [self.selectedIngredients[rowNumber] unit];
        NSString *itemName = [self.selectedIngredients[rowNumber] itemName];
        
        NSMutableString *ingredientText = [NSMutableString string];
        [ingredientText appendString:[self.selectedIngredients[rowNumber] amount]];
        
        if (![unit isEqualToString:RSAddUnitText]) {
            [ingredientText appendFormat:@" %@", unit];
        }
        
        if (![RSUtility checkIfBlankOrNil:itemName]) {
            [ingredientText appendFormat:@" %@", itemName];
        }
        
        cell.textLabel.text = [ingredientText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        cell.userInteractionEnabled = NO;
        
        return cell;
    }
    
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:0] - 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RSAddIngredientsCellReuseIdentifier forIndexPath:indexPath];
        cell.textLabel.text = RSAddIngredientText;
        return cell;
    }
    else {
        
        UITableViewCell *ingredientCell = [tableView dequeueReusableCellWithIdentifier:RSCustomAddIngredientsReuseIdentifier];
        UITextField *quantityTextField = ingredientCell.contentView.subviews[0];
        UIButton *unitsbutton = ingredientCell.contentView.subviews[1];
        UITextField *itemNameTextField = ingredientCell.contentView.subviews[2];
    
        if ([self.selectedIngredients[rowNumber] amount] == 0) {
            quantityTextField.text = RSBlankText;
        }
        else {
            quantityTextField.text = [self.selectedIngredients[rowNumber] amount];
        }
        quantityTextField.tag = rowNumber;
        
        [unitsbutton setTitle:[self.selectedIngredients[rowNumber] unit] forState:UIControlStateNormal];
        unitsbutton.tag = rowNumber;
        
        itemNameTextField.text = [self.selectedIngredients[rowNumber] itemName];
        itemNameTextField.tag = rowNumber;
        
        return ingredientCell;
    }
    return nil;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.ingredientsTableView setEditing:editing animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isViewMode) {
        return UITableViewCellEditingStyleNone;
    }
    
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:0] - 1) {
        return UITableViewCellEditingStyleInsert;
    }
    else {
        return UITableViewCellEditingStyleDelete;
    }
    
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.selectedIngredients removeObjectAtIndex:indexPath.row];
        [self tableView:tableView numberOfRowsInSection:0];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        if (self.selectedIngredients == nil) {
            self.selectedIngredients = [NSMutableArray arrayWithCapacity:0];
        }
        RSIngredient *ingredient = [RSIngredient new];
        ingredient.unit = RSAddUnitText;
        [self.selectedIngredients addObject:ingredient];
        
        [self tableView:tableView numberOfRowsInSection:0];
        
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }   
}

#pragma mark - RSUnitTabelViewDelegate methods

- (void)viewUnitOptionsDidCancel:(RSUnitTableViewController*)view {
    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewUnitOptionsDidDone:(RSUnitTableViewController*)view {
    
    [self.clickedButton setTitle:(view.selectedUnit == nil ? RSBlankText : view.selectedUnit) forState:UIControlStateNormal] ;
    
    ((RSIngredient*)self.selectedIngredients[self.clickedButton.tag]).unit = view.selectedUnit;
    
    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Action handlers

- (IBAction)selectUnit:(UIButton*)sender {
    self.clickedButton = sender;
}

- (IBAction)saveAmount:(UITextField *)sender {
    ((RSIngredient*)self.selectedIngredients[sender.tag]).amount = sender.text;
}

- (IBAction)saveItemName:(UITextField *)sender {
    ((RSIngredient*)self.selectedIngredients[sender.tag]).itemName = sender.text;
}

- (IBAction)saveIngredients:(UIBarButtonItem *)sender {
    [self.delegate viewIngredientsDidDone:self];
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self.delegate viewIngredientsDidCancel:self];
}

@end
