//
//  DynamicObject.h
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 10..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameCondition.h"

@interface DynamicObject : CCSprite {
    int LastOpenedStageCode;
}

-(void)update:(ccTime)delta;

@end
