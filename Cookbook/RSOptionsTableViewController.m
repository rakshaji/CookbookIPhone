//
//  RSOptionsTableViewController.m
//  Cookbook
//
//  Created by Raksha Singhania on 05/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import "RSOptionsTableViewController.h"
#import "RSCuisine.h"
#import "RSCollection.h"
#import "RSDataExchange.h"

@interface RSOptionsTableViewController ()

@property (strong, nonatomic) NSMutableArray *options;

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *selectedData;

@end

@implementation RSOptionsTableViewController

static NSString *const RSOptionsCellReuseIdentifier = @"optionsCell";

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
    
    if ([self.identifier isEqualToString:RSCollectionSegueDisclosureIdentifier]
        || [self.identifier isEqualToString:RSCollectionButtonSegueIdentifier]) {
        self.options = [RSDataExchange fetchAllCollections];
        self.optionsNavigationItem.title = RSCollectionSectionHeaderTitle;
    } else {
        self.options = [RSDataExchange fetchAllCuisines];
        self.optionsNavigationItem.title = RSCuisineSectionHeaderTitle;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action handler methods

- (IBAction)cancel:(id)sender {
    [self.delegate viewOptionsDidCancel:self];
}

- (IBAction)done:(id)sender {
    [self.delegate viewOptionsDidDone:self];
}

#pragma mark - Table view data source and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RSOptionsCellReuseIdentifier
                                                            forIndexPath:indexPath];
    
    if ([self.identifier isEqualToString:RSCollectionSegueDisclosureIdentifier]
        || [self.identifier isEqualToString:RSCollectionButtonSegueIdentifier]) {
        cell.textLabel.text = [self.options[indexPath.row] collectionName];
    } else {
        cell.textLabel.text = [self.options[indexPath.row] cuisineName];
    }
    
    NSString *currentRowData = cell.textLabel.text;
    
    // do not deselect if the tapped row has checkmark already
    if ([currentRowData isEqualToString:self.selectedData]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *currentRowData = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    if (self.selectedData == nil || ![self.selectedData isEqualToString:currentRowData]) {
        self.selectedData = currentRowData;
    } else {
        self.selectedData = nil;
    }
    
    [tableView reloadData];
}

@end
