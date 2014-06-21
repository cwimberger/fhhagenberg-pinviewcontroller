//
//  Copyright (c) 2014 Christoph Wimberger. All rights reserved.
//

#import "PinViewController.h"

#import <CoreMotion/CoreMotion.h>

@interface PinViewController () <UIAlertViewDelegate>

@end

@implementation PinViewController
{
    UILabel *_pinLabel;
    NSString *_correctPin;
    UIDynamicAnimator *_animator;
    CMMotionManager *_motionManager;
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

    [self __addViews:view];
    
    self.view = view;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _pinLabel.text = @"";
}

#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self __reset];
}

#pragma mark Private Methods

- (void)__addViews:(UIView *)view
{
    for (NSUInteger i=0;i<10;i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:[self __rectForButtonAtIndex:i withSize:view.bounds.size]];
        button.backgroundColor = [UIColor lightGrayColor];
        button.titleLabel.font = [UIFont systemFontOfSize:30.0f];
        button.layer.cornerRadius = 30.0f;
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        [button setTitle:[@((i+1)%10) description] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(__digitButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
    _pinLabel = [[UILabel alloc] initWithFrame:[self __rectForPinLabel]];
    _pinLabel.backgroundColor = [UIColor lightGrayColor];
    _pinLabel.textAlignment = NSTextAlignmentCenter;
    _pinLabel.font = [UIFont systemFontOfSize:30.0f];
    _pinLabel.layer.cornerRadius = 5.0f;
    _pinLabel.clipsToBounds = YES;
    _pinLabel.text = @"";
    [view addSubview:_pinLabel];
}

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

- (CGRect)__rectForPinLabel
{
    return CGRectMake(40, 90, 240, 50);
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
        
        [self __addDynamicsForWrongPin];
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Incorrect" message:@"The entered pin is incorrect." delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
        [av show];
    }
}

- (void)__addDynamicsForWrongPin
{
    [_animator removeAllBehaviors];
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:self.view.subviews];
    [_animator addBehavior:gravityBehavior];

    _motionManager = [[CMMotionManager alloc] init];
    _motionManager.deviceMotionUpdateInterval = 0.1;
    [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        CMAcceleration gravity = motion.gravity;
        gravityBehavior.gravityDirection = CGVectorMake(gravity.x, -gravity.y);
    }];
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:self.view.subviews];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    [_animator addBehavior:collisionBehavior];
}

- (void)__reset
{
    _animator = nil;
    _motionManager = nil;
    
    [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        [self.view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
            [subview removeFromSuperview];
        }];
        
        [self __addViews:self.view];
    } completion:nil];
}

@end
