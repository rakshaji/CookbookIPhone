//
//  RSUtility.m
//  Cookbook
//
//  Created by Raksha Singhania on 03/12/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import "RSUtility.h"

@implementation RSUtility

/*
 This method changes star icon in the button or image view to yellow star
 */
+ (void)changeToYellowStar:(id)uiElement {
    if ([uiElement isKindOfClass:[UIButton class]]) {
        [uiElement setImage:[UIImage imageNamed:RSFullStar] forState:UIControlStateNormal];
    } else {
        [uiElement setImage:[UIImage imageNamed:RSFullStar]];
    }
}

/*
 This method changes star icon in the button or image view to grey star
 */
+ (void)changeToGreyStar:(id)uiElement {
    if ([uiElement isKindOfClass:[UIButton class]]) {
        [uiElement setImage:[UIImage imageNamed:RSNoStar] forState:UIControlStateNormal];
    } else {
        [uiElement setImage:[UIImage imageNamed:RSNoStar]];
    }
}

/*
 This method changes star icon in the button or image view to half star
 */
+ (void)changeToHalfStar:(id)uiElement {
    if ([uiElement isKindOfClass:[UIButton class]]) {
        [uiElement setImage:[UIImage imageNamed:RSHalfStar] forState:UIControlStateNormal];
    } else {
        [uiElement setImage:[UIImage imageNamed:RSHalfStar]];
    }
}

+ (BOOL)checkIfBlankOrNil:(NSString *)value {
    if (value != nil && ![value isEqualToString:RSBlankText]) {
        return false;
    }
    return true;
}


+  (NSURL*)applicationDirectory {
    NSString* bundleID = [[NSBundle mainBundle] bundleIdentifier];
    
    NSFileManager* fm = [NSFileManager defaultManager];
    
    NSURL* dirPath = nil;
    
    // Find the application support directory in the home directory.
    
    NSArray* appSupportDir = [fm URLsForDirectory:NSApplicationSupportDirectory
                                        inDomains:NSUserDomainMask];
    
    if ([appSupportDir count] > 0)
     {
        
        // Append the bundle ID to the URL for the
        
        // Application Support directory
        
        dirPath = [[appSupportDir objectAtIndex:0] URLByAppendingPathComponent:bundleID];
        
        // If the directory does not exist, this method creates it.
        
        NSError* theError = nil;
        
        if (![fm createDirectoryAtURL:dirPath withIntermediateDirectories:YES
                           attributes:nil error:&theError])
         {
            return nil;
         }
     }
    return dirPath;
}

/*
 This method returns the blank string for nil values, else returns the value itself.
 @return blank string if nil, else passed value
 */
+ (NSString*)notNilValue:(NSString*)value {
    return value == nil ? RSBlankText : value;
}

@end
