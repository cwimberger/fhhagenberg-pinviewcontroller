//
//  Copyright (c) 2014 Christoph Wimberger. All rights reserved.
//

#import "PinViewController.h"

@interface PinViewController ()

@end

@implementation PinViewController

// designated initializer
- (instancetype)initWithPin:(NSString *)pin
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Enter PIN";
    }
    return self;
}

- (instancetype)init
{
    return [self initWithPin:@"0000"];
}

@end
