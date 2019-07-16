//
//  CreditScene.h
//  KEEPINGSHAPE
//
//  Created by JinWoong Han on 11. 8. 11..
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "FrameAnimator.h"
#import "ShineEffect.h"
@class GraphTouchObserver;

@interface CreditScene : CCLayer {
    
    FrameAnimator * noise;
    ShineEffect * homeShine;
    
    CCLayer * layer;
    
    GraphTouchObserver * touchLayer;
    BOOL touched;
    
    BOOL run;
    
    CCSprite * textSlide;
    float textSlideHeight;
    float slideSpeed;
}
+(id)scene ;
@end
