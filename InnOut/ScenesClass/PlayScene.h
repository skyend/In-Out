//
//  PlayScene.h
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 12..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"

@class ProgressManager;
@class GameController;
@class StagePlacementManager;

@interface PlayScene : CCLayer {
	StagePlacementManager * SPM;
	
	//Field 가 붙은 레이어는 캐릭터가 그려질레이어임
	CCLayer * backgroundLayer;
	CCLayer * hillOfBackField;
	CCLayer * foregroundLayer;
	CCLayer * ontheHillField;
	CCLayer * effectLayer;
	CCLayer * coveringLayer;

	NSMutableArray * ShapeObjects;
	
	ProgressManager *PM;
	
	NSMutableArray *touchedTrace;
	
	StageCode stageCode;
	
	BOOL initGameOfAll;
}
@property (assign) CCLayer * foregroundLayer;
//-(id)initWithStage:(StageCode)stageCode_;
+(id)sceneWithStageCode:(StageCode)stageCode_;
-(void)GoMain;
-(void)restartStage;
@end
