//
//  RSCollectionRecipesViewController.m
//  Cookbook
//
//  Created by Raksha Singhania on 07/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import "RSCollectionRecipesViewController.h"
#import "RSDataExchange.h"
#import "RSUtility.h"
#import "UIImage+Scale.h"
#import "RSAddRecipeViewController.h"

@interface RSCollectionRecipesViewController ()

@property (strong, nonatomic) NSMutableArray *recipes;
@property (strong, nonatomic) RSCollection *parentCollection;
@property (strong, nonatomic) NSMutableArray *selectedCollections;
@property (strong, nonatomic) NSMutableArray *selectedRecipes;

enum {
    RSDeleteRecipeFromCollection = 0
};

enum  {
    RSRowHeight = 70,
    RSTotalSections = 1
};

/*
 This method enables or disables the bottom toolbar buttons
 @param boolean value, true to enable else false
 */
- (void)enableToobarButtons:(BOOL)isEnabled;

/*
 This method gives a confirmation alert for deletion of recipes from collection
 */
- (void)confirmDeletion;

/*
 Fetches recipes for the collection
 */
- (void)fetchRecipes;

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@implementation RSCollectionRecipesViewController

static NSString *const RSCollectionToViewRecipeSegueIdentifier = @"collectionToViewRecipes";
static NSString *const RSRecipesOfCollectionCellReuseIdentifier = @"RecipeCollectionCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // hide the bottom toolbar
    self.navigationController.toolbarHidden = YES;
    
    // change the title with the selected collection name
    self.collectionNavigationItem.title = self.parentCollection.collectionName;
    
    // fetch recipes for the collection
    [self fetchRecipes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:RSCollectionToViewRecipeSegueIdentifier]) {
        
        RSAddRecipeViewController *addRecipeController = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        
        // set the delegate
        addRecipeController.delegate = self;
        
        RSRecipe *recipe = self.recipes[((UITableViewCell*)sender).tag];
        addRecipeController.recipe = recipe;
    }
    else {
        RSAddRecipeToOptionsTableViewController *addRecipeController = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        
        // set the delegate
        addRecipeController.delegate = self;
        addRecipeController.identifier = segue.identifier;
        
        self.selectedCollections = [NSMutableArray arrayWithObject:self.parentCollection];
        addRecipeController.selectedCollections = self.selectedCollections;
    }
}

#pragma mark - Table view data source and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return RSTotalSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recipes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RSRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RSRecipesOfCollectionCellReuseIdentifier
                                                            forIndexPath:indexPath];
    NSString *recipeName = [self.recipes[indexPath.row] recipeTitle];
    cell.textLabel.text = recipeName;
    cell.tag = indexPath.row;
    
    if (self.navigationController.toolbarHidden == NO) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        for (RSRecipe *recipe in self.selectedRecipes) {
            if ([recipe.recipeTitle isEqualToString:cell.textLabel.text]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    
    NSString *imagePath = [self.recipes[indexPath.row] imagePath];
    UIImage *image;
    
    if ([RSUtility checkIfBlankOrNil:imagePath]) {
        image = [UIImage imageNamed:RSNoPhoto];
    }
    else {
        NSData *pngData = [NSData dataWithContentsOfFile:imagePath];
        image = [UIImage imageWithData:pngData];
    }
    @autoreleasepool {
        UIImage *scaledImage = [image scaleToSize:CGSizeMake(75.0f, 70.0f)];
        cell.imageView.image = scaledImage;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.navigationController.toolbarHidden == NO) {
        // store or delete recipe based on user selection
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            if (self.selectedRecipes == nil) {
                self.selectedRecipes = [NSMutableArray arrayWithCapacity:0];
            }
            
            [self.selectedRecipes addObject:self.recipes[indexPath.row]];
        }
        else {
            [self.selectedRecipes removeObject:self.recipes[indexPath.row]];
        }
        
        // enable/disable toolbar buttons - Add to and delete buttons
        [self enableToobarButtons:(self.selectedRecipes.count > 0 ? YES : NO)];
    }
    [tableView reloadData];
}

#pragma mark - Utility methods

/*
 This method enables or disables the bottom toolbar buttons
 @param boolean value, true to enable else false
 */
- (void)enableToobarButtons:(BOOL)isEnabled {
    UIBarButtonItem *addToButton = self.toolbarItems[0];
    addToButton.enabled = isEnabled;
    
    UIBarButtonItem *deleteButton = self.toolbarItems[2];
    deleteButton.enabled = isEnabled;
}


/*
 This method gives a confirmation alert for deletion of recipes from collection
 */
- (void)confirmDeletion {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:RSDeleteFromCollectionTitleText
                                                             delegate:self
                                                    cancelButtonTitle:RSCancelText
                                               destructiveButtonTitle:RSDeleteFromCollectionButtonText
                                                    otherButtonTitles: nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)fetchRecipes {
    self.recipes = [RSDataExchange fetchAllRecipesByCollectionId:self.parentCollection.collectionId];
}

#pragma mark - Action handlers

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == RSDeleteRecipeFromCollection) {
        [RSDataExchange deleteRecipes:self.selectedRecipes fromCollection:self.parentCollection.collectionId];
        
        [self enableToobarButtons:NO];
        
        [self fetchRecipes];
        
        [self.recipeTableView reloadData];
    }
    else {
        // cancel
        return;
    }
}

/*
 This method is called on click of 'Select' or 'Cancel' button, depending on selection changes the
 screen accordingly.
 */
- (IBAction)selectRecipes:(UIBarButtonItem *)sender {
    // check which button was clicked and reset the view accordingly
    if ([sender.title isEqualToString:RSCancelText]) {
        sender.title = RSSelectText;
        self.navigationController.toolbarHidden = YES;

    }
    else {
        sender.title = RSCancelText;
        self.navigationController.toolbarHidden = NO;
        [self enableToobarButtons:NO];
    }
    [self clearRecipeSelection];
    //[self.recipeTableView reloadData];
}

- (void)clearRecipeSelection {
    if (self.selectedRecipes != nil) {
        [self.selectedRecipes removeAllObjects];
    }
    [self.recipeTableView reloadData];
    [self enableToobarButtons:NO];
}

/*
 This method responds to the click on delete button to delete recipes from collection
 */
- (IBAction)deleteRecipesFromCollection:(UIBarButtonItem *)sender {
    [self confirmDeletion];
}

#pragma mark - RSAddRecipeViewDelegate methods

- (void)viewDidCancel:(RSAddRecipeViewController *)view {
    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidDone:(RSAddRecipeViewController *)view {
    
    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    // load all recipes from db
    [self fetchRecipes];
    [self.recipeTableView reloadData];
}

#pragma mark - RSAddViewDelegate methods

- (void)viewCollectionDidCancel:(RSAddRecipeToOptionsTableViewController *)view {
    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewCollectionDidDone:(RSAddRecipeToOptionsTableViewController *)view {
    
    [RSDataExchange addCollection:view.selectedCollections forRecipes:self.selectedRecipes];
    
    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    // load all recipes from db
    [self fetchRecipes];
    [self clearRecipeSelection];
    
}

@end
