//
//  Theme.h
//  TipCalculator
//
//  Created by Nilesh Agrawal on 7/17/15.
//  Copyright (c) 2015 Nilesh Agrawal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol Theme <NSObject>

-(void)themeForLabels:(UILabel *)label;
-(void)themForBackGround:(UIView *)view;
-(void)themeForSeparators:(UIView *)view;
-(void)themeForIgnoreViews:(UIView *)view;
-(void)themeForTextField:(UITextField *)textField withPlaceHolder:(NSString *)string;




@end
