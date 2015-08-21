//
//  RSAddRecipeViewController.m
//  Cookbook
//
//  Created by Raksha Singhania on 30/11/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import "RSAddRecipeViewController.h"
#import "RSUtility.h"
#import "RSRecipe.h"
#import "RSCollection.h"
#import "RSCuisine.h"
#import "RSDataExchange.h"
#import "UIImage+Scale.h"

@interface RSAddRecipeViewController ()

@property (strong, nonatomic) NSMutableArray *hoursList;
@property (strong, nonatomic) NSMutableArray *minutesList;
@property NSInteger selectedRow;
@property (strong, nonatomic) RSRecipe *recipe;
@property (strong, nonatomic) NSString *segueIdentifier;
@property (strong, nonatomic) NSMutableArray *selectedCollections;
@property (strong, nonatomic) RSCuisine *selectedNewCuisine;
@property (strong, nonatomic) NSMutableArray *allRecipes;
@property (strong, nonatomic) UIBarButtonItem *oldButton;
@property BOOL isViewMode;

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end

@implementation RSAddRecipeViewController {
@private
    enum RSRating {
        RSOneStar = 1,
        RSTwoStar = 2,
        RSThreeStar = 3,
        RSFourStar = 4,
        RSFiveStar= 5
    };
    
    enum RSRowNumber {
        RSPhoto = 0,
        RSTitle = 1,
        RSYields = 2,
        RSCalories = 3,
        RSFirstBreak = 4,
        RSTotalTime = 5,
        RSTotalTimePicker = 6,
        RSCookTime = 7,
        RSCookTimePicker = 8,
        RSPrepTime = 9,
        RSPrepTimePicker = 10,
        RSSecondBreak = 11,
        RSIngredients = 12,
        RSProcedure = 13,
        RSNotes = 14,
        RSThirdBreak = 15,
        RSCuisines = 16,
        RSCollections = 17,
        RSFourthBreak = 18,
        RSWebsite = 19
    };
    
    enum RSRowHeights {
        RSTimePickerHeight = 190,
        RSImageViewHeight = 140,
        RSNotesHeight = 140
    };
    
    enum RSDataCount {
        RSTotalRowCount = 21,
        RSTotalSections = 1
    };
    
    enum {
        RSHourSelector,
        RSHoursColumn,
        RSMinuteSelector,
        RSMinuteColumn
    };
    
    enum RSActionSheetButtons {
        RSTakePhoto = 0,
        RSChoosePhoto = 1,
        RSDeletePhoto = 2
    };
}

static NSString *const RSAddRecipeCuisineDisclosureSegueIdentifier = @"addRecipeCuisineToOptionsSegue";
static NSString *const RSAddRecipeCuisineButtonSegueIdentifier = @"addRecipeCuisineButtonToOptionsSegue";
static NSString *const RSAddRecipeToIngredientsSegueIdentifier = @"addRecipeToIngredientsSegue";
static NSString *const RSAddRecipeToIngredientsButtonSegueIdentifier = @"recipeToIngredientButtonSegue";
static NSString *const RSAddRecipeToStepsSegueIdentifier = @"recipeToStepsSegue";
static NSString *const RSAddRecipeToStepsButtonSegueIdentifier = @"recipeToStepsButtonSegue";

#pragma mark - View controller methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load the picker's column value for hour and minute
    self.hoursList = [NSMutableArray array];
    self.minutesList = [NSMutableArray array];
    for (NSInteger i = 0; i <= 23; i++) {
        [self.hoursList addObject:[NSNumber numberWithInteger:i]];
    }
    for (NSInteger i = 0; i <= 59; i++) {
        [self.minutesList addObject:[NSNumber numberWithInteger:i]];
    }
    
    // back up the save button before hiding in case of view mode
    if (self.oldButton == nil) {
        self.oldButton = self.navigationItem.rightBarButtonItem;
    }
    
    self.navigationItem.rightBarButtonItem.tag = 1;
    
    if (self.recipe != nil && self.recipe.recipeId != 0) {
        [self makeViewReadOnly];
    }
    else {
        self.isViewMode = NO;
        self.recipe = [[RSRecipe alloc] init];
        self.navigationItem.rightBarButtonItem = self.oldButton;
        [self hideAddPhotoButton:NO];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Save recipe related utiltiy methods

/*
 This method saves recipe image into the applications directory
 */
- (NSString*)writePhotoToLibrary:(UIImage*)recipeImage {
    NSString *filePath;
    if (recipeImage != nil) {
        NSInteger lastRowId = [RSDataExchange fetchLastRecipeId];
        if (lastRowId != -1) {
            // add image name to the directory path
            NSString *imageName = [NSString stringWithFormat:RSImageNameFormat, @(lastRowId+1).stringValue];
            filePath = [[[RSUtility applicationDirectory] path] stringByAppendingPathComponent:imageName];
            
            // write image file to the applications documents directory
            NSData *imageData = UIImagePNGRepresentation(recipeImage);
            [imageData writeToFile:filePath atomically:YES];
        }
    }
    return filePath;
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

#pragma mark - View mode Utility methods

/*
 This method does all the configurations to make screen view only
 */
- (void)makeViewReadOnly {
    self.isViewMode = YES;
    
    self.navigationItem.title = RSViewRecipeHeaderDefault;
    
    // query db for details
    self.recipe = [RSDataExchange fetchRecipeWithRecipeId:self.recipe.recipeId];
    
    // hide all buttons
    self.navigationItem.rightBarButtonItem = nil;
    [self addPhotoButton].hidden = YES;
    [self editPhotoButton].hidden = YES;
    
    [self showAllData];
    
    self.notesTextView.editable = NO;
}

/*
 This method populates all data related to selected recipe in the screen
 */
- (void)showAllData {
    self.recipeNameTextField.text = self.recipe.recipeTitle;
    [self showStarsByUserRating:self.recipe.rating.integerValue];
    self.yieldsTextField.text = [RSUtility notNilValue:self.recipe.yields];
    self.caloriesTextField.text = [RSUtility notNilValue:self.recipe.calories];
    self.websiteTextField.text = [RSUtility notNilValue:self.recipe.website];
    self.cookTimeLabel.text = self.recipe.cookTime ;
    self.prepTimeLabel.text = self.recipe.prepTime;
    self.totalTimeLabel.text = self.recipe.totalTime;
    self.selectedCollections = self.recipe.collection;
    self.selectedNewCuisine = self.recipe.cuisine;
    self.notesTextView.text = [RSUtility notNilValue:self.recipe.notes ];

    NSInteger count = self.recipe.ingredient.count;
    [self.ingredientsCountButton setTitle:[NSString stringWithFormat:RSShowIngredientsCountFormat, @(count).stringValue]
                                 forState:UIControlStateNormal];
    
    count = self.recipe.collection.count;
    [self.collectionButton setTitle:[NSString stringWithFormat:RSShowCollectionCountFormat, @(count).stringValue]
                           forState:UIControlStateNormal];
    
    count = self.recipe.steps.count;
    [self.stepsCountButton setTitle:[NSString stringWithFormat:RSShowStepsCountFormat, @(count).stringValue]
                           forState:UIControlStateNormal];
    
    [self.cuisineButton setTitle:[RSUtility notNilValue:self.recipe.cuisine.cuisineName]
                        forState:UIControlStateNormal];
    
    // show the image if any
    if (self.recipe.imagePath != nil) {
        NSData *pngData = [NSData dataWithContentsOfFile:self.recipe.imagePath];
        UIImage *image = [UIImage imageWithData:pngData];
        UIImage *scaledImage = [image scaleToSize:CGSizeMake(305.0f, 125.0f)];
        self.recipeImage.image = scaledImage;
    }
}

#pragma mark - Rating related utility method

/*
 This method shows stars for user rating of an instructor
 */
- (void)showStarsByUserRating:(NSInteger)rating {
    switch (rating) {
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


#pragma mark - Add/edit photo action related methods

/*
 This method shows options to allow user to choose on how to add photo or otherwise cancel the operation
 */
- (void)showAddPhotoOptions {
   UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:RSCancelText
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:RSTakePhotoText, RSChoosePhotoText, nil];

    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

/*
 This method shows options to allow user to choose on how to edit photo or otherwise cancel the operation
 */
- (void)showEditPhotoOptions {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:RSCancelText
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:RSTakePhotoText, RSChoosePhotoText, RSDeletePhotoText, nil];

    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == RSTakePhoto) {
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else if (buttonIndex == RSChoosePhoto) {
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
    else if (actionSheet.numberOfButtons == 4 && buttonIndex == RSDeletePhoto) {
        [self recipeImage].image = nil;
        [self hideAddPhotoButton:NO];
    }
    else {
        // cancel
        return;
    }
}

/*
 This method opens screen based on the selected option for choosing photo i.e. camera or gallery
 */
- (void)showImagePickerForSourceType:(NSInteger)sourceType {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = sourceType;
    [self presentViewController:imagePicker animated:YES completion:^{
        if ([self recipeImage].image != nil) {
            [self hideAddPhotoButton:YES];
        }
        
    }];
}

/*
 This method hides the add photo button and shows the edit photo buttons if No is passed
 @param boolean value stating the state of add photo button
 */
- (void)hideAddPhotoButton:(BOOL)isVisible {
    [self addPhotoButton].hidden = isVisible;
    [self editPhotoButton].hidden = !isVisible;
    [self recipeImage].hidden = !isVisible;
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    [self recipeImage].image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        if ([self recipeImage].image != nil) {
            [self hideAddPhotoButton:YES];
        }
        
    }];
	
}

#pragma mark - Action handlers

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    // turn off the editing in view mode else allow
    return !self.isViewMode;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self hideKeyboard];
    return YES;
}

- (IBAction)editRecipeImage:(UIButton *)sender {
    [self showEditPhotoOptions];
}

- (IBAction)addRecipeImage:(UIButton *)sender {
    [self showAddPhotoOptions];
}

- (IBAction)rateRecipe:(UIButton *)sender {
    if (self.isViewMode) {
        return;
    }
    
    self.recipe.rating = @(sender.tag).stringValue;
    [self showStarsByUserRating:sender.tag];
}

- (IBAction)cancel:(id)sender {
    [self.delegate viewDidCancel:self];
}

- (IBAction)done:(id)sender {
    
    // validate mandatory fields
    if([RSUtility checkIfBlankOrNil:self.recipeNameTextField.text]) {
        [self.titleLabel setTextColor:[UIColor redColor]];
        [self.titleLabel setText:RSTitleRequiredText];
        return;
    }
    
    // save all the details
    self.recipe.recipeTitle = self.recipeNameTextField.text;
    self.recipe.yields = self.yieldsTextField.text;
    self.recipe.calories = self.caloriesTextField.text;
    self.recipe.website = self.websiteTextField.text;
    self.recipe.cookTime = self.cookTimeLabel.text;
    self.recipe.prepTime = self.prepTimeLabel.text;
    self.recipe.totalTime = self.totalTimeLabel.text;
    self.recipe.collection = self.selectedCollections;
    self.recipe.cuisine = self.selectedNewCuisine;
    self.recipe.notes = self.notesTextView.text;
    self.recipe.imagePath = [self writePhotoToLibrary:[self recipeImage].image];
    
    // save or update recipe
    [RSDataExchange addRecipe:self.recipe];
    
    [self.delegate viewDidDone:self];
}

#pragma mark - Table View data source and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return RSTotalSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return RSTotalRowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = tableView.rowHeight;
    
    switch (indexPath.row) {
        case RSPhoto:
            rowHeight = RSImageViewHeight;
            break;
        case RSNotes:
            rowHeight = RSNotesHeight;
            break;
        case RSTotalTimePicker:
            if (self.selectedRow == RSTotalTime) {
                [self.totalTimePickerCell setHidden:NO];
                rowHeight = RSTimePickerHeight;
            } else {
                [self.totalTimePickerCell setHidden:YES];
                rowHeight = 0;
            }
            break;
        case RSCookTimePicker:
            if (self.selectedRow == RSCookTime) {
                [self.cookTimePickerCell setHidden:NO];
                rowHeight = RSTimePickerHeight;
            } else {
                [self.cookTimePickerCell setHidden:YES];
                rowHeight = 0;
            }
            break;
        case RSPrepTimePicker:
            if (self.selectedRow == RSPrepTime) {
                [self.prepTimePickerCell setHidden:NO];
                rowHeight = RSTimePickerHeight;
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
    
    if (self.isViewMode) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    
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

#pragma mark - Picker related methods

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
 This method reloads the table
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
 This method deselects given time cell
 @param table instance
 @param row to select
 @param index path of the cell
 */
- (void)deselectTimeCellForTableView:(UITableView *)tableView andRow:(NSInteger)row forIndexPath:(NSIndexPath *)indexPath {

    // remove highlight of selected row
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // change color back to black
    [[self getTimeLabelForRow:row] setTextColor:[UIColor blackColor]];
    
    [self showPickerForTableView:tableView andRow:self.selectedRow andIsVisble:NO];
}

/*
 This method deselects given time cell
 @param table instance
 @param row to select
 */
- (void)selectTimeCellForTableView:(UITableView *)tableView forTableRow:(NSInteger)row {
    self.selectedRow = row;
    [[self getTimeLabelForRow:row] setTextColor:[UIColor redColor]];
    [self showPickerForTableView:tableView andRow:self.selectedRow andIsVisble:YES];
}


#pragma mark - Picker view delegate methods

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
        case RSMinuteColumn:
            return 1;
        default:
            break;
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    @try {
        NSInteger selectedHoursRow = [pickerView selectedRowInComponent:RSHourSelector];
        NSString *selectedHoursValue = [self pickerView:pickerView
                                            titleForRow:selectedHoursRow
                                           forComponent:component];
            
        NSInteger selectedMinutesRow = [pickerView selectedRowInComponent:RSMinuteSelector];
        NSString *selectedMinutesValue = [self pickerView:pickerView
                                              titleForRow:selectedMinutesRow
                                             forComponent:component];
        
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

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case RSHourSelector:
            return [self.hoursList[row] stringValue];
        case RSHoursColumn:
             return RSHoursText;
        case RSMinuteSelector:
            return [self.minutesList[row] stringValue];
        case RSMinuteColumn:
            return RSMinutesText;
        default:
            break;
    }
    return nil;
}

#pragma mark - Screen transition methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.segueIdentifier = segue.identifier;
    
   if ([segue.identifier isEqualToString:RSAddRecipeCollectionButtonSegueIdentifier]
            || [segue.identifier isEqualToString:RSAddRecipeCollectionSegueDisclosureIdentifier]
             || [segue.identifier isEqualToString:RSAddRecipeCuisineButtonSegueIdentifier]
               || [segue.identifier isEqualToString:RSAddRecipeCuisineDisclosureSegueIdentifier]) {
        
        RSAddRecipeToOptionsTableViewController *optionsController = [[[segue destinationViewController] viewControllers]
                                                                      objectAtIndex:0];
        
        // set the delegate
        optionsController.delegate = self;
        
        // send the triggered segue
        optionsController.identifier = self.segueIdentifier;
       
       optionsController.isViewMode = self.isViewMode;
        
        // preset the last selected data
        if ([self.segueIdentifier isEqualToString:RSAddRecipeCuisineButtonSegueIdentifier]
            || [self.segueIdentifier isEqualToString:RSAddRecipeCuisineDisclosureSegueIdentifier]) {
            
            optionsController.selectedCuisine = self.selectedNewCuisine;
        }
        else {
            optionsController.selectedCollections = self.selectedCollections;
        }
    }
   else if ([segue.identifier isEqualToString:RSAddRecipeToIngredientsSegueIdentifier]
            || [segue.identifier isEqualToString:RSAddRecipeToIngredientsButtonSegueIdentifier]) {
       RSIngredientsTableViewController *ingredientsController = [[[segue destinationViewController] viewControllers]
                                                                  objectAtIndex:0];
       
       // set the delegate
       ingredientsController.delegate = self;
       ingredientsController.selectedIngredients = self.recipe.ingredient;
       ingredientsController.isViewMode = self.isViewMode;
   }
   else if ([segue.identifier isEqualToString:RSAddRecipeToStepsSegueIdentifier]
            || [segue.identifier isEqualToString:RSAddRecipeToStepsButtonSegueIdentifier]) {
       RSMethodTableViewController *optionsController = [[[segue destinationViewController] viewControllers]
                                                         objectAtIndex:0];
       // set the delegate
       optionsController.delegate = self;
       optionsController.selectedSteps = self.recipe.steps;
       optionsController.isViewMode = self.isViewMode;
   }
}

#pragma mark - RSAddRecipeToOptionsDelegate methods

- (void)viewOptionsDidCancel:(RSAddRecipeToOptionsTableViewController *)view {
    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewOptionsDidDone:(RSAddRecipeToOptionsTableViewController *)view {
    
    if ([self.segueIdentifier isEqualToString:RSAddRecipeCuisineButtonSegueIdentifier]
        || [self.segueIdentifier isEqualToString:RSAddRecipeCuisineDisclosureSegueIdentifier]) {
        
        self.selectedNewCuisine = view.selectedCuisine;
        
        [self.cuisineButton setTitle:view.selectedCuisine.cuisineName forState:UIControlStateNormal];
    }
    else {
        self.selectedCollections = view.selectedCollections;
        
        [self.collectionButton setTitle:[NSString stringWithFormat:RSShowCollectionCountFormat, @(view.selectedCollections.count).stringValue]
                               forState:UIControlStateNormal];
    }
    
    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - RSIngredientsTableViewDelegate methods

- (void)viewIngredientsDidCancel:(RSIngredientsTableViewController *)view {
    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewIngredientsDidDone:(RSIngredientsTableViewController *)view {
    self.recipe.ingredient = view.selectedIngredients;
    
    [self.ingredientsCountButton setTitle:[NSString stringWithFormat:RSShowIngredientsCountFormat, @(view.selectedIngredients.count).stringValue]
                           forState:UIControlStateNormal];
    
    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - RSMethodTableViewDelegate methods

- (void)viewMethodDidCancel:(RSMethodTableViewController *)view {
    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewMethodDidDone:(RSMethodTableViewController *)view {
    
    self.recipe.steps = view.selectedSteps;
    
    [self.stepsCountButton setTitle:[NSString stringWithFormat:RSShowStepsCountFormat, @(view.selectedSteps.count).stringValue]
                                 forState:UIControlStateNormal];
    
    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

@end
