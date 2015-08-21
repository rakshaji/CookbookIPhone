//
//  RSRecipeViewController.h
//  Cookbook
//
//  Created by Raksha Singhania on 28/11/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSAddRecipeViewDelegate.h"
#import "RSAddRecipeViewController.h"

@interface RSRecipeViewController : UIViewController <RSAddRecipeViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *recipeTableView;

@end
