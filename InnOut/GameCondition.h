//
//  GameCondition.h
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 12..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConfig.h"

//..Super Property
#define Game_key_APP_INITIALIZED @"KEEPINGSHAPE_AppInitialized"
#define Game_key_USING_PROFILE_SLOT_COUNT   @"usingProfileSlotCount"

//..Option Property
#define Option_key_LAST_EXECUTE_DATE			@"O_lastExecuteDate"		//DATE
#define Option_key_APP_EXECUTE_COUNT			@"O_appExecuteCount"		//INT
#define Option_key_SOUND_ON_OFF					@"O_soundOnOff"				//BOOL
#define Option_key_BGM_ON_OFF					@"O_bgmOnOff"				//BOOL
#define Option_key_SELECTED_USER_PROFILE_SLOT	@"O_selectedUserProfileS"	//INT
#define Option_key_USER_PROFILES_ARRAY_SLOT		@"O_userProfilesArraySlot"	//NSArray

#define Option_key_Last_Played_StageCode        @"O_Key_Last_Played_StageCode"
#define Option_key_Has_Learn_Tutorial           @"O_Key_Has_Learn_Tutorial"
//Option_key_UserProfilesSlotArray 에서 Dictionary 객체를 빼내고 그 객체내부에서 쓰이는 키값
//..Key in Selected UserProfileDictianary
#define Profile_key_USER_NAME				@"P_userName" //NSString
#define Profile_key_TOTAL_GAME_PLAYTIME		@"P_totalGamePlaytime" //long
#define Profile_key_HAVING_EXP				@"P_havingExp"		//int
#define Profile_key_MAX_EXP					@"P_maxExp"			//int
#define	Profile_key_LEVEL					@"P_level"			//int
#define Profile_key_POSSIBLE_STAGE_CODES	@"P_possibleStageCode"	//NSString
#define Profile_key_EACH_STAGE_INFO_ARRAY	@"P_eachStageInfoArray" //Array STAGE_1 = index:0

//..Key in Stage Info Dictionary
#define StageInfo_key_MISSION_CLEARED_TABLES @"StageInfo_key_MISSION_CLEARED_TABLES" // NSArray
#define StageInfo_key_HIGH_PLAYTIME @"StageInfo_key_HIGH_PLAYTIME" //int
#define StageInfo_key_HIGH_OVERCLEAR @"StageInfo_key_HIGH_OVERCLEAR" // int //un Use
#define StageInfo_key_HIGH_TOTAL_COMBO @"StageInfo_key_HIGH_TOTAL_COMBO" //int
#define StageInfo_key_HIGH_COMBO @"StageInfo_key_HIGH_COMBO" //int
#define StageInfo_key_HIGH_SCORE @"StageInfo_key_HIGH_SCORE" //int
#define StageInfo_key_TOTAL_CLIST @"StageInfo_key_TOTAL_CLIST" //NSString
#define StageInfo_key_TOTAL_STAGE_PLAYTIME @"StageInfo_key_TOTAL_STAGE_PLAYTIME" //int
#define StageInfo_key_SCORE_HISTORY_TABLES @"StageInfo_key_SCORE_HISTORY_TABLES" //NSArray 
#define StageInfo_key_STARTED_FINALRELAY_COUNT @"StageInfo_key_STARTED_FINALRELAY_COUNT"
#define StageInfo_key_STARTED_MAXFINALRELAY_COUNT @"StageInfo_key_STARTED_MAXFINALRELAY_COUNT"
#define StageInfo_key_HIGH_DURATION_FINALRELAY @"StageInfo_key_HIGH_DURATION_FINALRELAY"     
#define StageInfo_key_HIGH_DURATION_MAXFINALRELAY @"StageInfo_key_HIGH_DURATION_MAXFINALRELAY"

//DB Key
#define DB_key_ApplicableMissionCodes @"DB_key_ApplicableMissionCodes"

@class StagePlacementManager;
@class ProgressManager;


//Memory0_0AppDelegate 에 의해 최초로 만들어짐 

@interface GameCondition : NSObject {
	StagePlacementManager * SPM;
	ProgressManager * runningPM; //현재 돌아가고 있는 PM객체
    
	BOOL touchingPlayScene;
	
	//게임에 직접적으로 적용되는 변수 모든 정보를 로드후에 최종적으로 써야할것임
	CGFloat windSpeed;
	
	
	CGFloat stepSpeed;
	CGFloat createPeroid;
	
	CGFloat default_stepSpeed;
	CGFloat Game_default_CreatePeroid;
	CGFloat Any_CreatePeroid;
	CGFloat Any_stepSpeed;
	
	CGFloat etime;
	
	unsigned long long normalScore;
	unsigned long long overClearScore;
	unsigned long long infiniteScore;
	unsigned long long totalScore;
	//long    score;
	unsigned int    level;
	BOOL thisTimeLevelUp;
	unsigned int	beginningLife;
	unsigned int    life;
	unsigned int    hint;
	unsigned int	currentCombo;
	unsigned int	maxCombo;
	unsigned int    totalCombo;
	RANK rank;
	NSArray * thisTimeRescueShapeCodes; // from [PM init_After_GameCondition]
	NSArray * usingCharacterCodes;
	
	
	unsigned long long prevMaxExp; 
	
	//캐릭터의 이동에 관련한 변수 StagePlacement 에서 셋팅하고 BaseCharacter에서 읽는다 
	float wayTotalDistance;
	float totalZDistance;
	
	//from SPM 스테이지 레벨 셋팅
	int		stageCode;
	float	ExpJumpValue; //스테이지 마다 보상이 증가시키기 위한
	float	ScoreJumpValue; //
	NSString * AppearenceCharacterCodes;

	int		PrevStep;
	float	BeginStepSpeed;
	float	BeginCreatePeroid;
	float	MaxLevel_StepSpeed;
	float   MaxLevel_CreatePeroid;
	int		FinalRelayStaringComboPoint;
	int		MaxFinalRelayComboPoint;
	int		StandbyCounting;
	int		BeginLife;
	int		BeginHint;
	int		stageMaxLevel;
	NSArray*StageSkilledLevelMaxExpTable;
	NSArray*ClearObjects; //필터링이 안된 미션들
	//NSArray*ClearObjectCodes;
	NSMutableDictionary * ClearObjectsValuesAtCode; //코드로 이루어진 키를 가진 해당미션의 값들을 가지는 배열 딕셔너리
	int ClearedMissionCode;
	int OverClearedMissionCode;
	
	int startedFinalRelayCount;
	int arrivedMaxFinalRelayCount;
	float highFinalRelayDuration;
	float highMaxFinalRelayDuration;
	
    
    LanguageCase lang;
    BOOL japanLock;
	//데이터 저장에 관련된 변수들
	//belong to NSUserDefaults
	//Game Options
	int			usingProfileSlotCount;
	NSDate *	lastDate; //alloc 안함 그떄 그떄 필요할때 꺼내쓰기
	NSDate *	start_date; //alloc 안함
	int			appExecuteCount;
	bool		soundOnOff;
	bool		bgmOnOff;
	int			selectedUserSlot;
	
    BOOL hasLearnTutorial;
	//NSArray *	userProfileArraySlot;
	//NSDictionary *selectedUserProfile; //프로필슬롯에서 선택된 프로필을 꺼내서 담음
	
		//in Profile
		NSString *	user_name;
		unsigned long long		havingExp;
		unsigned long long		maxExp;
		//int			level; //위에 있음
		NSString *	possibleStageCode;
	
			int			StageSkilledLevel;
			int			StageSkilledLevelExp;
			int			StageSkilledLevelMaxExp;
			//NSArray *	MissionClearedTables;
			NSDictionary * MissionClearedTables;
			int			highPlayTime;
			int			highOverClear;
			unsigned int		highTotalCombo;
			unsigned int		highCombo;
			unsigned long long	highScore;
            unsigned long long	worldTopScore;
			NSString *	totalClist;
			long long	totalStagePlayTime;
			NSMutableArray *  ScoreHistoryTables;
			int stage_startedFinalRelayCount;
			int stage_arrivedMaxFinalRelayCount;
			int stage_highFinalRelayDuration;
			int stage_highMaxFinalRelayDuration;
    
    
    BOOL nextStageUnLocked;
	
    
    BOOL gameCenterLoginSuccessed;
    NSString * playerID; //alloc
}
@property (assign) ProgressManager * runningPM;
@property BOOL touchingPlayScene;

@property (readonly) int PrevStep;
@property CGFloat stepSpeed;
@property CGFloat createPeroid;

@property int stageCode;
@property CGFloat default_stepSpeed;
@property CGFloat Game_default_CreatePeroid;
@property CGFloat windSpeed;
@property CGFloat etime;

@property unsigned long long normalScore;
@property unsigned long long overClearScore;
@property unsigned long long infiniteScore;
@property unsigned long long totalScore;

@property unsigned int level;
@property uint beginningLife;
@property unsigned int life;
@property unsigned int hint;
@property (readonly) int StandbyCounting;
@property unsigned int currentCombo;
@property unsigned int maxCombo;
@property unsigned int totalCombo;
@property RANK rank;
@property (assign)NSArray * thisTimeRescueShapeCodes;
@property int ClearedMissionCode;
@property int OverClearedMissionCode;

@property int stageMaxLevel;
@property int startedFinalRelayCount;
@property int arrivedMaxFinalRelayCount;
@property float highFinalRelayDuration;
@property float highMaxFinalRelayDuration;

@property (readonly) NSArray * usingCharacterCodes;

//Final Relay
@property (readonly) int FinalRelayStartingComboPoint;
@property (readonly) int MaxFinalRelayComboPoint;
@property (readonly) CGFloat BeginStepSpeed;
@property (readonly) CGFloat BeginCreatePeroid;

//User Level Management
@property unsigned long long havingExp;
@property (readonly)unsigned long long maxExp;
@property unsigned long long prevMaxExp;

//AnimationMode Values
@property CGFloat Any_CreatePeroid;
@property CGFloat Any_stepSpeed;

@property float wayTotalDistance;
@property float totalZDistance;

//System Property
@property (readonly) LanguageCase lang;
@property (readonly) BOOL japanLock;
//DB Values 
@property (readonly,assign) int selectedUserSlot;
@property (readonly,assign) unsigned int highTotalCombo;
@property (readonly,assign) unsigned int highCombo;
@property (readonly,assign) unsigned long long highScore;
@property (readonly,assign) unsigned long long worldTopScore;
@property (readonly,assign) NSString * possibleStageCode;
@property (readonly,assign) NSMutableArray * ScoreHistoryTables;
@property (readonly,assign) NSDictionary * MissionClearedTables;
@property BOOL hasLearnTutorial;
@property (assign) NSString * user_name;
@property long long	totalStagePlayTime;

//ProgressManager MissionCheck
@property (assign) NSMutableDictionary * ClearObjectsValuesAtCode;

@property (readonly,nonatomic) BOOL gameCenterLoginSuccessed;
@property (assign,nonatomic,readonly) NSString * playerID;

+(GameCondition*)sharedGameCondition;
-(void)superInitialize;
-(void)finalGameInit;
-(void)LevelUp;
-(StageCode)nextStageUnLock;
-(BOOL)unLockedNextStage;
-(unsigned long long)getMaxExp:(int)level_;
-(void)setSPM:(StagePlacementManager *)SPM_;
-(StagePlacementManager*)getSPM;


-(void)settingFromSPM:(float)BeginStepSpeed_
			  beginCP:(float)BeginCreatePeroid_
		 maxStepSpeed:(float)MaxLevel_StepSpeed_
	  maxCreatePeroid:(float)MaxLevel_CreatePeroid_
finalRelayStartingComboPoint:(int)FinalRelayStartingComboPoint_
maxFinalRelayComboPoint:(int)MaxFinalRelayComboPoint_
		  stanbyCount:(int)StanbyCounting_
			 prevStep:(int)PrevStep_
			beginLife:(int)BeginLife_
			beginHint:(int)BeginHint_
		stageMaxLevel:(int)StageMaxLevel_
stageSkilledLevelMaxExpTable:(NSArray*)StageSkilledLevelMaxExpTable_
		 expJumpValue:(float)ExpJumpValue_
	   scoreJumpValue:(float)ScoreJumpValue_
appearenceCharacterCodes:(NSString*)AppearenceCharacterCodes_
		 clearObjects:(NSArray*)ClearObjects_
				  spm:(StagePlacementManager*)SPM_;

-(void)setUsingCharacterCodesFromSPM:(NSString*)AppearenceCharacterCodes_;

//-(void)loadGame;
-(void)saveGame;

//-(void)settingProfile;
-(void)saveProfile;

//-(void)settingStagePlayInfo:(StageCode)stageCode_;
-(void)saveStagePlayInfo:(StageCode)stageCode_;

//GameOption
-(void)SoundOn;
-(void)SoundOff;
-(BOOL)onSound;
-(void)BGMOn;
-(void)BGMOff;
-(BOOL)onBGM;

//DB Key Getter
NSString* getProKey(int ProfileSlotNumber_ ,NSString* key_);
NSString* getStageInfoKey(int ProfileSlotNumber_ ,int TargetStageCode_ ,NSString* key_);
-(NSString*)getProfileKey:(int)ProfileSlotNumber_ keyValue:(NSString*)key_;
-(NSString*)getStagePlayInfoKey:(int)ProfileSlotNumber_ stageCode:(int)TargetStageCode_ keyValue:(NSString*)key_;

-(void)GameCenterLoginSuccess:(NSString*)playerID_;
-(void)settingProfile;
-(void)settingStagePlayInfo:(StageCode)stageCode_;
@end
