//
//  ProgressManager.m
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 10..
//  Copyright 2011 Student. All rights reserved.
//

#import "ProgressManager.h"

#import "GameHeaders.h"

#import "PlayScene.h"
#import "GameMainScene.h"
#import "NodeTweener.h"
#import "ComboParty.h"
#import "FinalRelayDisplayController.h"
#import "TutorialManager.h"
#import "StageFinalizer.h"
#import "MissionCard.h"
#import "SoundManager.h"

@interface ProgressManager (privateMethods)

-(void)Main_ani_loop:(ccTime)delta;
-(void)Game_PLAY_loop:(ccTime)delta;
-(long long)scoreCalcurator;
-(void)comboCounter:(BOOL)pass;
-(void)passShape;
-(void)passingShape:(int)code_;
-(void)standByCounter:(ccTime)dt;
-(void)resetCounter;
-(void)pauseCallBack:(id)sender;
-(void)resumeCallBack:(id)sender;
-(void)optionCallBack:(id)sender;
-(void)mainCallBack:(id)sender;
-(void)pushMissionCode:(MissionList)code;
-(void)eventObserver:(ccTime)d;
-(void)Tutorial_Run;
-(void)tutorialDelete:(id)sender;
@end
 
@implementation ProgressManager

@synthesize otherAnimationObject;
@synthesize totalFieldWays;
@synthesize behindFieldWays;
@synthesize frontFieldWays;
@synthesize PerfromNormaltoFinalRelay;
@synthesize PerfromFinalRelaytoMaxFinalRelay;
@synthesize GPMode;
@synthesize ClearedMissionCode;
@synthesize OverClearedMissionCode;
@synthesize missionDic;
@synthesize ShapeObjects;
@synthesize standbySpace;
@synthesize passedShapesCode;
@synthesize game_state;

#define tutoCloser_tag 9999


#pragma mark -
#pragma mark === init ===
-(id)initWithLayer:(CCLayer*)fieldLayer field2:(CCLayer*)fieldLayer2 {
	if ( (self = [super init]) ){
		FieldLayer = fieldLayer;
		FieldLayer2 = fieldLayer2;
	
	
        ShapeObjects = [[NSMutableArray alloc] init];
        otherAnimationObject = [[NSMutableArray alloc] init];
	
        //통과한 유닛 저장공간
        passedShapesCode = [[NSMutableArray alloc] init];
        /*
         for ( int i = 0 ; i < 5 ; i++){
         NSNumber * order = [[NSNumber alloc] initWithInt:99];
         [passedShapesCode addObject:order];
         [order release];
         }*/
	
        willDieObjects = [[NSMutableArray alloc] init]; //곧 죽을 객체이지만 수행해야할 루프가 남아있는 객체들을 모아두는 곳
        
	
        creatingflag = TRUE;
        creatingCycle = 1;
        creatCount = 0;
        creatingPeriod = 1.5f; //초
        createdTime = 0;
        mode = MAIN_ANMATION;
        standbyCharacterCount = 0;
        
        //점프 효과음 재생 간격
        switch ([GameCondition sharedGameCondition].stageCode) {
            case STAGE_1 :
                jumpingInterval = 0.5f;
                break;
            case STAGE_2 :
                jumpingInterval = 0.45f;
                break;
            case STAGE_3 :
                jumpingInterval = 0.7f;
                break;
            case STAGE_4 :
                jumpingInterval = 0.32f;
                break;
            case STAGE_5 :
                jumpingInterval = 0.29f;
                break;
            default:
                jumpingInterval = 0.5f;
                break;
        }
        
    }
	return self;
}

-(id)initWithLayerMode:(CCLayer *)fieldLayer field2:(CCLayer *)fieldLayer2 cover:(CCLayer*)coverLayer 
	   backGroundLayer:(CCLayer *)BackGroundLayer_ mode:(PM_MODE)pmmode whoCalled:(id)who{
	
	self = [self initWithLayer:fieldLayer field2:fieldLayer2];
	caller = who;
	mode = pmmode;
	CoverLayer = coverLayer;
	BackGroundLayer = BackGroundLayer_;
	ForeGroundLayer = [(GameMain*)caller foregroundLayer];

    
    
	//게임용으로 만들어진 PM
	if (mode == GAME_PLAY) {
        GameCondition * GC = [GameCondition sharedGameCondition];
        GC.runningPM = self; //다이나믹 오브젝트가 이 매니저 클래스의 파이널릴레이 활성 백분율 값을 GC를 통해 읽기위한 통로를 확보 파이널릴레이로인한 고조된 긴장감연출을 위함 (뭔가 파이널릴레이에대한 버그가 있을땐 덮어쓰기때문일수도)
        
		GPMode = PLAYMODE_NORMAL;
		
		gameObjects_needsLoop = [[NSMutableArray alloc] init];
		
		creatingPeriod = GC.Game_default_CreatePeroid;
		
		standbySpace = [[NSMutableArray alloc] init];
		
		ClearedMissionCode = -1;
		OverClearedMissionCode = -1;
		
		//Combo Party initialize
		comboParty = [[ComboParty alloc] init];
		comboParty.anchorPoint = ccp(0.5f,0.5f);
		comboParty.position = ccp(340, 200);
		comboParty.scale = 6.0f;
		comboParty.rotation = -45;
		comboParty.opacity = 255;
		comboParty.visible = FALSE;
		
		comboPartyTweener = [[NodeTweener alloc] initWithTarget:comboParty field:CoverLayer];
		[comboPartyTweener setTweeningScale:ccp(1,1) setTime:0.2f];
		[comboPartyTweener setTweeningOpacity:0 setTime:1];
		[comboPartyTweener setTweeningRotate:0 setTime:0.2f];
		[gameObjects_needsLoop addObject:comboPartyTweener];
		[comboPartyTweener release];
		[comboParty release];
		
		
		pauseButton = [CCMenuItemImage itemFromNormalImage:@"Game_pause.png" 
														  selectedImage:@"Game_pause-d.png" 
																 target:self 
															   selector:@selector(pauseCallBack:)];
		CCMenu * menuSet = [CCMenu menuWithItems:pauseButton,nil];
		menuSet.anchorPoint = ccp(1,1);
		menuSet.position = ccp(460,300);
		[CoverLayer addChild:menuSet];
		
		//경과시간 표시
		label_time = [[[CCLabelAtlas alloc] initWithString:@"0" charMapFile:@"GameText-time11.png" itemWidth:11 itemHeight:17 startCharMap:'.'] autorelease];
		label_time.anchorPoint = ccp(0.5f,0);
		label_time.position = ccp(240,291);
		label_time.scale = 1;
        [label_time setAdjustWordBetween:-5];
		[CoverLayer addChild:label_time];

		
		
        

        
		
		CCSprite * lifeDown = [CCSprite spriteWithFile:@"Image_PlayGame_notifications_lifedown.png"];
		lifeDown.scaleX = lifeDown.scaleY = 1.5f;
		lifeDown.position = ccp(340,190);
		lifeDown.opacity = 255;
		lifeDown.visible = FALSE;
		lifeDownTweener = [[NodeTweener alloc] initWithTarget:lifeDown field:CoverLayer];
		[lifeDownTweener setTweeningPos:ccp(340,100) setTime:1];
		[lifeDownTweener setTweeningOpacity:0 setTime:1];
		[lifeDownTweener setTweeningScale:ccp(0.5f,0.5f) setTime:1];
		[gameObjects_needsLoop addObject:lifeDownTweener];
		[lifeDownTweener release];
		

		
		//FinalRelay Ready after initialized
		FRDC = [[FinalRelayDisplayController alloc] initWithLayer:BackGroundLayer coverLayer:CoverLayer];
	
        TM = nil;
        TMDied = YES;
        if ([GameCondition sharedGameCondition].stageCode == STAGE_1) {
            //TutorialAndHint Manager initialized
            TM = [[[TutorialManager alloc] initWithLayers:CoverLayer pm:self] autorelease];
            TMDied = NO;
        }
		
        
		
        
		//StageFinalizer initialized
		SF = [[StageFinalizer alloc] initWithPM:self coverLayer:CoverLayer];
		
		//packing Stage
		black = [CCSprite spriteWithFile:@"blackDot.png"];
		black.anchorPoint = ccp(0,0);
		black.position = ccp(0,0);
		black.scaleX = 480;
		black.scaleY = 320;
		black.opacity = 200;
		[CoverLayer addChild:black z:100];
		
		startRelayMessage = [CCSprite spriteWithFile:@"StartRelayMessage.png"];
		startRelayMessage.anchorPoint = ccp(0.5f,0.5f);
		startRelayMessage.position = ccp(240,160);
		[CoverLayer addChild:startRelayMessage z:101];
		
		startRelayMessage_moving = [CCSprite spriteWithFile:@"StartRelayMessage_moving.png"];
		startRelayMessage_moving.anchorPoint = ccp(0.5f,0.5f);
		startRelayMessage_moving.position = ccp(240,160);
		startRelayMessage_moving.opacity = 0;
		[CoverLayer addChild:startRelayMessage_moving z:102];
		TapToScreen = [CCSprite spriteWithFile:@"text_TapToScreen.png"];
		TapToScreen.anchorPoint = ccp(0.5f,0.5f);
		TapToScreen.position = ccp(240, 50);
		[CoverLayer addChild:TapToScreen z:103];
		
		startDelay = 0;
		gameStart = NO;
		
		
		
		game_state = GAME_PLAYING;
		
				
	}else if (mode == MAIN_ANMATION) { //메인애니메이션용으로 만들어진 PM
        flag_characterCycle = YES;
		[GameCondition sharedGameCondition].stepSpeed = [GameCondition sharedGameCondition].Any_stepSpeed;
	}
	NSLog(@"ProgressManager Initialize");
	return self;
}

-(void)init_After_GameCondition {
    //GameCondition * GC = [GameCondition sharedGameCondition];
    
	[label_life setString:[NSString stringWithFormat:@"%d",[GameCondition sharedGameCondition].life]];
	
	//<--Counter init Code
	NSMutableArray * tempArr = [[NSMutableArray alloc] init];
	maxCounting = [GameCondition sharedGameCondition].StandbyCounting;
	NSLog(@"MaxCounting:%d",maxCounting);
	for (int i = 0; i <= maxCounting; i++) {
		CCLabelAtlas * one = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%d",i] 
													  charMapFile:@"Text_sprite_numbers2.png" 
														itemWidth:15 
													   itemHeight:26 
													 startCharMap:'.'];
		one.anchorPoint = ccp(0.5f,0);
		one.opacity = 0;
		[tempArr addObject:one];
		[CoverLayer addChild:one];
		[one release];
	}
    NSLog(@"PM::init_After_GameCondition Step1");
    if ([GameCondition sharedGameCondition].stageCode == STAGE_1) { //스테이지 1일때 튜토리얼 실행
        [self Tutorial_Run];
        
        if ([GameCondition sharedGameCondition].hasLearnTutorial == YES) {
            CCMenuItem * tutoClose;
            if ([GameCondition sharedGameCondition].lang == Language_ko) {
                tutoClose = [CCMenuItemImage itemFromNormalImage:@"tutorialSkipInform_ko.png" selectedImage:@"tutorialSkipInform_ko.png" target:self selector:@selector(tutorialDelete:)];
            }else if([GameCondition sharedGameCondition].lang == Language_en){
                tutoClose = [CCMenuItemImage itemFromNormalImage:@"tutorialSkipInform_en.png" selectedImage:@"tutorialSkipInform_en.png" target:self selector:@selector(tutorialDelete:)];
            }else{
                tutoClose = [CCMenuItemImage itemFromNormalImage:@"tutorialSkipInform_en.png" selectedImage:@"tutorialSkipInform_en.png" target:self selector:@selector(tutorialDelete:)];
            }
            
            CCMenu * tutoMenu = [CCMenu menuWithItems:tutoClose, nil];
            tutoMenu.anchorPoint = ccp(0,0);
            tutoMenu.position = ccp(240,256);
            [CoverLayer addChild:tutoMenu z:tutoCloser_tag tag:tutoCloser_tag];
            
            
        }
        
    }
    NSLog(@"PM::init_After_GameCondition Step2");
	accrueScorePer = 1;
	counterNodeArr = [[NSArray alloc] initWithArray:tempArr];
	[tempArr release];
	
	//EventObserver value initaial
	missionDic = [[[GameCondition sharedGameCondition] ClearObjectsValuesAtCode] retain]; //retain
	missionCodes = [[missionDic allKeys] retain]; //retain
	missionCodeLength = [missionCodes count];
	rescuedShapeCodes = [[NSMutableArray alloc] init];
	[GameCondition sharedGameCondition].thisTimeRescueShapeCodes = rescuedShapeCodes;
    NSLog(@"PM::init_After_GameCondition Step3");
	m_5_current_comboUnitsCount = 0;
	m_5_Defer_comboUnit = NO;
	m_5_needComboUnit = 0;
	m_5_needComboUnitsCount = 0;
	
    label_level = [[[CCLabelAtlas alloc] initWithString:@"0" 
                                            charMapFile:@"GameText-score11.png" 
                                              itemWidth:11 itemHeight:17 startCharMap:'.'] autorelease];
    label_level.position = ccp(60,295);
    [CoverLayer addChild:label_level z:-1];
    
    label_score = [[[CCLabelAtlas alloc] initWithString:@"0" 
                                            charMapFile:@"GameText-score11.png" 
                                              itemWidth:11 itemHeight:17 startCharMap:'.'] autorelease];
    [label_score setAdjustWordBetween:-5/2];
    label_score.position = ccp(60,258);
    [CoverLayer addChild:label_score z:-2];
    
    label_life = [[[CCLabelAtlas alloc] initWithString:@"0" 
                                           charMapFile:@"GameText-score11.png" 
                                             itemWidth:11 itemHeight:17 startCharMap:'.'] autorelease];
    label_life.position = ccp(60,276.5f);
    [CoverLayer addChild:label_life z:-3];
    NSLog(@"PM::init_After_GameCondition Step4");
    //NSLog(@"HighScore:%llu",GC.highScore);
    label_highScore = [[[CCLabelAtlas alloc] initWithString:@"0"
                                                charMapFile:@"GameText-score11.png" 
                                                  itemWidth:11 itemHeight:17 startCharMap:'.'] autorelease];
    [label_highScore setAdjustWordBetween:-5/2];
    label_highScore.position = ccp(95,241);
    [CoverLayer addChild:label_highScore z:-4];
    
    label_worldScore = [[[CCLabelAtlas alloc] initWithString:@"0" 
                                                charMapFile:@"GameText-score11.png" 
                                                itemWidth:11 itemHeight:17 startCharMap:'.'] autorelease];
    [label_worldScore setAdjustWordBetween:-5/2];
    label_worldScore.position = ccp(95,224);
    [CoverLayer addChild:label_worldScore z:-5];
    
    [label_level setString:[NSString stringWithFormat:@"%d",[GameCondition sharedGameCondition].level]];
    [label_life setString:[NSString stringWithFormat:@"%d",[GameCondition sharedGameCondition].life]];
    
    
    
    
    
	//Counter init ended -->
	NSLog(@"ProgressManager:init_After_GameCondition :: END");
}

#pragma mark -
#pragma mark === CenterLoop ===
-(void)centerProgressLoop:(ccTime)delta {
	
	//NSLog(@"PM loop");
	if (mode == MAIN_ANMATION) {
        //NSLog(@"PM loop MAIN_ANMATION");
		[self Main_ani_loop:delta];
		
	}else if (mode == GAME_PLAY){
		//NSLog(@"PM loop GAME_PLAY");
		if (game_state == GAME_OVER) {
			//NSLog(@"PM loop GAME_OVER");

			if (![SF runfinalize]) {
                //NSLog(@"PM loop ![SF runfinalize]");
				[SF release];
				SF = [[StageFinalizer alloc] initWithPM:self coverLayer:CoverLayer];
				[pauseButton setIsEnabled:NO];
				[SF finalizeTheStage:FINALIZE_GAME_OVER];
			}
			[SF update:delta];
			
		}else if (game_state == GAME_FINALIZE){
            //NSLog(@"PM loop GAME_FINALIZE");
			if (SF == nil) { //SF가 죽은상태라면 다시살림 ^^
				SF = [[StageFinalizer alloc] initWithPM:self coverLayer:CoverLayer];
			}
			
			if (![SF runfinalize]) {
                //NSLog(@"PM loop ![SF runfinalize]");
				[pauseButton setIsEnabled:NO];
				[SF finalizeTheStage:FINALIZE_MISSION_CLEAR];
			}
			[SF update:delta];
			
		}else if (game_state == GAME_PAUSING){ //게임 일시정지에 의한 정지
			//NSLog(@"PM loop GAME_PAUSING");
			
		}else if (game_state == GAME_PLAYING) {
			//NSLog(@"PM loop GAME_PLAYING");
			
			if(gameStart){
               // NSLog(@"PM loop gameStart");
				startDelay += delta;
				
				if (startDelay <= 0.3f) {
					//NSLog(@"PM loop startDelay <= 0.3f");
					if (TapToScreen.opacity < 5) {
						TapToScreen.visible = NO;
                        
                        
                        
					}else {
						TapToScreen.visible = YES;
					}
					
					if (black.opacity < 5) {
						black.visible = NO;
					}else {
						black.visible = YES;
					}
					
					black.opacity += (0.9f * (0 - black.opacity))*delta*5;
					startRelayMessage.position = ccp(startRelayMessage.position.x + (0.9f * ((-startRelayMessage.contentSize.width/2) - startRelayMessage.position.x))*delta*15,160);
					startRelayMessage_moving.position = startRelayMessage.position;
					startRelayMessage_moving.opacity = (1 - ( ((240 + startRelayMessage.contentSize.width/2)-startRelayMessage_moving.position.x) / (240+startRelayMessage.contentSize.width/2) ) ) * 255;
					TapToScreen.opacity += (0.9f * (0 - TapToScreen.opacity))*delta*10;
				}
				
				if (startDelay > 0.05f) {
                    //NSLog(@"PM loop startDelay > 0.05f");
					[self Game_PLAY_loop:delta];
					//[self eventObserver:delta];
				
					if (needReleaseSF) { //죽어야할 SF가 있으면 죽여버림 --+
						[SF release];
						SF = nil;
						needReleaseSF = NO;
					}
				}
			}else {
                //NSLog(@"PM loop ![SF runfinalize 2]");
				if ([GameCondition sharedGameCondition].touchingPlayScene) {
                    //NSLog(@"PM loop [GameCondition sharedGameCondition].touchingPlayScene");
					gameStart = YES;
                    if([CoverLayer getChildByTag:tutoCloser_tag] != nil){
                        //[[CoverLayer getChildByTag:tutoCloser_tag] setVisible:NO]; 
                        [(CCMenu*)[CoverLayer getChildByTag:tutoCloser_tag] setOpacity:70];
                    }
				}
			}

			
		}
        
        
        if (startDelay > 0.05f) {
            [self eventObserver:delta];
        }
        
		//<-- 관상용 애니메이션 객체 루프 돌리는 코드  //게임 진행 상황에 영향을 주지 않는 객체
		for (DynamicObject *o in otherAnimationObject){
            //NSLog(@"Ani loop");
			[o update:delta];
			
		}
        //NSLog(@"PM loop end-------------------------------------");
		// 루프돌리기 끝 -->
        
        
		
		
	}
    
    
    //점프 소리 재생
    if (mode == GAME_PLAY) {
        if (startDelay > 0.05f) {
            //점프 사운드 재생 
            dfjSound += delta;
            if (dfjSound > jumpingInterval - ((PerfromNormaltoFinalRelay + PerfromFinalRelaytoMaxFinalRelay)/2 * 0.1) ) {
                
                [[SoundManager sharedSM] playJumpingSoundEffect];
                
                dfjSound  = 0;
            }
        }
    }else if(mode == MAIN_ANMATION){
        dfjSound += delta;
        if (dfjSound > 0.5f) {
            
            [[SoundManager sharedSM] playJumpingSoundEffect];
            
            dfjSound  = 0;
        }
    }
    
}



#pragma mark -
#pragma mark === GameLoop ===
-(void)Game_PLAY_loop:(ccTime)delta {
	GameCondition * GC = [GameCondition sharedGameCondition];
	
	GC.etime += delta; //게임 경과시간 누적
	
	//<--게임 경과시간 뿌려주기
	int s = GC.etime;
	//int ms = (GC.etime - (float)s ) *10;
	
	NSString * displayTime = [NSString stringWithFormat:@"%d",s];
	
	if (GC.etime > 60) {
		
		int m = GC.etime / 60;
		displayTime = [NSString stringWithFormat:@"%d/%d",m,s%60];
		if (m > 60) {
			int h = m/60;
			m = m%(60*h);
			
			displayTime = [NSString stringWithFormat:@"%d/%d/%d",h,m,s%60];
		}
		
	}
	
	[label_time setString:displayTime];
	//경과시간 코드 -->
	
	if (finalRelayOn) {
		finalRelayDuration += delta;
		if (maxFinalRelayOn) {
			maxFinalRelayDuration += delta;
		}
	}
	
	
	
	
	//<--캐릭터를 시간마다 뿌려주는 코드
	if(creatingflag){
		srandom(time(NULL));
		srandom(rand());
		
		int arrayCount = [GC.usingCharacterCodes count];
		
		creatingCycle = [[GC.usingCharacterCodes objectAtIndex:rand()%arrayCount] intValue];
        
        //튜토리얼에 맞춰서 캐릭터생성하는코드 
		if(GC.stageCode == 1){
            if (creatCount < 4) {
                
                switch (creatCount) {
                    case 0:
                        creatingCycle = 0;
                        break;
                    case 1:
                        creatingCycle = 1;
                        break;
                    case 2:
                        creatingCycle = 1;
                        break;
                    case 3:
                        creatingCycle = 1;
                        break;
                    default:
                        break;
                }
            }
        }
        
		BaseCharacter *o = [[BaseCharacter alloc] initWithPos:creatingCycle LayerPos:FRONT Position:ccp([[[totalFieldWays objectAtIndex:1] objectAtIndex:0] intValue],[[[totalFieldWays objectAtIndex:1] objectAtIndex:1] intValue]) superLayer:ForeGroundLayer];
		
		[ShapeObjects addObject:o];
		[ForeGroundLayer addChild:o z:-1*(int)(o.ZdistanceForCurrentTargetpoint)];
		[o release];
		creatCount++;
		creatingflag = FALSE; //한번 생성후 정지
	}else {
		createdTime += delta;
		if (createdTime > GC.createPeroid) {
			
			creatingflag = TRUE;
			createdTime = 0;
		}
		
	}//*/
	// 캐릭터 뿌려주는 코드 끝 -->
	
	
	
	
	//<-- 캐릭터마다 목표점을 지정해주고 동작시키는 코드
	int totalWaysLength = [[totalFieldWays objectAtIndex:0] intValue];

	for (int i = 0; i < [ShapeObjects count]; i++) {
        BaseCharacter * o = [ShapeObjects objectAtIndex:i];
		
        if ([o state] == STOPING) {	
			if (o.LocationinWay + 1 < totalWaysLength) {
				o.LocationinWay += 1;
				int nextWay = 3* o.LocationinWay;
				CGPoint ts = CGPointMake([[[totalFieldWays objectAtIndex:1] objectAtIndex:nextWay] intValue],[[[totalFieldWays objectAtIndex:1] objectAtIndex:nextWay+1] intValue]);
				
				o.targetSpot = ts;
				
				int nowWayToWalk = (o.LocationinWay - 1) * 3;
				o.currentZDirection = [[[totalFieldWays objectAtIndex:1] objectAtIndex:nowWayToWalk+2] intValue]; 
				
				o.state = WALKING;
					
			}
				
		}	
		
		int divideLoop = GC.stepSpeed / 50 * 2 ;
		for( int i = 0 ; i < divideLoop ; i++){
			
			[o update:delta/divideLoop];
			
			if (o.state == STOPING || o.state == ARRIVED || o.state == STANDBY) {
				
				i = divideLoop;
			}
		}
		//if (o.state == WALKING)[ForeGroundLayer reorderChild:o z:-1*(int)(o.ZdistanceForCurrentTargetpoint)];
		
		
		if(o.state == ARRIVED){ 
			//NSLog(@"ARRIVED");
			
			[standbySpace addObject:o];
			[ShapeObjects removeObject:o];
			
			[ForeGroundLayer removeChild:o cleanup:NO];
			
			int fieldLayerCount = [[FieldLayer2 children] count];
			
			[FieldLayer2 addChild:o z:-standbyCharacterCount];

			o.state = STANDBY;
			standbyCharacterCount ++; //계속 누적됨
			if (fieldLayerCount == 0) {
				standbyCount = maxCounting;
			}
			
		}
	}//*/
	// 캐릭터 동작코드 끝 -->
	
	
	for (BaseCharacter * o in standbySpace )[o update:delta];
	
	
	
	//<-- 캐릭터가 최종지점에 도착해 대기중일때 판별하는 코드
    [self checkUserCommand:delta];

	
	
	// 캐릭터 판별시켜 통과시키는 코드 끝 -->
	
	
	//<-- 곧 죽을 객체들의 루프를 돌리고, 죽는지 체크하는 코드
	int removeCount = 0;
	for (BaseCharacter * o in willDieObjects){
		[o update:delta];
		if (o.state == DIED) {
			removeCount++;
			//[ShapeObjects removeObjectAtIndex:0]
		}
		
	}
	// 다이체크 코드 끝 -->
	
	// <-- 리무브카운터가 올라간만큼 배열 인덱스 0의 캐릭터를 제거하는 코드
	while (removeCount--) {
		//NSLog(@"removeObj");
		[FieldLayer2 removeChild:[willDieObjects objectAtIndex:0] cleanup:YES];
		[willDieObjects removeObjectAtIndex:0];
		
	}
	// 캐릭터 제거코드 끝 -->
	

	//<-- 게임진행에 영향을 주는 객체의 루프를 돌려주는 코드
	for (DynamicObject *o in gameObjects_needsLoop){
		[o update:delta];
		
	}
	// 코드 끝 -->
	
	
	
	[FRDC update:delta];
    
    
	
}

#pragma mark -
#pragma mark === MainSceneLoop ===
//수정중 메인애니메이션 루프
-(void)Main_ani_loop:(ccTime)delta {
    
    if (flag_characterCycle) {
        
        srandom(time(NULL));
        if(creatingflag){
            
            GameCondition * GC = [GameCondition sharedGameCondition];
            
            int arrayCount = [GC.usingCharacterCodes count];
            //creatingCycle = [[GC.usingCharacterCodes objectAtIndex:rand()%arrayCount] intValue];
            BOOL isNothingEqually = YES;
            for (int i = 0; i < arrayCount; i++) {
                if (creatingCycle == [[GC.usingCharacterCodes objectAtIndex:i] intValue]) {
                    isNothingEqually = NO;
                }
            }
            
            if (isNothingEqually) {
                creatingCycle = [[GC.usingCharacterCodes objectAtIndex:0] intValue];
            }
//            if (creatingCycle <= [[GC.usingCharacterCodes objectAtIndex:0] intValue] && creatingCycle > [[GC.usingCharacterCodes objectAtIndex:arrayCount-1] intValue]) {
//                creatingCycle = 0;
//            }
            
            BaseCharacter *o = [[BaseCharacter alloc] initWithPos:creatingCycle LayerPos:FRONT Position:ccp([[[totalFieldWays objectAtIndex:1] objectAtIndex:0] intValue],[[[totalFieldWays objectAtIndex:1] objectAtIndex:1] intValue]) superLayer:ForeGroundLayer];
            
            creatingCycle += 1;
            [ShapeObjects addObject:o];
            [ForeGroundLayer addChild:o z:-1*(int)(o.ZdistanceForCurrentTargetpoint)];
            [o release];
            creatingflag = FALSE; //한번 생성후 정지
        }else {
            createdTime += delta;
            if (createdTime > [GameCondition sharedGameCondition].Any_CreatePeroid) {
                creatingflag = TRUE;
                createdTime = 0;
            }
            
        }
        
        
        int removeCount = 0;
        
        int totalWaysLength = [[totalFieldWays objectAtIndex:0] intValue];
        
            
        
        
        for (int i = 0; i < [ShapeObjects count]; i++) {
            BaseCharacter * o = [ShapeObjects objectAtIndex:i];
            
            if ([o state] == STOPING) {	
                if (o.LocationinWay + 1 < totalWaysLength) {
                    o.LocationinWay += 1;
                    int nextWay = 3* o.LocationinWay;
                    CGPoint ts = CGPointMake([[[totalFieldWays objectAtIndex:1] objectAtIndex:nextWay] intValue],[[[totalFieldWays objectAtIndex:1] objectAtIndex:nextWay+1] intValue]);
                    
                    o.targetSpot = ts;
					
                    int nowWayToWalk = (o.LocationinWay - 1) * 3;
                    o.currentZDirection = [[[totalFieldWays objectAtIndex:1] objectAtIndex:nowWayToWalk+2] intValue]; 
                    
                    o.state = WALKING;
					
                }
                
            }
            
            int divideLoop = [GameCondition sharedGameCondition].stepSpeed / 50 * 2 ;
            for( int i = 0 ; i < divideLoop ; i++){
                [o update:delta/divideLoop];
                if (o.state == STOPING || o.state == ARRIVED) {
                    //printf("Skip Loop");
                    i = divideLoop;
                }
            }
			
            //if (o.state == WALKING)[ForeGroundLayer reorderChild:o z:-1*(int)(o.ZdistanceForCurrentTargetpoint)];
            
            if (o.state == ARRIVED) {
                
                o.state = DISAPPEAR;
                
                [ForeGroundLayer removeChild:o cleanup:YES];
                [FieldLayer2 addChild:o];
                
            }else if (o.state == DIED) {
                
                [FieldLayer2 removeChild:o cleanup:YES];
                [ShapeObjects removeObject:o];
                //NSLog(@"Character remove");
                removeCount++;
            }else if (o.state == DISAPPEAR) {
                
            }
        }
        
        
		
        
	}
	
	for (DynamicObject *o in otherAnimationObject){
		[o update:delta];
		
	}
	
}//*/

#pragma mark -
#pragma mark ==== Event (MisstionCheck) ===
-(void)eventObserver:(ccTime)d {
	//Final Relay Check
	GameCondition * GC = [GameCondition sharedGameCondition];

	for(int i = 0 ; i < missionCodeLength ; i++){
		
		int code = [[missionCodes objectAtIndex:i] intValue];
		NSDictionary * mission = [missionDic valueForKey:[NSString stringWithFormat:@"%d",code]];
		
		if (code == MISSION_RESCUE_CHARACTER){
			int m_CharCount = [[mission valueForKey:@"CharCount"] intValue];
			if (m_CharCount == [rescuedShapeCodes count]) { //미션클리어 체크
				[self pushMissionCode:code];
			}

		}else if (code == MISSION_TOTAL_COMBO_RECORD) {
			int ObjectiveTotalCombo = [[mission valueForKey:@"totalRecordCombo"] intValue];
			if (ObjectiveTotalCombo == GC.totalCombo) {
				[self pushMissionCode:code];
			}
		}else if (code == MISSION_PLAYTIME_RECORD) {
			float ObjectivePlayTime = [[mission valueForKey:@"recordPlayTime"] intValue];
			if (ObjectivePlayTime <= GC.etime) {
				[self pushMissionCode:code];
			}
		}else if (code == MISSION_SCORE_RECORD) {
			long long ObjectiveScore = [[mission valueForKey:@"recordScore"] intValue];
			if (ObjectiveScore <= GC.totalScore) {
				[self pushMissionCode:code];
			}
		}else if (code == MISSION_COMBO_TECHNIQUE) {
			NSString* ObjectiveComboTechicque = [NSString stringWithString:[mission valueForKey:@"comboChainXxY"]];
			
			if (m_5_needComboUnit == 0) { //0이면 값을 입력 한번만 연산을 하기위해서 
				m_5_needComboUnit = [[[ObjectiveComboTechicque componentsSeparatedByString:@"/"] objectAtIndex:0] intValue];
				m_5_needComboUnitsCount = [[[ObjectiveComboTechicque componentsSeparatedByString:@"/"] objectAtIndex:1] intValue];
			}
			
			if (GC.currentCombo == m_5_needComboUnit) {
				m_5_Defer_comboUnit = YES;		
				NSLog(@"m_5_Defer_comboUnit = YES !!!!!!!!!!!!!!!!!!!!!!!!!!!");
				if (m_5_needComboUnitsCount == m_5_current_comboUnitsCount +1) { //한번남은 상황에서 필요콤보에 도달하면 바로 미션 성공
					[self pushMissionCode:code];
					NSLog(@"MISSION_COMBO_TECHNIQUE !!!!!!!!!!!!!!!!!!!!!!!!!");
				}
			}else if (m_5_Defer_comboUnit == YES && GC.currentCombo == 0) {
				m_5_Defer_comboUnit = NO;
				m_5_current_comboUnitsCount += 1;
				NSLog(@"m_5_current_comboUnitsCount ++ :%d !!!!!!!!!!!!!!!!!!!!!!!!!!!",m_5_current_comboUnitsCount);
				
			}else if (m_5_Defer_comboUnit == YES && GC.currentCombo > m_5_needComboUnit){
				m_5_Defer_comboUnit = NO;
				NSLog(@"m_5_Defer_comboUnit = NO !!!!!!!!!!!!!!!!!!!!!!!!!!!");
			}
			/*
			if (m_5_current_comboUnitsCount == m_5_needComboUnitsCount) {
				
				NSLog(@"MISSION_COMBO_TECHNIQUE !!!!!!!!!!!!!!!!!!!!!!!!!");
				
			}*/
			
			
			
		}else if (code == MISSION_HIGH_COMBO_RECORD) {
			int ObjectiveHighCombo = [[mission valueForKey:@"HighComboRecord"] intValue];
			if (ObjectiveHighCombo == GC.maxCombo) {
				[self pushMissionCode:code];
			}
		}
		
	}
	//test
	//OverClearedMissionCode = 0; //오버클리어 테스트용 변수
	
	
	
	//미션카드 애니메이션후 게임 파이널라이즈
	if (ClearedMissionCode != -1 && GPMode == PLAYMODE_NORMAL) {
		if (clearMissionCard == nil) {

			clearMissionCard = [[[MissionCard alloc] initWithCode:ClearedMissionCode missionDic:missionDic] autorelease];
			[CoverLayer addChild:clearMissionCard];
			clearMissionCard.anchorPoint = ccp(1,1);
			clearMissionCard.position = ccp(470,310);
			clearMissionCard.scale = 20;
		}else {
			if (clearMissionCard.scale > 0.6f) {
				clearMissionCard.scale += (0.99f * (0.5f - clearMissionCard.scale))*d*10;
			}else {
				clearMissionCard.scale = 0.5f;
				game_state = GAME_FINALIZE;
			}
		}
	}
	
	if (OverClearedMissionCode != -1) {
		if (overClearMissionCard == nil) {

			overClearMissionCard = [[[MissionCard alloc] initWithCode:OverClearedMissionCode missionDic:missionDic] autorelease];
			[CoverLayer addChild:overClearMissionCard];
			overClearMissionCard.anchorPoint = ccp(1,1);
			overClearMissionCard.position = ccp(415,310);
			overClearMissionCard.scale = 20;
		}else {
			if (overClearMissionCard.scale > 0.6f) {
				overClearMissionCard.scale += (0.99f * (0.5f - overClearMissionCard.scale))*d*10;
			}else {
				overClearMissionCard.scale = 0.5f;
				game_state = GAME_FINALIZE;
			}
		}
	}
	
	

}

-(void)pushMissionCode:(MissionList)code {
	
	GameCondition * GC = [GameCondition sharedGameCondition];
	
	if (GPMode == PLAYMODE_NORMAL && ClearedMissionCode == -1) { //노멀모드이면 클리어미션코드로
		ClearedMissionCode = code;
		GC.ClearedMissionCode = code;
        [[SoundManager sharedSM] playMissionClearSE];
		gameStart = NO;
		//NSLog(@"Mission Rescue Character Success!");
	}else if (GPMode == PLAYMODE_OVERCLEAR && OverClearedMissionCode == -1){ //오버클리어모드이면 오브클리어미션코드로
		if (ClearedMissionCode != code ) {
			OverClearedMissionCode = code;
			GC.OverClearedMissionCode = code;
            [[SoundManager sharedSM] playMissionClearSE];
			gameStart = NO;
		}
		//NSLog(@"Mission Rescue Character Success! Over");
	}
}
#pragma mark -



-(void)offCharacterCycle{
    flag_characterCycle = NO;
}

-(void)passShape{
	GameCondition * GC = [GameCondition sharedGameCondition];
	
	firstO.targetSpot = ccp(400,-20);
	[self passingShape:firstO.shapeCode];
	
	[willDieObjects addObject:firstO];
	[standbySpace removeObject:firstO];
	[self comboCounter:YES];
	
	//Score Accumulate
	if (GPMode == PLAYMODE_NORMAL) {
		GC.normalScore += [self scoreCalcurator];
	}else if (GPMode == PLAYMODE_OVERCLEAR) {
		GC.overClearScore += [self scoreCalcurator];
	}else if (GPMode == PLAYMODE_INFINITE) {
		GC.infiniteScore += [self scoreCalcurator];
	}
	GC.totalScore = GC.normalScore + GC.overClearScore + GC.infiniteScore;
    
    NSMutableString * scoreStr = [NSMutableString stringWithFormat:@"%llu",GC.totalScore];
    NSMutableString * highScoreStr = [NSMutableString stringWithFormat:@"%llu",MAX(GC.totalScore,GC.highScore)];
    //NSMutableString * worldScoreStr = [NSMutableString stringWithFormat:@"%d",MAX(GC.totalScore,GC.worldTopScore)];
    NSMutableString * worldScoreStr = [NSMutableString stringWithFormat:@"%llu",GC.worldTopScore];
    
    if ([scoreStr length] > 3) {
        int length = [scoreStr length];
        int pushCommaCount = roundf(length/3);
        
        for (int i = 1; i <= pushCommaCount; i++) {
            if(length%3 == 0){
                if (i != pushCommaCount) {
                    [scoreStr insertString:@"." atIndex:[scoreStr length]-((i*3)+i-1)]; 
                }
            }else{
                [scoreStr insertString:@"." atIndex:[scoreStr length]-((i*3)+i-1)];  
            } 
        }
    }
    
    if ([highScoreStr length] > 3) {
        int length = [highScoreStr length];
        int pushCommaCount = roundf(length/3);
        
        for (int i = 1; i <= pushCommaCount; i++) {
        
            if(length%3 == 0){
                if (i != pushCommaCount) {
                    [highScoreStr insertString:@"." atIndex:[highScoreStr length]-((i*3)+i-1)]; 
                }
            }else{
                [highScoreStr insertString:@"." atIndex:[highScoreStr length]-((i*3)+i-1)];  
            } 
        }
    }
    
    if ([worldScoreStr length] > 3) {
        int length = [worldScoreStr length];
        int pushCommaCount = roundf(length/3);
        
        for (int i = 1; i <= pushCommaCount; i++) {
            if(length%3 == 0){
                if (i != pushCommaCount) {
                    [worldScoreStr insertString:@"." atIndex:[worldScoreStr length]-((i*3)+i-1)]; 
                }
            }else{
                [worldScoreStr insertString:@"." atIndex:[worldScoreStr length]-((i*3)+i-1)];  
            } 
        }
    }
    
    // 11 111 111 111
	[label_score setString:scoreStr];
	[label_highScore setString:highScoreStr];
    [label_worldScore setString:worldScoreStr];
    
    
	[FieldLayer2 reorderChild:firstO z:[[FieldLayer2 children] count]];
	
	[self resetCounter];
}

-(void)passingShape:(int)code_ {
	NSNumber * code = [[NSNumber alloc] initWithInt:code_];
	[passedShapesCode addObject:code];
	if (firstO.state == COMEIN) { //지금해당하는 캐릭터가 안으로 들어온거면 구출로 간주하며 구출된 캐릭터코드배열에 추가됨
		[rescuedShapeCodes addObject:code];
	}
	//[TAHM push_passedShapeCode:code_];
	[code release];
}

-(void)standByCounter:(ccTime)dt{
	for(int i = maxCounting ; i >= 0 ; i--){
		CCLabelAtlas * o = [counterNodeArr objectAtIndex:i];
		float this_standbyCount = standbyCount;
		if ((int)this_standbyCount == i) {
			o.position = ccp(firstO.position.x,firstO.position.y+100);
			o.opacity = 255;
			
		}else if(this_standbyCount < i) {
			
			if (o.opacity < 20) {
				o.opacity = 0;
			}else {
				o.opacity -= 200*dt;
				o.position = ccp(firstO.position.x,o.position.y + 40*dt);
			}


		}
		
	}
}

-(void)resetCounter {
	for (CCLabelAtlas * o in counterNodeArr){
		o.opacity = 0;
	}
	standbyCount = maxCounting;
}

-(void)GButtonEventListener:(BUTTON_NAME)bname_ {
	buttonDown = TRUE;
	justDownButton = bname_;
}

-(void)inputFinalRelayDuration_to_GC { //파이널릴레이가 꺼질때 기록값을 입력
	GameCondition * GC = [GameCondition sharedGameCondition];
	GC.highFinalRelayDuration = fmax(GC.highFinalRelayDuration, finalRelayDuration);
	GC.highMaxFinalRelayDuration = fmax(GC.highMaxFinalRelayDuration, maxFinalRelayDuration);
	finalRelayDuration = 0;
	maxFinalRelayDuration = 0;
}

-(void)comboCounter:(BOOL)pass {
	GameCondition * GC = [GameCondition sharedGameCondition];
	if (!pass) { //콤보를 취소 시킴 유저가 오판할때
		
		GC.currentCombo = -1;
		
		GC.stepSpeed = GC.BeginStepSpeed;
		GC.createPeroid = GC.BeginCreatePeroid;
		
		PerfromNormaltoFinalRelay = 0;
		PerfromFinalRelaytoMaxFinalRelay = 0;
		
		if (finalRelayOn) {
			[FRDC offFinalRelay];
			finalRelayOn = NO;
			maxFinalRelayOn = NO;
			[self inputFinalRelayDuration_to_GC];
		}

		return;
	}
	
	if ((float)maxCounting-0.5f < standbyCount) {
		//NSLog(@"MaxCounting :%f StandbyCount:%f",(float)maxCounting,(float)standbyCount);
		GC.currentCombo++;
		
		[comboParty setComboText:GC.currentCombo];
		[comboPartyTweener start];
		GC.totalCombo++;
		
		//콤보수가 최대콤보보다 높으면 최대콤보로 기록함
		if(GC.currentCombo > GC.maxCombo) GC.maxCombo = GC.currentCombo;
		
		
		//From Normal to FinalRelay to MaxFinalRelay
		if (GC.currentCombo < GC.FinalRelayStartingComboPoint) { // 노멀에서 파이널 릴레이 진입전까지
			PerfromNormaltoFinalRelay = (float)GC.currentCombo / (float)GC.FinalRelayStartingComboPoint;
			
			
			GC.stepSpeed = GC.BeginStepSpeed + (GC.BeginStepSpeed * 0.125) * PerfromNormaltoFinalRelay;
			GC.createPeroid = GC.BeginCreatePeroid - ((GC.BeginCreatePeroid * 0.0625) * PerfromNormaltoFinalRelay);
			//NSLog(@"NormalRelay currentCombo:%d toFinalRelay:%f\%",GC.currentCombo,PerfromNormaltoFinalRelay*100);
		
		}else if (GC.currentCombo >= GC.FinalRelayStartingComboPoint && GC.currentCombo < GC.MaxFinalRelayComboPoint){ // 파이널 릴레이 진입부터 맥스파이널릴레이까지
			finalRelayOn = YES;
			if (GC.currentCombo == GC.FinalRelayStartingComboPoint) {
				[FRDC onFinalRelay];
				GC.startedFinalRelayCount++;
			}
			
			PerfromNormaltoFinalRelay = 1;
			PerfromFinalRelaytoMaxFinalRelay = (float)(GC.currentCombo - GC.FinalRelayStartingComboPoint)/(float)(GC.MaxFinalRelayComboPoint - GC.FinalRelayStartingComboPoint);
			
			
			GC.stepSpeed = (GC.BeginStepSpeed  * 1.25) + ((GC.BeginStepSpeed * 0.75) * PerfromFinalRelaytoMaxFinalRelay);
			GC.createPeroid = (GC.BeginCreatePeroid  * 0.875) - ((GC.BeginCreatePeroid * 0.375) * PerfromFinalRelaytoMaxFinalRelay);
			//NSLog(@"FinalRelay currentCombo:%d toMaxFinalRelay:%f\%",GC.currentCombo,PerfromFinalRelaytoMaxFinalRelay*100);
			
		}else if (GC.currentCombo <= GC.MaxFinalRelayComboPoint) { //맥스 파이널 릴레이 도달
			if (GC.currentCombo == GC.MaxFinalRelayComboPoint) {
				[FRDC onMaxFinalRelay];
				GC.arrivedMaxFinalRelayCount++;
				maxFinalRelayOn = YES;
			}
			
			PerfromFinalRelaytoMaxFinalRelay = 1;
			
			GC.stepSpeed = GC.BeginStepSpeed * 2;
			GC.createPeroid = GC.BeginCreatePeroid * 0.5;
			
			NSLog(@"MaxFinalRelay currentCombo:%d",GC.currentCombo);
		}//*/ FinalRelay code 끝
		
		[FRDC setPerfromNormaltoFinalRelay:PerfromNormaltoFinalRelay];
		if (finalRelayOn) {
			[FRDC setPerfromFinalRelaytoMaxFinalRelay:PerfromFinalRelaytoMaxFinalRelay];
		}
		
	}else {
		GC.currentCombo = 0;
		
		if (finalRelayOn) {
			[FRDC offFinalRelay];
			finalRelayOn = NO;
			maxFinalRelayOn = NO;
			[self inputFinalRelayDuration_to_GC];
		}
		PerfromNormaltoFinalRelay = 0;
		PerfromFinalRelaytoMaxFinalRelay = 0;
		
		GC.stepSpeed = GC.BeginStepSpeed;
		GC.createPeroid = GC.BeginCreatePeroid;
	
	}
}

-(long long)scoreCalcurator{
	//점수 계산
	GameCondition * GC = [GameCondition sharedGameCondition];

	//long long score = 5+((GC.level * ((GC.stageCode+2)/2)) * (GC.currentCombo + 1)) * (standbyCount / maxCounting) + (GC.level*GC.stageCode*GC.maxCombo)*PerfromFinalRelaytoMaxFinalRelay;
    
    long long score = ((GC.level * GC.stageCode)*(50*(1+(1*PerfromNormaltoFinalRelay))))+((standbyCount/maxCounting)*GC.currentCombo)*(1+(1*PerfromFinalRelaytoMaxFinalRelay));
	return score;
}


-(void)ExitPlayScene {

	[caller GoMain];
}


-(void)pauseCallBack:(id)sender {
	//게임이 진행중일때만 버튼이 먹힘
	if ( game_state == GAME_PLAYING) {
		game_state = GAME_PAUSING;
		[pauseButton setIsEnabled:NO];
		
		
		pauseLayer = [[CCLayer alloc] init];
		[CoverLayer addChild:pauseLayer];
		[pauseLayer release];
		
		CCSprite * darkness = [CCSprite spriteWithFile:@"blackDot.png"];
		darkness.scaleX = 480;
		darkness.scaleY = 320;
		darkness.opacity = 130;
		darkness.anchorPoint = ccp(0,0);
		[pauseLayer addChild:darkness];
		
		CCSprite * pauseBack = [CCSprite spriteWithFile:@"PauseMenu_back.png"];
		pauseBack.anchorPoint = ccp(0.5f,0.5f);
		pauseBack.position = ccp(240,160);
		[pauseLayer addChild:pauseBack];
		
		CCMenuItem * resume = [CCMenuItemImage itemFromNormalImage:@"Pause_resume.png" selectedImage:@"Pause_resume.png" target:self selector:@selector(resumeCallBack:)];
		//CCMenuItem * option = [CCMenuItemImage itemFromNormalImage:@"Pause_option.png" selectedImage:@"Pause_option.png" target:self selector:@selector(optionCallBack:)];
		CCMenuItem * bmain	= [CCMenuItemImage itemFromNormalImage:@"Pause_main.png" selectedImage:@"Pause_main.png" target:self selector:@selector(mainCallBack:)];
		
		CCMenu * pauseMenuSet = [CCMenu menuWithItems:resume,bmain,nil];
		pauseMenuSet.anchorPoint = ccp(0.5f,0.5f);
		pauseMenuSet.position = ccp(240,175);
		[pauseMenuSet alignItemsVertically];
		
		[pauseLayer addChild:pauseMenuSet];
		
	}
}

-(void)Tutorial_Run{
	[TM begin];
}

-(void)resumeCallBack:(id)sender {
	if (game_state == GAME_PAUSING) {
		[CoverLayer removeChild:pauseLayer cleanup:YES];
		game_state = GAME_PLAYING;
		[pauseButton setIsEnabled:YES];
	}
}
//
//-(void)optionCallBack:(id)sender {
//	if (game_state == GAME_PAUSING) {
//		//[CoverLayer removeChild:pauseLayer cleanup:YES]; //완전히 구현 후에 주석 해제
//	}
//}

-(void)mainCallBack:(id)sender {
	if (game_state == GAME_PAUSING) {
		[CoverLayer removeChild:pauseLayer cleanup:YES];
		[self ExitPlayScene];
	}
}

-(void)ResumeGamefromStageFinalizer {
	game_state = GAME_PLAYING;
	[pauseButton setIsEnabled:YES];
	needReleaseSF = YES;
	
	
}

-(void)packingStage {

	black.opacity = 200;
	
	startRelayMessage.position = ccp(240,160);
	
	startRelayMessage_moving.position = ccp(240,160);
	startRelayMessage_moving.opacity = 0;
	startDelay = 0;
	gameStart = NO;
}

-(void)RestartGamefromStageFinalizer {
	[caller restartStage];
}

-(BOOL)checkUserCommand:(ccTime)d { //유저의 키 입력을 체크함
    GameCondition * GC = [GameCondition sharedGameCondition];
    
    BOOL passed;
    passed = NO;
    
    if ([standbySpace count] > 0) { //배열의 카운터가 0이상일때 접근함
		
		firstO = [standbySpace objectAtIndex:0]; 
        
		
		[self standByCounter:d];
		standbyCount -= d;
		
		if (standbyCount < 0) {
            NSLog(@"GameOver");
			game_state = GAME_OVER;
		}
		
        
		
		if (buttonDown) {
			
			
			if (firstO.state == STANDBY) {
				int prevStep = GC.PrevStep;
				int compareCode;
				
				if (([passedShapesCode count]-prevStep) < 1) {
					compareCode = 99;
				}else {
					compareCode = [[passedShapesCode objectAtIndex:([passedShapesCode count]-1-prevStep)] intValue];
					
				}
                
                
				if (justDownButton == IN) {
					if (firstO.shapeCode == compareCode) {
						
						firstO.state = COMEIN;
						[self passShape];
						passed = YES;
                         //NSLog(@"PASS");
					}else {
                        if (d != 0) { //튜토리얼에선 콤보,라이프까기없음
                            [self comboCounter:NO];
                            GC.life -= 1;
                            [lifeDownTweener start];
                            
                            [label_life setString:[NSString stringWithFormat:@"%d",GC.life]];
                            
                            if (GC.life == -1) {
                                game_state = GAME_OVER;
                                
                            }
                        }
						
                        passed = NO;
                         //NSLog(@"NOT PASS");
					}
                    
				}else if(justDownButton == OUT) {
					if (firstO.shapeCode != compareCode) {
						
						firstO.state = GOOUT;
						[self passShape];
						passed = YES;
                         //NSLog(@"PASS");
					}else {
                        if (d != 0) { //튜토리얼에선 콤보,라이프까기없음
                            [self comboCounter:NO];
                            GC.life -= 1;
                            [lifeDownTweener start];
                            
                            [label_life setString:[NSString stringWithFormat:@"%d",GC.life]];
                            
                            if (GC.life == -1) {
                                game_state = GAME_OVER;
                            }
                            passed = NO;
                            //NSLog(@"NOT PASS");
                        }
                        
					}
                    
				}				
				
                
				
			}
            
		}
	}
   
    
    buttonDown = FALSE; //버튼의 값을 한번 판단했으니
    return passed;
}

-(BOOL)checkTutorialEndCommand{
    if (buttonDown) {
		if (justDownButton == HINT) {
            //NSLog(@"PM:  TM close");
			buttonDown = FALSE;
            return YES;
		}
	}
    buttonDown = FALSE;
    return NO;
}

-(void)deleteTM {
    if(TM != nil){
        [TM endTutorial];
        TMDied = YES;
        TM = nil;
        
    }
}

-(void)buttonDownInvalidation {
    buttonDown = FALSE;
}

-(void)tutorialDelete:(id)sender{
    [self tutoCloserRemove];
    [TM endTutorial];
}

-(void)tutoCloserRemove{
    [CoverLayer removeChildByTag:tutoCloser_tag cleanup:YES];
}

#pragma mark -
#pragma mark === Dealloc ===
-(void)dealloc 
{

	[passedShapesCode release];
	if (mode == GAME_PLAY) {

		[rescuedShapeCodes release];
		
		//[SF release];
		game_state = GAME_EXIT;
		//쉐입코드 큐 초기화 클래스 변수라서 해줘야함
		
		//NSLog(@"PM ExitPlayScene");
		
		
		
		[gameObjects_needsLoop release];
		
		[standbySpace release];
		
		
		[counterNodeArr release];
		
		//EventObserver
		[missionDic release];
		[missionCodes release];
		
		[FRDC release];
		[SF autorelease];
		
	}else{
        
    }
    
    [otherAnimationObject release];
	[totalFieldWays release];
	[ShapeObjects release];
    [willDieObjects release];
    
	[super dealloc];
	NSLog(@"ProgressManager Dealloc");
}

@end
