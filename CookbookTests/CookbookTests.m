//
//  CookbookTests.m
//  CookbookTests
//
//  Created by Raksha Singhania on 28/11/14.
//  Copyright (c) 2014 Raksha Singhania. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RSDatabaseAccess.h"
#import "RSRecipe.h"

@interface CookbookTests : XCTestCase

@end

@implementation CookbookTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    RSDatabaseAccess *con = [RSDatabaseAccess instance];
    NSMutableArray *rows = [con fetchAllRecipes];
    //XCTAssertTrue(rows.count == 1);
    //XCTAssertTrue(rows.count == 2);
    
    // RSRecipe *recipe = [RSRecipe new];
    //recipe.recipeTitle = @"MyRecipe2";
    //XCTAssertTrue([con save:recipe] == YES);
    
    XCTAssertTrue(rows.count > 0);
}

@end
