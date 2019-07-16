//
//  MyGraphScene.h
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 6. 6..
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class StagePlacementManager;
@class GraphDisplay;
@class TextLineBriefer;
@class GraphTouchObserver;

@interface MyGraphScene : CCLayer {
    BOOL ratina;
    
    CCLayer * superLayer;
    CCLayer * backGroundLayer;
    CCLayer * foreGroundLayer;
    CCLayer * effectLayer;
    CCLayer * contentsLayer;
	CCLayer * textContentsLayer;
    
    CCSprite * BackGroundBlinder;
    CCSprite * GraphBackGround;
    CCSprite * GraphWindow;
	GraphDisplay * scoreGraph;
    GraphDisplay * comboGraph;
    
    CCMenuItem * arrowLeft;
    CCMenuItem * arrowRight;
    CCMenuItem * home;
    
    int ViewingStageCode;
    int lastStageCode;
    
    NSTimer * highTiemer;
    
    float timeCount;
    
    unsigned int stageTotalCombo;

    CCLabelAtlas * hour_n;
    CCSprite * hour;
    CCLabelAtlas * minute_n;
    CCSprite * minute;
    CCLabelAtlas * second_n;
    CCSprite * second;
    
    CCLayer * CardLayer;
    CCSprite * MC1;
    CCSprite * MC2;
    CCSprite * MC3;
    CCSprite * MC4;
    CCSprite * MC5;
    CCSprite * MC6;
    float mc1Speed;
    float mc2Speed;
    float mc3Speed;
    float mc4Speed;
    float mc5Speed;
    float mc6Speed;
    
    int ShowCardIndex; // 0~ 5
    
    GraphTouchObserver * touchObserver;
    
    NSMutableArray * otherAnimationObject;
    
    float wayTotalDistance;
	float totalZDistance; //제일 앞에서 제일 끝까지의 거리 전진하는것만 사용 전진 y값만을 모두 더함
	
}
+(id)scene ;
@end
