//
//  TipCalculatorTheme.m
//  TipCalculator
//
//  Created by Nilesh Agrawal on 7/17/15.
//  Copyright (c) 2015 Nilesh Agrawal. All rights reserved.
//

#import "TipCalculatorTheme.h"
#import "TipCalculator-Swift.h"

@implementation TipCalculatorTheme

-(UIColor *)backGroundColor{
    return [UIColor colorWithRed:0.36 green:0.40 blue:0.46 alpha:1];
}

-(UIColor *)separatorColor{
    return [UIColor whiteColor];
}

-(UIColor *)labelColor{
    return [UIColor whiteColor];
}
-(void)themeForLabels:(UILabel *)label{
    [label setTextColor:[self labelColor]];
    [label setFont:[UIFont fontWithName:@"Georgia" size:20.00]];
}

-(void)themeForSeparators:(UIView *)view{
    
     [view setBackgroundColor:[self separatorColor]];
}
-(void)themeForIgnoreViews:(UIView *)view{
    [view setBackgroundColor:[self backGroundColor]];
}
-(void)themForBackGround:(UIView *)view{
    [view setBackgroundColor:[self backGroundColor]];
}

-(void)themeForTextField:(MKTextField *)textField withPlaceHolder:(NSString *)placeHolder{
    textField.layer.borderColor = [UIColor clearColor].CGColor;
    textField.placeholder = placeHolder;
    textField.cornerRadius = 0;
    textField.bottomBorderEnabled = YES;
    [textField setFont:[UIFont fontWithName:@"Georgia" size:36.00]];
    [textField setValue:[self labelColor] forKeyPath:@"_placeholderLabel.textColor"];
    [textField setTintColor:[self labelColor]];
    [textField setTextColor:[self labelColor]];
}

@end
