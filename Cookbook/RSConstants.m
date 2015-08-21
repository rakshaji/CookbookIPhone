//
//  RSConstants.m
//  Cookbook
//
//  Created by Raksha Singhania on 05/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import "RSConstants.h"

@implementation RSConstants

NSString *const RSCollectionSegueDisclosureIdentifier = @"collectionOptionsSegue";
NSString *const RSCollectionButtonSegueIdentifier = @"collectionButtonSegue";
NSString *const RSAddRecipeCollectionSegueDisclosureIdentifier = @"addRecipeCollectionToOptionsSegue";
NSString *const RSAddRecipeCollectionButtonSegueIdentifier = @"addRecipeCollectionButtonToOptionsSegue";

// labels
NSString *const RSCollectionSectionHeaderTitle = @"Collections";
NSString *const RSCuisineSectionHeaderTitle = @"Cuisines";
NSString *const RSNoResultsSectionHeaderTitle = @"No results found";
NSString *const RSViewRecipeHeaderDefault = @"Details";
NSString *const RSShowIngredientsCountFormat = @"%@ item(s)";
NSString *const RSShowCollectionCountFormat = @"%@ selected";
NSString *const RSShowStepsCountFormat = @"%@ step(s)";
NSString *const RSTimeFormat = @"%02d:%02d";
NSString *const RSBlankText = @"";
NSString *const RSAddUnitText = @"add unit";
NSString *const RSAddIngredientText = @"add ingredient";
NSString *const RSAddStepText = @"add step";
NSString *const RSEqualsConditionText = @"equals";
NSString *const RSGreaterThanConditionText = @"greater than";
NSString *const RSLessThanConditionText = @"less than";
NSString *const RSLessthanEqualsConditionText = @"less than equals";
NSString *const RSGreaterThanEqualsConditionText = @"greater than equals";
NSString *const RSNotEqualsConditionText = @"not equals";
NSString *const RSHoursText = @"hours";
NSString *const RSMinutesText = @"mins";
NSString *const RSTakePhotoText = @"Take Photo";
NSString *const RSChoosePhotoText = @"Choose Photo";
NSString *const RSDeletePhotoText = @"Delete Photo";
NSString *const RSCancelText = @"Cancel";
NSString *const RSDefaultTimeText = @"00:00";
NSString *const RSSelectText = @"Select";
NSString *const RSSaveText = @"Save";
NSString *const RSSubmitText = @"Submit";
NSString *const RSDeleteFromCollectionButtonText = @"Remove from Collection";
NSString *const RSDeleteFromCollectionTitleText = @"These recipes will be removed from this collection, but will remain under Recipes tab";
NSString *const RSNewCollectionTitleText = @"New Collection";
NSString *const RSNewCollectionDescriptionText = @"Enter a name for this collecton.";
NSString *const RSDuplicateNameSuffix = @" (1)";
NSString *const RSTitleRequiredText = @"Title*";
NSString *const RSImageNameFormat = @"%@.png";
NSString *const RSDefaultConditionText = @"equals";
NSString *const RSStepCountTextFormat = @"Step %d";

// image names
NSString *const RSHalfStar = @"halfStar";
NSString *const RSNoStar = @"noStar";
NSString *const RSFullStar = @"fullstar";
NSString *const RSNoPhoto = @"no_image";

// column names
NSString *const RSColumnRecipeTitle = @"RecipeTitle";
NSString *const RSColumnWebsite = @"Website";
NSString *const RSColumnRating = @"Rating";
NSString *const RSColumnCooktime = @"CookTime";
NSString *const RSColumnTotalTime = @"TotalTime";
NSString *const RSColumnPrepTime = @"PrepTime";
NSString *const RSColumnCalories = @"Calories";
NSString *const RSColumnCollectionName = @"CollectionName";
NSString *const RSColumnCuisineName = @"CuisineName";
NSString *const RSColumnYields = @"Yields";
NSString *const RSColumnIngredientItem = @"Item";

@end
