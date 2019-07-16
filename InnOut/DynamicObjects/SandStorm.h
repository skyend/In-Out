//
//  SandStorm.h
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 6. 16..
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DynamicObject.h"

@interface SandStorm : DynamicObject {
    NSMutableArray * SandStormWave;
    int StormHeadIndex;
    int StormTailIndex;
    float wind;
}

@end
