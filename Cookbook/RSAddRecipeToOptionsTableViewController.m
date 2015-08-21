//
//  RSOptionsTableViewController.m
//  Cookbook
//
//  Created by Raksha Singhania on 05/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import "RSAddRecipeToOptionsTableViewController.h"
#import "RSCuisine.h"
#import "RSCollection.h"
#import "RSDataExchange.h"

@interface RSAddRecipeToOptionsTableViewController ()

@property (strong, nonatomic) NSMutableArray *options;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSMutableArray *selectedCollections;
@property (strong, nonatomic) RSCuisine *selectedCuisine;
@property (strong, nonatomic) UIBarButtonItem *oldButton;

@end

@implementation RSAddRecipeToOptionsTableViewController

static NSString *const RSAddRecipeOptionReuseIdentifier = @"addRecipeOptionsCell";
static NSString *const RSAddToCollectionSegueIdentifier = @"addToCollectionSegue";
static NSString *const RSMoveToCollectionSegueIdentifier = @"moveToCollectionSegue";
static NSString *const RSAddToCollectionSectionHeaderTitle = @"Add/Move To";

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
    
    // This screen is
    if ([self.identifier isEqualToString:RSAddRecipeCollectionButtonSegueIdentifier]
        || [self.identifier isEqualToString:RSAddRecipeCollectionSegueDisclosureIdentifier]
        )
    {
        self.options = [RSDataExchange fetchAllCollections];
        self.optionsNavigationItem.title = RSCollectionSectionHeaderTitle;
    }
    else if ([self.identifier isEqualToString:RSAddToCollectionSegueIdentifier]) {
        self.options = [RSDataExchange fetchAllCollections];
        self.optionsNavigationItem.title = RSAddToCollectionSectionHeaderTitle;
    }
    else {
        self.options = [RSDataExchange fetchAllCuisines];
        self.optionsNavigationItem.title = RSCuisineSectionHeaderTitle;
    }
    
    // backup the old button before hiding
    if (self.oldButton == nil) {
        self.oldButton = self.navigationItem.rightBarButtonItem;
    }
    
    // hide the Save or done button when in view mode
    if (self.isViewMode) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Action handlers

- (IBAction)cancel:(id)sender {
    if ([self.identifier isEqualToString:RSAddToCollectionSegueIdentifier]
        || [self.identifier isEqualToString:RSMoveToCollectionSegueIdentifier])
    {
       [self.delegate viewCollectionDidCancel:self];
       return;
    }
    
    [self.delegate viewOptionsDidCancel:self];
}

- (IBAction)done:(id)sender {
    
    if ([self.identifier isEqualToString:RSAddToCollectionSegueIdentifier]
        || [self.identifier isEqualToString:RSMoveToCollectionSegueIdentifier])
     {
        [self.delegate viewCollectionDidDone:self];
        return;
     }
    
    [self.delegate viewOptionsDidDone:self];
}

#pragma mark - Table view data source and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RSAddRecipeOptionReuseIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ([self.identifier isEqualToString:RSAddRecipeCollectionSegueDisclosureIdentifier]
        || [self.identifier isEqualToString:RSAddRecipeCollectionButtonSegueIdentifier]
        || [self.identifier isEqualToString:RSAddToCollectionSegueIdentifier]
        || [self.identifier isEqualToString:RSMoveToCollectionSegueIdentifier]
        ) {
        
        cell.textLabel.text = [self.options[indexPath.row] collectionName];
        cell.tag = [self.options[indexPath.row] collectionId];
        
        for (RSCollection *collection in self.selectedCollections) {
            if (collection.collectionId == cell.tag) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    } else {
        cell.textLabel.text = [self.options[indexPath.row] cuisineName];
        cell.tag = [self.options[indexPath.row] cuisineId];
        
        if (cell.tag == self.selectedCuisine.cuisineId) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isViewMode) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    
    // store or delete recipe based on user selection
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.identifier isEqualToString:RSAddRecipeCollectionButtonSegueIdentifier]
            || [self.identifier isEqualToString:RSAddRecipeCollectionSegueDisclosureIdentifier]
            || [self.identifier isEqualToString:RSAddToCollectionSegueIdentifier]
            || [self.identifier isEqualToString:RSMoveToCollectionSegueIdentifier]) {

        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            if (self.selectedCollections == nil) {
                self.selectedCollections = [NSMutableArray arrayWithCapacity:0];
            }
            [self.selectedCollections addObject:self.options[indexPath.row]];
        }
        else {
            for (RSCollection *collection in self.selectedCollections) {
                if (collection.collectionId == cell.tag) {
                    [self.selectedCollections removeObject:collection];
                    break;
                }
            }
            
        }
    }
    else {
        self.selectedCuisine = (cell.accessoryType == UITableViewCellAccessoryNone) ? self.options[indexPath.row] : nil;
    }
    [tableView reloadData];
}


@end
