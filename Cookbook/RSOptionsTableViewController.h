//
//  RSOptionsTableViewController.h
//  Cookbook
//
//  Created by Raksha Singhania on 05/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSOptionTableViewDelegate.h"
#import "RSSearchViewController.h"

@interface RSOptionsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) id<RSOptionTableViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UINavigationItem *optionsNavigationItem;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

/*
 Accessor methods to exchange data between the two screens
 */
- (void)setIdentifier:(NSString *)identifier;
- (NSString *)identifier;

- (void)setSelectedData:(NSString *)selectedData;
- (NSString *)selectedData;

@end
