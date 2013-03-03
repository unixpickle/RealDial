//
//  ANAppDelegate.m
//  RealDial
//
//  Created by Alex Nichol on 3/3/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANAppDelegate.h"

@implementation ANAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    dialView = [[ANDialView alloc] initWithFrame:CGRectMake(0, 100, 320, 320)];
    dialView.delegate = self;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:dialView];
    [self.window makeKeyAndVisible];
    
    numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 300, 60)];
    numberLabel.font = [UIFont fontWithName:@"DBLCDTempBlack" size:40];
    numberLabel.text = @"123";
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.backgroundColor = [UIColor blackColor];
    numberLabel.textColor = [UIColor greenColor];
    [self.window addSubview:numberLabel];
    
    clearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    clearButton.frame = CGRectMake(10, dialView.frame.origin.y + 340, 300, 32);
    [clearButton addTarget:self
                    action:@selector(clearPressed:)
          forControlEvents:UIControlEventTouchUpInside];
    [clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    [self.window addSubview:clearButton];
    
    return YES;
}

- (void)dialView:(ANDialView *)dailView dialedNumber:(int)number {
    if (numberLabel.text.length == 0) {
        numberLabel.text = [NSString stringWithFormat:@"%d", number];
    } else {
        numberLabel.text = [NSString stringWithFormat:@"%@%d", numberLabel.text, number];
    }
}

- (void)clearPressed:(id)sender {
    numberLabel.text = @"";
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
