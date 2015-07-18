//
//  ViewController.m
//  TipCalculator
//
//  Created by Nilesh Agrawal on 7/17/15.
//  Copyright (c) 2015 Nilesh Agrawal. All rights reserved.
//

#import "ViewController.h"
#import "NGOneFingerRotationGestureRecognizer.h"
#import "ThemeManager.h"


static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface ViewController ()
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
    [self setUpView];
    [self setUpInitialValues];
    [self addGestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)handleRotationGesture:(NGOneFingerRotationGestureRecognizer *)gestureRecognizer
{
    //Get Percentage ...
    CGFloat radians = atan2f(self.circleImage.transform.b, self.circleImage.transform.a);
    CGFloat imageAngle = radians * (180 / M_PI);
    if (imageAngle > 0)
        imageAngle = imageAngle;
    else if (imageAngle < 0 )
        imageAngle +=360 ;
    
    _percentage = (imageAngle/360)*100;
    
    //Control Rotation.
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        gestureRecognizer.rotation = atan2(self.circleImage.transform.b, self.circleImage.transform.a);
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.circleImage.transform = CGAffineTransformMakeRotation(gestureRecognizer.rotation);
    }
    [self updateDisplay];
}


-(void)addGestureRecognizer{
    
    NGOneFingerRotationGestureRecognizer * gestureRecognizer = [[NGOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGesture:)];
    [self.circleImage addGestureRecognizer:gestureRecognizer];

}
-(void)setUpView{
    
    [[ThemeManager theme] themForBackGround:self.view];
    [[ThemeManager theme] themeForIgnoreViews:_view1];
    [[ThemeManager theme] themeForIgnoreViews:_view2];
    [[ThemeManager theme] themeForIgnoreViews:_view3];
    [[ThemeManager theme] themeForSeparators:_view4];
    [[ThemeManager theme] themeForSeparators:_view5];
    [[ThemeManager theme] themeForTextField:_tfAmount withPlaceHolder:@"$ 0.00"];
    [[ThemeManager theme] themeForLabels:_lTip];
    [[ThemeManager theme] themeForLabels:_ltipAmount];
    [[ThemeManager theme] themeForLabels:_lTotal];
    [[ThemeManager theme] themeForLabels:_lBillAmount];
    [[ThemeManager theme] themeForLabels:_ltotalAmount];
    [[ThemeManager theme] themeForLabels:_selectTipLabel];
    [[ThemeManager theme]themeForLabels:_tipPercentageLabel];
}


-(void)setUpInitialValues{
    _lTotal.text =[ NSString stringWithFormat:@"%@  %@",@"$ ",@"0.00"];
    _tipPercentageLabel.text = [ NSString stringWithFormat:@"%@  %@",@"Tip Percentage % ", @"0.00"];
    _ltipAmount.text = [NSString stringWithFormat:@"%@ %@",@"Tip Amount $",@"0.00"];
    _tfAmount.delegate = self;
    _percentage = 0.00;
    

}


-(void)updateDisplay{
    float amount = [_billMade floatValue];
    float percentDivideby100 = _percentage/100;
    float tip = amount * percentDivideby100;
    float totalBillFloat = tip+amount;
    _lTotal.text =[ NSString stringWithFormat:@"%@  %0.2f",@"$ ", totalBillFloat];
    _tipPercentageLabel.text = [ NSString stringWithFormat:@"%@  %0.2f",@"Tip Percentage % ", _percentage];
    _ltipAmount.text = [NSString stringWithFormat:@"%@ %0.2f",@"Tip Amount $",tip];
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
