//
//  RSMethodTableViewController.h
//  Cookbook
//
//  Created by Raksha Singhania on 09/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSMethodTableViewDelegate.h"
#import "RSMethodTableViewController.h"

@interface RSMethodTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property BOOL isViewMode;
@property (strong, nonatomic) IBOutlet UITableView *stepsTableView;
@property (weak, nonatomic) id<RSMethodTableViewDelegate> delegate;

- (IBAction)cancel:(UIBarButtonItem *)sender;
- (IBAction)done:(UIBarButtonItem *)sender ;


/*
 Accessor methods to exchange data between two screens
 */
- (void)setSelectedSteps:(NSMutableArray *)steps;
- (NSMutableArray *)selectedSteps;

@end
