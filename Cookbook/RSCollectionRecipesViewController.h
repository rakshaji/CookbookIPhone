//
//  RSCollectionRecipesViewController.h
//  Cookbook
//
//  Created by Raksha Singhania on 07/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSCollectionRecipesViewDelegate.h"
#import "RSAllCollectionsTableViewController.h"
#import "RSAddRecipeToOptionsDelegate.h"
#import "RSAddRecipeToOptionsTableViewController.h"
#import "RSAddRecipeViewDelegate.h"
#import "RSCollection.h"

@interface RSCollectionRecipesViewController : UIViewController <RSAddRecipeToOptionsDelegate,
UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, RSAddRecipeViewDelegate>

@property (weak, nonatomic) id<RSCollectionRecipesViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UINavigationItem *collectionNavigationItem;
@property (strong, nonatomic) IBOutlet UITableView *recipeTableView;

- (void)setParentCollection:(RSCollection *)collection;
- (RSCollection*)parentCollection;

- (IBAction)selectRecipes:(UIBarButtonItem *)sender;
- (IBAction)deleteRecipesFromCollection:(UIBarButtonItem *)sender;

@end
