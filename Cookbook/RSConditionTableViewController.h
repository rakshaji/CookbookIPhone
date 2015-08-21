//
//  RSConditionTableViewController.h
//  Cookbook
//
//  Created by Raksha Singhania on 04/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSConditionTableViewControllerDelegate.h"
#import "RSSearchViewController.h"

@interface RSConditionTableViewController : UITableViewController <UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableViewCell *equalsConditionCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *greaterThanCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *lessThanCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *lessThanEqualCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *notEqualsCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *greaterThanEqualCell;
@property (weak, nonatomic) id<RSConditionTableViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;


/*
 Accessor methods to exchange data between two screens
 */
- (void)setConditions:(NSDictionary *)condition ;
- (NSDictionary *)conditions ;

- (void)setSelectedRow:(NSInteger)row ;
- (NSInteger)selectedRow ;

- (void)setSelectedData:(NSString *)selectedData;
- (NSString *)selectedData;

@end


