//
//  Copyright (c) 2014 Christoph Wimberger. All rights reserved.
//

#import "AppDelegate.h"

#import "PinViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    PinViewController *pinViewController = [[PinViewController alloc] initWithPin:@"1234"];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:pinViewController];
    self.window.rootViewController = nc;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
