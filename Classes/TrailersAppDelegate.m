//
//  TrailersAppDelegate.m
//  Trailers
//
//  Created by Lucas Harding on 10-11-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TrailersAppDelegate.h"

@implementation TrailersAppDelegate


@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.
    
    [window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {

    // Save data if appropriate.
}

- (void)dealloc {

    [window release];
    [super dealloc];
}

@end
