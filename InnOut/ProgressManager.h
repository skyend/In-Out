//
//  ProgressManager.h
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 10..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"

@class BaseCharacter;
@class GameCondition;
@class PlayScene;
@class NodeTweener;
@class ComboParty;
@class FinalRelayDisplayController;
@class TutorialManager;
@class StageFinalizer;
@class MissionCard;

//typedef enum {


@interface ProgressManager : CCNode {
	float startDelay; //플레이모드로 시작시 1초후에 게임을 시작하기위해
	float gameStart;
	CCSprite * black;
	CCSprite * startRelayMessage;
	CCSprite * startRelayMessage_moving;
	CCSprite * TapToScreen;
	
	PM_MODE mode;
	PlayScene * caller;
	
	NSMutableArray * ShapeObjects; //게임 캐릭터를 돌리는 루프
	NSMutableArray * otherAnimationObject; // 움직이는 오브젝트
	NSMutableArray * gameObjects_needsLoop; // 변하는 게임진행표시 객체들
	NSMutableArray * willDieObjects; //곧 죽을 게임의 흐름에서 벗어난 캐릭터 객체
	NSMutableArray * standbySpace;
	
	CCLayer * BackGroundLayer;
	CCLayer * stanbyLayer;
	CCLayer * ForeGroundLayer;
	CCLayer * FieldLayer;
	CCLayer * FieldLayer2;
	CCLayer * CoverLayer;// 게임상황 표시 레이어

	CCLayer * pauseLayer; // 일시정지 레이어
	
	NSArray * totalFieldWays;
	//NSArray * behindFieldWays; //GC를 통해 받아와야함
	//NSArray * frontFieldWays; //GC를 통해 받아옴
	
	int creatingCycle; //종류별로 돌아가게 하기위한 카운터 게임할땐 제거
	float creatingPeriod; //캐릭터 생성 주기 
	float createdTime;
	BOOL creatingflag;
	int creatCount;
	
	//게임제어 변수들
	CCMenuItemImage * pauseButton;
	CCLabelAtlas *label_level;
	CCLabelAtlas *label_time;
	CCLabelAtlas *label_score;
	CCLabelAtlas *label_life;
	CCLabelAtlas *label_highScore;
	CCLabelAtlas * label_worldScore;
    
	float standbyCount;
	int	standbyCharacterCount;
	float prevCount;
	int maxCounting;
	float accrueScorePer;

	NSArray * counterNodeArr;
	BaseCharacter * firstO; 
	
	NSMutableArray * passedShapesCode;
	NSMutableArray * rescuedShapeCodes;
	
	BOOL buttonDown;
	BUTTON_NAME justDownButton;
	
	BOOL flag_characterCycle;
	//GameOverView *gameOverLayer;
	GAME_STATE game_state;
	
	//게임오버관련 클리어된 미션 코드
	MissionCard * clearMissionCard;
	MissionCard * overClearMissionCard;
	int ClearedMissionCode;
	int OverClearedMissionCode;
	GamePlayMODE GPMode;
	
	//Mission Observing Value
	int m_5_current_comboUnitsCount;
	BOOL m_5_Defer_comboUnit;
	int m_5_needComboUnit;
	int m_5_needComboUnitsCount;
	
	//EventObserver
	NSDictionary * missionDic;
	NSArray * missionCodes;
	int missionCodeLength;
	
	//FinalRelay
	BOOL finalRelayOn;
	BOOL maxFinalRelayOn;
	float PerfromNormaltoFinalRelay; //노멀에서 파이널 릴레이까지
	float PerfromFinalRelaytoMaxFinalRelay; //파이널 릴레이부터 맥스파이널릴레이까지
	float finalRelayDuration;
	float maxFinalRelayDuration;
	
	FinalRelayDisplayController * FRDC;
	
	//Tutorial And Hint Display
	TutorialManager * TM;
	BOOL TMDied;
	//Stage Finalizer
	StageFinalizer * SF;
	BOOL needReleaseSF;
	
	//게임진행표시,가이드 객체
	NodeTweener	*InFollowerTweener;
	NodeTweener	*OutFollowerTweener;
	NodeTweener	*HintFollwerTweener;
	NodeTweener *lifeDownTweener;
	NodeTweener	*HintDownTweener;
	ComboParty	*comboParty; // 0.5초 안에 판별시
	NodeTweener *comboPartyTweener;
    
    float dfjSound; // delta for jumpingSound
    float jumpingInterval;
}

@property (assign) NSMutableArray * otherAnimationObject; //외부에서 객체 추가 가능하도록!
@property (retain) NSArray * totalFieldWays;
@property (assign) NSArray * behindFieldWays;
@property (assign) NSArray * frontFieldWays;

@property (readonly) float PerfromNormaltoFinalRelay;
@property (readonly) float PerfromFinalRelaytoMaxFinalRelay;

@property (assign) NSDictionary * missionDic;
@property  GamePlayMODE GPMode;
@property (readonly) int ClearedMissionCode;
@property (readonly) int OverClearedMissionCode;
@property GAME_STATE game_state;

//for FRDC
@property (readonly)NSMutableArray * passedShapesCode;
@property (readonly)NSMutableArray * standbySpace;
@property (readonly)NSMutableArray * ShapeObjects;
-(void)offCharacterCycle;

-(void)init_After_GameCondition;

-(void)centerProgressLoop:(ccTime)delta;
-(id)initWithLayer:(CCLayer*)fieldLayer field2:(CCLayer*)fieldLayer2;
-(id)initWithLayerMode:(CCLayer *)fieldLayer field2:(CCLayer *)fieldLayer2 cover:(CCLayer*)coverLayer backGroundLayer:(CCLayer *)BackGroundLayer_ mode:(PM_MODE)pmmode whoCalled:(id)who;
-(void)GButtonEventListener:(BUTTON_NAME)bname_;

-(void)ResumeGamefromStageFinalizer;
-(void)RestartGamefromStageFinalizer;
-(void)packingStage;
-(void)ExitPlayScene;
-(BOOL)checkUserCommand:(ccTime)d;
-(BOOL)checkTutorialEndCommand;
-(void)deleteTM;
-(void)buttonDownInvalidation;
-(void)tutoCloserRemove;
@end
