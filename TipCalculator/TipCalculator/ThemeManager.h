//
//  ThemeManager.h
//  TipCalculator
//
//  Created by Nilesh Agrawal on 7/17/15.
//  Copyright (c) 2015 Nilesh Agrawal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Theme.h"

@interface ThemeManager : NSObject
+(id<Theme>)theme;

@end
