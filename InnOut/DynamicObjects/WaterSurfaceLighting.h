//
//  WaterSurfaceLighting.h
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 7. 9..
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DynamicObject.h"
@class ShineEffect;

@interface WaterSurfaceLighting : DynamicObject {
    ShineEffect ** effectArr;
    int objCount;
}
-(void)update:(ccTime)delta;
@end
