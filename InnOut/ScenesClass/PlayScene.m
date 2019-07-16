//
//  PlayScene.m
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 12..
//  Copyright 2011 Student. All rights reserved.
//

#import "PlayScene.h"

#import "GameConfig.h"

#import "GameHeaders.h"
#import "GameMainScene.h"
#import "StagePlacement.h"
#import "WorldMapScene.h"

@interface PlayScene (privateMethods)

-(BOOL)placeBackGround;
-(void)buttonCallback:(id)sender;

@end

@implementation PlayScene
@synthesize foregroundLayer;

static CCScene *scene = nil;
static int c_stageCode = 0;

+(id)sceneWithStageCode:(StageCode)stageCode_ {
	
	c_stageCode = stageCode_;
	
	[scene release];
	NSLog(@"asdasda");
	scene = [[CCScene alloc] init];
	
	PlayScene *stage = [PlayScene node];
	
	[scene addChild:stage];
	
	return scene;
}


-(id)init {
	
	if ((self = [super init])) {
		stageCode = c_stageCode;
		[GameCondition sharedGameCondition].stageCode = stageCode;
		initGameOfAll = FALSE;
	
		backgroundLayer = [CCLayer node];
		hillOfBackField = [CCLayer node];
		foregroundLayer = [CCLayer node];
		ontheHillField  = [CCLayer node];
		effectLayer		= [CCLayer node];
		coveringLayer   = [CCLayer node];
	
		[self addChild:backgroundLayer];
		[self addChild:hillOfBackField];
		[self addChild:foregroundLayer];
		[self addChild:ontheHillField];
		[self addChild:effectLayer];
		[self addChild:coveringLayer];
	
		
		//코드의 순서 중요함
		PM = [[ProgressManager alloc] initWithLayerMode:hillOfBackField 
												 field2:ontheHillField 
												  cover:coveringLayer 
										backGroundLayer:backgroundLayer
												   mode:GAME_PLAY
											  whoCalled:self];
		
	
		[self placeBackGround];
		
		[self schedule:@selector(loop:)];
		//NSLog(@"1");
		self.isTouchEnabled = YES;
		//NSLog(@"2");
		[[GameCondition sharedGameCondition] finalGameInit];
		//NSLog(@"3");
		initGameOfAll = YES; //YES가 되기 전엔 루프를 돌지않음
		//NSLog(@"PlayScene:init ::END");
	}
	NSLog(@"PlayScene Initialize");
	return self;
}

-(BOOL)placeBackGround {
	NSLog(@"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
	SPM = [[StagePlacementManager alloc] initStageWith3Layers:stageCode 
														   pm:PM 
											  backGroundLayer:backgroundLayer 
											  foreGroundLayer:foregroundLayer 
												  effectLayer:effectLayer];
	[[GameCondition sharedGameCondition] setSPM:SPM]; //SPM생성후 GameCondition 객체에게 넘겨줌
	[PM init_After_GameCondition]; //순서 문제로 두번쨰 초기화
	NSLog(@"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
	
    //BGM
    [[AudioPlayer sharedAudioPlayer] allStopAudio];
    [[AudioPlayer sharedAudioPlayer] stageBGMSetting:stageCode];
    
//	CCSprite * text_Level =[CCSprite spriteWithFile:@"GameText_level.png"];
//	CCSprite * text_Score =[CCSprite spriteWithFile:@"GameText_score.png"];
//	CCSprite * text_Life = [CCSprite spriteWithFile:@"GameText_life.png"];
    CCSprite * totalLable = [CCSprite spriteWithFile:@"GameText_total.png"];
    
//    
//	//CCSprite * text_Hint = [CCSprite spriteWithFile:@"GameText_hint.png"];
//	//CCSprite * text_Prev = [CCSprite spriteWithFile:@"GameText_prev.png"];
//	
//	text_Level.anchorPoint = 
//	//text_Prev.anchorPoint = 
//  //text_Hint.anchorPoint=
//	text_Life.anchorPoint = 
//	text_Score.anchorPoint= ccp(0,0);
	totalLable.anchorPoint = ccp(0,1);
//    
//	
//	text_Level.position = ccp(10,295);
//	text_Score.position = ccp(10,275);
//	text_Life.position  = ccp(10,255);
//	//text_Hint.position  = ccp(10,235);
//	//text_Prev.position  = ccp(355,285);
	totalLable.position = ccp(5,315);
    
    
	//[coveringLayer addChild:text_Level];
	//[coveringLayer addChild:text_Score];
	//[coveringLayer addChild:text_Life];
    [coveringLayer addChild:totalLable z:-1];
	//[coveringLayer addChild:text_Hint];
	//[coveringLayer addChild:text_Prev];
	
    CCSprite * timeBack = [CCSprite spriteWithFile:@"TimeBackAndPause.png"];
    timeBack.position = ccp(240,300);
    [coveringLayer addChild:timeBack z:-1];
    
    
	//NSLog(@"PlayScene:placeBackGround ::END");
	return YES;
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch*)touch withEvent:(UIEvent*)event {	
	CGPoint conPos = [self convertTouchToNodeSpace:touch];
	
	[touchedTrace dealloc];
	touchedTrace = [[NSMutableArray alloc] init];//메모리릭이 있으면 배열해제시에 객체도 모두 해제되는지 체크 
	[touchedTrace addObject:[NSValue valueWithCGPoint:conPos]]; //첫 터치 지점 저장
	
	[[GameCondition sharedGameCondition] setTouchingPlayScene:YES];
	return YES;
}

-(void)ccTouchMoved:(UITouch*)touch withEvent:(UIEvent*)event {
	CGPoint conPos = [self convertTouchToNodeSpace:touch];
	[touchedTrace addObject:[NSValue valueWithCGPoint:conPos]];
    

}

-(void)ccTouchEnded:(UITouch*)touch withEvent:(UIEvent*)event {
	CGPoint conPos = [self convertTouchToNodeSpace:touch];
	[touchedTrace addObject:[NSValue valueWithCGPoint:conPos]]; //최종터치가 끝난 지점을 저장
	
	CGPoint bP = [[touchedTrace objectAtIndex:0] CGPointValue];
	CGPoint eP = [[touchedTrace objectAtIndex:[touchedTrace count]-1] CGPointValue];
	//printf("\ntraceCount:%d",[touchedTrace count]);
	
	
/*
	BOOL PassLD;
	BOOL PassLU;
	BOOL PassRU;
	BOOL PassRD;
	BOOL cycleGesture;
	int forinLoopCount = 0;
	CGPoint prevPos = [[touchedTrace objectAtIndex:0] CGPointValue];
	for(NSValue * o in touchedTrace) {
		forinLoopCount ++;
		BOOL nextIfPass;
		
		if (forinLoopCount > 0) { // 두번쨰 인덱스부터 비교하기위해
			CGPoint pos = [o CGPointValue];
			
			if (prevPos.x > pos.x && prevPos.y < pos.y && !PassLD && !nextIfPass) {
				PassLD = YES;
				nextIfPass = YES;
			}
			if (PassLD && !nextIfPass) {
				if (prevPos.x < pos.x && prevPos.y < pos.y) {
					PassLU = YES;
					nextIfPass = YES;
				}
			}
			if (PassLU && !nextIfPass) {
				if (prevPos.x < pos.x && prevPos.y > pos.y) {
					PassRU = YES;
					nextIfPass = YES;
				}
			}
			if (PassRU && !nextIfPass) {
				if (prevPos.x > pos.x && prevPos.y > pos.y) {
					PassRD = YES;
					//nextIfPass = YES;
				}
			}
			if (PassRD) {
				cycleGesture = YES;
			}

		}
		
		prevPos = [o CGPointValue]; //이전의 포인트 
	}
*/
	
	BOOL HintGesture = NO;
	BOOL PrevDown = NO;
	BOOL directionDent = NO;
	int forinLoopCount = 0;
	CGPoint prevPos = [[touchedTrace objectAtIndex:0] CGPointValue];
	CGPoint beginPos = prevPos;
	CGPoint vertexPoint;
	CGPoint EndPoint;
	
	for(NSValue * o in touchedTrace) {
		forinLoopCount ++;
		CGPoint pos = [o CGPointValue];
		if (forinLoopCount > 0) { // 두번쨰 인덱스부터 비교하기위해
			if (prevPos.x < pos.x) {
				if (prevPos.y > pos.y) {
					PrevDown = YES;
				}else {
					if (PrevDown) {
						
						if (directionDent == NO) {
							directionDent = YES;
							vertexPoint = prevPos;
						}

					}
				}

			}
		}
		EndPoint = pos;
		prevPos = pos; //이전의 포인트 
	}
	if (directionDent) {
		if (beginPos.x < vertexPoint.x && vertexPoint.x < EndPoint.x) {
			if (beginPos.y > vertexPoint.y && vertexPoint.y < EndPoint.y) {
				HintGesture = YES;
			}
		}
		//printf("\ndirectionDent");
		//printf("begin x:%f y:%f  Dent x:%f y:%f End x:%f y:%f",beginPos.x,beginPos.y,vertexPoint.x,vertexPoint.y,EndPoint.x,EndPoint.y);
	}
	
	
	if (HintGesture) { 
		[PM GButtonEventListener:HINT];
		//printf("\nCycle Gestureaaaa");
	}else { //사이클 제스춰가 아니면 인 아웃 판정
		
//		if (bP.x < eP.x && bP.y > eP.y) {
//			//NSLog(@"IN");
//			[PM GButtonEventListener:IN];
//		}else if (bP.x > eP.x && bP.y < eP.y) {
//			//NSLog(@"OUT");
//			[PM GButtonEventListener:OUT];
//		}
        if (eP.x > bP.x) {
            [PM GButtonEventListener:IN];
            //[[SoundManager sharedSM] playSound:@"0080.wav"];
        }else if(eP.x < bP.x){
            [PM GButtonEventListener:OUT];
            [[SoundManager sharedSM] playSound:@"flyOut.wav"]; //테일즈 효과음 0382.wav 
        }
	}

	
	[[GameCondition sharedGameCondition] setTouchingPlayScene:NO];

}

-(void)buttonCallback:(id)sender {

}

-(void)loop:(ccTime)delta 
{	
    //NSLog(@"loop");
    if(initGameOfAll){
        //NSLog(@"initGameOfAll");
		[PM centerProgressLoop:delta];
    }
    
}


-(void)GoMain{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[WorldMap scene]]];
    
    [[AudioPlayer sharedAudioPlayer] allStopAudio];
    [[AudioPlayer sharedAudioPlayer] playAudio:@"world.mp3"];
}

-(void)restartStage {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2 scene:[PlayScene sceneWithStageCode:[GameCondition sharedGameCondition].stageCode]]];
	//[[CCDirector sharedDirector] replaceScene:[PlayScene sceneWithStageCode:[GameCondition sharedGameCondition].stageCode]];

}

-(void)dealloc {
	[self unschedule:@selector(loop:)];
	//NSLog(@"PS goMain");
	[PM release];
	[SPM release];
	//NSLog(@"PS goMain");
	

	
	[touchedTrace removeAllObjects];
	
	[touchedTrace release];
	
    NSLog(@"PlayScene");
	[[CCTextureCache sharedTextureCache] removeAllTextures];
	
	[super dealloc];
	NSLog(@"PlayScene Dealloc");
	
}
@end