//
//  RSOptionsTableViewController.m
//  Cookbook
//
//  Created by Raksha Singhania on 05/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import "RSUnitTableViewController.h"

@interface RSUnitTableViewController ()

@property (strong, nonatomic) NSMutableArray *options;
@property (strong, nonatomic) NSString *selectedUnit;

@end

@implementation RSUnitTableViewController

static NSString *const RSAddUnitsReuseIdentifer = @"unitOptionsCell";

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

    // unit options
    self.options = [NSMutableArray arrayWithObjects:@"tsp", @"tbsp", @"cup", @"lb", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Action handlers

- (IBAction)cancel:(id)sender {
    [self.delegate viewUnitOptionsDidCancel:self];
}

- (IBAction)done:(id)sender {
    [self.delegate viewUnitOptionsDidDone:self];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RSAddUnitsReuseIdentifer forIndexPath:indexPath];

    cell.textLabel.text = self.options[indexPath.row];
    
    NSString *currentRowData = cell.textLabel.text;
    
    if ([currentRowData isEqualToString:self.selectedUnit]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *currentRowData = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    if (self.selectedUnit == nil || ![self.selectedUnit isEqualToString:currentRowData]) {
        self.selectedUnit = currentRowData;
    }
    
    [self done:nil];
}

@end
