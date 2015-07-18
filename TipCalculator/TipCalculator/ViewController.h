//
//  ViewController.h
//  TipCalculator
//
//  Created by Nilesh Agrawal on 7/17/15.
//  Copyright (c) 2015 Nilesh Agrawal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipCalculator-Swift.h"

@interface ViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;

@property (weak, nonatomic) IBOutlet UILabel *lBillAmount;
@property (weak, nonatomic) IBOutlet UILabel *ltipAmount;
@property (weak, nonatomic) IBOutlet UILabel *ltotalAmount;
@property (weak, nonatomic) IBOutlet UILabel *lTip;

@property (weak, nonatomic) IBOutlet MKTextField *tfAmount;
@property (weak, nonatomic) IBOutlet UILabel *lTotal;
@property (weak, nonatomic) IBOutlet UIImageView *circleImage;

@end

