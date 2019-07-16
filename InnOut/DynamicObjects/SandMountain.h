//
//  SandMountain.h
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 6. 17..
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DynamicObject.h"

//샌드마운틴 구현부에서만 한정적으로 쓰임
typedef enum {
    NONE,
    MountainCase_CASE1,
    MountainCase_CASE2,
    MountainCase_CASE3
}MountainCase;

@interface SandMountain : DynamicObject {
    MountainCase casing;
    NSMutableArray * effectors;
}
-(id)initWithMountainImage:(NSString*)str;
-(void)update:(ccTime)delta;

@end
