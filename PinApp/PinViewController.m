//
//  Copyright (c) 2014 Christoph Wimberger. All rights reserved.
//

#import "PinViewController.h"

@interface PinViewController ()

@end

@implementation PinViewController
{
    UILabel *_pinLabel;
    NSString *_correctPin;
}

// designated initializer
- (instancetype)initWithPin:(NSString *)pin
{
    self = [super init];
    if (self) {
        _correctPin = pin;
        self.navigationItem.title = @"Enter PIN";
    }
    return self;
}

- (instancetype)init
{
    return [self initWithPin:@"0000"];
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    view.backgroundColor = [UIColor darkGrayColor];
    
    for (NSUInteger i=0;i<10;i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:[self __rectForButtonAtIndex:i withSize:view.bounds.size]];
        button.backgroundColor = [UIColor lightGrayColor];
        button.showsTouchWhenHighlighted = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:30.0f];
        button.layer.cornerRadius = 30.0f;
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        [button setTitle:[@((i+1)%10) description] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(__digitButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
    _pinLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 90, 240, 50)];
    _pinLabel.backgroundColor = [UIColor lightGrayColor];
    _pinLabel.textAlignment = NSTextAlignmentCenter;
    _pinLabel.font = [UIFont systemFontOfSize:30.0f];
    _pinLabel.layer.cornerRadius = 5.0f;
    _pinLabel.clipsToBounds = YES;
    [view addSubview:_pinLabel];
    
    self.view = view;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _pinLabel.text = @"";
}

#pragma mark Private Methods

- (CGRect)__rectForButtonAtIndex:(NSUInteger)index withSize:(CGSize)size
{
    CGSize buttonSize = CGSizeMake(60.0f, 60.0f);
    CGFloat buttonSpacing = 10.0f;
    CGFloat top = 80.0f;
    NSUInteger buttonsPerRow = 3;
    NSUInteger rows = 4;
    
    NSUInteger row = index / buttonsPerRow;
    NSUInteger col = index % buttonsPerRow;
    
    if (index==9) {
        col = 1;
    }
    
    CGFloat leftMargin = (size.width - buttonSize.width*buttonsPerRow - buttonSpacing*(buttonsPerRow-1))/2;
    CGFloat topMargin = top + (size.height - buttonSize.height*rows - buttonSpacing*(rows-1))/2;
    
    CGFloat x = leftMargin + col*(buttonSize.width + buttonSpacing);
    CGFloat y = topMargin + row*(buttonSize.height + buttonSpacing);
    
    return CGRectMake(x, y, buttonSize.width, buttonSize.height);
}

- (void)__digitButtonTapped:(UIButton *)button
{
    _pinLabel.text = [_pinLabel.text stringByAppendingString:button.titleLabel.text];
    [self __checkCurrentPin];
}

- (void)__checkCurrentPin
{
    NSString *currentPin = _pinLabel.text;
    
    if ([currentPin length]<4) {
        return;
    }
    
    if ([_correctPin isEqualToString:currentPin]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Correct" message:@"The entered pin is correct." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    } else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Incorrect" message:@"The entered pin is incorrect." delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
        [av show];
    }
    
    _pinLabel.text = @"";
}

@end
