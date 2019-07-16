//
//  StagePlacement.h
//  Memory0_0
//
//  Created by JinUng Han on 11. 4. 2..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"
@class ProgressManager;



/*
typedef struct {
	DataType valueName;
}structName;

union {
	DataType valueName;
}unionName;

union {
	struct {
		DataType valueName;
	}A;
}unionName;
*/

@interface StagePlacementManager : NSObject {
	ProgressManager * PM;
	
	StageCode stageCode; //GameCondition에서 읽음
	BOOL useForAnimation;
	
	NSMutableDictionary *stageObjectsDic;
	CCLayer * backGroundLayer;
	CCLayer * foreGroundLayer;
	CCLayer * effectLayer;
	
	//Loaded Dictionary Item Reference Value
	NSArray * totalWay;
	NSArray * BackGroundObject;
	NSArray * ForeGroundObject;
	NSArray * EffectObject;
	
	
	float wayTotalDistance;
	float totalZDistance; //제일 앞에서 제일 끝까지의 거리 전진하는것만 사용 전진 y값만을 모두 더함
	
	//Values is will go to GC
	NSArray * ClearObjects;
	float	ExpJumpValue; //스테이지 마다 보상이 증가시키기 위한
	float	ScoreJumpValue; //
	NSString * AppearenceCharacterCodes;
	
	int		PrevStep;
	float	BeginStepSpeed;
	float	BeginCreatePeroid;
	float	MaxLevel_StepSpeed;
	float   MaxLevel_CreatePeroid;
	int		StanbyCounting;
	int		BeginLife;
	int		BeginHint;
	int		StageMaxLevel;
	int		FinalRelayStartingComboPoint; //FinalRelay가 시작되기위한 콤보횟수
	int		MaxFinalRelayComboPoint;
	
	NSArray  * StageSkilledLevelMaxExpTable;

}

-(id)initStageWith3Layers:(uint)StageCode_ 
					   pm:(ProgressManager*)PM_
		  backGroundLayer:(CCLayer*)behindGroundLayer_ 
		  foreGroundLayer:(CCLayer*)foreGroundLayer_ 
			  effectLayer:(CCLayer*)effectLayer_;

-(id)initStageWith3Layers:(uint)StageCode_ 
					   pm:(ProgressManager*)PM_
		  backGroundLayer:(CCLayer*)backGroundLayer_ 
		  foreGroundLayer:(CCLayer*)foreGroundLayer_ 
			  effectLayer:(CCLayer*)effectLayer_
				useforAni:(BOOL)UFA_;

@property StageCode stageCode;

@end
