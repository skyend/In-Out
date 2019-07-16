//
//  StageFinalizer.m
//  Memory0_0
//
//  Created by JinUng Han on 11. 5. 3..
//  Copyright 2011 Student. All rights reserved.
//

#import "StageFinalizer.h"

#import "ProgressManager.h"
#import "GameCondition.h"
#import "MissionCard.h"
#import "ScoreHistoryTable.h"
#import "GameCenterManager.h"

//#define D_UnLockRankCode RANK_SSS
#define D_UnLockRankCountNum 5


float floatMarkOut2(float v) {
	if (v < 0) {
		return v * -1;
	}else {
		return v;
	}
}

@interface StageFinalizer (privateMethods)
-(void)resumeGame;
-(void)MissionClearFinalize_Loop:(ccTime)d;
-(void)GameOver_Finalize_Loop:(ccTime)d;
-(void)finalizeButtonCallback:(id)sender;
-(BOOL)isKeyinFlags:(NSString*)key_;
-(BOOL)addFlagAndJustUsing:(NSString*)key_;
-(void)menuShow:(BOOL)flag_;
-(void)Finalize_Rewarding_Loop:(ccTime)d;
@end

@implementation StageFinalizer
@synthesize runfinalize;

//blackDot.png
//numbers19.png
//Sprite_HavingExpLine
//Sprite_GettingExpLine-hd.png
//Sprite_ExpLine

//text_TapToScreen
//text_GameOver
//text_Rewarding.png
//text_Rewarding-d.png
//text_Retry.png
//text_retry-d.png
//text_OverClear.png
//text_OverClear-d.png
//text_moreChallenge.png
//text_MissionClear.png
//text_Level.png
//text_Infinite.png
//text_infinite-d.png
//text_Experience.png
//text_buttonBar.png

-(id)initWithPM:(ProgressManager*)PM_ coverLayer:(CCLayer*)CoverLayer_{
	if ( ( self = [ super init] ) ) {
		runfinalize = NO;
		PM = PM_;
		GC = [GameCondition sharedGameCondition];
		
		finalLayer = [CCLayer node];
		CoverLayer = CoverLayer_;
		[CoverLayer addChild:finalLayer z:9999];
		

		
		blackDot = [CCSprite spriteWithFile:@"blackDot.png"];
		blackDot.scaleX = 480;
		[finalLayer addChild:blackDot];
		
		tapToScreen = [CCSprite spriteWithFile:@"text_TapToScreen.png"];
		tapToScreen.anchorPoint = ccp(0.5f,0.5f);
		tapToScreen.position = ccp(240,55);
		tapToScreen.opacity = 0;
		[finalLayer addChild:tapToScreen];
		
		Icon_Faster = [CCSprite spriteWithFile:@"TapToScreenIcon_Faster.png"];
		Icon_Faster.anchorPoint = ccp(0.5f,0.5f);
		Icon_Faster.position = ccp(240,30);
		Icon_Faster.opacity = 0;
		[finalLayer addChild:Icon_Faster];
		
		Icon_FasterOutLine = [CCSprite spriteWithFile:@"TapToScreenIcon_FasterOutLine.png"];
		Icon_FasterOutLine.anchorPoint = ccp(0.5f,0.5f);
		Icon_FasterOutLine.position = ccp(240,30);
		Icon_FasterOutLine.opacity = 0;
		[finalLayer addChild:Icon_FasterOutLine];
		
		Icon_Main = [CCSprite spriteWithFile:@"TapToScreenIcon_Main.png"];
		Icon_Main.anchorPoint = ccp(0.5f,0.5f);
		Icon_Main.position = ccp(240,30);
		Icon_Main.opacity = 0;
		[finalLayer addChild:Icon_Main];
		
		Icon_MainOutLine = [CCSprite spriteWithFile:@"TapToScreenIcon_MainOutLine.png"];
		Icon_MainOutLine.anchorPoint = ccp(0.5f,0.5f);
		Icon_MainOutLine.position = ccp(240,30);
		Icon_MainOutLine.opacity = 0;
		[finalLayer addChild:Icon_MainOutLine];
		
		
		
		
		
		//Step 1 objects initialize
		s_GameOver = [CCSprite spriteWithFile:@"text_GameOver.png"];
		s_GameOver.anchorPoint = ccp(0.5f,0.5f);
		s_GameOver.position = ccp(-s_GameOver.contentSize.width/2,160);
		
		s_MissionClear = [CCSprite spriteWithFile:@"text_MissionClear.png"];
		s_MissionClear.anchorPoint = ccp(0.5f,0.5f);
		s_MissionClear.position = ccp(-s_MissionClear.contentSize.width/2,160);
		
		
		
		
		
		b_rewarding = [CCMenuItemImage itemFromNormalImage:@"text_Rewarding.png" selectedImage:@"text_Rewarding-d.png" target:self selector:@selector(finalizeButtonCallback:)];
		b_rewarding.visible = NO;
		[b_rewarding setIsEnabled:NO];
		b_rewarding.tag = 0;
		
		b_overClear = [CCMenuItemImage itemFromNormalImage:@"text_OverClear.png" selectedImage:@"text_OverClear-d.png" target:self selector:@selector(finalizeButtonCallback:)];
		b_overClear.visible = NO;
		[b_overClear setIsEnabled:NO];
		b_overClear.tag = 1;
		
		b_infinite = [CCMenuItemImage itemFromNormalImage:@"text_Infinite.png" selectedImage:@"text_Infinite-d.png" target:self selector:@selector(finalizeButtonCallback:)];
		b_infinite.visible = NO;
		[b_infinite setIsEnabled:NO];
		b_infinite.tag = 2;
		
		b_retry = [CCMenuItemImage itemFromNormalImage:@"text_Retry.png"  selectedImage:@"text_Retry-d.png" target:self  selector:@selector(finalizeButtonCallback:)];
		b_retry.visible = NO;
		[b_retry setIsEnabled:NO];
		b_retry.tag = 3;
		
		
		s_moreChallenge = [CCSprite spriteWithFile:@"text_moreChallenge.png"];
		s_moreChallenge.anchorPoint = ccp(0.5f,0.5f);
		s_moreChallenge.position = ccp(265,130);
		s_moreChallenge.visible = NO;
		
		menu = [CCMenu menuWithItems:b_rewarding,b_overClear,b_infinite,b_retry,nil];
		[menu alignItemsHorizontally];
		menu.anchorPoint = ccp(0.5f,0.5f);
		menu.position = ccp(240,145);
		
		s_selectedBar = [CCSprite spriteWithFile:@"text_buttonBar.png"];
		s_selectedBar.anchorPoint = ccp(0.5f,0.5f);
		s_selectedBar.position = ccp(menu.position.x + b_retry.position.x,menu.position.y + b_retry.position.y);
		s_selectedBar.opacity = s_selTopa = 0;
		s_selTp = s_selectedBar.position;
		selectedTag = -1;
		
		[finalLayer addChild:s_moreChallenge];
		[finalLayer addChild:s_selectedBar];
		[finalLayer addChild:s_MissionClear];
		[finalLayer addChild:s_GameOver];
		[finalLayer addChild:menu];
		
		
	}
	NSLog(@"StageFinalizer Initialize");
	return self;
}

-(void)finalizeTheStage:(FinalizeCode)code_{
	printf("\nStageCode: %d",[GC stageCode]);
	
	switch ([GC stageCode]) { //원래 위에 있던건데 스테이지코드 초기화가 안되서 밑으로 내려옴
		case STAGE_1:
			backCoverColor = [CCSprite spriteWithFile:@"Gradiantlines_Oceanblue.png"];
			break;
		case STAGE_2:
			backCoverColor = [CCSprite spriteWithFile:@"Gradiantlines_Blue.png"];
			break;
		case STAGE_3:
			backCoverColor = [CCSprite spriteWithFile:@"Gradiantlines_Gold.png"];
			break;
		case STAGE_4:
			backCoverColor = [CCSprite spriteWithFile:@"Gradiantlines_Green.png"];
			break;
		case STAGE_5:
			backCoverColor = [CCSprite spriteWithFile:@"Gradiantlines_Sunset.png"];
			break;
		default:
			backCoverColor = [CCSprite spriteWithFile:@"Gradiantlines_Red.png"];
			break;
	}
	
	backCoverColor.scaleX = 480;
	backCoverColor.opacity = 0;
	backCoverColor.anchorPoint = ccp(0,0);
	backCoverColor.position = ccp(0,0);
	[finalLayer addChild:backCoverColor z:-1];
	backCoverTopa = 215;
	
	runfinalize = YES;
	FCode = code_;
	GPMode = [PM GPMode];
	ClearedMissionCode = [PM ClearedMissionCode];
	OverClearedMissionCode = [PM OverClearedMissionCode];
	
	updateElapsedTime = 0;
	elapsedTime = 0;
	flags = [[NSMutableDictionary alloc] init];
	
	blackDot.position = ccp(0,160);
	blackDot.anchorPoint = ccp(0,0.5f);
	blackDot.opacity = 0;
	blackDotTopa = 200;
	blackDotRect = CGRectMake(0, 160, 480, 50);
	blackDot.scaleX = blackDotRect.size.width;
	
	//Finalize result values initialize
//	int missionClearScore;
//	int missionOverClearScore;
//	int comboScore;
//	int totalScore;
//	RANK rank;
//	
//	int gettingExp;
//	int havingExp;
//	int maxExp;
//	int level;
	if (ClearedMissionCode != -1) {
		NSDictionary * mission = [[PM missionDic] valueForKey:[NSString stringWithFormat:@"%d",ClearedMissionCode]];
		NSArray * ApplyLogic = [(NSString*)[mission valueForKey:@"Clear"] componentsSeparatedByString:@"_"];
		
		//NSArray * scoreAmpMultiplier
		if ([[ApplyLogic objectAtIndex:0] isEqualToString:@"score"]) {
			if ([[ApplyLogic objectAtIndex:1] isEqualToString:@"x"]) {
				missionClearScore = GC.totalScore * ([[ApplyLogic objectAtIndex:2] floatValue]-1);
				NSLog(@"multiplier:%f",[[ApplyLogic objectAtIndex:2] floatValue]);
                missionClearBonusMultiplier = [[ApplyLogic objectAtIndex:2] floatValue];
			}else if ([[ApplyLogic objectAtIndex:1] isEqualToString:@"+"]) {
				missionClearScore = [[ApplyLogic objectAtIndex:2] floatValue];
			}
		}
	}
	if (OverClearedMissionCode != -1) {
		NSDictionary * mission = [[PM missionDic] valueForKey:[NSString stringWithFormat:@"%d",OverClearedMissionCode]];
		NSArray * ApplyLogic = [(NSString*)[mission valueForKey:@"Overclear"] componentsSeparatedByString:@"_"];
		
		//NSArray * scoreAmpMultiplier
		if ([[ApplyLogic objectAtIndex:0] isEqualToString:@"score"]) {
			if ([[ApplyLogic objectAtIndex:1] isEqualToString:@"x"]) {
				missionOverClearScore = (GC.totalScore+missionClearScore) * ([[ApplyLogic objectAtIndex:2] floatValue]-1);
				missionOverClearBonusMultiplier = [[ApplyLogic objectAtIndex:2] floatValue];
			}else if ([[ApplyLogic objectAtIndex:1] isEqualToString:@"+"]) {
				missionOverClearScore = [[ApplyLogic objectAtIndex:2] floatValue];
			}
		}
	}
	
	int ComboDefaultScore = 77;
	comboScore = (GC.totalCombo * GC.maxCombo)+ComboDefaultScore;
	NSLog(@"%lld",comboScore);
	totalScore = GC.totalScore + missionClearScore + missionOverClearScore + comboScore;
	GC.totalScore = totalScore;
	
	int inmaxCombo = GC.maxCombo;
	int intotalCombo = GC.totalCombo;
	float ComboPercentage;
	if (inmaxCombo == 0 || intotalCombo == 0) {
		ComboPercentage = 0 ;
	}else {
		ComboPercentage = (float)((float)inmaxCombo/intotalCombo) * 100 ;
	}

	
	if (ComboPercentage < 20) {
		rank = RANK_F;
	}else if (ComboPercentage >= 20 && ComboPercentage < 40) {
		rank = RANK_D;
		if (GC.life == GC.beginningLife)rank = RANK_Dp;
		
	}else if (ComboPercentage >= 40 && ComboPercentage < 50) {
		rank = RANK_C;
		if (GC.life == GC.beginningLife)rank = RANK_Cp;
		
	}else if (ComboPercentage >= 50 && ComboPercentage < 60) {
		rank = RANK_B;
		if (GC.life == GC.beginningLife)rank = RANK_Bp;
		
	}else if (ComboPercentage >= 60 && ComboPercentage < 85) {
		rank = RANK_A;
		if (GC.life == GC.beginningLife)rank = RANK_Ap;
		
	}else if (ComboPercentage >= 85 && ComboPercentage < 90) {
		rank = RANK_S;
		//if (GC.life == GC.beginningLife)rank = RANK_Sp;
		
	}else if (ComboPercentage >= 90 && ComboPercentage < 98) {
		rank = RANK_SS;
		//if (GC.life == GC.beginningLife)rank = RANK_SSp;
		
	}else if (ComboPercentage >= 98) {
		rank = RANK_SSS;
		//if (GC.life == GC.beginningLife)rank = RANK_SSSp;	
	}
    
	NSLog(@"Combo skill percentage:%f RankCode :%d",ComboPercentage,rank);
	GC.rank = rank;
	
	//float scoreRatio = (float)(GC.normalScore*0.0001f) / (GC.totalScore*0.0001f); 
	just_gettingExp = ((GC.maxCombo*((missionOverClearBonusMultiplier > 1)? missionOverClearBonusMultiplier:1))+(GC.totalCombo*((missionClearBonusMultiplier > 1)? missionClearBonusMultiplier:1)))*GC.level*GC.stageCode;
    //(GC.normalScore + GC.overClearScore + missionClearScore + missionOverClearScore) + ((PM.GPMode == PLAYMODE_INFINITE)? (GC.totalCombo * GC.maxCombo)*scoreRatio:(GC.totalCombo * GC.maxCombo));
	just_havingExp = GC.havingExp;
	//just_maxExp = 2342342;//[GC getMaxExp:GC.level];
	just_level = GC.level;
	NSLog(@"init just_maxExp:%llu",[GC getMaxExp:GC.level]);
	
	//Finalize result values initialized
	addScoreAtlas = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@".%llu",0] charMapFile:@"numbers19.png" itemWidth:19 itemHeight:24 startCharMap:'.'];
	addScoreAtlas.anchorPoint = ccp(0.5f,0.5f);
	addScoreAtlas.position = ccp(480+addScoreAtlas.contentSize.width/2,160);
	addScoreAtlas.opacity = 0;
	scoreAtlasTp = ccp(240,160);
	[finalLayer addChild:addScoreAtlas];
	
	//Step2 initialize
	if (ClearedMissionCode != -1) {
//		NSDictionary * dic = [[PM missionDic] valueForKey:[NSString stringWithFormat:@"%d",ClearedMissionCode]];
//		NSArray * keys = [dic allKeys];
//		NSString * value;
//		for (int i = 0; i < [keys count]; i++) {
//			if ([(NSString*)[keys objectAtIndex:i] isEqualToString:@"Overclear"] == NO && NO == [(NSString*)[keys objectAtIndex:i] isEqualToString:@"Clear"]) {
//				value = [dic valueForKey:[keys objectAtIndex:i]]; //오버클리어도 아니고 클리어도 아닌 키의 값
//			}
//		}
		
		
		clearedMissionCard = [[[MissionCard alloc] initWithCode:ClearedMissionCode missionDic:PM.missionDic] autorelease];
		clearedMissionCard.anchorPoint = ccp(0.5f,0.5f);
		clearedMissionCard.position = ccp(480+clearedMissionCard.contentSize.width/2,160);
		[finalLayer addChild:clearedMissionCard];
		[addScoreAtlas setString:[NSString stringWithFormat:@".%llu",missionClearScore]];
		
		
		
		//NSLog(@"+%llu",missionClearScore);
		
		if (OverClearedMissionCode != -1) {
//			NSDictionary * dic = [[PM missionDic] valueForKey:[NSString stringWithFormat:@"%d",OverClearedMissionCode]];
//			NSArray * keys = [dic allKeys];
//			NSString * value;
//			for (int i = 0; i < [keys count]; i++) {
//				if ([(NSString*)[keys objectAtIndex:i] isEqualToString:@"Overclear"] == NO && NO == [(NSString*)[keys objectAtIndex:i] isEqualToString:@"Clear"]) {
//					value = [dic valueForKey:[keys objectAtIndex:i]]; //오버클리어도 아니고 클리어도 아닌 키의 값
//				}
//			}
			
			overClearedMissionCard = [[[MissionCard alloc] initWithCode:OverClearedMissionCode missionDic:PM.missionDic] autorelease];
			overClearedMissionCard.anchorPoint = ccp(0.5f,0.5f);
			overClearedMissionCard.position = ccp(480+overClearedMissionCard.contentSize.width/2,160);
			[finalLayer addChild:overClearedMissionCard];
		}
	}
	
	totalCombo = [CCSprite spriteWithFile:@"text_totalCombo.png"];
	totalCombo.position = ccp(480+totalCombo.contentSize.width/2,160);
	highCombo = [CCSprite spriteWithFile:@"text_HighCombo.png"];
	highCombo.position = ccp(480+highCombo.contentSize.width/2,160);
	
	totalComboLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d",GC.totalCombo] charMapFile:@"numbers19Red.png" itemWidth:19 itemHeight:24 startCharMap:'.'];
	totalComboLabel.position = ccp(480 + totalComboLabel.contentSize.width/2,160);
	highComboLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d",GC.maxCombo] charMapFile:@"numbers19Red.png" itemWidth:19 itemHeight:24 startCharMap:'.'];
	highComboLabel.position = ccp(480 + highComboLabel.contentSize.width/2,160);
	
	totalCombo.anchorPoint = highCombo.anchorPoint = totalComboLabel.anchorPoint = highComboLabel.anchorPoint = ccp(0.0f,0.5f);
	totalRectWidth = totalCombo.contentSize.width + highCombo.contentSize.width +20+ totalComboLabel.contentSize.width + highComboLabel.contentSize.width;
	
	totalComboXt = 240 - totalRectWidth/2;
	totalComboLabelXt = totalComboXt + totalCombo.contentSize.width;
	highComboXt = 20 + totalComboLabelXt + totalComboLabel.contentSize.width;
	highComboLabelXt = highComboXt + highCombo.contentSize.width;
	
	[finalLayer addChild:totalCombo];
	[finalLayer addChild:totalComboLabel];
	[finalLayer addChild:highCombo];
	[finalLayer addChild:highComboLabel];
	
	if (GC.totalCombo > GC.highTotalCombo) {
		NSLog(@"totalCombo NewRecord");
		newRecord1 = [CCSprite spriteWithFile:@"text_newRecord.png"];
		newRecord1.anchorPoint = ccp(0.5f,0.5f);
		newRecord1.position = ccp(totalComboXt + totalCombo.contentSize.width,140);
		[finalLayer addChild:newRecord1];
		newRecord1_deleOpacity = 0;
		newRecord1.opacity = newRecord1_deleOpacity;
		
		newRecord1_opacityT = 255;
		shine_newRecord1 = YES;
	}
	if (GC.maxCombo > GC.highCombo) {
		newRecord2 = [CCSprite spriteWithFile:@"text_newRecord.png"];
		newRecord2.anchorPoint = ccp(0.5f,0.5f);
		newRecord2.position = ccp(highComboXt + highCombo.contentSize.width,140);
		newRecord2_deleOpacity = 0;
		newRecord2.opacity = newRecord2_deleOpacity;
		[finalLayer addChild:newRecord2];
		
		newRecord2_opacityT = 255;
		shine_newRecord2 = YES;
		NSLog(@"maxCombo NewRecord");
	}
	
	if (GC.totalScore > GC.highScore) {
		newRecordScore = [CCSprite spriteWithFile:@"text_newRecord.png"];
		newRecordScore.anchorPoint = ccp(0.5f,0.5f);
		newRecordScore.position = ccp(240 ,140);
		newRecordScore_deleOpacity = 0;
		newRecordScore.opacity = newRecordScore_deleOpacity;
		[finalLayer addChild:newRecordScore];
		
		newRecordScore_opacityT = 255;
		shine_newRecordScore = YES;
		NSLog(@"Score NewRecord");
	}
	
	//NSLog(@" %f %f %f %%f ",totalComboXt,totalComboLabelXt,highComboXt,highComboLabelXt);
	GetExpRect = CGRectMake(480, 0, 0, 0);
	
	Experience = [CCSprite spriteWithFile:@"text_Experience.png"];
	Experience.anchorPoint = ccp(0.5f,0.5f);
	Experience.position = ccp(480+Experience.contentSize.width/2,185);
	Experience.opacity = 0;
	
	LevelSprite = [CCSprite spriteWithFile:@"text_Level2.png"];
	LevelSprite.anchorPoint = ccp(0.5f,0.0f);
	LevelSprite.position = ccp(480+LevelSprite.contentSize.width/2,155);
	LevelSprite.opacity = 0;
	
	LevelLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d",GC.level] charMapFile:@"numbers19.png" itemWidth:19 itemHeight:24 startCharMap:'.'];
	LevelLabel.anchorPoint = ccp(0,0.0f);
	LevelLabel.position = ccp(480+LevelLabel.contentSize.width/2,155);
	LevelLabel.opacity = 0;	
	LevelLabel.scale = 0.7f;
	
	addExpLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@".%llu",just_gettingExp] charMapFile:@"numbers19.png" itemWidth:19 itemHeight:24 startCharMap:'.'];
	addExpLabel.anchorPoint = ccp(0,0.0f);
	addExpLabel.position = ccp(480+addExpLabel.contentSize.width/2,155);
	addExpLabel.opacity = 0;			   
	addExpLabel.scale = 0.7f;
	
	ExpLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%llu",GC.havingExp] charMapFile:@"numbers19.png" itemWidth:19 itemHeight:24 startCharMap:'.'];
	ExpLabel.anchorPoint = ccp(1.0f,0.5f);
	ExpLabel.position = ccp(240,140);
	ExpLabel.opacity = 0;	
	ExpLabel.scale = 0.7f;
	
	long long maxExpValue = [GC getMaxExp:GC.level];
	MaxExpLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"/%llu",maxExpValue] charMapFile:@"numbers19.png" itemWidth:19 itemHeight:24 startCharMap:'.'];
	MaxExpLabel.anchorPoint = ccp(0.0f,0.5f);
	MaxExpLabel.position = ccp(240,140);
	MaxExpLabel.opacity = 0;
	MaxExpLabel.scale = 0.7f;
	
	LevelUpSprite = [CCSprite spriteWithFile:@"text_LevelUp2.png"];
	LevelUpSprite.anchorPoint = ccp(0.5f,0.5f);
	LevelUpSprite.position = ccp(240,160);
	LevelUpSprite.scale = 30;
	LevelUpSprite.opacity = 0;
	LevelUpSprite_opacityT = 255;
	shine_LevelUpSprite = YES;
	
	/////////////
	
	havingExpSprite = [CCSprite spriteWithFile:@"Sprite_HavingExpLine.png"];
	havingExpSprite.anchorPoint = ccp(0,0.5f);
	havingExpSprite.position = ccp(0,160);
	havingExpSprite.opacity = 0;
	
	getExpSprite = [CCSprite spriteWithFile:@"Sprite_GettingExpLine.png"];
	getExpSprite.anchorPoint = ccp(0,0.5f);
	getExpSprite.position = ccp(GetExpRect.origin.x,160);
	getExpSprite.scaleX = GetExpRect.size.width;
	getExpSprite.opacity = 0;
	
	blankExpSprite = [CCSprite spriteWithFile:@"Sprite_ExpLine.png"];
	blankExpSprite.anchorPoint = ccp(1,0.5f);
	blankExpSprite.position = ccp(480,160);
	blankExpSprite.scaleX = GetExpRect.origin.x+GetExpRect.size.width;
	blankExpSprite.opacity = 0;
	
	[finalLayer addChild:havingExpSprite];
	[finalLayer addChild:getExpSprite];
	[finalLayer addChild:blankExpSprite];
	
	[finalLayer addChild:Experience];
	[finalLayer addChild:LevelSprite];
	[finalLayer addChild:LevelLabel];
	[finalLayer addChild:addExpLabel];
	[finalLayer addChild:ExpLabel];
	[finalLayer addChild:MaxExpLabel];
	[finalLayer addChild:LevelUpSprite];
	
	//Step5 initialize
	switch (rank) {
		case RANK_F:
			rankSprite = [CCSprite spriteWithFile:@"Rank_F.png"];
			break;
		case RANK_D:
			rankSprite = [CCSprite spriteWithFile:@"Rank_D.png"];
			break;
		case RANK_Dp:
			rankSprite = [CCSprite spriteWithFile:@"Rank_Dp.png"];
			break;
		case RANK_C:
			rankSprite = [CCSprite spriteWithFile:@"Rank_C.png"];
			break;
		case RANK_Cp:
			rankSprite = [CCSprite spriteWithFile:@"Rank_Cp.png"];
			break;
		case RANK_B:
			rankSprite = [CCSprite spriteWithFile:@"Rank_B.png"];
			break;
		case RANK_Bp:
			rankSprite = [CCSprite spriteWithFile:@"Rank_Bp.png"];
			break;
		case RANK_A:
			rankSprite = [CCSprite spriteWithFile:@"Rank_A.png"];
			break;
		case RANK_Ap:
			rankSprite = [CCSprite spriteWithFile:@"Rank_Ap.png"];
			break;
		case RANK_S:
			rankSprite = [CCSprite spriteWithFile:@"Rank_S.png"];
			break;
		case RANK_Sp:
			rankSprite = [CCSprite spriteWithFile:@"Rank_S.png"];
			break;
		case RANK_SS:
			rankSprite = [CCSprite spriteWithFile:@"Rank_SS.png"];
			break;
		case RANK_SSp:
			rankSprite = [CCSprite spriteWithFile:@"Rank_SS.png"];
			break;
		case RANK_SSS:
			rankSprite = [CCSprite spriteWithFile:@"Rank_SSS.png"];
			break;
		case RANK_SSSp:
			rankSprite = [CCSprite spriteWithFile:@"Rank_SSS.png"];
			break;
		default:
			break;
	}
	rankSprite.anchorPoint  = ccp(0.5f,0.5f);
	rankSprite.position = ccp(480+rankSprite.contentSize.width/2,160);
	rankSprite.opacity = 0;
    rankTargetOpacity = 255;
	[finalLayer addChild:rankSprite];
	
    
    
    //Next Stage Unlock 판별을 위해 자료준비
    SRankCount = 0;
    for (ScoreHistoryTable * t in [GC ScoreHistoryTables]){
        if (t.rank <= RANK_S) {
            SRankCount ++;
        }
    }
    if ([GC rank] <= RANK_S) { //현재의 랭크도 합쳐서 반영
        SRankCount++;
    }
    
    UnLockedNextStage = [GC unLockedNextStage]; //다음 스테이지가 언락되어 있는지 확인
    if (!UnLockedNextStage) { //열려있지 않다면
        if (GC.stageCode +1 <= 6) {
            stageThumbnail = [[[ShineEffect alloc] initWithSource:[NSString stringWithFormat:@"unlockStageThumbnails0%d.jpg",GC.stageCode+1]] autorelease];
            stageThumbnail.anchorPoint = ccp(0.5f,0.5f);
            stageThumbnail.opacity = 0;
            stageThumbnail.position = ccp(240,160);
            [stageThumbnail setShineNum:1];
            [stageThumbnail setDuration:1.5f];
            [stageThumbnail setDelay:0];
            [stageThumbnail setOpacityRange:0 Max:1];
            [stageThumbnail runningControll:SE_Suspend];
            [finalLayer addChild:stageThumbnail];
        }
        
    }
    
}

-(void)update:(ccTime)d {
	if (endFinalize) {
		return;
	}
	
	for (int c = 0; c < (GC.touchingPlayScene? 5:1); c++) {
		
		if (runfinalize) {
			updateElapsedTime += d;
			backCoverColor.opacity += (0.9f * (backCoverTopa - backCoverColor.opacity))*d*10;
			
			if (updateElapsedTime >= 0.5f) {
				if (FCode == FINALIZE_GAME_OVER) {
					[self GameOver_Finalize_Loop:d];
				}else if (FCode == FINALIZE_MISSION_CLEAR) {
					[self MissionClearFinalize_Loop:d];
					
				}
			}
			
			
		}
		
	}
	
	//탭투스크린
	if (runfinalize) {
		if (ON_Icon_Main || ON_Icon_Faster)
			tapToScreen.opacity += (0.9f * (255 - tapToScreen.opacity))*d*10;
		else
			tapToScreen.opacity += (0.9f * (0 - tapToScreen.opacity))*d*10;
		
		
		
		if (ON_Icon_Faster) {
			Icon_Faster.opacity += (0.9f * (255 - Icon_Faster.opacity))*d*10;
			if(Icon_Faster.opacity >250){
				shine_Icon_Faster = YES;
			}
				
			if(shine_Icon_Faster){
				Icon_Faster_deleOpacity += (0.9f * (Icon_Faster_opacityT - Icon_Faster_deleOpacity))*d*10;
				Icon_FasterOutLine.opacity = Icon_Faster_deleOpacity;
				if (floatMarkOut2(Icon_Faster_deleOpacity - Icon_Faster_opacityT) <= 5) {
					if (Icon_Faster_deleOpacity > 250) {
							
						Icon_Faster_opacityT = 100;
						
					}else if (Icon_Faster_deleOpacity < 105) {
						Icon_Faster_opacityT = 255;
					}
				}
			}
		}else {
			Icon_Faster.opacity += (0.9f * (0 - Icon_Faster.opacity))*d*10;
			Icon_FasterOutLine.opacity += (0.9f * (0 - Icon_FasterOutLine.opacity))*d*10;
		}
		
		if (ON_Icon_Main) {
			Icon_Main.opacity += (0.9f * (255 - Icon_Main.opacity))*d*10;
			if(Icon_Faster.opacity >250){
				shine_Icon_Faster = YES;
			}
			
			if(shine_Icon_Faster){
				Icon_Main_deleOpacity += (0.9f * (Icon_Main_opacityT - Icon_Main_deleOpacity))*d*10;
				Icon_MainOutLine.opacity = Icon_Main_deleOpacity;
				if (floatMarkOut2(Icon_Main_deleOpacity - Icon_Main_opacityT) <= 5) {
					if (Icon_Main_deleOpacity > 250) {
						
						Icon_Main_opacityT = 100;
						
					}else if (Icon_Main_deleOpacity < 105) {
						Icon_Main_opacityT = 255;
					}
				}
			}
		}else {
			Icon_Main.opacity += (0.9f * (0 - Icon_Main.opacity))*d*10;
			Icon_MainOutLine.opacity += (0.9f * (0 - Icon_MainOutLine.opacity))*d*10;
		}

	}
	
	if (ON_Icon_Main) {
		endDelay += d;
		
		if ([GC touchingPlayScene] && endDelay > 0.3f) {
			ON_endEffect = YES;
			
		}
		if (ON_endEffect) {
			endFinalize = YES;
			[[GameCondition sharedGameCondition] saveGame];
			[PM ExitPlayScene];
		}
	}
	
}

-(void)MissionClearFinalize_Loop:(ccTime)d {
	elapsedTime += d;
	
	blackDot.scaleX += (0.9f * (blackDotRect.size.width - blackDot.scaleX))*d*10;
	blackDot.scaleY += (0.9f * (blackDotRect.size.height - blackDot.scaleY))*d*10;
	blackDot.opacity += (0.9f * (blackDotTopa - blackDot.opacity))*d*15;
	
	if (startingRewarding == NO || step1End == NO) {
		if (elapsedTime >= 0.5f && elapsedTime < 0.8f) {
			s_MissionClear.position = ccp(s_MissionClear.position.x + (0.999f * (240 - s_MissionClear.position.x))*d*15,s_MissionClear.position.y);
		
		}else if (elapsedTime >= 1.0f && passStep1 == NO) {
			if (PM.GPMode != PLAYMODE_OVERCLEAR) {
				s_MissionClear.position = ccp(s_MissionClear.position.x + (0.999f * (240 - s_MissionClear.position.x))*d*15,s_MissionClear.position.y+(0.999f * (180 - s_MissionClear.position.y))*d*15);
				s_selectedBar.position = ccp(s_selectedBar.position.x + (0.9f * (s_selTp.x - s_selectedBar.position.x))*d*10,s_selectedBar.position.y);
				s_selectedBar.opacity += (0.9f * (s_selTopa - s_selectedBar.opacity))*d*10;
				s_selectedBar.scaleX += (0.9f * (s_selTscaleX - s_selectedBar.scaleX))*d*10;
			}
			if ([self addFlagAndJustUsing:@"dot_spread2"]) {
			
				blackDotRect = CGRectMake(0, 120, 480, 80);
				if (PM.GPMode != PLAYMODE_OVERCLEAR) {
					[self menuShow:YES];
				}else {
					passStep1 = YES;
					startingRewarding = YES;
				}

				ON_Icon_Faster = YES;
			}
		
		}else if (passStep1) {
			passStep1ElapsedTime += d;
			
			s_MissionClear.position = ccp(s_MissionClear.position.x + (0.999f * (-s_MissionClear.contentSize.width/2 - s_MissionClear.position.x))*d*15,s_MissionClear.position.y+(0.999f * (180 - s_MissionClear.position.y))*d*15);
			s_MissionClear.opacity += (0.9f * (0 - s_MissionClear.opacity))*d*20;
			s_selectedBar.position = ccp(s_selectedBar.position.x + (0.9f * (s_selTp.x - s_selectedBar.position.x))*d*20,s_selectedBar.position.y);
			s_selectedBar.opacity += (0.9f * (s_selTopa - s_selectedBar.opacity))*d*20;
			
			if (disappearSF) {
				blackDotTopa = 0;
				ON_Icon_Faster = NO;
				backCoverTopa = 0;
				if ( passStep1ElapsedTime >= 1.0f) {
					if (selectedRetry) {
						[PM RestartGamefromStageFinalizer];
						runfinalize = NO;
						endFinalize = YES;
					}else {
						[PM ResumeGamefromStageFinalizer];
						runfinalize = NO;
						[finalLayer removeAllChildrenWithCleanup:YES];
					}
					
				}
			}
			
			
			//s_selectedBar.scaleX += (0.9f * (s_selTscaleX - s_selectedBar.scaleX))*d*10;
			//s_selectedBar.scaleY += (0.9f * (0 - s_selectedBar.scaleY))*d*10;
			if ( passStep1ElapsedTime >= 1.0f) {
				step1End = YES;
				
//				if (selectedRetry) {
//					[PM RestartGamefromStageFinalizer];
//					runfinalize = NO;
//				}else {
//					[PM ResumeGamefromStageFinalizer];
//					runfinalize = NO;
//				}

			}
		}
		
	}else {
		[self Finalize_Rewarding_Loop:d];
	}

}
-(void)GameOver_Finalize_Loop:(ccTime)d {
	elapsedTime += d;
	blackDot.scaleX += (0.9f * (blackDotRect.size.width - blackDot.scaleX))*d*10;
	blackDot.scaleY += (0.9f * (blackDotRect.size.height - blackDot.scaleY))*d*10;
	blackDot.opacity += (0.9f * (blackDotTopa - blackDot.opacity))*d*15;
	
	if (elapsedTime >= 0.5f && elapsedTime < 0.8f) {
		s_GameOver.position = ccp(s_GameOver.position.x + (0.999f * (240 - s_GameOver.position.x))*d*15,s_GameOver.position.y);
		
	}else if (elapsedTime >= 1.0f && elapsedTime < 1.7f/*passStep1 == NO*/) {
		s_GameOver.position = ccp(s_GameOver.position.x + (0.999f * ((480 + s_GameOver.contentSize.width/2) - s_GameOver.position.x))*d*15,s_GameOver.position.y);
				
		if ([self addFlagAndJustUsing:@"dot_spread2"]) {
			
			blackDotRect = CGRectMake(0, 120, 480, 80);
			ON_Icon_Faster = YES;
		}
	}else if ( elapsedTime >= 1.7f) {
		[self Finalize_Rewarding_Loop:d];
	}
}


-(void)Finalize_Rewarding_Loop:(ccTime)d {
	RewardingT += d;
	//NSLog(@"Rewarding");
	if (ClearedMissionCode != -1 && [self isKeyinFlags:@"MissionBriefingEnd"] == NO) {
		if ([self addFlagAndJustUsing:@"clearMissionAni"]) {
			blackDotTopa = 170;
			blackDotRect = CGRectMake(0, 160, 480, 80);
		}
		
		if ([self isKeyinFlags:@"ClearMissionBriefingEnd"] == NO) {
			if (RewardingT < 1.3f) {//1
				clearedMissionCard.position = ccp(clearedMissionCard.position.x + (0.9f * (240 - clearedMissionCard.position.x))*d*10,160);
				
			}else if (RewardingT >= 1.3f && [self isKeyinFlags:@"ClearMissionBriefingEnd"] == NO) {
			
				if (RewardingT >= 2.6f) {//3
					addScoreAtlas.position = ccp(addScoreAtlas.position.x + (0.9f * ((-addScoreAtlas.contentSize.width/2) - addScoreAtlas.position.x))*d*10,addScoreAtlas.position.y);
					addScoreAtlas.opacity += (0.9f * (0 - addScoreAtlas.opacity))*d*10;
					if (RewardingT >= 3.0f) {//4 End
						[self addFlagAndJustUsing:@"ClearMissionBriefingEnd"];
						if (OverClearedMissionCode != -1) { //5 다음 대상 초기화
							[addScoreAtlas setString:[NSString stringWithFormat:@".%llu",missionOverClearScore]];
							addScoreAtlas.position = ccp(480+addScoreAtlas.contentSize.width/2,160);
							addScoreAtlas.opacity = 0;
							scoreAtlasTp = ccp(240,160);
							RewardingT = 0;
						}
						NSLog(@"Next Briefing");
					}
				}else {//2
					clearedMissionCard.position = ccp(clearedMissionCard.position.x + (0.9f * ((-clearedMissionCard.contentSize.width/2) - clearedMissionCard.position.x))*d*10,160);
					addScoreAtlas.position = ccp(addScoreAtlas.position.x + (0.9f * (scoreAtlasTp.x - addScoreAtlas.position.x))*d*10,addScoreAtlas.position.y);
					addScoreAtlas.opacity += (0.9f * (255 - addScoreAtlas.opacity))*d*10;
				}
			}
		}
		
		if (OverClearedMissionCode != -1 && [self isKeyinFlags:@"ClearMissionBriefingEnd"] == YES) { // OverClear Briefing
			NSLog(@"Next OverClearedMission Briefing");
			
			if (RewardingT < 1.3f) {//1
				overClearedMissionCard.position = ccp(overClearedMissionCard.position.x + (0.9f * (240 - overClearedMissionCard.position.x))*d*10,160);
				
			}else if (RewardingT >= 1.3f && [self isKeyinFlags:@"OverClearMissionBriefingEnd"] == NO) {
				
				if (RewardingT >= 2.6f) {//3
					addScoreAtlas.position = ccp(addScoreAtlas.position.x + (0.9f * ((-addScoreAtlas.contentSize.width/2) - addScoreAtlas.position.x))*d*10,addScoreAtlas.position.y);
					addScoreAtlas.opacity += (0.9f * (0 - addScoreAtlas.opacity))*d*10;
					if (RewardingT >= 3.0f) {//4 End
						

						[self addFlagAndJustUsing:@"MissionBriefingEnd"];
						RewardingT = 0;
						NSLog(@"BreifEnd");
					}
				}else {//2
					overClearedMissionCard.position = ccp(overClearedMissionCard.position.x + (0.9f * ((-overClearedMissionCard.contentSize.width/2) - overClearedMissionCard.position.x))*d*10,160);
					addScoreAtlas.position = ccp(addScoreAtlas.position.x + (0.9f * (scoreAtlasTp.x - addScoreAtlas.position.x))*d*10,addScoreAtlas.position.y);
					addScoreAtlas.opacity += (0.9f * (255 - addScoreAtlas.opacity))*d*10;
				}
			
			
			}
			
		}else if( [self isKeyinFlags:@"ClearMissionBriefingEnd"] == YES && OverClearedMissionCode == -1) { //노멀미션브리핑은 끝났는데 오버클리어가 아니면
			//NSLog(@")
			[self addFlagAndJustUsing:@"MissionBriefingEnd"];
			RewardingT = 0;
		}

	} else {
		if ([self addFlagAndJustUsing:@"MissionBriefingEnd"]) { //클리어 미션이 없을때
			RewardingT = 0;
			NSLog(@"MissionBriefingEnd");
		}
		
	}
	
	//초기화된 RewardingTime 과 함꼐 콤보부터 브리핑 시작
	//start since Combo
	// RewardingT = 0
	if ([self isKeyinFlags:@"MissionBriefingEnd"]) {
		//NSLog(@"Combo");
		
		if ( [ self isKeyinFlags:@"ComboBreifFinalEnd"] == NO) {
			
	
			totalCombo.position = ccp(totalCombo.position.x + (0.9f * (totalComboXt - totalCombo.position.x))*d*10,160);
			if (RewardingT > 0.1f) {
				totalComboLabel.position = ccp(totalComboLabel.position.x + (0.9f * (totalComboLabelXt - totalComboLabel.position.x))*d*10,160);
				
				if (RewardingT > 0.3f) {
					highCombo.position = ccp(highCombo.position.x + (0.9f * (highComboXt - highCombo.position.x))*d*10,160);
					
					if (RewardingT > 0.35f) {
						highComboLabel.position = ccp(highComboLabel.position.x + (0.9f * (highComboLabelXt - highComboLabel.position.x))*d*10,160);
						
						if (newRecord1 != nil) {
							newRecord1_deleOpacity += (0.9f * (newRecord1_opacityT - newRecord1_deleOpacity))*d*10;
							newRecord1.opacity = newRecord1_deleOpacity;
							
							if (RewardingT < 2.4f) {
							
								if (floatMarkOut2(newRecord1_deleOpacity - newRecord1_opacityT) <= 5) {
									if (newRecord1_deleOpacity > 250) {
								
										newRecord1_opacityT = 100;
										//printf("100 GO");
									}else if (newRecord1_deleOpacity < 105) {
									newRecord1_opacityT = 255;
											//printf("255 GO");
									}
								}
							}else {
								newRecord1_opacityT = 0;
							}
							
						}
						
						if (newRecord2 != nil && RewardingT > 0.37f) {
							newRecord2_deleOpacity += (0.9f * (newRecord2_opacityT - newRecord2_deleOpacity))*d*10;
							newRecord2.opacity = newRecord2_deleOpacity;
							
							if (RewardingT < 2.42f) {
								
								if (floatMarkOut2(newRecord2_deleOpacity - newRecord2_opacityT) <= 5) {
									if (newRecord2_deleOpacity > 250) {
										
										newRecord2_opacityT = 100;
										//printf("100 GO");
									}else if (newRecord2_deleOpacity < 105) {
										newRecord2_opacityT = 255;
										//printf("255 GO");
									}
								}
							}else {
								newRecord2_opacityT = 0;
							}
							
						}
						
						if (RewardingT > 2.3f) {
							totalComboXt = -totalCombo.contentSize.width*2.5;
							if (RewardingT > 2.35f) {
								totalComboLabelXt = - totalCombo.contentSize.width*2;
								if (RewardingT > 2.45f) {
									highComboXt = - highCombo.contentSize.width*1.5;
									if (RewardingT > 2.5f) {
										highComboLabelXt = - highComboLabel.contentSize.width;
										if (RewardingT > 2.8f) {	
											if ([self addFlagAndJustUsing:@"ComboBirefFianl"] ) { //다음나올 객체설정 한번만 실행되는구문
												[addScoreAtlas setString:[NSString stringWithFormat:@".%llu",comboScore]];
												addScoreAtlas.opacity = 0;
												addScoreAtlas.position = ccp(480+addScoreAtlas.contentSize.width/2,160);
												scoreAtlasTp = ccp(240,160);
												scoreAtlasOpacityT = 255;
											}
											addScoreAtlas.position = ccp(addScoreAtlas.position.x + (0.9f * (scoreAtlasTp.x - addScoreAtlas.position.x))*d*10,160);
											addScoreAtlas.opacity += (0.9f * (scoreAtlasOpacityT - addScoreAtlas.opacity)) * d * 10;
										
											if (RewardingT > 4.5f) {
												scoreAtlasTp = ccp(-addScoreAtlas.contentSize.width/2,160);
												scoreAtlasOpacityT = 0;
												if (RewardingT > 4.7f) {
													[self addFlagAndJustUsing:@"ComboBreifFinalEnd"];
													
													RewardingT = 0; //시간초기화
													[addScoreAtlas setString:[NSString stringWithFormat:@"%llu",totalScore]];
													addScoreAtlas.position = ccp(480+addScoreAtlas.contentSize.width/2,160);
													addScoreAtlas.opacity = 0;
													scoreAtlasTp = ccp(240,160);
													scoreAtlasOpacityT = 255;
												}
											}
										}
									} 
								}
								
								
							}
						}
					}
				}
				
				
			}
		}//콤보 브리핑 끝
		//
		
		//토탈스코어 + 경험 브리핑 시작
		if ([self isKeyinFlags:@"ComboBreifFinalEnd"]) {
			if (RewardingT <= 1.0f) {
				addScoreAtlas.position = ccp(addScoreAtlas.position.x + (0.9f * (scoreAtlasTp.x - addScoreAtlas.position.x))*d*10,160);
				addScoreAtlas.opacity += (0.9f * (scoreAtlasOpacityT - addScoreAtlas.opacity))*d*10;
				
				
			}else if (RewardingT > 1.9f) {
				if ([self addFlagAndJustUsing:@"totalScoreBreifEnd"]) {
					scoreAtlasTp = ccp(-addScoreAtlas.contentSize.width/2,160);
					scoreAtlasOpacityT = 0;
				}
				
				addScoreAtlas.position = ccp(addScoreAtlas.position.x + (0.9f * (scoreAtlasTp.x - addScoreAtlas.position.x))*d*10,160);
				addScoreAtlas.opacity += (0.9f * (scoreAtlasOpacityT - addScoreAtlas.opacity))*d*10;
				if (RewardingT >= 1.7f) {
					blackDotRect = CGRectMake(0, 160, 0, 80);
					blackDotTopa = 0;
				}
				
				
			}
			
			if (newRecordScore != nil && RewardingT > 0.1f) {
				newRecordScore_deleOpacity += (0.9f * (newRecordScore_opacityT - newRecordScore_deleOpacity))*d*10;
				newRecordScore.opacity = newRecordScore_deleOpacity;
				
				if (RewardingT < 1.82f) {
					
					if (floatMarkOut2(newRecordScore_deleOpacity - newRecordScore_opacityT) <= 5) {
						if (newRecordScore_deleOpacity > 250) {
							
							newRecordScore_opacityT = 100;
							//printf("100 GO");
						}else if (newRecord1_deleOpacity < 105) {
							newRecordScore_opacityT = 255;
							//printf("255 GO");
						}
					}
				}else {
					newRecordScore_opacityT = 0;
				}
				
			}
			
			if (RewardingT >= 2.2f && !experienceSuccess) {//경험치 모션
				if (RewardingT >= 2.2f && RewardingT < 2.6f ) {
					GetExpRect.origin = ccp(GetExpRect.origin.x + (0.9f * (0 - GetExpRect.origin.x))*d*10,160); // 원점으로 초기화 모션
					
					Experience.position = ccp(Experience.position.x + (0.9f * (240 - Experience.position.x))*d*10,Experience.position.y);
					Experience.opacity += (0.9f * (255 - Experience.opacity))*d*10;
					
					LevelSprite.position = ccp(LevelSprite.position.x + (0.9f * (190 - LevelSprite.position.x))*d*10,LevelSprite.position.y);
					LevelSprite.opacity += (0.9f * (255 - LevelSprite.opacity))*d*10;
					
					LevelLabel.position = ccp(LevelLabel.position.x + (0.9f * ((195+LevelSprite.contentSize.width/2) - LevelLabel.position.x))*d*10,LevelLabel.position.y);
					LevelLabel.opacity += (0.9f * (255 - LevelLabel.opacity))*d*10;
					
					addExpLabel.position = ccp(addExpLabel.position.x + (0.9f * (260 - addExpLabel.position.x))*d*10,addExpLabel.position.y);
					addExpLabel.opacity += (0.9f * (255 - addExpLabel.opacity))*d*10;
					
				}else if (RewardingT >= 2.8f) {
					ExpLabel.opacity += (0.9f * (255 - ExpLabel.opacity))*d*5;
					MaxExpLabel.opacity += (0.9f * (255 - MaxExpLabel.opacity))*d*5;
					
					if (cycleExpAniEnd == NO){
						float tx = (just_havingExp*0.00001f)/([GC getMaxExp:GC.level]*0.00001f) * 480.0f;
						float tw;
						
						if (just_havingExp + just_gettingExp < [GC getMaxExp:GC.level]) {
							tw = (just_gettingExp*0.00001f)/([GC getMaxExp:GC.level]*0.00001f) * 480.0f;
							just_havingExp += just_gettingExp;
							just_gettingExp = 0;
							
							ExpLabelValue = 0;
							CurrentTargetExpValue = just_havingExp;
							
						}else {
							long long usingExp = [GC getMaxExp:GC.level] - just_havingExp;
						
							long long remainGetExp = just_gettingExp - usingExp;
							just_gettingExp = remainGetExp;
						
							tw = (usingExp*0.00001f)/([GC getMaxExp:GC.level]*0.00001f) * 480.0f;
						
							just_havingExp = 0;
							ExpLabelValue = 0;
							CurrentTargetExpValue = [GC getMaxExp:GC.level];
							
							[GC LevelUp];
							
						}
						GetExpRectXt = tx;
						GetExpRectWt = tw;
						cycleExpAniEnd = YES;
						//[self addFlagAndJustUsing:@"ExperienceProgressing"];
						
					}
					
					
					
					//경험치증가 애니메이션
					ExpLabelValue += (0.9f * (CurrentTargetExpValue - ExpLabelValue))*d*10;
					[ExpLabel setString:[NSString stringWithFormat:@"%llu",ExpLabelValue]];
					if (CurrentTargetExpValue - ExpLabelValue < 5) {
						[ExpLabel setString:[NSString stringWithFormat:@"%llu",CurrentTargetExpValue]];
					}
					
					//경험치바 애니메이션
					GetExpRect = CGRectMake(GetExpRect.origin.x + (0.9f * (GetExpRectXt - GetExpRect.origin.x))*d*((1-(GetExpRectXt/480)) * 3 + 3)
											,160
											,GetExpRect.size.width
											,0);
					if (RewardingT >= 3.3f) {
						GetExpRect = CGRectMake(GetExpRect.origin.x
												,160
												,GetExpRect.size.width + (0.9f * (GetExpRectWt - GetExpRect.size.width))*d*((1-(GetExpRectWt/480)) * 3 + 3)
												,0);
					}
					
					
					if (floatMarkOut2(GetExpRect.size.width - GetExpRectWt) <= 1 && floatMarkOut2(GetExpRect.origin.x - GetExpRectXt) <= 1) {
						GetExpRect = CGRectMake(GetExpRectXt,160,GetExpRectWt,0);
						if (just_gettingExp > 0) { //남은 경험치가 있으면
							//[flags removeObjectForKey:[flags valueForKey:@"ExperienceProgressing"]];
							cycleExpAniEnd = NO;
							GetExpRect = CGRectMake(0, 0, 0, 0);
							
							//경험치바 모션 1사이클 완료시에 레벨업 디스플레이 업데이트
							long long maxExpValue = [GC getMaxExp:GC.level];
							[MaxExpLabel setString:[NSString stringWithFormat:@"/%llu",maxExpValue]];
							CurrentTargetExpValue = just_havingExp;
							[LevelLabel setString:[NSString stringWithFormat:@"%d",GC.level]];
							
							LevelUpDisplay = YES;
							LevelUpSprite.anchorPoint = ccp(0.5f,0.5f);
							LevelUpSprite.position = ccp(240,160);
							LevelUpSprite.scale = 30;
							LevelUpSprite.opacity = 0;
							
						}else { //남은 경험치가 없으면
							GC.havingExp = just_havingExp;
							experienceSuccess = YES;
							experienceSuccessedDelay = 0;
							NSLog(@"experienceSuccess!!");
						}

					}
				}

				//
				havingExpSprite.opacity += (0.9f * (170 - havingExpSprite.opacity))*d*10;
				getExpSprite.opacity += (0.9f * (210 - getExpSprite.opacity))*d*10;
				blankExpSprite.opacity += (0.9f * (170 - blankExpSprite.opacity))*d*10;
				
				havingExpSprite.scaleX = GetExpRect.origin.x;
				getExpSprite.position = ccp(GetExpRect.origin.x,160);
				getExpSprite.scaleX = GetExpRect.size.width;
				blankExpSprite.scaleX = 480-(GetExpRect.size.width+GetExpRect.origin.x);
			}
			
			if (LevelUpDisplay) { //경험치증가모션이 끝나도 레벨업표시는 반짝거리기 위해서 경험치 블록에서 뺴왓음
				LevelUpSprite.position = ccp(LevelUpSprite.position.x + (0.9f * ((LevelSprite.position.x-LevelSprite.contentSize.width/2 - LevelUpSprite.contentSize.width/2) - LevelUpSprite.position.x))*d*20,
											 LevelUpSprite.position.y + (0.9f * ((LevelSprite.position.y + LevelSprite.contentSize.height/2) - LevelUpSprite.position.y))*d*20);
				LevelUpSprite.scale += (0.9f * (1 - LevelUpSprite.scale))*d*20;
				
				if (LevelUpSprite.scale < 1.1f) {
					
					LevelUpSprite_deleOpacity += (0.9f * (LevelUpSprite_opacityT - LevelUpSprite_deleOpacity))*d*10;
					LevelUpSprite.opacity = LevelUpSprite_deleOpacity;
					
					if (floatMarkOut2(LevelUpSprite_deleOpacity - LevelUpSprite_opacityT) <= 5) {
						if (LevelUpSprite_deleOpacity > 250) {
							
							LevelUpSprite_opacityT = 100;
							
						}else if (LevelUpSprite_deleOpacity < 105) {
							LevelUpSprite_opacityT = 255;
							
						}
					}
					
				}else {
					LevelUpSprite.opacity += (0.9f * (255 - LevelUpSprite.opacity))*d*10;
				}
				
			}
			if (experienceSuccess) {
				experienceSuccessedDelay += d;
				if (experienceSuccessedDelay > 2.0f) {
					LevelUpDisplay = NO;
					
					GetExpRect = CGRectMake(GetExpRect.origin.x + (0.9f * (0 - GetExpRect.origin.x))*d*((1-(GetExpRectXt/480)) * 10 + 3)
											,160
											,GetExpRect.size.width
											,0);
					if (experienceSuccessedDelay >= 2.3f) {
						GetExpRect = CGRectMake(GetExpRect.origin.x
												,160
												,GetExpRect.size.width + (0.9f * (0 - GetExpRect.size.width))*d*((1-(GetExpRectWt/480)) * 10 + 3)
												,0);
						
					}
					havingExpSprite.opacity += (0.9f * (170 - havingExpSprite.opacity))*d*10;
					getExpSprite.opacity += (0.9f * (210 - getExpSprite.opacity))*d*10;
					blankExpSprite.opacity += (0.9f * (170 - blankExpSprite.opacity))*d*10;
					
					havingExpSprite.scaleX = GetExpRect.origin.x;
					getExpSprite.position = ccp(GetExpRect.origin.x,160);
					getExpSprite.scaleX = GetExpRect.size.width;
					blankExpSprite.scaleX = 480-(GetExpRect.size.width+GetExpRect.origin.x);
					
					Experience.opacity += (0.9f * (0 - Experience.opacity))*d*10;
					LevelSprite.opacity += (0.9f * (0 - LevelSprite.opacity))*d*10;
					LevelLabel.opacity += (0.9f * (0 - LevelLabel.opacity))*d*10;
					addExpLabel.opacity += (0.9f * (0 - addExpLabel.opacity))*d*10;
					LevelUpSprite.opacity += (0.9f * (0 - LevelUpSprite.opacity))*d*10;
					ExpLabel.opacity += (0.9f * (0 - ExpLabel.opacity))*d*5;
					MaxExpLabel.opacity += (0.9f * (0 - MaxExpLabel.opacity))*d*5;
					
					if (experienceSuccessedDelay > 2.5) {
						//blankExpSprite.scaleX += (.9f - (0 - blankExpSprite.scaleX))*d*5;
						//blankExpSprite.position = ccp(blankExpSprite.position.x + (0.9f * (0 - blankExpSprite.position.x))*d*5,blankExpSprite.position.y);
						rankSprite.position = ccp(rankSprite.position.x + (0.9f * (240 - rankSprite.position.x))*d*10,160);
						rankSprite.opacity += (0.9f * (rankTargetOpacity - rankSprite.opacity))*d*10;
						
                        //NSLog(@"SRankCount:%d >= 5 GC.level:%d >= GC.stageMaxLevel:%d if Ture then unlockStage:%d",SRankCount,GC.level,GC.stageMaxLevel,GC.stageCode+1);
						ON_Icon_Faster = NO;
                        
                        if (experienceSuccessedDelay > 4) {
                            if (SRankCount >= D_UnLockRankCountNum && GC.level >= GC.stageMaxLevel && UnLockedNextStage == NO) {
                                
                                [GC nextStageUnLock]; //스테이지 언락을 예약해서 마지막 데이터 저장시점에서 새로운스테이지 슬롯을 만들도록 예약
                                
                                
                                if (aniTransfered == NO) {
                                    
                                    [stageThumbnail runningControll:SE_Running];
                                    rankTargetOpacity = 0;
                                    aniTransfered = YES;
                                }
                                [stageThumbnail update:d];
                                [stageThumbnail setOpacityRange:0.5f Max:1];
                                if (experienceSuccessedDelay > 6.0f) {
                                    ON_Icon_Main = YES;
                                }
                                
                                //스테이지 언락애니메이션 후 ON_ICON_Main 켜기
                                
                                
                            }else if (experienceSuccessedDelay > 4.0f) {
                                ON_Icon_Main = YES;
                            }
                        }
                        
						
					}
				}
			}
			
			
		}
	}
	
	//NSLog(@"StageMaxLevel:%d currentLevel:%d",[GC stageMaxLevel],[GC level]);
	
}

-(void)finalizeButtonCallback:(id)sender{
	CCMenuItemImage * sd = sender;
	s_selTp = ccp([sd position].x + menu.position.x,s_selectedBar.position.y);
	s_selTopa = 255;
	s_selTscaleX = sd.contentSize.width / s_selectedBar.contentSize.width;
	
	if (selectedTag != [sender tag]) {
		selectedTag = [sender tag];
	}else {
		switch ([sender tag]) {
			case 0:
				NSLog(@"Rewarding");
				
				blackDotTopa = 0;
				blackDotRect = CGRectMake(0, 160, 480, 0);
				s_selTopa = 0;
				passStep1 = YES;
				startingRewarding = YES;
				
				[self menuShow:NO];
				break;
			case 1:
				blackDotTopa = 0;
				blackDotRect = CGRectMake(0, 160, 480, 0);
				s_selTopa = 0;
				passStep1 = YES;
				disappearSF = YES;
				NSLog(@"OverClear");
				PM.GPMode = PLAYMODE_OVERCLEAR;
				//[PM ResumeGamefromStageFinalizer];
				[PM packingStage];
				[self menuShow:NO];
				break;
			case 2:
				blackDotTopa = 0;
				blackDotRect = CGRectMake(0, 160, 480, 0);
				s_selTopa = 0;
				passStep1 = YES;
				disappearSF = YES;
				PM.GPMode = PLAYMODE_INFINITE;
				//[PM ResumeGamefromStageFinalizer];
				NSLog(@"Infinite");
				[PM packingStage];
				[self menuShow:NO];
				break;
			case 3:
				blackDotTopa = 0;
				blackDotRect = CGRectMake(0, 160, 480, 0);
				s_selTopa = 0;
				passStep1 = YES;
				disappearSF = YES;
				selectedRetry = YES;
                [PM RestartGamefromStageFinalizer];
				NSLog(@"Retry");
				//게임재시작구현
				[self menuShow:NO];
				break;
			default:
				break;
		}
	}

}


-(BOOL)addFlagAndJustUsing:(NSString*)key_ { //루프 내에서 일회성으로 사용할 명령블럭에 이프를 이용해서 사용함
	if (![self isKeyinFlags:key_]) { //키가 없다면 만든다
		NSNumber * spread2Dot = [NSNumber numberWithBool:YES];
		[flags setObject:spread2Dot forKey:key_];
		
		return YES;
	}else { //키가 존재한다면 한번 사용된 플래그이므로 노 를 리턴하여 이프를통해 일회성 구문을 구현
		return NO;
	}

}

-(BOOL)isKeyinFlags:(NSString*)key_ {
	NSArray * keys = [flags allKeys];
	for (NSString * s in keys){
		if ([s isEqualToString:key_]) {
			return YES;
		}
	}
	return NO;
}



-(void)resumeGame{
	//runfinalize = NO;
	//[PM ResumeGamefromStageFinalizer];
}

-(void)menuShow:(BOOL)flag_ {
	b_retry.visible = flag_;
	[b_retry setIsEnabled:flag_];
	
	b_infinite.visible = flag_;
	[b_infinite setIsEnabled:flag_];
	
	b_rewarding.visible = flag_;
	[b_rewarding setIsEnabled:flag_];
	
	b_overClear.visible = flag_;
	[b_overClear setIsEnabled:flag_];
	
	s_moreChallenge.visible = flag_;
}

-(void)dealloc {
	
	[flags removeAllObjects];
	[flags release];
	
	
	
	
	//[CoverLayer removeChild:finalLayer cleanup:YES];
	
	[super dealloc];
	NSLog(@"StageFinalizer Dealloc");
}
@end
