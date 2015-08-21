//
//  RSConditionTableViewController.m
//  Cookbook
//
//  Created by Raksha Singhania on 04/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import "RSConditionTableViewController.h"

@interface RSConditionTableViewController ()

@property (strong, nonatomic) RSSearchViewController *searchViewController;
@property NSInteger selectedRow;
@property NSString *selectedData;
@property NSDictionary *conditions;

enum {
    RSEquals,
    RSGreaterThan,
    RSLessThan,
    RSLessthanEquals,
    RSGreaterThanEquals,
    RSNotEquals
};

@end

@implementation RSConditionTableViewController

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
    self.conditions = @{
                        [NSNumber numberWithInt:RSEquals]: RSEqualsConditionText,
                        [NSNumber numberWithInt:RSGreaterThan]: RSGreaterThanConditionText,
                        [NSNumber numberWithInt:RSLessThan]: RSLessThanConditionText,
                        [NSNumber numberWithInt:RSLessthanEquals]: RSLessthanEqualsConditionText,
                        [NSNumber numberWithInt:RSGreaterThanEquals]: RSGreaterThanEqualsConditionText,
                        [NSNumber numberWithInt:RSNotEquals]: RSNotEqualsConditionText
                    };
    self.selectedRow = 0;// default is Equals option from the condition list
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch (indexPath.row) {
        case RSEquals:
            cell = self.equalsConditionCell;
            cell.textLabel.text = [self.conditions objectForKey:[NSNumber numberWithInt:RSEquals]];
            break;
        case RSGreaterThan:
            cell = self.greaterThanCell;
            cell.textLabel.text = [self.conditions objectForKey:[NSNumber numberWithInt:RSGreaterThan]];
            break;
        case RSGreaterThanEquals:
            cell = self.greaterThanEqualCell;
            cell.textLabel.text = [self.conditions objectForKey:[NSNumber numberWithInt:RSGreaterThanEquals]];
            break;
        case RSLessThan:
            cell = self.lessThanCell;
            cell.textLabel.text = [self.conditions objectForKey:[NSNumber numberWithInt:RSLessThan]];
            break;
        case RSLessthanEquals:
            cell = self.lessThanEqualCell;
            cell.textLabel.text = [self.conditions objectForKey:[NSNumber numberWithInt:RSLessthanEquals]];
            break;
        case RSNotEquals:
            cell = self.notEqualsCell;
            cell.textLabel.text = [self.conditions objectForKey:[NSNumber numberWithInt:RSNotEquals]];
            break;
        default:
            break;
    }
    
    NSString *currentRowData = cell.textLabel.text;
    
    if ([self.selectedData isEqualToString:currentRowData]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRow = indexPath.row;
    
    NSString *currentRowData = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    if (self.selectedData == nil || ![self.selectedData isEqualToString:currentRowData]) {
        self.selectedData = currentRowData;
    }
    
    [tableView reloadData];
}

#pragma mark - Action handlers

- (IBAction)cancel:(id)sender {
    [self.delegate viewDidCancel:self];
}

- (IBAction)done:(id)sender {
    [self.delegate viewDidDone:self];
}


@end
