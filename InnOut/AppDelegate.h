//
//  AppDelegate.h
//  InnOut
//
//  Created by  on 11. 11. 27..
//  Copyright __MyCompanyName__ 2011년. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
