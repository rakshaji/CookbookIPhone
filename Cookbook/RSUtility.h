//
//  RSUtility.h
//  Cookbook
//
//  Created by Raksha Singhania on 03/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSUtility : NSObject

/*
 This method changes star icon in the button or image view to yellow star
 */
+ (void)changeToYellowStar:(id)uiElement ;
/*
 This method changes star icon in the button or image view to grey star
 */
+ (void)changeToGreyStar:(id)uiElement ;
/*
 This method changes star icon in the button or image view to half star
 */
+ (void)changeToHalfStar:(id)uiElement ;

+ (BOOL)checkIfBlankOrNil:(NSString *)value;

+  (NSURL*)applicationDirectory ;

+ (NSString*)notNilValue:(NSString*)value;

@end
