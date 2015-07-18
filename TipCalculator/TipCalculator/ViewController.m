//
//  ViewController.m
//  TipCalculator
//
//  Created by Nilesh Agrawal on 7/17/15.
//  Copyright (c) 2015 Nilesh Agrawal. All rights reserved.
//

#import "ViewController.h"
#import "NGOneFingerRotationGestureRecognizer.h"


static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface ViewController ()
@property UIColor *backGroundColor;
@property UIColor *whiteColor;
@property (weak, nonatomic) IBOutlet UILabel *selectTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipPercentageLabel;
@property CGFloat animatedDistance;
@property CGFloat percentage;
@property NSNumber *billMade;
@end

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    _backGroundColor= [UIColor colorWithRed:0.36 green:0.40 blue:0.46 alpha:1];
    _whiteColor = [UIColor whiteColor];
        [self setUpView];
    _percentage = 0.00;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.circleImage.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
}

- (void)handleRotationGesture:(NGOneFingerRotationGestureRecognizer *)gestureRecognizer
{
    
    
    CGFloat radians = atan2f(self.circleImage.transform.b, self.circleImage.transform.a);
    CGFloat imageAngle = radians * (180 / M_PI);
    if (imageAngle > 0)
        imageAngle = imageAngle;
    else if (imageAngle < 0 )
        imageAngle +=360 ;
    
    _percentage = (imageAngle/360)*100;
    
    NSLog(@"image percent %f",_percentage);
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        gestureRecognizer.rotation = atan2(self.circleImage.transform.b, self.circleImage.transform.a);
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.circleImage.transform = CGAffineTransformMakeRotation(gestureRecognizer.rotation);
    }
    [self updateDisplay];
}

-(void)setUpView{
    
    NGOneFingerRotationGestureRecognizer * gestureRecognizer = [[NGOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGesture:)];
    [self.circleImage addGestureRecognizer:gestureRecognizer];
    _tfAmount.delegate = self;
    self.view.backgroundColor  = _backGroundColor;    
    [_view1 setBackgroundColor:_backGroundColor];
    [_view2 setBackgroundColor:_backGroundColor];
    [_view3 setBackgroundColor:_backGroundColor];
    [_view4 setBackgroundColor:_whiteColor];
    [_view5 setBackgroundColor:_whiteColor];
    [_lTip setTextColor:_whiteColor];
    [_ltipAmount setTextColor:_whiteColor];
    [_lTotal setTextColor:_whiteColor];
    [_lTotal setFont:[UIFont fontWithName:@"Georgia" size:20.00]];
    [_lBillAmount setTextColor:_whiteColor];
    [_lBillAmount setFont:[UIFont fontWithName:@"Georgia" size:20.00]];
    [_ltotalAmount setTextColor:_whiteColor];
    [_ltotalAmount setFont:[UIFont fontWithName:@"Georgia" size:20.00]];
    [_ltipAmount setTextColor:_whiteColor];
    
    [_tipPercentageLabel setTextColor:_whiteColor];
    [_selectTipLabel setTextColor:_whiteColor];
    [_selectTipLabel setFont:[UIFont fontWithName:@"Georgia" size:20.00]];
    [self setFloatingTextField:_tfAmount withPlaceHolder:@"$0.00"];

    _lTotal.text =[ NSString stringWithFormat:@"%@  %@",@"$ ",@"0.00"];
    _tipPercentageLabel.text = [ NSString stringWithFormat:@"%@  %@",@"Tip Percentage % ", @"0.00"];
    _ltipAmount.text = [NSString stringWithFormat:@"%@ %@",@"Tip Amount $",@"0.00"];
    
}


-(void)setFloatingTextField:(MKTextField *)textField withPlaceHolder:(NSString *)placeHolder{
    textField.layer.borderColor = [UIColor clearColor].CGColor;
    textField.placeholder = placeHolder;
    textField.cornerRadius = 0;
    textField.bottomBorderEnabled = YES;
    [textField setFont:[UIFont fontWithName:@"Georgia" size:36.00]];
    [textField setValue:_whiteColor forKeyPath:@"_placeholderLabel.textColor"];
    [textField setTintColor:_whiteColor];
    [textField setTextColor:_whiteColor];
    
}


-(void)updateDisplay{
    float amount = [_billMade floatValue];
    //float percentage = _percentage;
    float percentDivideby100 = _percentage/100;
    float tip = amount * percentDivideby100;
    float totalBillFloat = tip+amount;
    
    NSString  *totalBill =[[NSNumber numberWithFloat:totalBillFloat] stringValue];
    
    NSString *tipAmount = [[NSNumber numberWithFloat:tip] stringValue];
    
    NSString *tipPercentage= [[NSNumber numberWithFloat:_percentage] stringValue];
    _lTotal.text =[ NSString stringWithFormat:@"%@  %@",@"$ ", totalBill];
    _tipPercentageLabel.text = [ NSString stringWithFormat:@"%@  %@",@"Tip Percentage % ", tipPercentage];
    _ltipAmount.text = [NSString stringWithFormat:@"%@ %@",@"Tip Amount $",tipAmount];
}



#pragma mark - TextField Delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
   
    
    NSString *cleanCentString = [[textField.text
                                  componentsSeparatedByCharactersInSet:
                                  [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                 componentsJoinedByString:@""];
    // Parse final integer value
    NSInteger centAmount = cleanCentString.integerValue;
    // Check the user input
    if (string.length > 0)
    {
        // Digit added
        centAmount = centAmount * 10 + string.integerValue;
    }
    else
    {
        // Digit deleted
        centAmount = centAmount / 10;
    }
    // Update call amount value
    NSNumber *amount = [[NSNumber alloc] initWithFloat:(float)centAmount / 100.0f];
    
    //Upating the bill amount
    _billMade = amount;
   
    // Write amount with currency symbols to the textfield
    NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
    [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [_currencyFormatter setCurrencyCode:@"USD"];
    [_currencyFormatter setNegativeFormat:@"-¤#,##0.00"];
    textField.text = [_currencyFormatter stringFromNumber:amount];
     [self updateDisplay];
    return NO;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_tfAmount resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
 
   
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        _animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        _animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= _animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += _animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
    [textField resignFirstResponder];
}



#pragma mark - Helper methods.
-(NSString *)convertInDollarFormat:(NSString *)inputString{
    
    NSString *cleanCentString = [[inputString
                                  componentsSeparatedByCharactersInSet:
                                  [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                 componentsJoinedByString:@""];
    // Parse final integer value
    NSInteger centAmount = cleanCentString.integerValue;
    // Check the user input
    if (inputString.length > 0)
    {
        // Digit added
        centAmount = centAmount * 10 + inputString.integerValue;
    }
    else
    {
        // Digit deleted
        centAmount = centAmount / 10;
    }
    
    NSNumber *amount = [[NSNumber alloc] initWithFloat:(float)centAmount / 100.0f];
    NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
    [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [_currencyFormatter setCurrencyCode:@"USD"];
    [_currencyFormatter setNegativeFormat:@"-¤#,##0.00"];
    return  [_currencyFormatter stringFromNumber:amount];
}


@end
