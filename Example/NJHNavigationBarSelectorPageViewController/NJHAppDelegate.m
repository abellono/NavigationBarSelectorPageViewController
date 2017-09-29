//
//  NJHAppDelegate.m
//  NJHNavigationBarSelectorPageViewController
//
//  Created by Hakon Hanesand on 07/29/2015.
//  Copyright (c) 2015 Hakon Hanesand. All rights reserved.
//

#import "NJHAppDelegate.h"

@import NJHNavigationBarSelectorPageViewController;

@implementation NJHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UIViewController *one = [[UIViewController alloc] init];
    one.view.backgroundColor = [UIColor redColor];
    one.title = @"111";

    UIViewController *two = [[UIViewController alloc] init];
    two.view.backgroundColor = [UIColor whiteColor];
    two.title = @"222";

    UIViewController *three = [[UIViewController alloc] init];
    three.view.backgroundColor = [UIColor greenColor];
    three.title = @"333333333";

    UIViewController *four = [[UIViewController alloc] init];
    four.view.backgroundColor = [UIColor blueColor];
    four.title = @"444";

    NJHNavigationBarSelectorPageViewController *swipeController = [[NJHNavigationBarSelectorPageViewController alloc] initWithPageViewControllers:@[one, two, three, four]];

    swipeController.navigationBarSelectionWidthProportion = 0.9;
    swipeController.view.backgroundColor = [UIColor blackColor];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:swipeController];
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
