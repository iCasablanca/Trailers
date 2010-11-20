//
//  TrailersAppDelegate_iPad.m
//  Trailers
//
//  Created by Lucas Harding on 10-11-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TrailersAppDelegate_iPad.h"

@implementation TrailersAppDelegate_iPad


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch.
	window.backgroundColor = [UIColor blackColor];
	
	view = [[TrailersViewController alloc] init];
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
    nav.navigationBar.barStyle = UIBarStyleBlack;
	[nav setNavigationBarHidden:YES];
	
	[window addSubview:nav.view];
    
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


/**
 Superclass implementation saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	[super applicationWillTerminate:application];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    [super applicationDidReceiveMemoryWarning:application];
}


- (void)dealloc {
	
	[super dealloc];
}


@end
