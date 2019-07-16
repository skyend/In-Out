//
//  StageFinalizer.h
//  Memory0_0
//
//  Created by JinUng Han on 11. 5. 3..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"
#import "ShineEffect.h"

typedef enum {
	FINALIZE_GAME_OVER,
	FINALIZE_MISSION_CLEAR,
}FinalizeCode;

@class ProgressManager;
@class GameCondition;
@class MissionCard;

@interface StageFinalizer : NSObject {
	GameCondition * GC;
	ProgressManager * PM;
	
	CCLayer * CoverLayer;
	CCLayer * finalLayer;
	
	BOOL runfinalize;
	BOOL endFinalize;
	BOOL ON_endEffect;
	BOOL selectedRetry;
	float endDelay;
	
	int ClearedMissionCode;
	int OverClearedMissionCode;
	GamePlayMODE GPMode;
	FinalizeCode FCode;
	
	//Finalize result value
	unsigned long long  missionClearScore;
	unsigned long long  missionOverClearScore;
	unsigned long long  comboScore;
	unsigned long long  totalScore;
	RANK rank;
	float missionClearBonusMultiplier;
    float missionOverClearBonusMultiplier;
    
    
	unsigned long long  just_gettingExp;
	unsigned long long  just_havingExp;
	unsigned long long  just_maxExp;
	int just_level;
	
	
	//Finalizer Display values
	NSMutableDictionary * flags;
	float updateElapsedTime;
	float elapsedTime;
	BOOL step1Ended;
	
	//Finalizer Display Objects
	CCSprite * backCoverColor; int backCoverTopa;
	CCSprite * blackDot; CGRect blackDotRect; int blackDotTopa;
	
	CCSprite * tapToScreen;
	CCSprite * Icon_Faster; BOOL ON_Icon_Faster; float Icon_Faster_deleOpacity ;int Icon_Faster_opacityT; BOOL shine_Icon_Faster;
	CCSprite * Icon_FasterOutLine;
	CCSprite * Icon_Main; BOOL ON_Icon_Main; float Icon_Main_deleOpacity ;int Icon_Main_opacityT; BOOL shine_Icon_Main;
	CCSprite * Icon_MainOutLine;
	
	
	
	
	//Finalize step 1 
	CCSprite * s_GameOver;
	CCSprite * s_MissionClear;
	CCMenuItem * b_infinite;
	CCMenuItem * b_rewarding;
	CCMenuItem * b_retry;
	CCMenuItem * b_overClear;
	CCMenu * menu;
	CCSprite * s_selectedBar; CGPoint s_selTp; int s_selTopa; int selectedTag; float s_selTscaleX;
	CCSprite * s_moreChallenge;
	BOOL passStep1; float passStep1ElapsedTime;
	BOOL step1End;
	BOOL disappearSF;
	
	//All step shared
	CCLabelAtlas * addScoreAtlas; CGPoint scoreAtlasTp; int scoreAtlasOpacityT;
	
	//Finalize step 2 Rewarding
	BOOL  startingRewarding;
	float RewardingT;
	MissionCard * clearedMissionCard;
	MissionCard * overClearedMissionCard;
	
	//Finalize step3 since Combo
	float totalRectWidth;
	CCSprite * totalCombo;
	CCSprite * highCombo;
	CCLabelAtlas * totalComboLabel;
	CCLabelAtlas * highComboLabel;
	CCSprite * newRecord1; float newRecord1_deleOpacity ;int newRecord1_opacityT; BOOL shine_newRecord1;
	CCSprite * newRecord2; float newRecord2_deleOpacity ;int newRecord2_opacityT; BOOL shine_newRecord2;
	float totalComboXt;
	float totalComboLabelXt;
	float highComboXt;
	float highComboLabelXt;
	CCSprite * newRecordScore; float newRecordScore_deleOpacity; int newRecordScore_opacityT; BOOL shine_newRecordScore;
	
	//Finalize step4 Experience
	CCSprite * Experience;
	CCSprite * LevelSprite;
	CCLabelAtlas * LevelLabel;
	CCLabelAtlas * addExpLabel;
	CCLabelAtlas * ExpLabel; long long ExpLabelValue; long long CurrentTargetExpValue;
	CCLabelAtlas * MaxExpLabel;
	CCSprite * LevelUpSprite; BOOL LevelUpDisplay; float LevelUpSprite_deleOpacity ;int LevelUpSprite_opacityT; BOOL shine_LevelUpSprite; 
	
	CCSprite * havingExpSprite;
	CCSprite * getExpSprite;
	CCSprite * blankExpSprite;
	CGRect GetExpRect; float GetExpRectXt; float GetExpRectWt;
	BOOL cycleExpAniEnd;
	BOOL experienceSuccess;
	float experienceSuccessedDelay;
	
	//Finalize step5 Rank
	CCSprite * rankSprite;
	int rankTargetOpacity;
    
	//Finalize step6 unlock Stage
    int SRankCount;
	//스프라이트는 미리 준비해둠
	CCSprite * unlckStage; //축하 메세지
	//CCSprite * stageThumbnail; // 언락될 스테이지 썸네일
    ShineEffect * stageThumbnail;
	BOOL UnLockedNextStage; //최종적으로 언락모션을 보여줄지 판별후 이 값에따라 마지막 애니 컨트롤
	BOOL aniTransfered;
	
}
@property (readonly) BOOL runfinalize;
//@property (assign) CCLayer * finalLayer;

-(id)initWithPM:(ProgressManager*)PM_ coverLayer:(CCLayer*)CoverLayer_;
-(void)finalizeTheStage:(FinalizeCode)code_;
-(void)update:(ccTime)d;

@end
