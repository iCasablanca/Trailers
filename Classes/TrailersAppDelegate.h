//
//  TrailersAppDelegate.h
//  Trailers
//
//  Created by Lucas Harding on 10-11-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrailersViewController.h"

@interface TrailersAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
