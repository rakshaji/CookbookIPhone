//
//  RSMethodTableViewController.m
//  Cookbook
//
//  Created by Raksha Singhania on 09/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import "RSMethodTableViewController.h"
#import "RSSteps.h"

@interface RSMethodTableViewController ()

@property (strong, nonatomic) NSMutableArray *selectedSteps;
@property (strong, nonatomic) UIBarButtonItem *oldButton;

@end

@implementation RSMethodTableViewController

static NSString *const RSStepsTextAreaCellReuseIdentifier = @"stepsTextAreaCell";
static NSString *const RSStepsCellReuseIdentifier = @"addStepsCell";

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

    [self setEditing:!self.isViewMode animated:!self.isViewMode];
    
    // backup navigation button before hiding it in view mode
    if (self.oldButton == nil) {
        self.oldButton = self.navigationItem.rightBarButtonItem;
    }
    
    if (self.isViewMode) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isViewMode) {
        return self.selectedSteps.count;
    }
    
    NSInteger rowCount = self.selectedSteps == nil? 1 :self.selectedSteps.count+1;
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int rowNumber = (int)indexPath.row;
    
    if (self.isViewMode) {
        UITableViewCell *stepCell = [tableView dequeueReusableCellWithIdentifier:RSStepsTextAreaCellReuseIdentifier];
        
        UITextView *stepTextView = stepCell.contentView.subviews[0];
        stepTextView.text = [self.selectedSteps[rowNumber] instruction];
        stepTextView.editable = NO;
        stepTextView.tag = rowNumber;
        
        UILabel *label = stepCell.contentView.subviews[1];
        label.text = [NSString stringWithFormat:RSStepCountTextFormat, rowNumber+1];
        
        return stepCell;
    }
    
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:0] - 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RSStepsCellReuseIdentifier
                                                                forIndexPath:indexPath];
        cell.textLabel.text = RSAddStepText;
        return cell;
    }
    else {
        
        UITableViewCell *stepCell = [tableView dequeueReusableCellWithIdentifier:RSStepsTextAreaCellReuseIdentifier];
        
        UITextView *stepTextView = stepCell.contentView.subviews[0];
        UILabel *label = stepCell.contentView.subviews[1];
        
        label.text = [NSString stringWithFormat:RSStepCountTextFormat, rowNumber+1];
        
        stepTextView.text = [self.selectedSteps[rowNumber] instruction];
        stepTextView.tag = rowNumber;
        
        return stepCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = tableView.rowHeight;
    
    if (self.isViewMode) {
        return 100;
    }
    
    if (indexPath.row != [self tableView:tableView numberOfRowsInSection:0] - 1) {
        height = 100;
    }
    return height;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.stepsTableView setEditing:editing animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isViewMode) {
        return UITableViewCellEditingStyleNone;
    }
    
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:0] - 1) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:0] - 1) {
        [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleInsert
      forRowAtIndexPath:indexPath];
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.selectedSteps removeObjectAtIndex:indexPath.row];
        
        [self tableView:tableView numberOfRowsInSection:0];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                 withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        if (self.selectedSteps == nil) {
            self.selectedSteps = [NSMutableArray arrayWithCapacity:0];
        }
        [self.selectedSteps addObject:[RSSteps new]];
        
        [self tableView:tableView numberOfRowsInSection:0];
        
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                 withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Action handlers

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self.delegate viewMethodDidCancel:self];
}

- (IBAction)done:(UIBarButtonItem *)sender {
    [self.delegate viewMethodDidDone:self];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    ((RSSteps*)self.selectedSteps[textView.tag]).instruction = textView.text;
}

@end
