//
//  ThemeManager.m
//  TipCalculator
//
//  Created by Nilesh Agrawal on 7/17/15.
//  Copyright (c) 2015 Nilesh Agrawal. All rights reserved.
//

#import "ThemeManager.h"
#import "TipCalculatorTheme.h"

@implementation ThemeManager
+(id<Theme> )theme{
    static TipCalculatorTheme *sharedTheme = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTheme = [[TipCalculatorTheme alloc] init];
    });
    return sharedTheme;
}
@end
