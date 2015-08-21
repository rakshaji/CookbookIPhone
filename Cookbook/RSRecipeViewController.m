//
//  RSRecipeViewController.m
//  Cookbook
//
//  Created by Raksha Singhania on 28/11/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import "RSRecipeViewController.h"
#import "RSDataExchange.h"
#import "RSUtility.h"
#import "UIImage+Scale.h"

@interface RSRecipeViewController ()

@property (strong, nonatomic) NSMutableArray *recipes;

@end

@implementation RSRecipeViewController

static NSString *const RSViewRecipeSegueIdentifier = @"viewRecipeSegue";
static NSString *const RSAllRecipeReuseIdentifer = @"RecipeCell";

#pragma mark - View controller methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchRecipes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    RSAddRecipeViewController *addRecipeController = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
    
    // set the delegate
    addRecipeController.delegate = self;
    
    if ([segue.identifier isEqualToString:RSViewRecipeSegueIdentifier]) {
        RSRecipe *recipe = self.recipes[((UITableViewCell*)sender).tag];
        addRecipeController.recipe = recipe;
    }
    else {
        addRecipeController.recipe = nil;
    }
    
}

#pragma mark - Utility methods

- (void)fetchRecipes {
    self.recipes = [RSDataExchange fetchAllRecipes];
}

#pragma mark - RSAddViewDelegate methods

- (void)viewDidCancel:(RSAddRecipeViewController *)view {
    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidDone:(RSAddRecipeViewController *)view {

    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    // load all recipes from db
    [self fetchRecipes];
    [self.recipeTableView reloadData];
}

#pragma mark - Table view data source and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recipes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RSAllRecipeReuseIdentifer forIndexPath:indexPath];
    NSString *recipeName = [self.recipes[indexPath.row] recipeTitle];
    cell.textLabel.text = recipeName;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
