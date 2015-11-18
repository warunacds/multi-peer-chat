//
//  AppDelegate.m
//  WDPeerChat
//
//  Created by Waruna de Silva on 11/10/15.
//  Copyright © 2015 Waruna de Silva. All rights reserved.
//

#import "AppDelegate.h"
#import "WDChatManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"Username"]) {
        
        WDChatManager *chatManager = [WDChatManager sharedWDChatManager];
        [chatManager setupPeerAndSessionWithDisplayName:[userDefaults objectForKey:@"Username"]];
        [chatManager advertiseSelf:YES];

    }    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

   
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end
