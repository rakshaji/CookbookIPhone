//
//  RSSearchResultTableViewController.m
//  Cookbook
//
//  Created by Raksha Singhania on 05/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import "RSSearchResultTableViewController.h"
#import "RSDataExchange.h"
#import "RSUtility.h"
#import "UIImage+Scale.h"

@interface RSSearchResultTableViewController ()

@property (strong, nonatomic) RSSearchCriteria *searchCriteria;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *selectedData;
@property (strong, nonatomic) NSMutableArray *recipes;

@end

@implementation RSSearchResultTableViewController

static NSString *const RSSearchToViewRecipesSegueIdentifier = @"searchToViewRecipes";
static NSString *const RSSeachResultCellReuseIdentifier = @"resultCell";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.recipes = [RSDataExchange searchRecipes:self.searchCriteria];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:RSSearchToViewRecipesSegueIdentifier]) {
        
        RSAddRecipeViewController *addRecipeController = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        
        // set the delegate
        addRecipeController.delegate = self;
        
        RSRecipe *recipe = self.recipes[((UITableViewCell*)sender).tag];
        addRecipeController.recipe = recipe;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.recipes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RSSeachResultCellReuseIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.recipes[indexPath.row] recipeTitle];
    cell.tag = indexPath.row;
    
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title;
    if (self.recipes.count == 0) {
        title = RSNoResultsSectionHeaderTitle;
    }
    return title;
}

#pragma mark - RSAddRecipeViewDelegate methods

- (void)viewDidCancel:(RSAddRecipeViewController *)view {
    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidDone:(RSAddRecipeViewController *)view {
    
    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    // reload recipes from db
    self.recipes = [RSDataExchange searchRecipes:self.searchCriteria];
    [self.tableView reloadData];
}


@end
