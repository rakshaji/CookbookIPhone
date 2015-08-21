//
//  RSConstants.h
//  Cookbook
//
//  Created by Raksha Singhania on 05/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSConstants : NSObject

// Segues
extern NSString *const RSCollectionSegueDisclosureIdentifier;
extern NSString *const RSCollectionButtonSegueIdentifier;
extern NSString *const RSAddRecipeCollectionSegueDisclosureIdentifier ;
extern NSString *const RSAddRecipeCollectionButtonSegueIdentifier ;


// Labels
extern NSString *const RSCollectionSectionHeaderTitle;
extern NSString *const RSCuisineSectionHeaderTitle;
extern NSString *const RSNoResultsSectionHeaderTitle;
extern NSString *const RSViewRecipeHeaderDefault;

extern NSString *const RSEqualsConditionText;
extern NSString *const RSGreaterThanConditionText;
extern NSString *const RSLessThanConditionText;
extern NSString *const RSLessthanEqualsConditionText;
extern NSString *const RSGreaterThanEqualsConditionText;
extern NSString *const RSNotEqualsConditionText;
extern NSString *const RSHoursText;
extern NSString *const RSMinutesText;
extern NSString *const RSTakePhotoText;
extern NSString *const RSChoosePhotoText;
extern NSString *const RSDeletePhotoText;
extern NSString *const RSCancelText;
extern NSString *const RSSelectText;
extern NSString *const RSSaveText;
extern NSString *const RSSubmitText;
extern NSString *const RSDeleteFromCollectionButtonText;
extern NSString *const RSDeleteFromCollectionTitleText;
extern NSString *const RSNoPhoto;
extern NSString *const RSNewCollectionTitleText;
extern NSString *const RSNewCollectionDescriptionText;
extern NSString *const RSDuplicateNameSuffix;
extern NSString *const RSTitleRequiredText;
extern NSString *const RSDefaultTimeText;
extern NSString *const RSBlankText;
extern NSString *const RSAddUnitText;
extern NSString *const RSAddIngredientText;
extern NSString *const RSAddStepText;
extern NSString *const RSDefaultConditionText;
extern NSString *const RSStepCountTextFormat;

extern NSString *const RSImageNameFormat;
extern NSString *const RSShowIngredientsCountFormat;
extern NSString *const RSShowCollectionCountFormat;
extern NSString *const RSShowStepsCountFormat;
extern NSString *const RSTimeFormat;

// image names
extern NSString *const RSHalfStar;
extern NSString *const RSNoStar;
extern NSString *const RSFullStar;

// table and column names
extern NSString *const RSColumnRecipeTitle;
extern NSString *const RSColumnWebsite;
extern NSString *const RSColumnRating;
extern NSString *const RSColumnCooktime;
extern NSString *const RSColumnTotalTime;
extern NSString *const RSColumnPrepTime;
extern NSString *const RSColumnCalories;
extern NSString *const RSColumnCollectionName;
extern NSString *const RSColumnCuisineName;
extern NSString *const RSColumnYields;
extern NSString *const RSColumnIngredientItem;



@end
