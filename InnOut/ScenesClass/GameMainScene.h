//
//  GameMainScene.h
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 8..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"
//#import <GameKit/GameKit.h>

@class ProgressManager;
@class PlayScene;
@class StagePlacementManager;
@class GameCenterViewController;

@interface GameMain : CCLayer {
	StagePlacementManager * SPM;
    
	//Field 가 붙은 레이어는 캐릭터가 그려질레이어임
	CCLayer * backgroundLayer;
	CCLayer * hillOfBackField;
	CCLayer * foregroundLayer;
	CCLayer * ontheHillField;
	CCLayer * coveringLayer;
	CCLayer * effectLayer;
	
	NSMutableArray *moveGuidePoints; //가이드라인 출력을 위해 만들어진 배열
//	NSMutableArray * ShapeObjects;
	ProgressManager *PM;
	
	PlayScene * playScene;
	
	CCSprite * OptionSubBack;
	CCSprite * LeaderBoardSubBack;
	CCSprite * AchievementSubBack;
	CCMenuItem * b_SwitchBGM;
	CCMenuItem * b_SwitchSound;
//	CCMenuItem * b_LeaderBoard_GameCenter;
//	CCMenuItem * b_LeaderBoard_OpenFeint;
//	CCMenuItem * b_Achievement_GameCenter;
//	CCMenuItem * b_Achievement_OpenFeint;
	
	BOOL openedOptionMenu;
	BOOL openedLeaderBoardMenu;
	BOOL openedAchievementMenu;
	
	GameCenterViewController * GameCenterViewCon;
    
    StageCode currentLoadedStage; 
    
}
@property (assign) CCLayer * foregroundLayer;
+(id)scene;
-(void)closeGameCenterView;

@end
