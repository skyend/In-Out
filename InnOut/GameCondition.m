//
//  GameCondition.m
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 12..
//  Copyright 2011 Student. All rights reserved.
//

#import "GameCondition.h"
#import "StagePlacement.h"
#import "MissionClearTable.h"
#import "ScoreHistoryTable.h"
#import "GameCenterManager.h"

//UserDefault Object Const String Key//





NSString* getProKey(int ProfileSlotNumber_ ,NSString* key_){
	return [NSString stringWithFormat:@"KEEPINGSHAPE_Slot_%d_%@",ProfileSlotNumber_,key_];
}
NSString* getStageInfoKey(int ProfileSlotNumber_ ,int TargetStageCode_ ,NSString* key_){
	return [NSString stringWithFormat:@"KEEPINGSHAPE_Slot_%d_Stage_%d_%@",ProfileSlotNumber_,TargetStageCode_,key_];
}




@interface GameCondition (privateMethods) 

-(void)loadGame;
//-(void)saveGame;

//-(void)settingProfile;
////-(void)saveProfile;
//
//-(void)settingStagePlayInfo:(StageCode)stageCode_;
////-(void)saveStagePlayInfo:(StageCode)stageCode_;

- (void)accessGameCenter;

-(void)newProfileFirstInit:(int)targetProfileSlotNumber_;
-(void)newStageFirstInit:(int)currentProfileSlotNumber_ stageCode:(int)stageCode_;



@end

@implementation GameCondition
@synthesize runningPM;
@synthesize touchingPlayScene;

@synthesize usingCharacterCodes,stageCode,possibleStageCode;
@synthesize windSpeed,Game_default_CreatePeroid,stepSpeed,createPeroid,default_stepSpeed,PrevStep;
@synthesize etime,level,beginningLife,life,hint;
@synthesize Any_stepSpeed,Any_CreatePeroid,StandbyCounting;
@synthesize normalScore,overClearScore,infiniteScore,totalScore;
@synthesize currentCombo,maxCombo,totalCombo,rank,thisTimeRescueShapeCodes, ClearedMissionCode,OverClearedMissionCode;
@synthesize FinalRelayStartingComboPoint,MaxFinalRelayComboPoint,BeginCreatePeroid,BeginStepSpeed; //FinalRelay
@synthesize havingExp,maxExp,prevMaxExp; 

@synthesize wayTotalDistance,totalZDistance;

@synthesize ClearObjectsValuesAtCode;

@synthesize stageMaxLevel;

//FinalRelay Record
@synthesize startedFinalRelayCount;
@synthesize arrivedMaxFinalRelayCount;
@synthesize highFinalRelayDuration;
@synthesize highMaxFinalRelayDuration;

//DB Values
@synthesize highTotalCombo, highCombo, highScore, ScoreHistoryTables,selectedUserSlot,hasLearnTutorial,worldTopScore,user_name,totalStagePlayTime,MissionClearedTables;

static GameCondition *_sharedGameCondition = nil;
//System Property
@synthesize lang,japanLock;
@synthesize gameCenterLoginSuccessed,playerID;

//MainScene이 init되기전 init됨
+(GameCondition*)sharedGameCondition {
	
	if (!_sharedGameCondition) {
		_sharedGameCondition = [[GameCondition alloc] init];
	}
	
	return _sharedGameCondition;
}

-(id)init 
{
	if ( (self = [super init] ) ) {
		
		windSpeed =  200;
		Any_stepSpeed = 100;
		Any_CreatePeroid = 1.5f; //1.5
		etime = 0;

		Game_default_CreatePeroid = 1.5f;
		
		
		NSLog(@"Language:%@",[(NSArray*)[NSLocale preferredLanguages] description] );
        NSLog(@"Location:%@",[[NSLocale currentLocale] localeIdentifier] );
        NSString * preferredLangCode = [(NSArray*)[NSLocale preferredLanguages] objectAtIndex:0];
        NSLog(@"SystemSettings:%@",[[(NSUserDefaults*)[NSUserDefaults standardUserDefaults] dictionaryRepresentation] description]);
        if ([preferredLangCode isEqualToString:@"ko"]) {
            lang = Language_ko;
            NSLog(@" Selected Language:KO");
        }else if ([preferredLangCode isEqualToString:@"en"]) {
            lang = Language_en;
            NSLog(@" Selected Language:EN");
        }else {
            lang = Language_en;
            NSLog(@" Selected Language:EN");
        }
		
        
        //japanLock 설정 한번락은 영원한 락
        //감지 방법
        //GMT시간 측정
        //
        if ([preferredLangCode isEqualToString:@"ja"]) {
            japanLock = YES;
        }
        
        [self accessGameCenter];
        
		[self loadGame];
		
	}
	NSLog(@"GameCondition Initialize");
	return self;
}

-(void)finalGameInit {
	etime = 0; //고정
	normalScore = overClearScore = infiniteScore = totalScore = 0; // 고정 
	
	currentCombo = 0; // 고정 
	maxCombo = 0; //고정 
	totalCombo = 0; //고정
	touchingPlayScene = NO;
	thisTimeLevelUp = NO;
	[self settingStagePlayInfo:[SPM stageCode]]; //이전의 스테이지로그를 불러와 변수에 셋팅
	ClearedMissionCode = -1;
	OverClearedMissionCode = -1;
	
	startedFinalRelayCount = 0;
	arrivedMaxFinalRelayCount = 0;
	highFinalRelayDuration = 0;
	highMaxFinalRelayDuration = 0;
	
	//NSLog(@"GameCondition:finalGameInit ::END");
}

-(void)loadGame {
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
	start_date = [[NSDate date] retain];
	
	//NSLog(@"date:%@",[start_date description]);
	
	if ([defaults boolForKey:Game_key_APP_INITIALIZED] == NO) { //최초실행 //정식릴리즈시엔:NO 테스트는:YES

        [self superInitialize];
        	
	}else {
		
		lastDate = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:Option_key_LAST_EXECUTE_DATE]];//Before
 
		[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:start_date] forKey:Option_key_LAST_EXECUTE_DATE]; //After
		
		appExecuteCount = [defaults integerForKey:Option_key_APP_EXECUTE_COUNT];//Before
		[defaults setInteger:appExecuteCount++ forKey:Option_key_APP_EXECUTE_COUNT];//After
		
		usingProfileSlotCount = [defaults integerForKey:Game_key_USING_PROFILE_SLOT_COUNT];
		selectedUserSlot = [defaults integerForKey:Option_key_SELECTED_USER_PROFILE_SLOT];
		soundOnOff = [defaults boolForKey:Option_key_SOUND_ON_OFF];
		bgmOnOff = [defaults boolForKey:Option_key_BGM_ON_OFF];
		
		
		[self settingProfile];
		
		NSLog(@"LastExecuteDate:%@",[lastDate description]);
		NSLog(@"YES");
	}
	[defaults synchronize];
	
	/*
	NSLog(@"%@",[(NSDictionary*)[defaults dictionaryRepresentation] description]);
	NSDictionary * exDic = [defaults dictionaryRepresentation];
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
	if ( [exDic writeToFile:[NSString stringWithFormat:@"%@userDefaults.plist",documentsDirectory] atomically:YES] ){
		NSLog(@"Save Success dir:%@",documentsDirectory);
	}*/
}


-(void)superInitialize{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
    [defaults setBool:YES forKey:Game_key_APP_INITIALIZED];
    /////////////////////DB Setting///////////////////////// 레벨디자인부분
    NSString * db_missionCodes_stageZero = @"99";
    NSString * db_missionCodes_stage1 = @"0,1,2,3,4,5";
    NSString * db_missionCodes_stage2 = @"0,1,2,3,4,5";
    NSString * db_missionCodes_stage3 = @"0,1,2,3,4,5";
    NSString * db_missionCodes_stage4 = @"0,1,2,3,4,5";
    NSString * db_missionCodes_stage5 = @"0,1,2,3,4,5";
    NSString * db_missionCodes_stage6 = @"0,1,2,3,4,5";
    NSString * db_missionCodes_stage7 = @"0,1,2,3,4,5"; //스테이지 업데이트로 최대 7스테이지 까지만 늘릴수 있음 미션종류는 총 6개로 한정됨
    NSArray * applicableMissionCodes = [NSArray arrayWithObjects:db_missionCodes_stageZero,db_missionCodes_stage1,db_missionCodes_stage2,db_missionCodes_stage3,db_missionCodes_stage4,db_missionCodes_stage5,db_missionCodes_stage6,db_missionCodes_stage7,nil]; //수정후 클린빌드
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:applicableMissionCodes] forKey:DB_key_ApplicableMissionCodes];
    
    /**/[defaults synchronize];
    
    /////////////////////Game Setting////////////////////////
    usingProfileSlotCount = 1;//selectedUserSlot 은 배열의 형태로 사용하기 때문에 0~ 에서 부터 슬롯번호가 시작됨
    selectedUserSlot = usingProfileSlotCount-1;
    soundOnOff = TRUE;
    bgmOnOff = TRUE;
    
    [defaults setInteger:usingProfileSlotCount forKey:Game_key_USING_PROFILE_SLOT_COUNT];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:start_date] forKey:Option_key_LAST_EXECUTE_DATE];
    [defaults setInteger:1 forKey:Option_key_APP_EXECUTE_COUNT];
    [defaults setBool:soundOnOff forKey:Option_key_SOUND_ON_OFF];
    [defaults setBool:bgmOnOff forKey:Option_key_BGM_ON_OFF];
    [defaults setInteger:selectedUserSlot forKey:Option_key_SELECTED_USER_PROFILE_SLOT];
    
    
    ///////////////////// ... Profile 초기화 // 합성키를 이용한 공간할당
    user_name = [[NSString alloc] initWithString:@"ILD3_defaultName"];
    level = 1;
    havingExp = 0;
    maxExp = [self getMaxExp:level];
    possibleStageCode = [[NSString alloc] initWithString:@"1,2,3,4,5"]; //처음엔 1스테이지 밖에 못함 이후에 1,2 이렇게 추가됨
    [defaults setInteger:1 forKey:Option_key_Last_Played_StageCode];
    [self saveProfile];
    
    //		[defaults setObject:user_name forKey:[self getProfileKey:selectedUserSlot keyValue:Profile_key_USER_NAME]];
    //		[defaults setInteger:level forKey:[self getProfileKey:selectedUserSlot keyValue:Profile_key_LEVEL]];
    //		[defaults setInteger:havingExp forKey:[self getProfileKey:selectedUserSlot keyValue:Profile_key_HAVING_EXP]];
    //		[defaults setInteger:maxExp forKey:[self getProfileKey:selectedUserSlot keyValue:Profile_key_MAX_EXP]];
    //		[defaults setObject:possibleStageCode forKey:[self getProfileKey:selectedUserSlot keyValue:Profile_key_POSSIBLE_STAGE_CODES]];
    
    
    ///////////////////// ... StageInfo 초기화///// 합성키 이용
    //int			StageSkilledLevel;
    //int			StageSkilledLevelExp;
    //*int*/			StageSkilledLevelMaxExp;
    
    int initStageCode = STAGE_1;
    NSArray * missionCodes = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:DB_key_ApplicableMissionCodes]];
    NSArray * stageApplicableCodes = [(NSString*)[missionCodes objectAtIndex:initStageCode] componentsSeparatedByString:@","];
    //NSMutableArray * cleardTables = [[[NSMutableArray alloc] init] autorelease];
    NSMutableDictionary * cleardTables = [[[NSMutableDictionary alloc] init] autorelease];
    
    for (int i = 0;i < [stageApplicableCodes count]; i++) {
        MissionClearTable * o = [[[MissionClearTable alloc] init] autorelease];
        
        [o setMCode:[[stageApplicableCodes objectAtIndex:i] intValue]];
        [o setClearCount:0];
        [o setOverClearCount:0];
        
        [cleardTables setValue:o forKey:[stageApplicableCodes objectAtIndex:i]] ;
    }
    
    
    MissionClearedTables = [[NSDictionary alloc] initWithDictionary:cleardTables]; //미션코드를 키로 이용하여 검색가능
    highPlayTime = 0;
    highOverClear = 0;
    highTotalCombo = 0;
    highCombo = 0;
    highScore = 0;
    totalClist = @"";
    totalStagePlayTime = 0;
    ScoreHistoryTables = [[NSMutableArray alloc] init]; //스코어히스토리테이블이 쌓이는 공간
    
    stage_startedFinalRelayCount = 0;
    stage_arrivedMaxFinalRelayCount = 0;
    stage_highFinalRelayDuration = 0;
    stage_highMaxFinalRelayDuration = 0;
    
    [self saveStagePlayInfo:initStageCode];
}


-(void)GameAllReset { //예비
	//NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
}


-(void)saveGame { //게임이 끝나고 메인으로 돌아가거나 재시작할 때 실행
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
	//ScoreHistorySaving
	ScoreHistoryTable * savinghistory = [[ScoreHistoryTable alloc] initWithRescueShapeCodes:thisTimeRescueShapeCodes];
	savinghistory.score = totalScore;
	savinghistory.highCombo = maxCombo;
	savinghistory.totalCombo = totalCombo;
	savinghistory.playTime = etime;
	savinghistory.rank = rank;
    NSLog(@"%d",maxCombo);
    
	if (thisTimeLevelUp) {
		savinghistory.levelUp = level;
	}else {
		savinghistory.levelUp = -1;
	}
	[ScoreHistoryTables addObject:savinghistory];
	[savinghistory release];
    
	//MissionClearBoard Update
	if (ClearedMissionCode != -1) {
		MissionClearTable * mct = [MissionClearedTables valueForKey:[NSString stringWithFormat:@"%d",ClearedMissionCode]];
		[mct setClearCount:[mct clearCount]+1];
		
		if (OverClearedMissionCode != -1) {
			MissionClearTable * mct = [MissionClearedTables valueForKey:[NSString stringWithFormat:@"%d",OverClearedMissionCode]];
			[mct setOverClearCount:[mct overClearCount]+1];
		}
	}
	
	highPlayTime = fmax(highPlayTime, etime);
	//highOverClear = 
	highTotalCombo = fmax(highTotalCombo, totalCombo);
	highCombo = fmax(highCombo, maxCombo);
	highScore = MAX(highScore, totalScore);
	//totalClist = 
	totalStagePlayTime += etime;
	
	stage_startedFinalRelayCount += startedFinalRelayCount;
	stage_arrivedMaxFinalRelayCount += arrivedMaxFinalRelayCount;
	stage_highFinalRelayDuration = fmax(stage_highFinalRelayDuration, highFinalRelayDuration);
	stage_highMaxFinalRelayDuration = fmax(stage_highMaxFinalRelayDuration, highMaxFinalRelayDuration);
	
	
	[defaults setInteger:usingProfileSlotCount forKey:Game_key_USING_PROFILE_SLOT_COUNT];
	[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:start_date] forKey:Option_key_LAST_EXECUTE_DATE];
	[defaults setInteger:1 forKey:Option_key_APP_EXECUTE_COUNT];
	[defaults setBool:soundOnOff forKey:Option_key_SOUND_ON_OFF];
	[defaults setBool:bgmOnOff forKey:Option_key_BGM_ON_OFF];
	[defaults setInteger:selectedUserSlot forKey:Option_key_SELECTED_USER_PROFILE_SLOT];
	[defaults setInteger:stageCode forKey:Option_key_Last_Played_StageCode];
    [defaults setBool:hasLearnTutorial forKey:Option_key_Has_Learn_Tutorial];
    
    [GameCenterManager sendScoreToGameCenter:totalScore StageCode:stageCode];
	[self saveProfile];
	[self saveStagePlayInfo:stageCode];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (nextStageUnLocked) {

        NSArray * missionCodes = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:DB_key_ApplicableMissionCodes]];
        NSArray * stageApplicableMissionCodes = [(NSString*)[missionCodes objectAtIndex:stageCode+1] componentsSeparatedByString:@","];
        //NSMutableArray * cleardTables = [[[NSMutableArray alloc] init] autorelease];
        NSMutableDictionary * cleardTables = [[[NSMutableDictionary alloc] init] autorelease];
    
        for (int i = 0;i < [stageApplicableMissionCodes count]; i++) {
            MissionClearTable * o = [[[MissionClearTable alloc] init] autorelease];
        
            [o setMCode:[[stageApplicableMissionCodes objectAtIndex:i] intValue]];
            [o setClearCount:0];
            [o setOverClearCount:0];
        
            [cleardTables setValue:o forKey:[stageApplicableMissionCodes objectAtIndex:i]] ;
        }
	
	
        MissionClearedTables = [[NSDictionary alloc] initWithDictionary:cleardTables]; //미션코드를 키로 이용하여 검색가능
        highPlayTime = 0;
        highOverClear = 0;
        highTotalCombo = 0;
        highCombo = 0;
        highScore = 0;
        totalClist = @"";
        totalStagePlayTime = 0;
        ScoreHistoryTables = [[NSMutableArray alloc] init]; //스코어히스토리테이블이 쌓이는 공간
        stage_startedFinalRelayCount = 0;
        stage_arrivedMaxFinalRelayCount = 0;
        stage_highFinalRelayDuration = 0;
        stage_highMaxFinalRelayDuration = 0;
    
        NSString * currentPossibleStageCode = [NSString  stringWithFormat:@"%@,%d",possibleStageCode,stageCode+1];
        [possibleStageCode release];
        possibleStageCode = [[NSString alloc] initWithString:currentPossibleStageCode];
        NSLog(@"currentPossibleStageCode:%@",currentPossibleStageCode);
        [self saveStagePlayInfo:stageCode+1];
        [self saveProfile];
        
///스테이지 6추가 업데이트때 주석해제하고 업뎃후 게임 첫 시작때 스테이지5가 열려있으면 한번 실행해주고 아직 아니라면 여기에 둔다
//        
//        //이번에 열리는 스테이지가 5라면 6도 같이 열어 데이터저장공간을 마련한다
//        if (stageCode + 1 == 5) {
//            //하지만 재팬락이 걸려있다면 제외함
//            if (![GameCondition sharedGameCondition].japanLock) {
//                NSArray * missionCodes = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:DB_key_ApplicableMissionCodes]];
//                NSArray * stageApplicableMissionCodes = [(NSString*)[missionCodes objectAtIndex:stageCode+2] componentsSeparatedByString:@","];
//                //NSMutableArray * cleardTables = [[[NSMutableArray alloc] init] autorelease];
//                NSMutableDictionary * cleardTables = [[[NSMutableDictionary alloc] init] autorelease];
//                
//                for (int i = 0;i < [stageApplicableMissionCodes count]; i++) {
//                    MissionClearTable * o = [[[MissionClearTable alloc] init] autorelease];
//                    
//                    [o setMCode:[[stageApplicableMissionCodes objectAtIndex:i] intValue]];
//                    [o setClearCount:0];
//                    [o setOverClearCount:0];
//                    
//                    [cleardTables setValue:o forKey:[stageApplicableMissionCodes objectAtIndex:i]] ;
//                }
//                
//                
//                MissionClearedTables = [[NSDictionary alloc] initWithDictionary:cleardTables]; //미션코드를 키로 이용하여 검색가능
//                highPlayTime = 0;
//                highOverClear = 0;
//                highTotalCombo = 0;
//                highCombo = 0;
//                highScore = 0;
//                totalClist = @"";
//                totalStagePlayTime = 0;
//                ScoreHistoryTables = [[NSMutableArray alloc] init]; //스코어히스토리테이블이 쌓이는 공간
//                stage_startedFinalRelayCount = 0;
//                stage_arrivedMaxFinalRelayCount = 0;
//                stage_highFinalRelayDuration = 0;
//                stage_highMaxFinalRelayDuration = 0;
//                
//                NSString * currentPossibleStageCode = [NSString  stringWithFormat:@"%@,%d",possibleStageCode,stageCode+2];
//                [possibleStageCode release];
//                possibleStageCode = [[NSString alloc] initWithString:currentPossibleStageCode];
//                NSLog(@"currentPossibleStageCode:%@",currentPossibleStageCode);
//                [self saveStagePlayInfo:stageCode+2];
//                [self saveProfile];
//            }
//        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //게임 저장후 게임에서 변경되는 변수 모두 초기화
    nextStageUnLocked = NO;
	
    
    stageCode = 0;
}

-(void)settingProfile {
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	//Profile
	user_name = [[NSString alloc] initWithString:[defaults objectForKey:[self getProfileKey:selectedUserSlot keyValue:Profile_key_USER_NAME]]];
	level = [defaults integerForKey:[self getProfileKey:selectedUserSlot keyValue:Profile_key_LEVEL]];
	havingExp = [defaults integerForKey:[self getProfileKey:selectedUserSlot keyValue:Profile_key_HAVING_EXP]];
	maxExp = [defaults integerForKey:[self getProfileKey:selectedUserSlot keyValue:Profile_key_MAX_EXP]];
	possibleStageCode = [[NSString alloc] initWithString:[defaults objectForKey:[self getProfileKey:selectedUserSlot keyValue:Profile_key_POSSIBLE_STAGE_CODES]]];
    hasLearnTutorial = [defaults boolForKey:Option_key_Has_Learn_Tutorial];
    
	NSLog(@"Setting Profile");
	NSLog(@"User_Name : %@",user_name);
	NSLog(@"PossibleStage_Codes:%@",possibleStageCode);
	
	NSLog(@"level :%d ",level);
	NSLog(@"havingExp :%lld",havingExp);
	NSLog(@"Max EXp:%lld",maxExp);
}

-(void)saveProfile {
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:user_name forKey:[self getProfileKey:selectedUserSlot keyValue:Profile_key_USER_NAME]];
	[defaults setInteger:level forKey:[self getProfileKey:selectedUserSlot keyValue:Profile_key_LEVEL]];
	[defaults setInteger:havingExp forKey:[self getProfileKey:selectedUserSlot keyValue:Profile_key_HAVING_EXP]];
	[defaults setInteger:maxExp forKey:[self getProfileKey:selectedUserSlot keyValue:Profile_key_MAX_EXP]];
	[defaults setObject:possibleStageCode forKey:[self getProfileKey:selectedUserSlot keyValue:Profile_key_POSSIBLE_STAGE_CODES]];
	[defaults synchronize];
	NSLog(@"Save Profile");
	NSLog(@"User_Name : %@",user_name);
	NSLog(@"PossibleStage_Codes:%@",possibleStageCode);
	NSLog(@"level :%d ",level);
	NSLog(@"havingExp :%lld",havingExp);
	NSLog(@"Max EXp:%lld",maxExp);
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)settingStagePlayInfo:(StageCode)stageCode_ {
    if (ScoreHistoryTables != nil) {
        [ScoreHistoryTables release];
    }
    if (MissionClearedTables != nil) {
        [MissionClearedTables release];
    }
    
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
	MissionClearedTables = [[NSDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_MISSION_CLEARED_TABLES)]]];
	NSLog(@"why1");
	highPlayTime = [defaults integerForKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_HIGH_PLAYTIME)];
	//highOverClear = [defaults integerForKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_HIGH_OVERCLEAR)];
	highTotalCombo = [defaults integerForKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_HIGH_TOTAL_COMBO)];
	highCombo = [defaults integerForKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_HIGH_COMBO)];
	highScore = [defaults integerForKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_HIGH_SCORE)];
	//totalClist = [[NSString alloc] initWithString:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_TOTAL_CLIST)]]];
	totalStagePlayTime = [defaults integerForKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_TOTAL_STAGE_PLAYTIME)];
	ScoreHistoryTables = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_SCORE_HISTORY_TABLES)]]];
	//NSLog(@"ScoreHistoryTables : %d",[(ScoreHistoryTable*)[ScoreHistoryTables objectAtIndex:0] score]);
	stage_startedFinalRelayCount = [defaults integerForKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_STARTED_FINALRELAY_COUNT)];
	stage_arrivedMaxFinalRelayCount  = [defaults integerForKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_STARTED_MAXFINALRELAY_COUNT)];
	stage_highFinalRelayDuration  = [defaults integerForKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_HIGH_DURATION_FINALRELAY)];
	stage_highMaxFinalRelayDuration  = [defaults integerForKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_HIGH_DURATION_MAXFINALRELAY)];
	
    worldTopScore = 0;
	//게임센터에서 스테이지별 스코어중의 1위 스코어를 받아옴
    GKLeaderboard *board = [[[GKLeaderboard alloc] init] autorelease];
    if (board != nil)
    {
        board.range = NSMakeRange(1, 10);
        //board.timeScope = GKLeaderboardTimeScopeAllTime;
        board.playerScope = GKLeaderboardPlayerScopeGlobal;
        switch (stageCode_) {
            case STAGE_1 :
                board.category = [NSString stringWithFormat:@"rb_stage1"];
                break;
            case STAGE_2 :
                board.category = [NSString stringWithFormat:@"rb_stage2"];
                break;
            case STAGE_3 :
                board.category = [NSString stringWithFormat:@"rb_stage3"];
                break;
            case STAGE_4 :
                board.category = [NSString stringWithFormat:@"rb_stage4"];
                break;
            case STAGE_5 :
                board.category = [NSString stringWithFormat:@"rb_stage5"];
                break;
            case STAGE_6 :
                board.category = [NSString stringWithFormat:@"rb_stage6"];
                break;
            default:
                break;
        }
        
        [board loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
            if (error == nil)
            {
                if ([board localPlayerScore]==nil){
                    NSLog(@"localplayer nil!");
                    worldTopScore = 0;
                }else {
                    int64_t topScore = 0;
                    if (scores != nil) {
                        if ([scores count] > 0) {
                            GKScore * topScoreData = [scores objectAtIndex:0];
                            topScore = [topScoreData value];
                        }
                    }
                    worldTopScore = topScore;
                } 
            } else {
                NSLog(@"error 1st fetch");
                worldTopScore = 0;
            }
        }];
        
    }
    
    
}
	 
-(void)saveStagePlayInfo:(StageCode)stageCode_ {
	

	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:MissionClearedTables] forKey:getStageInfoKey(selectedUserSlot,stageCode_,StageInfo_key_MISSION_CLEARED_TABLES)];
	[defaults setInteger:highPlayTime forKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_HIGH_PLAYTIME)];
	//[defaults setInteger:highOverClear forKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_HIGH_OVERCLEAR)];
	[defaults setInteger:highTotalCombo forKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_HIGH_TOTAL_COMBO)];
	[defaults setInteger:highCombo forKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_HIGH_COMBO)];
	[defaults setInteger:highScore forKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_HIGH_SCORE)];
	//[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:totalClist] forKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_TOTAL_CLIST)];
	[defaults setInteger:totalStagePlayTime forKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_TOTAL_STAGE_PLAYTIME)];
	[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:ScoreHistoryTables] forKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_SCORE_HISTORY_TABLES)];
	
	[defaults setInteger:stage_startedFinalRelayCount forKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_STARTED_FINALRELAY_COUNT)];
	[defaults setInteger:stage_arrivedMaxFinalRelayCount forKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_STARTED_MAXFINALRELAY_COUNT)];
	[defaults setInteger:stage_highFinalRelayDuration forKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_HIGH_DURATION_FINALRELAY)];
	[defaults setInteger:stage_highMaxFinalRelayDuration forKey:getStageInfoKey(selectedUserSlot, stageCode_, StageInfo_key_HIGH_DURATION_MAXFINALRELAY)];
	
	[[NSUserDefaults standardUserDefaults] synchronize];
	for (int i = 0; i < [ScoreHistoryTables count]; i++) {
		//NSLog(@"\n\nScoreHistoryTable Index:%d\nDescription:%@",i,[[ScoreHistoryTables objectAtIndex:i] description]);
	}
	for (MissionClearTable * t in MissionClearedTables){
		//NSLog(@"\n\nMissionClearedTables \n%@",[[MissionClearedTables valueForKey:[t description]] description]);
	}
	//NSLog(@"User Data :%@",[[defaults dictionaryRepresentation] description]);
	
	//세이브후 사용할 일이 없고, 사용할 일이 생기면 로드해서 사용함으로 모두 해제함 
	[MissionClearedTables release];
	//[totalClist release];
	[ScoreHistoryTables removeAllObjects];
	[ScoreHistoryTables release];
    MissionClearedTables = nil;
    ScoreHistoryTables = nil;
	
}



-(void)newProfileFirstInit:(int)targetProfileSlotNumber_ {
	
}

-(void)newStageFirstInit:(int)currentProfileSlotNumber_ stageCode:(int)stageCode_ {
	
}

-(NSString*)getProfileKey:(int)ProfileSlotNumber_ keyValue:(NSString*)key_{
	return [NSString stringWithFormat:@"KEEPINGSHAPE_Slot_%d_%@",ProfileSlotNumber_,key_];
}
-(NSString*)getStagePlayInfoKey:(int)ProfileSlotNumber_ stageCode:(int)TargetStageCode_ keyValue:(NSString*)key_{
	return [NSString stringWithFormat:@"KEEPINGSHAPE_Slot_%d_Stage_%d_%@",ProfileSlotNumber_,TargetStageCode_,key_];
}

#pragma mark === GameCenter ===	
- (void)accessGameCenter {
    /////////////////Geunwon,Mo : GameCenter 추가 start /////////////
    
    
    
    //AppUtils 가 인스턴스 메소드이기 때문에 걍 쓴다
    
    if ([GameCenterManager isGameCenterAvailable]) { //게임센터가 가능한 단말이면...
        
        [GameCenterManager connectGameCenter];       //게임센터 접속~
        
    }
    
    /////////////////Geunwon,Mo : GameCenter 추가 end   /////////////
} 

-(void)GameCenterLoginSuccess:(NSString*)playerID_{
    //[GameCenterManager resetAchievements];
    //[GameCenterManager sendAchievementWithIdentifier:@"ks_ac_start" percentComplete:20.0f];
    //[GameCenterManager sendAchievementWithIdentifier:@"ttest" percentComplete:25.0f];
    
    gameCenterLoginSuccessed = YES;
    playerID = [[NSString alloc] initWithString:playerID_];
    
//    [GKLeaderboard loadCategoriesWithCompletionHandler:^(NSArray *categories, NSArray *titles, NSError *error) {
//        //NSLog(@"Categories:%@",[titles description]);
//    }];
    

    
//    GKLeaderboard *board = [[[GKLeaderboard alloc] init] autorelease];
//    if (board != nil)
//    {
//        board.range = NSMakeRange(1, 10);
//        //board.timeScope = GKLeaderboardTimeScopeAllTime;
//        board.playerScope = GKLeaderboardPlayerScopeGlobal;
//        board.category = [NSString stringWithFormat:@"rb_stage1"];
//        
//        [board loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
//            if (error == nil)
//            {
//                if ([board localPlayerScore]==nil){
//                    NSLog(@"localplayer nil!");
//                }else {
//                    NSLog(@"%@",[[board localPlayerScore] description]);
//                    NSLog(@"%@",[scores description]);
//                }
//                //NSLog(@"Scores:%@",[scores description]); 
//            } else {
//                NSLog(@"error 1st fetch");
//            }
//        }];
//        
//    }
    
    [GameCenterManager sendLevelToGameCenter:level ShowLevelMode:YES];
}

#pragma mark === calling from StagePlacement ===																									  
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
				  spm:(StagePlacementManager*)SPM_{
	SPM = SPM_;
	
	BeginStepSpeed = BeginStepSpeed_;
	BeginCreatePeroid = BeginCreatePeroid_;
	MaxLevel_StepSpeed = MaxLevel_StepSpeed_; //스테이지 레벨이 만랩일때
	MaxLevel_CreatePeroid = MaxLevel_CreatePeroid_; // 스테이지 레벨이 만렙일때
	FinalRelayStartingComboPoint = FinalRelayStartingComboPoint_;
	MaxFinalRelayComboPoint = MaxFinalRelayComboPoint_;
	StandbyCounting = StanbyCounting_; //카운팅 시간
	PrevStep = PrevStep_;
	BeginLife = BeginLife_; //게임시작시 주어지는 라이프 
	BeginHint = BeginHint_; //게임시작시 주어지는 힌트포인트
	stageMaxLevel = StageMaxLevel_; //스테이지최종 클리어가 가능한 레벨
	//StageSkilledLevelMaxExpTable = [[NSArray alloc] initWithArray:StageSkilledLevelMaxExpTable_ copyItems:YES];//[StageSkilledLevelMaxExpTable_ copy];
	
	ExpJumpValue = ExpJumpValue_;
	ScoreJumpValue = ScoreJumpValue_;
	
	AppearenceCharacterCodes = AppearenceCharacterCodes_;
	NSArray * temp = [AppearenceCharacterCodes componentsSeparatedByString:@","];
	NSMutableArray * tempCodes = [[[NSMutableArray alloc] init] autorelease];
	for (NSString * s in temp) {
		NSNumber * n = [[[NSNumber alloc] initWithInteger:[s intValue]] autorelease];
		[tempCodes addObject:n];
	}
	if (usingCharacterCodes != nil) {
		[usingCharacterCodes release];
	}
	usingCharacterCodes = [tempCodes copy];
	NSLog(@"Appearence Character Codes : %@",[usingCharacterCodes description]);
	
	

	//난이도 설정
	default_stepSpeed = BeginStepSpeed;
	Game_default_CreatePeroid = BeginCreatePeroid;
	
	beginningLife = BeginLife;
	life = BeginLife;
	hint = BeginHint;
	
	stepSpeed = default_stepSpeed;
	createPeroid = Game_default_CreatePeroid;
	
	//ClearObject 초기화
	if (ClearObjects != nil) {
		[ClearObjects release];
	}
	ClearObjects = [ClearObjects_ copy];
	int inf_stageCode = [SPM stageCode];
	stageCode = inf_stageCode;
	
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	NSArray * applicableMissionCodesDBArr = [[[NSArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:DB_key_ApplicableMissionCodes]]] autorelease];
	NSArray * applicableMissionCodesAtStage = [[[NSArray alloc] initWithArray:[(NSString*)[applicableMissionCodesDBArr objectAtIndex:inf_stageCode] componentsSeparatedByString:@","]] autorelease];
	
	if (ClearObjectsValuesAtCode != nil) {
		[ClearObjectsValuesAtCode removeAllObjects];
		[ClearObjectsValuesAtCode release];
	}
	ClearObjectsValuesAtCode = [[NSMutableDictionary alloc] init];
	
	NSLog(@"activation MissionCode :%@",[applicableMissionCodesAtStage description]);
	for (int i = 0; i < [applicableMissionCodesAtStage count]; i++ ) {
		int missionCode = [[applicableMissionCodesAtStage objectAtIndex:i] intValue];
		
		NSString * missionObjectStr = [ClearObjects objectAtIndex:missionCode];
		NSArray * missionArticles = [missionObjectStr componentsSeparatedByString:@" "];
		
		NSMutableDictionary * missionInfo = [[[NSMutableDictionary alloc] init] autorelease];
		
		for (int j = 0; j < [missionArticles count]; j++) {
			NSArray * dividedMissionArticle = [[missionArticles objectAtIndex:j] componentsSeparatedByString:@":"];
			NSString * keyAtMissionInfo = [dividedMissionArticle objectAtIndex:0];
			NSString * ValueAtMissionArticle = [dividedMissionArticle objectAtIndex:1];
			[missionInfo setObject:ValueAtMissionArticle forKey:keyAtMissionInfo];
			
			//미션정보 셋팅은 끝 이제 미션읽어서 체크루틴만들기
		}
		
		[ClearObjectsValuesAtCode setObject:missionInfo forKey:[NSString stringWithFormat:@"%d",missionCode]];
		NSLog(@"MissionCodes :%d",missionCode);
	}
	
	
}
-(void)setUsingCharacterCodesFromSPM:(NSString *)AppearenceCharacterCodes_ {
    
    AppearenceCharacterCodes = AppearenceCharacterCodes_;
	NSArray * temp = [AppearenceCharacterCodes componentsSeparatedByString:@","];
	NSMutableArray * tempCodes = [[[NSMutableArray alloc] init] autorelease];
	for (NSString * s in temp) {
		NSNumber * n = [[[NSNumber alloc] initWithInteger:[s intValue]] autorelease];
		[tempCodes addObject:n];
	}
	if (usingCharacterCodes != nil) {
		[usingCharacterCodes release];
	}
	usingCharacterCodes = [tempCodes copy];
	NSLog(@"Appearence Character Codes : %@",[usingCharacterCodes description]);
    
}
#pragma mark -

#pragma mark === StageUnlock & levelUp & Exp ===
-(void)LevelUp {
	level += 1;
	prevMaxExp = maxExp;
	maxExp = [self getMaxExp:level];
	thisTimeLevelUp = YES;
	NSLog(@"LevelUp level:%d MaxExp:%lld",level,maxExp);
    [GameCenterManager sendLevelToGameCenter:level ShowLevelMode:NO];
}

-(StageCode)nextStageUnLock { //스테이지가 한변 열릴때 단 한번만 실행됨 반환값 새로운 스테이지가 열리면 열린 스테이지코드를 안열리면 -1반환
	//NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	int lastStageCode = STAGE_5+1; //제일 마지막 스테이지에 최종 클리어 스테이지 6까지
	if (stageCode + 1 <= lastStageCode) {
		//int initStageCode = stageCode+1;
		
//		//이미 언락된 스테이지인지 판별
//		NSArray * possibleStageCodeArr = [possibleStageCode componentsSeparatedByString:@","]; 
//		BOOL alreadyIsStageCode = NO;
//		for (NSString * code in possibleStageCodeArr){
//			if ([code intValue] != initStageCode) {
//				alreadyIsStageCode = YES;
//			}
//		}
		
		if(![self unLockedNextStage]){ //이미 언락된 스테이지가 아니면
            nextStageUnLocked = YES;
			return stageCode+1;
		}
	}
	return -1;	
	
}

-(BOOL)unLockedNextStage{
    //이미 언락된 스테이지인지 판별 하지만 최종게임클리어 판별을 위해서 스테이지6이라는 가상의 대상도 감지한다.
    if (stageCode + 1 <= 6) {
        NSArray * possibleStageCodeArr = [possibleStageCode componentsSeparatedByString:@","]; 
        for (NSString * code in possibleStageCodeArr){
            if ([code intValue] == stageCode+1) { //언락되어(열려) 있다면 
                return YES;
                //NSLog(@"unLockedNextStage:YES");
            }
        }
        //NSLog(@"unLockedNextStage:NO");
        return NO;
    }else{
        return YES; //마지막 스테이지의 경우 다음스테이지가 없기때문에 참으로 가정하고 패스한다
    }
}

-(unsigned long long)getMaxExp:(int)level_{
	return level_*level_*250;
}
#pragma mark -
#pragma mark === ETC ===
-(void)setSPM:(StagePlacementManager *)SPM_ {
	SPM = SPM_;
}

-(StagePlacementManager*)getSPM {
	return SPM;
}

#pragma mark -
#pragma mark ::Sound Option Controller

-(void)SoundOn {soundOnOff = YES;}
-(void)SoundOff {soundOnOff = NO;}
-(BOOL)onSound {return soundOnOff;}
-(void)BGMOn {bgmOnOff = YES;}
-(void)BGMOff {bgmOnOff = NO;}
-(BOOL)onBGM {return bgmOnOff;}

//load Profile , Save Profile
@end
