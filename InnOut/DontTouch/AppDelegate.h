//
//  AppDelegate.h
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 5. 31..
//  Copyright - 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
