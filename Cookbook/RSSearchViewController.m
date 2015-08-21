//
//  RSSearchViewController.m
//  Cookbook
//
//  Created by Raksha Singhania on 04/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import "RSSearchViewController.h"
#import "RSConditionTableViewController.h"
#import "RSSearchCriteria.h"
#import "RSUtility.h"
#import "RSOptionsTableViewController.h"
#import "RSSearchResultTableViewController.h"

@interface RSSearchViewController ()

@property (strong, nonatomic) NSMutableArray *hoursList;
@property (strong, nonatomic) NSMutableArray *minutesList;
@property NSInteger selectedRow;
@property (strong, nonatomic) RSSearchCriteria *searchCriteria;
@property (strong, nonatomic) NSString *segueIdentifier;
@property (strong, nonatomic) NSDictionary *conditions;
@property (strong, nonatomic) NSString *selectedData;

enum RSTimePickerColumns{
    RSHourSelector,
    RSHoursColumn,
    RSMinuteSelector,
    RSMinutesColumn
};

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
@end

@implementation RSSearchViewController {
@private
    enum RSRating {
        RSResetStars = 0,
        RSOneStar = 1,
        RSTwoStar = 2,
        RSThreeStar = 3,
        RSFourStar = 4,
        RSFiveStar= 5
    };
    
    enum RSColumnTitles {
        RSTitle = 0,
        RSIngredients = 1,
        RSRating = 2,
        RSYields = 3,
        RSCalories = 4,
        RSTotalTime = 5,
        RSTotalTimePicker = 6,
        RSCookTime = 7,
        RSCookTimePicker = 8,
        RSPrepTime = 9,
        RSPrepTimePicker = 10,
        RSCuisines = 11,
        RSCollection = 12,
        RSWebsite = 13
    };
    
}

static NSString * const RSYeildsSegueIdentifier = @"conditionsForYields";
static NSString * const RSCalorieSegueIdentifier = @"conditionsForCalories";
static NSString * const RSTotalTimeSegueIdentifier = @"conditionsForTotalTime";
static NSString *const RSCookTimeSegueIdentifier = @"conditionsForCookTime";
static NSString *const RSPrepTimeSegueIdentifier = @"conditionsForPrepTime";
static NSString *const RSCuisineDisclosureSegueIdentifier = @"cuisineOptionsSegue";
static NSString *const RSCuisineButtonSegueIdentifier = @"cuisineButtonSegue";
static NSString *const RSSearchResultSegueIdentifier = @"SearchToRecipesSegue";

#pragma mark - View controller methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.conditions = @{
                        RSEqualsConditionText : @"=",
                        RSNotEqualsConditionText : @"<>",
                        RSLessThanConditionText : @"<",
                        RSLessthanEqualsConditionText : @"<=",
                        RSGreaterThanConditionText : @">",
                        RSGreaterThanEqualsConditionText : @"<="
                        };
    
    self.hoursList = [NSMutableArray array];
    self.minutesList = [NSMutableArray array];
    for (NSInteger i = 0; i <= 23; i++) {
        [self.hoursList addObject:[NSNumber numberWithInteger:i]];
    }
    for (NSInteger i = 0; i <= 59; i++) {
        [self.minutesList addObject:[NSNumber numberWithInteger:i]];
    }
    self.searchCriteria = [[RSSearchCriteria alloc] init];
    
    self.prepTimeConditionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.prepTimeConditionButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.segueIdentifier = segue.identifier;
    
    if ([segue.identifier isEqualToString:RSYeildsSegueIdentifier]
        || [segue.identifier isEqualToString:RSCalorieSegueIdentifier]
        || [segue.identifier isEqualToString:RSTotalTimeSegueIdentifier]
        || [segue.identifier isEqualToString:RSCookTimeSegueIdentifier]
        || [segue.identifier isEqualToString:RSPrepTimeSegueIdentifier]) {
        
        RSConditionTableViewController *conditionsController = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        
        // set the delegate
        conditionsController.delegate = self;
        
        if ([segue.identifier isEqualToString:RSYeildsSegueIdentifier]) {
            conditionsController.selectedData = self.yeildsConditionButton.titleLabel.text;
        } else if ([segue.identifier isEqualToString:RSCalorieSegueIdentifier]) {
            conditionsController.selectedData = self.caloriesConditionButton.titleLabel.text;
        } else if ([segue.identifier isEqualToString:RSTotalTimeSegueIdentifier]) {
            conditionsController.selectedData = self.totalTimeConditionButton.titleLabel.text;
        } else if ([segue.identifier isEqualToString:RSCookTimeSegueIdentifier]) {
            conditionsController.selectedData = self.cookTimeConditionButton.titleLabel.text;
        } else if ([segue.identifier isEqualToString:RSPrepTimeSegueIdentifier]) {
            conditionsController.selectedData = self.prepTimeConditionButton.titleLabel.text;
        }
        
    } else if ([segue.identifier isEqualToString:RSCuisineDisclosureSegueIdentifier]
               || [segue.identifier isEqualToString:RSCollectionSegueDisclosureIdentifier]
               || [segue.identifier isEqualToString:RSCuisineButtonSegueIdentifier]
               || [segue.identifier isEqualToString:RSCollectionButtonSegueIdentifier]) {
        
        RSOptionsTableViewController *optionsController = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        
        // set the delegate
        optionsController.delegate = self;
        
        // send the triggered segue
        optionsController.identifier = self.segueIdentifier;
        
        // preset the last selected data
        if ([self.segueIdentifier isEqualToString:RSCuisineDisclosureSegueIdentifier]
            || [self.segueIdentifier isEqualToString:RSCuisineButtonSegueIdentifier]) {
            optionsController.selectedData = self.selectedData;
        } else {
            optionsController.selectedData = self.selectedData;
        }
        
    } else if ([segue.identifier isEqualToString:RSSearchResultSegueIdentifier]) {
        RSSearchResultTableViewController *resultsController = [segue destinationViewController];
        
        [resultsController setSearchCriteria:[self criteria]];
    }
}

#pragma mark - Action handlers

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Table delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 14;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = tableView.rowHeight;
    
    switch (indexPath.row) {
        case RSTotalTimePicker:
            if (self.selectedRow == RSTotalTime) {
                [self.totalTimePickerCell setHidden:NO];
                rowHeight = 190;
            } else {
                [self.totalTimePickerCell setHidden:YES];
                rowHeight = 0;
            }
            break;
        case RSCookTimePicker:
            if (self.selectedRow == RSCookTime) {
                [self.cookTimePickerCell setHidden:NO];
                rowHeight = 190;
            } else {
                [self.cookTimePickerCell setHidden:YES];
                rowHeight = 0;
            }
            break;
        case RSPrepTimePicker:
            if (self.selectedRow == RSPrepTime) {
                [self.prepTimePickerCell setHidden:NO];
                rowHeight = 190;
            } else {
                [self.prepTimePickerCell setHidden:YES];
                rowHeight = 0;
            }
            break;
        default:
            break;
            
    }
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row){
        case RSTotalTime:
            if (self.selectedRow == RSTotalTime) {
                [self deselectTimeCellForTableView:tableView andRow:RSTotalTime forIndexPath:indexPath];
                return;
            } else {
                [self selectTimeCellForTableView:tableView forTableRow:RSTotalTime];
            }
            break;
        case RSCookTime:
            if (self.selectedRow == RSCookTime) {
                [self deselectTimeCellForTableView:tableView andRow:RSCookTime forIndexPath:indexPath];
                return;
            } else {
                [self selectTimeCellForTableView:tableView forTableRow:RSCookTime];
            }
            break;
        case RSPrepTime:
            if (self.selectedRow == RSPrepTime) {
                [self deselectTimeCellForTableView:tableView andRow:RSPrepTime forIndexPath:indexPath];
                return;
            } else {
                [self selectTimeCellForTableView:tableView forTableRow:RSPrepTime];
            }
            break;
        default:
            [self hideKeyboard];
            [self showPickerForTableView:tableView andRow:self.selectedRow andIsVisble:NO];
            break;
    }
}

- (void)deselectTimeCellForTableView:(UITableView *)tableView andRow:(NSInteger)row forIndexPath:(NSIndexPath *)indexPath {
    
    // remove highlight of selected row
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // change color back to black
    [[self getTimeLabelForRow:row] setTextColor:[UIColor blackColor]];
    
    [self showPickerForTableView:tableView andRow:self.selectedRow andIsVisble:NO];
}

- (void)selectTimeCellForTableView:(UITableView *)tableView forTableRow:(NSInteger)row {
    self.selectedRow = row;
    [[self getTimeLabelForRow:row] setTextColor:[UIColor redColor]];
    [self showPickerForTableView:tableView andRow:self.selectedRow andIsVisble:YES];
}

#pragma mark - Picker view methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case RSHourSelector:
            return [self.hoursList count];
        case RSHoursColumn:
            return 1;
        case RSMinuteSelector:
            return [self.minutesList count];
        case RSMinutesColumn:
            return 1;
        default:
            break;
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
   
    if (component == RSHourSelector || component == RSMinuteSelector) {
        NSInteger selectedHoursRow = [pickerView selectedRowInComponent:RSHourSelector];
        NSString *selectedHoursValue = [self pickerView:pickerView
                                            titleForRow:selectedHoursRow
                                           forComponent:component];
        
        NSInteger selectedMinutesRow = [pickerView selectedRowInComponent:RSMinuteSelector];
        NSString *selectedMinutesValue = [self pickerView:pickerView
                                              titleForRow:selectedMinutesRow
                                             forComponent:component];
        @try {
            switch (self.selectedRow) {
                case RSTotalTime:
                    self.totalTimeLabel.text = [NSString stringWithFormat:RSTimeFormat, [selectedHoursValue intValue],
                                                [selectedMinutesValue intValue]];
                    break;
                case RSCookTime:
                    self.cookTimeLabel.text = [NSString stringWithFormat:RSTimeFormat, [selectedHoursValue intValue],
                                               [selectedMinutesValue intValue]];
                    break;
                case RSPrepTime:
                    self.prepTimeLabel.text = [NSString stringWithFormat:RSTimeFormat, [selectedHoursValue intValue],
                                               [selectedMinutesValue intValue]];
                    break;
                default:
                    break;
            }
        }
        @catch (NSException *ne) {
            
        }
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case RSHourSelector:
            return [self.hoursList[row] stringValue];
        case RSHoursColumn:
            return RSHoursText;
        case RSMinuteSelector:
            return [self.minutesList[row] stringValue];
        case RSMinutesColumn:
            return RSMinutesText;
        default:
            break;
    }
    return nil;
}

#pragma mark - RSConditionTableViewControllerDelegate methods

- (void)changeCondition:(NSString *)newCondition {
    if ([self.segueIdentifier isEqualToString:RSYeildsSegueIdentifier]) {
        [self.yeildsConditionButton setTitle:newCondition forState:UIControlStateNormal];
    } else if ([self.segueIdentifier isEqualToString:RSCalorieSegueIdentifier]) {
        [self.caloriesConditionButton setTitle:newCondition forState:UIControlStateNormal];
    } else if ([self.segueIdentifier isEqualToString:RSTotalTimeSegueIdentifier]) {
        [self.totalTimeConditionButton setTitle:newCondition forState:UIControlStateNormal];
    } else if ([self.segueIdentifier isEqualToString:RSCookTimeSegueIdentifier]) {
        [self.cookTimeConditionButton setTitle:newCondition forState:UIControlStateNormal];
    } else if ([self.segueIdentifier isEqualToString:RSPrepTimeSegueIdentifier]) {
        [self.prepTimeConditionButton setTitle:newCondition forState:UIControlStateNormal];
    }
}

#pragma mark - RSOptionTableViewDelegate methods

- (void)viewOptionsDidCancel:(RSOptionsTableViewController *)view {
    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewOptionsDidDone:(RSOptionsTableViewController *)view {
    self.selectedData = view.selectedData;
    if ([self.segueIdentifier isEqualToString:RSCuisineDisclosureSegueIdentifier]
        || [self.segueIdentifier isEqualToString:RSCuisineButtonSegueIdentifier]) {
        [self.cuisineButton setTitle:self.selectedData forState:UIControlStateNormal];
    } else {
        [self.collectionButton setTitle:self.selectedData forState:UIControlStateNormal];
    }
    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - RSConditionTableViewControllerDelegate methods

- (void)viewDidCancel:(RSConditionTableViewController *)view {
    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidDone:(RSConditionTableViewController *)view {
    [view.delegate changeCondition:[[view conditions] objectForKey:[NSNumber numberWithInteger:view.selectedRow]]];
    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Action handlers

/*
This method shows stars based on user selection
 */
- (IBAction)enableRating:(UIButton *)sender {
    self.searchCriteria.rating = [@(sender.tag) stringValue];
    [self showStarsByUserRating:sender.tag];
}

/*
 This method resets search fields
 */
- (IBAction)resetSearch:(UIBarButtonItem *)sender {
    [self reset];
}

#pragma mark - Utility methods

/*
 This method hides or shows picker for the selected row
 @param table view instance
 @param time picker row
 @param YES to show picker else NO
 */
- (void)showPickerForTableView:(UITableView *)tableView andRow:(NSInteger)row andIsVisble:(BOOL)isVisible {
    if (isVisible == NO) {
        [self resetTimeLabelToColor:[UIColor blackColor]];
        
        // reset row selection counter
        self.selectedRow = 0;
    }
    NSIndexPath *indexPath = [tableView indexPathForCell:[self getTimePickerCellForRow:row]];
    [self tableView:tableView heightForRowAtIndexPath:indexPath];
    [self reloadTableView:tableView];
}

/*
 This method reloads table
 */
- (void)reloadTableView:(UITableView *)tableView {
    NSIndexSet* reloadSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self numberOfSectionsInTableView:tableView])];
    
    // Reload all sections
    [tableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView reloadData];
}

/*
 This method changed the color for time labels
 @param Color to set
 */
- (void)resetTimeLabelToColor:(UIColor *)color {
    [[self getTimeLabelForRow:RSTotalTime] setTextColor:color];
    [[self getTimeLabelForRow:RSCookTime] setTextColor:color];
    [[self getTimeLabelForRow:RSPrepTime] setTextColor:color];
}

/*
 This method returns the time label for the selected row
 @param row number of the time picker
 */
- (UILabel *)getTimeLabelForRow:(NSInteger)row {
    switch (row) {
        case RSTotalTime:
            return self.totalTimeLabel;
        case RSCookTime:
            return self.cookTimeLabel;
        case RSPrepTime:
            return self.prepTimeLabel;
        default:
            break;
    }
    return nil;
}

/*
 This method returns the table cell for the time picker row
 @param row number of the time picker
 */
- (UITableViewCell *)getTimePickerCellForRow:(NSInteger)row {
    switch (row) {
        case RSTotalTime:
            return self.totalTimePickerCell;
        case RSCookTime:
            return self.cookTimePickerCell;
        case RSPrepTime:
            return self.prepTimePickerCell;
        default:
            break;
    }
    return nil;
}

/*
 This method shows stars for user rating of an instructor
 */
- (void)showStarsByUserRating:(NSInteger)rating {
    switch (rating) {
        case RSResetStars:
            [RSUtility changeToGreyStar:self.userRate1];
            [RSUtility changeToGreyStar:self.userRate2];
            [RSUtility changeToGreyStar:self.userRate3];
            [RSUtility changeToGreyStar:self.userRate4];
            [RSUtility changeToGreyStar:self.userRate5];
            break;
        case RSOneStar:
            [RSUtility changeToYellowStar:self.userRate1];
            
            [RSUtility changeToGreyStar:self.userRate2];
            [RSUtility changeToGreyStar:self.userRate3];
            [RSUtility changeToGreyStar:self.userRate4];
            [RSUtility changeToGreyStar:self.userRate5];
            break;
        case RSTwoStar:
            [RSUtility changeToYellowStar:self.userRate1];
            [RSUtility changeToYellowStar:self.userRate2];
            
            [RSUtility changeToGreyStar:self.userRate3];
            [RSUtility changeToGreyStar:self.userRate4];
            [RSUtility changeToGreyStar:self.userRate5];
            break;
        case RSThreeStar:
            [RSUtility changeToYellowStar:self.userRate1];
            [RSUtility changeToYellowStar:self.userRate2];
            [RSUtility changeToYellowStar:self.userRate3];
            
            [RSUtility changeToGreyStar:self.userRate4];
            [RSUtility changeToGreyStar:self.userRate5];
            break;
        case RSFourStar:
            [RSUtility changeToYellowStar:self.userRate1];
            [RSUtility changeToYellowStar:self.userRate2];
            [RSUtility changeToYellowStar:self.userRate3];
            [RSUtility changeToYellowStar:self.userRate4];
            
            [RSUtility changeToGreyStar:self.userRate5];
            break;
        case RSFiveStar:
            [RSUtility changeToYellowStar:self.userRate1];
            [RSUtility changeToYellowStar:self.userRate2];
            [RSUtility changeToYellowStar:self.userRate3];
            [RSUtility changeToYellowStar:self.userRate4];
            [RSUtility changeToYellowStar:self.userRate5];
            break;
        default:
            break;
    }
}

/*
 This method hides keyboard
 */
- (void)hideKeyboard {
    [self.recipeNameTextField resignFirstResponder];
    [self.yieldsTextField resignFirstResponder];
    [self.caloriesTextField resignFirstResponder];
    [self.websiteTextField resignFirstResponder];
}

/*
 This method clears the input fields
 */
- (void)reset {
    self.totalTimeLabel.text = RSDefaultTimeText;
    self.cookTimeLabel.text = RSDefaultTimeText;
    self.prepTimeLabel.text = RSDefaultTimeText;
    self.yieldsTextField.text = RSBlankText;
    self.caloriesTextField.text = RSBlankText;
    self.websiteTextField.text = RSBlankText;
    self.recipeNameTextField.text = RSBlankText;
    self.ingredientTextField.text = RSBlankText;
    [self showStarsByUserRating:0];
    [self.collectionButton setTitle:RSBlankText forState:UIControlStateNormal];
    [self.cuisineButton setTitle:RSBlankText forState:UIControlStateNormal];
    self.selectedData = nil;
    [self.cookTimeConditionButton setTitle:RSDefaultConditionText forState:UIControlStateNormal];
    [self.prepTimeConditionButton setTitle:RSDefaultConditionText forState:UIControlStateNormal];
    [self.totalTimeConditionButton setTitle:RSDefaultConditionText forState:UIControlStateNormal];
    [self.yeildsConditionButton setTitle:RSDefaultConditionText forState:UIControlStateNormal];
    [self.caloriesConditionButton setTitle:RSDefaultConditionText forState:UIControlStateNormal];
    
    [self.searchCriteria reset];
}

/*
 This methods creates search criteria based on user selection or input
 @return RSSearchCriteria object with the search details
 */
- (RSSearchCriteria *)criteria {
    self.searchCriteria.recipeTitle = self.recipeNameTextField.text;
    self.searchCriteria.ingredient = self.ingredientTextField.text;
    
    self.searchCriteria.yields = self.yieldsTextField.text;
    self.searchCriteria.yeildsCondition = [self.conditions objectForKey:self.yeildsConditionButton.titleLabel.text];
    
    self.searchCriteria.calories = self.caloriesTextField.text;
    self.searchCriteria.caloriesCondition = [self.conditions objectForKey:self.caloriesConditionButton.titleLabel.text];
    
    self.searchCriteria.totalTime = self.totalTimeLabel.text;
    self.searchCriteria.totalTimeCondition = [self.conditions objectForKey:self.totalTimeConditionButton.titleLabel.text];
    
    self.searchCriteria.cookTime = self.cookTimeLabel.text;
    self.searchCriteria.cookTimeCondition = [self.conditions objectForKey:self.cookTimeConditionButton.titleLabel.text];
    
    self.searchCriteria.prepTime = self.prepTimeLabel.text;
    self.searchCriteria.prepTimeCondition = [self.conditions objectForKey:self.prepTimeConditionButton.titleLabel.text];
    
    self.searchCriteria.collection = self.collectionButton.titleLabel.text;
    self.searchCriteria.cuisine = self.cuisineButton.titleLabel.text;
    self.searchCriteria.website = self.websiteTextField.text;
    
    return self.searchCriteria;
}

@end
