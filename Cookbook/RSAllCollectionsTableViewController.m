//
//  RSAllCollectionsTableViewController.m
//  Cookbook
//
//  Created by Raksha Singhania on 07/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import "RSAllCollectionsTableViewController.h"
#import "RSDataExchange.h"
#import "RSCollection.h"
#import "RSUtility.h"
#import "UIImage+Scale.h"

@interface RSAllCollectionsTableViewController ()

@property (strong, nonatomic) NSMutableArray *allCollections;

@end

@implementation RSAllCollectionsTableViewController

static NSString *const RSCollectionCellReuseIdentifier = @"collectionCell";

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
    
    // keep toolbar hidden for this view
    self.navigationController.toolbarHidden = YES;
    
    [self fetchCollections];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)fetchCollections {
    self.allCollections = [RSDataExchange fetchAllCollections];
}

#pragma mark - RSAddViewDelegate methods

- (void)viewDidCancel:(RSCollectionRecipesViewController *)view {
    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidDone:(RSCollectionRecipesViewController *)view {
    [view.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allCollections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RSCollectionCellReuseIdentifier forIndexPath:indexPath];
    NSString *collectionName = [self.allCollections[indexPath.row] collectionName];
    cell.textLabel.text = collectionName;
    return cell;
}

#pragma mark - Screen transition method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    RSCollectionRecipesViewController *collectionRecipeController = [segue destinationViewController];
    
    // set the delegate
    collectionRecipeController.delegate = self;
    
    NSIndexPath *indexPath = [self.collectionTableView indexPathForSelectedRow];
    
    RSCollection *collection = [RSCollection new];
    collection.collectionId = [self.allCollections[indexPath.row] collectionId];
    collection.collectionName = [self.allCollections[indexPath.row] collectionName];
    collectionRecipeController.parentCollection = collection;
}

#pragma mark - Action handlers

/*
 This method is called on click of save, to create a collection
 */
- (IBAction)addCollection:(UIBarButtonItem *)sender {
    UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:RSNewCollectionTitleText
                                                     message:RSNewCollectionDescriptionText
                                                    delegate:self
                                           cancelButtonTitle:RSCancelText
                                           otherButtonTitles:RSSaveText, nil];
    prompt.alertViewStyle = UIAlertViewStylePlainTextInput;
    [prompt show];
}

/*
 This method shows input prompt to take get collection name for the new collection
 */
- (void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[theAlert buttonTitleAtIndex:buttonIndex] isEqualToString:RSSaveText]) {
        NSString *collectionTitle = [theAlert textFieldAtIndex:0].text;
        
        RSCollection *collection = [RSCollection new];
        collection.collectionName = collectionTitle;
        
        // save collection
        [RSDataExchange addCollection:collection];
        
        // reload all collections in table
        [self fetchCollections];
        [self.collectionTableView reloadData];
    }
}

@end
