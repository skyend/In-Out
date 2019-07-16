//
//  BackGroundLightning.h
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 7. 11..
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DynamicObject.h"
#import "ShineEffect.h"

@interface BackGroundLightning : DynamicObject {
    ShineEffect ** lightning;
    int lightningNum;
}

@end
