//
//  FishShoals.h
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 7. 5..
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DynamicObject.h"

typedef struct {
    CCSprite * sprite;
    CGPoint interval;
    float speed;
}FishArray;

@interface FishShoals : DynamicObject {
    CGSize scope;
    FishArray * fish;
    int fishNum;
    
    CGPoint rootPoint;
    CGPoint FollowRootP;
    float fishSpeed;
}
-(id)FishShoalsWithSize:(CGSize)scope_;
-(void)update:(ccTime)delta;
@end
