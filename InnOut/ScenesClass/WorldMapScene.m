//
//  WorldMapScene.m
//  KeepinTheMind
//
//  Created by JinUng Han on 11. 5. 13..
//  Copyright 2011 Student. All rights reserved.
//

#import "WorldMapScene.h"
#import "GameCondition.h"
#import "PlayScene.h"
#import "DiffusionEffect.h"
#import "CloudEngine.h"
#import "WindMill.h"
#import "FallingEffect.h"
#import "FrameAnimator.h"
#import "ShineEffect.h"
#import "GameMainScene.h"

@interface WorldMap (privateMethods)
-(void)loop:(ccTime)d;
-(void)inStageCallback:(id)sender;
-(void)backCallBack:(id)sender;
@end

@implementation WorldMap

+(id)scene {
	
	WorldMap *worldMap = [WorldMap node];
	
	CCScene *scene = [CCScene node];
	
	
	[scene addChild:worldMap];
	return scene;
}

-(id)init {
	if ( ( self = [super init] )) {
		backSky = [CCSprite spriteWithFile:@"worldMap_back.jpg"];
		backSky.anchorPoint = ccp(0.5f,0.5f);
		backSky.position = ccp(240,160);
		//backSky.scale = 0.5f;
		[self addChild:backSky]; 
		
		cloudEngine = [[[CloudEngine alloc] init] autorelease];
		cloudEngine.scale = 1.4f;
		cloudEngine.position = ccp(-100,-50);
		
		cloudEngine2 = [[[CloudEngine alloc] init] autorelease];
		
		ssun = [[[Sun alloc] initSun] autorelease];
		[[ssun sun] setTexture:[[CCTextureCache sharedTextureCache] addImage:@"worldMap_Sun.png"]];
		[[ssun sun] setTextureRect:CGRectMake(0,0,[[[ssun sun] texture] contentSize].width,[[[ssun sun] texture] contentSize].height)];
		ssun.anchorPoint = ccp(0.5f,0.5f);
		ssun.position = ccp(210,250);
		ssun.scale = 0.65f;
		
		[self addChild:ssun];
		[self addChild:cloudEngine2];
		[self addChild:cloudEngine];
		
		CCSprite * sea = [CCSprite spriteWithFile:@"WorldMap_eastSea.png"];
        sea.anchorPoint = ccp(0,0);
        [self addChild:sea];
		
		worldLayer = [CCLayer node];
		worldLayer.anchorPoint = ccp(0.5f,0.5f);
		worldLayer.position = ccp(240,100);
		[self addChild:worldLayer];
		
		natureLayer = [CCLayer node];
		natureLayer.anchorPoint = ccp(0.5f,0.5f);
		natureLayer.position = ccp(240,100);
		[self addChild:natureLayer];
		
		world = [CCSprite spriteWithFile:@"island.png"];
		world.anchorPoint = ccp(0.5f,0.5f);
		world.position = ccp(0,0);
		//world.scale = 0.5f;
		[worldLayer addChild:world];
		
		worldYmove = 3;
		Ycount = 0;
		
		windMill1 = [[[WindMill alloc] init] autorelease];
		windMill1.position = ccp(0,63);
		windMill1.anchorPoint = ccp(0.5f,0);
		windMill1.scale = .14f;
		[worldLayer addChild:windMill1];
		
		windMill2 = [[[WindMill alloc] init] autorelease];
		windMill2.position = ccp(-20,60);
		windMill2.anchorPoint = ccp(0.5f,0);
		windMill2.scale = .2f;
		[worldLayer addChild:windMill2];
		
		windMill3 = [[[WindMill alloc] init] autorelease];
		windMill3.position = ccp(2,47);
		windMill3.anchorPoint = ccp(0.5f,0);
		windMill3.scale = .3f;
		[worldLayer addChild:windMill3];
		
		sunShine = [CCSprite spriteWithFile:@"worldMap_SunShine.png"];
		sunShine.anchorPoint = ccp(0.5f,1);
		sunShine.position = ccp(-40,150);
		sunShine.opacity = sunShinedele = 255;
		[natureLayer addChild:sunShine];
		
		sunShine2 = [CCSprite spriteWithFile:@"worldMap_SunShine.png"];
		sunShine2.anchorPoint = ccp(0.5f,1);
		sunShine2.position = ccp(-40,150);
		sunShine2.rotation = 30;
		sunShine2.opacity = sunShine2dele = 1;
		[natureLayer addChild:sunShine2];

		CCMenuItem * backMenu = [CCMenuItemImage itemFromNormalImage:@"b_back_simple.png" selectedImage:@"b_back_simple.png" target:self selector:@selector(backCallBack:)];
		backMenu.anchorPoint = ccp(0,1);
		backMenu.position = ccp(-220,200);

		//최종적으로 열린 스테이지코드 알아내기
		GameCondition * GC = [GameCondition sharedGameCondition];
		NSString *possibleStageCode = [GC possibleStageCode];
		NSArray * pscodes = [possibleStageCode componentsSeparatedByString:@","];
		LastOpenedStageCode = 1; //테스트용변수 test
		for (NSString * str in pscodes) {
			LastOpenedStageCode = fmax([str intValue], LastOpenedStageCode);
		}

		b_stage1 = [CCMenuItemImage itemFromNormalImage:@"Stage_board_s1.png" selectedImage:@"Stage_board_s1.png" target:self selector:@selector(inStageCallback:)];
		b_stage2 = [CCMenuItemImage itemFromNormalImage:@"Stage_board_s2.png" selectedImage:@"Stage_board_s2.png" target:self selector:@selector(inStageCallback:)];
		b_stage3 = [CCMenuItemImage itemFromNormalImage:@"Stage_board_s3.png" selectedImage:@"Stage_board_s3.png" target:self selector:@selector(inStageCallback:)];
		b_stage4 = [CCMenuItemImage itemFromNormalImage:@"Stage_board_s4.png" selectedImage:@"Stage_board_s4.png" target:self selector:@selector(inStageCallback:)];
		b_stage5 = [CCMenuItemImage itemFromNormalImage:@"Stage_board_s5.png" selectedImage:@"Stage_board_s5.png" target:self selector:@selector(inStageCallback:)];
        b_stage6 = [CCMenuItemImage itemFromNormalImage:@"Stage_board_s6.png" selectedImage:@"Stage_board_s6.png" target:self selector:@selector(inStageCallback:)];
        
		b_stage1.tag = STAGE_1;
		b_stage2.tag = STAGE_2;
		b_stage3.tag = STAGE_3;
		b_stage4.tag = STAGE_4;
		b_stage5.tag = STAGE_5;
		b_stage6.tag = STAGE_6;
		b_stage1.anchorPoint=
		b_stage2.anchorPoint=
		b_stage3.anchorPoint=
		b_stage4.anchorPoint=
		b_stage5.anchorPoint=
        b_stage6.anchorPoint= ccp(0,0);
        
		b_stage1.position = ccp(-40,40);
		b_stage2.position = ccp(110,30);
		b_stage3.position = ccp(-200,-20);
		b_stage4.position = ccp(-170,90);
		b_stage5.position = ccp(80,110);
		b_stage6.position = ccp(120,-40);
        
		CCMenu * menu = [CCMenu menuWithItems:b_stage1,b_stage2,b_stage3,b_stage4,b_stage5,/*b_stage6,*/backMenu,nil];
		menu.anchorPoint = ccp(0,0);
		menu.position = ccp(0,0);
		
		banPlaceStage2 = [CCSprite spriteWithFile:@"worldMap_banPlace.png"];
		banPlaceStage3 = [CCSprite spriteWithFile:@"worldMap_banPlace.png"];
		banPlaceStage4 = [CCSprite spriteWithFile:@"worldMap_banPlace.png"];
		banPlaceStage5 = [CCSprite spriteWithFile:@"worldMap_banPlace.png"];
		banPlaceStage2.anchorPoint=
		banPlaceStage3.anchorPoint=
		banPlaceStage4.anchorPoint=
		banPlaceStage5.anchorPoint= ccp(0.5f,0.5f);
		
		banPlaceStage2.position = ccp(90,40);
		banPlaceStage3.position = ccp(-120,-10);
		banPlaceStage4.position = ccp(-100,100);
		banPlaceStage5.position = ccp(110,110);
		
		[natureLayer addChild:banPlaceStage2];
		[natureLayer addChild:banPlaceStage3];
		[natureLayer addChild:banPlaceStage4];
		[natureLayer addChild:banPlaceStage5];
		[natureLayer addChild:menu];
		
		if (LastOpenedStageCode == 1) {
			//b_stage2.visible = b_stage3.visible = b_stage4.visible = b_stage5.visible = NO;
			[b_stage2 setIsEnabled:NO];
			[b_stage3 setIsEnabled:NO];
			[b_stage4 setIsEnabled:NO];
			b_stage6.visible = NO;
			[b_stage5 setIsEnabled:NO];
			[b_stage6 setIsEnabled:NO];
	
		}else if (LastOpenedStageCode == 2) {
			//b_stage3.visible = b_stage4.visible = b_stage5.visible = NO;
			[b_stage3 setIsEnabled:NO];
			[b_stage4 setIsEnabled:NO];
			b_stage6.visible = NO;
			[b_stage5 setIsEnabled:NO];
			[b_stage6 setIsEnabled:NO];
			
			banPlaceStage2.visible = NO;
			//banPlaceStage2
		}else if (LastOpenedStageCode == 3) {
			//b_stage4.visible = b_stage5.visible = NO;
			[b_stage4 setIsEnabled:NO];
			b_stage6.visible = NO;
			[b_stage5 setIsEnabled:NO];
			[b_stage6 setIsEnabled:NO];
			
			banPlaceStage2.visible = NO;
			banPlaceStage3.visible = NO;
		}else if (LastOpenedStageCode == 4) {
			//b_stage5.visible = NO;
            b_stage6.visible = NO;
			[b_stage5 setIsEnabled:NO];
			[b_stage6 setIsEnabled:NO];
            
			banPlaceStage2.visible = NO;
			banPlaceStage3.visible = NO;
			banPlaceStage4.visible = NO;
		}else if (LastOpenedStageCode == 5) {
			if (GC.japanLock) {
                [b_stage6 setIsEnabled:NO];
                b_stage6.visible = NO;
            }else{
                b_stage6.visible = YES;
            }
			banPlaceStage2.visible = NO;
			banPlaceStage3.visible = NO;
			banPlaceStage4.visible = NO;
			banPlaceStage5.visible = NO;
		}
		
		
		
		if (LastOpenedStageCode >= 1) {
			
			if (LastOpenedStageCode >= 2) {
				CGPoint fallingPos1 = ccp(115,38);
				CGPoint fallingPos2 = ccp(110,37);
				CGPoint fallingPos3 = ccp(104,35);
				
				CGPoint fallingPos4 = ccp(68,24);
				CGPoint fallingPos5 = ccp(74,23);
				CGPoint fallingPos6 = ccp(80,22);
				
				CGPoint fallingPos7 = ccp(156,53);
				
				s_2_dust1 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"s2_dust1.png" Begin:3.2 Delay:-1 Restart:-1 DiffusionSpeed:1.5f DiffusionScale:3] autorelease];
				s_2_dust1.position = fallingPos1;
				
				s_2_fallingRock1 = [[[FallingEffect alloc] initWithFileAndTime:@"stone1.png" Begin:3.2 Delay:1 Restart:-1 FallingSpeed:300 _Duration:1] autorelease];
				[s_2_fallingRock1 setBeginPosition:fallingPos1];
				s_2_fallingRock1.runReceiver = s_2_dust1;


				s_2_dust2 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"s2_dust2.png" Begin:3.1 Delay:-1 Restart:-1 DiffusionSpeed:1.5f DiffusionScale:3] autorelease];
				s_2_dust2.position = fallingPos2;
				
				s_2_fallingRock2 = [[[FallingEffect alloc] initWithFileAndTime:@"stone2.png" Begin:3.1 Delay:1 Restart:-1 FallingSpeed:400 _Duration:1] autorelease];
				[s_2_fallingRock2 setBeginPosition:fallingPos2];
				s_2_fallingRock2.runReceiver = s_2_dust3;


				s_2_dust3 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"s2_dust3.png" Begin:3 Delay:-1 Restart:-1 DiffusionSpeed:1.5f DiffusionScale:3] autorelease];
				s_2_dust3.position = fallingPos3;
				
				s_2_fallingRock3 = [[[FallingEffect alloc] initWithFileAndTime:@"stone3.png" Begin:3 Delay:1 Restart:-1 FallingSpeed:350 _Duration:1] autorelease];
				[s_2_fallingRock3 setBeginPosition:fallingPos3];
				s_2_fallingRock3.runReceiver = s_2_dust3;
				
				
				s_2_dust4 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"s2_dust2.png" Begin:0 Delay:-1 Restart:-1 DiffusionSpeed:1.5f DiffusionScale:3] autorelease];
				s_2_dust4.position = fallingPos4;
				
				s_2_fallingRock4 = [[[FallingEffect alloc] initWithFileAndTime:@"stone3.png" Begin:0 Delay:1 Restart:-1 FallingSpeed:590 _Duration:1] autorelease];
				[s_2_fallingRock4 setBeginPosition:fallingPos4];
				s_2_fallingRock4.runReceiver = s_2_dust4;
				
				
				s_2_dust5 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"s2_dust3.png" Begin:0.2f Delay:-1 Restart:-1 DiffusionSpeed:1.5f DiffusionScale:3] autorelease];
				s_2_dust5.position = fallingPos5;
				
				s_2_fallingRock5 = [[[FallingEffect alloc] initWithFileAndTime:@"stone2.png" Begin:0.2f Delay:1 Restart:-1 FallingSpeed:350 _Duration:1] autorelease];
				[s_2_fallingRock5 setBeginPosition:fallingPos5];
				s_2_fallingRock5.runReceiver = s_2_dust5;
				
				
				s_2_dust6 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"s2_dust1.png" Begin:0.1f Delay:-1 Restart:-1 DiffusionSpeed:1.5f DiffusionScale:3] autorelease];
				s_2_dust6.position = fallingPos6;
				
				s_2_fallingRock6 = [[[FallingEffect alloc] initWithFileAndTime:@"stone1.png" Begin:0.1f Delay:1 Restart:-1 FallingSpeed:440 _Duration:1] autorelease];
				[s_2_fallingRock6 setBeginPosition:fallingPos6];
				s_2_fallingRock6.runReceiver = s_2_dust6;

				
				s_2_dust7 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"s2_dust1.png" Begin:3.1f Delay:-1 Restart:-1 DiffusionSpeed:1.5f DiffusionScale:3] autorelease];
				s_2_dust7.position = fallingPos7;
				
				s_2_fallingRock7 = [[[FallingEffect alloc] initWithFileAndTime:@"stone1.png" Begin:3.1f Delay:1 Restart:-1 FallingSpeed:440 _Duration:1] autorelease];
				[s_2_fallingRock7 setBeginPosition:fallingPos7];
				s_2_fallingRock7.runReceiver = s_2_dust7;
				
				[worldLayer addChild:s_2_fallingRock1];
				[worldLayer addChild:s_2_fallingRock2];
				[worldLayer addChild:s_2_fallingRock3];
				[worldLayer addChild:s_2_fallingRock4];
				[worldLayer addChild:s_2_fallingRock5];
				[worldLayer addChild:s_2_fallingRock6];
				[worldLayer addChild:s_2_fallingRock7];
				[worldLayer addChild:s_2_dust1];
				[worldLayer addChild:s_2_dust2];
				[worldLayer addChild:s_2_dust3];
				[worldLayer addChild:s_2_dust4];
				[worldLayer addChild:s_2_dust5];
				[worldLayer addChild:s_2_dust6];
				[worldLayer addChild:s_2_dust7];
				
				
				s_2_windEffect = [[[FrameAnimator alloc] initWithAnimationSheet:@"wind41x22.5.png" FrameMap:@"0/1/2/3/4/5/6/7/8/9/10/11" FrameLength:12 FrameSize:CGSizeMake(41, 22.5f) _FPS:24 Begin:0 Delay:2 Restart:-1] autorelease];
				s_2_windEffect.anchorPoint = ccp(0.5f,0.5f);
				s_2_windEffect.position = ccp(70,40);
				[worldLayer addChild:s_2_windEffect];
				
				s_2_windEffect2 = [[[FrameAnimator alloc] initWithAnimationSheet:@"wind41x22.5.png" FrameMap:@"0/1/2/3/4/5/6/7/8/9/10/11" FrameLength:12 FrameSize:CGSizeMake(41, 22.5f) _FPS:24 Begin:0.2f Delay:1.8f Restart:-1] autorelease];
				s_2_windEffect2.anchorPoint = ccp(0.5f,0.5f);
				s_2_windEffect2.position = ccp(110,60);
				[worldLayer addChild:s_2_windEffect2];
				
				if (LastOpenedStageCode >=3 ) {
					s_3_cascadeClode1 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"waterDust4.png" Begin:0 Delay:0.1f Restart:-1 DiffusionSpeed:2.0f DiffusionScale:3.0f] autorelease];
					s_3_cascadeClode1.position = ccp(-105,-80);
					s_3_cascadeClode1.rotation = 100;
					[s_3_cascadeClode1 setBeginScale:0.5f];
					[worldLayer addChild:s_3_cascadeClode1];
					
					s_3_cascadeClode2 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"waterDust4.png" Begin:0.3f Delay:0.2f Restart:-1 DiffusionSpeed:2.0f DiffusionScale:2.0f] autorelease];
					s_3_cascadeClode2.position = ccp(-125,-70);
					s_3_cascadeClode2.rotation = 200;
					[s_3_cascadeClode2 setBeginScale:0.5f];
					[worldLayer addChild:s_3_cascadeClode2];
					
					s_3_cascadeClode3 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"waterDust4.png" Begin:1 Delay:0.1f Restart:-1 DiffusionSpeed:3.0f DiffusionScale:5.0f] autorelease];
					s_3_cascadeClode3.position = ccp(-115,-75);
					s_3_cascadeClode3.rotation = 240;
					[s_3_cascadeClode3 setBeginScale:0];
					[worldLayer addChild:s_3_cascadeClode3];
					
					s_3_cascadeClode4 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"waterDust4.png" Begin:1.5f Delay:0.0f Restart:-1 DiffusionSpeed:4.0f DiffusionScale:5.5f] autorelease];
					s_3_cascadeClode4.position = ccp(-115,-85);
					s_3_cascadeClode4.rotation = 420;
					[s_3_cascadeClode4 setBeginScale:0];
					[worldLayer addChild:s_3_cascadeClode4];
					
					s_3_cascadeClode5 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"waterDust4.png" Begin:0.5f Delay:0.0f Restart:-1 DiffusionSpeed:4.0f DiffusionScale:5.5f] autorelease];
					s_3_cascadeClode5.position = ccp(-100,-90);
					s_3_cascadeClode5.rotation = 300;
					[s_3_cascadeClode5 setBeginScale:0];
					[worldLayer addChild:s_3_cascadeClode5];
					
					s_3_cascadeClode6 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"waterDust4.png" Begin:1.0f Delay:0.0f Restart:-1 DiffusionSpeed:2.5f DiffusionScale:3.5f] autorelease];
					s_3_cascadeClode6.position = ccp(-95,-85);
					s_3_cascadeClode6.rotation = 350;
					[s_3_cascadeClode6 setBeginScale:0];
					[worldLayer addChild:s_3_cascadeClode6];
					
					s_3_cascadeClode7 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"waterDust4.png" Begin:0.0f Delay:0.0f Restart:-1 DiffusionSpeed:2.5f DiffusionScale:3.5f] autorelease];
					s_3_cascadeClode7.position = ccp(-105,-95);
					s_3_cascadeClode7.rotation = 670;
					[s_3_cascadeClode7 setBeginScale:0];
					[worldLayer addChild:s_3_cascadeClode7];
					
					
					s_3_blueVapor1 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"waterDownFlow3.png" Begin:0.5f Delay:0.0f Restart:-1 DiffusionSpeed:0.5f DiffusionScale:1.0f] autorelease];
					s_3_blueVapor1.position = ccp(-120,-35);
					[s_3_blueVapor1 setBeginScale:0];
					[worldLayer addChild:s_3_blueVapor1];

					s_3_blueVapor2 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"waterDust3.png" Begin:0.5f Delay:0.5f Restart:-1 DiffusionSpeed:0.5f DiffusionScale:1] autorelease];
					s_3_blueVapor2.position = ccp(-103,-35);
					[s_3_blueVapor2 setBeginScale:0.2f];
					[worldLayer addChild:s_3_blueVapor2];
					
					
					s_3_pondWave1 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"waterFlow2.png" Begin:0.1f Delay:0.0f Restart:-1 DiffusionSpeed:0.5f DiffusionScale:1.7f] autorelease];
					s_3_pondWave1.position = ccp(-70,35);
					[s_3_pondWave1 setBeginScale:0.2f];
					[worldLayer addChild:s_3_pondWave1];
					
					s_3_pondWave2 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"waterFlow2.png" Begin:0.25f Delay:0.0f Restart:-1 DiffusionSpeed:0.5f DiffusionScale:1.7f] autorelease];
					s_3_pondWave2.position = ccp(-70,35);
					[s_3_pondWave2 setBeginScale:0.2f];
					[worldLayer addChild:s_3_pondWave2];
					
					s_3_pondWave3 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"waterFlow2.png" Begin:0.4f Delay:0.0f Restart:-1 DiffusionSpeed:0.5f DiffusionScale:1.7f] autorelease];
					s_3_pondWave3.position = ccp(-70,35);
					[s_3_pondWave3 setBeginScale:0.2f];
					[worldLayer addChild:s_3_pondWave3];
					
					
										
					if (LastOpenedStageCode >= 4) {
						s_4_forestAir1 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"forest_air.png" Begin:1 Delay:1 Restart:-1 DiffusionSpeed:1.0f DiffusionScale:2.0f] autorelease];
						s_4_forestAir1.position = ccp(-100,70);
						[s_4_forestAir1 setBeginScale:0];
						[worldLayer addChild:s_4_forestAir1];
						
						s_4_forestAir2 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"forest_air2.png" Begin:2 Delay:2 Restart:-1 DiffusionSpeed:1.0f DiffusionScale:2.0f] autorelease];
						s_4_forestAir2.position = ccp(-80,80);
						[s_4_forestAir2 setBeginScale:0];
						[worldLayer addChild:s_4_forestAir2];
						
						s_4_forestAir3 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"forest_air3.png" Begin:3 Delay:1.5f Restart:-1 DiffusionSpeed:1.0f DiffusionScale:2.0f] autorelease];
						s_4_forestAir3.position = ccp(-90,70);
						[s_4_forestAir3 setBeginScale:0];
						[worldLayer addChild:s_4_forestAir3];
						
						s_4_forestAir4 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"forest_air4.png" Begin:2.5f Delay:2 Restart:-1 DiffusionSpeed:1.0f DiffusionScale:2.0f] autorelease];
						s_4_forestAir4.position = ccp(-110,60);
						[s_4_forestAir4 setBeginScale:0];
						[worldLayer addChild:s_4_forestAir4];
						
						s_4_forestAir5 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"waterDust4.png" Begin:2.5f Delay:0.5f Restart:-1 DiffusionSpeed:1.0f DiffusionScale:2.5f] autorelease];
						s_4_forestAir5.position = ccp(-106,65);
						s_4_forestAir5.rotation = 100;
						[s_4_forestAir5 setBeginScale:0];
						[worldLayer addChild:s_4_forestAir5];
						
						s_4_forestAir6 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"waterDust4.png" Begin:3.5f Delay:0.5f Restart:-1 DiffusionSpeed:1.0f DiffusionScale:3.0f] autorelease];
						s_4_forestAir6.position = ccp(-85,70);
						s_4_forestAir6.rotation = -110;
						[s_4_forestAir6 setBeginScale:0];
						[worldLayer addChild:s_4_forestAir6];
						
						if (LastOpenedStageCode >= 5) {
                            
                            
							s_5_firing1 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"volcano_fire2.png" Begin:0 Delay:2 Restart:-1 DiffusionSpeed:3 DiffusionScale:2] autorelease];
							[s_5_firing1 setBeginScale:0.4f];
							s_5_firing1.anchorPoint = ccp(0.5f,0);
							s_5_firing1.position = ccp(110,100);
							[worldLayer addChild:s_5_firing1];
							
							s_5_firing2 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"volcano_fire2.png" Begin:0 Delay:1 Restart:-1 DiffusionSpeed:2 DiffusionScale:1.5f] autorelease];
							[s_5_firing2 setBeginScale:0.4f];
							s_5_firing2.anchorPoint = ccp(0.0f,0);
							s_5_firing2.position = ccp(112,100);
							[worldLayer addChild:s_5_firing2];
							
							s_5_firing3 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"volcano_fire3.png" Begin:0 Delay:1.5f Restart:-1 DiffusionSpeed:1.5f DiffusionScale:1.5f] autorelease];
							[s_5_firing3 setBeginScale:0.4f];
							s_5_firing3.anchorPoint = ccp(1.0f,0);
							s_5_firing3.position = ccp(108,100);
							[worldLayer addChild:s_5_firing3];
							
							s_5_firing4 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"volcano_fire2.png" Begin:0 Delay:2.5f Restart:-1 DiffusionSpeed:3 DiffusionScale:1.0f] autorelease];
							[s_5_firing4 setBeginScale:0.4f];
							s_5_firing4.anchorPoint = ccp(0.5f,0.5f);
							s_5_firing4.position = ccp(109.5f,110);
							[worldLayer addChild:s_5_firing4];
							
							s_5_firing5 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"volcano_fire2.png" Begin:0 Delay:0.5f Restart:-1 DiffusionSpeed:1 DiffusionScale:1.3f] autorelease];
							[s_5_firing5 setBeginScale:0.5f];
							s_5_firing5.anchorPoint = ccp(0.5f,0.5f);
							s_5_firing5.position = ccp(96,97);
							[worldLayer addChild:s_5_firing5];
							
							s_5_firing6 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"volcano_fire2.png" Begin:1 Delay:0.5f Restart:-1 DiffusionSpeed:1 DiffusionScale:1.0f] autorelease];
							[s_5_firing6 setBeginScale:0.2f];
							s_5_firing6.anchorPoint = ccp(0.5f,0.5f);
							s_5_firing6.position = ccp(102,94);
							[worldLayer addChild:s_5_firing6];
							
							s_5_firing7 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"volcano_fire2.png" Begin:2 Delay:0.5f Restart:-1 DiffusionSpeed:1 DiffusionScale:1.2f] autorelease];
							[s_5_firing7 setBeginScale:0.2f];
							s_5_firing7.anchorPoint = ccp(0.5f,0.5f);
							s_5_firing7.position = ccp(109.5f,94);
							[worldLayer addChild:s_5_firing7];
							
							s_5_volcanoFire = [CCSprite spriteWithFile:@"volcano_fire.png"];
							s_5_volcanoFire.anchorPoint = ccp(0.5f,0.5f);
							s_5_volcanoFire.position = ccp(103,100);
							s_5_volcanoFireTopa = 255;
							s_5_volcanoFireDele = 200;
							[worldLayer addChild:s_5_volcanoFire];
                            
                            lightningNum = 10;
                            lightnings = malloc(sizeof(ShineEffect*)*lightningNum);
                            for (int i = 0; i <lightningNum; i++) {
                                ShineEffect * lightning = [[[ShineEffect alloc] initWithSource:[NSString stringWithFormat:@"stage5_Lightning0%d.png",i%9+1]] autorelease];
                                lightning.anchorPoint = ccp(0.5f,0);
                                [lightning setOpacityRange:0 Max:1];
                                [lightning setShineNum:2];
                                [lightning setDelay:6];
                                [lightning setDuration:0.5f];
                                [lightning setBeginDelay:rand()%40];
                                [lightning setTransferShineRange:2];
                                [lightning setTransferDelayRange:10];
                                [lightning setTransferDurationRange:0.3f];
                                [lightning setTransferPositionRect:CGRectMake(300, 180, 120, 20)];
                                [lightning setAngleRange:-20 Max:20];
                                [lightning setTransferScaleRange:30 Max:60];
                                [self addChild:lightning];
                                lightnings[i] = lightning;
                            }
                            
                            firesNum = 100;
                            fires = malloc(sizeof(ShineEffect*)*firesNum);
                            for (int i = 0; i <firesNum; i++) {
                                ShineEffect * fire = [[[ShineEffect alloc] initWithSource:[NSString stringWithFormat:@"stage5_VolcanoSmoke0%d.png",i%6+1]] autorelease];
                                fire.anchorPoint = ccp(0.5f,0);
                                [fire setOpacityRange:0 Max:0.8f];
                                
                                [fire setDelay:0];
                                
                                [fire setBeginDelay:rand()%10];
                                //[fire setTransferShineRange:2];
                                //[fire setTransferDelayRange:10];
                                [fire setTransferDurationRange:6];
                                
                                [fire setIncreaseScaleRange:0.1f Max:0.2f];
                                [fire setAngleRange:0 Max:360];
                                [fire setTransferScaleRange:30 Max:55];
                                
                                if (i < (firesNum / 3) ) {
                                    [fire setShineNum:1];
                                    [fire setDuration:2];
                                    [fire setTransferPositionRect:CGRectMake(310, 200, 5, 5)];
                                    [fire setIncreasePositionRect:CGRectMake(-8, 15, 8, 30)];
                                }else if (i < (firesNum / 3)*2 + 3) {
                                    [fire setShineNum:2];
                                    [fire setDuration:3];
                                    [fire setTransferPositionRect:CGRectMake(345, 200, 5, 5)];
                                    [fire setIncreasePositionRect:CGRectMake(-12, 15, 12, 30)];
                                }else{
                                    [fire setShineNum:2];
                                    [fire setDuration:3];
                                    [fire setTransferPositionRect:CGRectMake(375, 200, 5, 5)];
                                    [fire setIncreasePositionRect:CGRectMake(-14, 15, 14, 30)];
                                }
                                
                                [self addChild:fire];
                                fires[i] = fire;
                            }
                        
							
						}
					}
				}
			}
		}

        //Cloud
        CCSprite * seaCloud1 = [CCSprite spriteWithFile:@"WorldMap_eastCloud1.png"];
        seaCloud1.anchorPoint = ccp(0,0);
        [self addChild:seaCloud1];
//        CCSprite * seaCloud2 = [CCSprite spriteWithFile:@"WorldMap_eastCloud2.png"];
//        seaCloud2.anchorPoint = ccp(0,0);
//        [self addChild:seaCloud2];
//        CCSprite * seaCloud3 = [CCSprite spriteWithFile:@"WorldMap_eastCloud3.png"];
//        seaCloud3.anchorPoint = ccp(0,0);
//        [self addChild:seaCloud3];
		seaCloud2 = [[[ShineEffect alloc] initWithSource:@"WorldMap_eastCloud2.png"] autorelease];
        seaCloud2.anchorPoint = ccp(0,0);
        [seaCloud2 setDuration:2];
        [seaCloud2 setBeginDelay:1];
        [seaCloud2 setDelay:0];
        [seaCloud2 setOpacityRange:0.8f Max:1];
        [self addChild:seaCloud2];
	
        seaCloud3 = [[[ShineEffect alloc] initWithSource:@"WorldMap_eastCloud2.png"] autorelease];
        seaCloud3.anchorPoint = ccp(0,0);
        seaCloud3.scaleX = -1;
        [seaCloud3 setDuration:2];
        [seaCloud3 setBeginDelay:0];
        [seaCloud3 setDelay:0];
        [seaCloud3 setOpacityRange:0.8f Max:1];
        [self addChild:seaCloud3];
        
        seaCloud4 = [[[ShineEffect alloc] initWithSource:@"WorldMap_eastCloud3.png"] autorelease];
        seaCloud4.anchorPoint = ccp(0,0);
        [seaCloud4 setDuration:2];
        [seaCloud4 setBeginDelay:0];
        [seaCloud4 setDelay:0];
        [seaCloud4 setOpacityRange:0.8f Max:1];
        [self addChild:seaCloud4];
        
        CCSprite * TextBack = [CCSprite spriteWithFile:@"blackDot.png"];
        TextBack.anchorPoint = ccp(0,0.5f);
        TextBack.position = ccp(0,40);
        TextBack.scaleX = 480;
        TextBack.scaleY = 50;
        TextBack.opacity = 200;
        [self addChild:TextBack];
        
        if (GC.lang == Language_ko) {
            CCSprite * WorldMap_help = [CCSprite spriteWithFile:@"WorldMap_ko_help.png"];
            WorldMap_help.anchorPoint = ccp(0.5f,0.5f);
            WorldMap_help.position = ccp(240,40);
            [self addChild:WorldMap_help];
        }else if(GC.lang == Language_en){
            CCSprite * WorldMap_help = [CCSprite spriteWithFile:@"WorldMap_en_help.png"];
            WorldMap_help.anchorPoint = ccp(0.5f,0.5f);
            WorldMap_help.position = ccp(240,40);
            [self addChild:WorldMap_help];
        }
        
        //Audio
        
        
        
		self.isTouchEnabled = YES;
		[self schedule:@selector(loop:)];

	}
	return self;
}
				
-(void)loop:(ccTime)d {
    NSLog(@"loop");
	Ycount += d;
	worldLayer.position = ccp(worldLayer.position.x,worldLayer.position.y + worldYmove*d);
	if (Ycount > 1) {
		Ycount = 0;
		worldYmove *= -1;
	}
	[ssun update:d];
	[cloudEngine update:d];
	[cloudEngine2 update:d];
	[windMill1 update:d];
	[windMill2 update:d];
	[windMill3 update:d];
	
	sunShine.opacity = sunShinedele;
	sunShinedele += (0.9f * (sunShineTopa - sunShinedele))*d;
	if (sunShinedele < 0.6f) {
		sunShineTopa = 255;
	}else if (sunShinedele > 254.4f) {
		sunShineTopa = 0;
	}
	sunShine2.opacity = sunShine2dele;
	sunShine2dele += (0.9f * (sunShine2Topa - sunShine2dele))*d;
	if (sunShine2dele < 0.6f) {
		sunShine2Topa = 255;
	}else if (sunShine2dele > 254.4f) {
		sunShine2Topa = 0;
	}
	
	if (LastOpenedStageCode >= 1) {
		
		if (LastOpenedStageCode >= 2) {
			[s_2_dust1 update:d];
			[s_2_fallingRock1 update:d];
			
			[s_2_dust2 update:d];
			[s_2_fallingRock2 update:d];
			
			[s_2_dust3 update:d];
			[s_2_fallingRock3 update:d];
			
			[s_2_dust4 update:d];
			[s_2_fallingRock4 update:d];
			
			[s_2_dust5 update:d];
			[s_2_fallingRock5 update:d];
			
			[s_2_dust6 update:d];
			[s_2_fallingRock6 update:d];
			
			[s_2_dust7 update:d];
			[s_2_fallingRock7 update:d];
			
			[s_2_windEffect update:d];
			[s_2_windEffect2 update:d];
			
			if (LastOpenedStageCode >=3 ) {
				[s_3_cascadeClode1 update:d];
				[s_3_cascadeClode2 update:d];
				[s_3_cascadeClode3 update:d];
				[s_3_cascadeClode4 update:d];
				[s_3_cascadeClode5 update:d];
				[s_3_cascadeClode6 update:d];
				[s_3_cascadeClode7 update:d];
				[s_3_blueVapor1 update:d];
				[s_3_blueVapor2 update:d];
				[s_3_pondWave1 update:d];
				[s_3_pondWave2 update:d];
				[s_3_pondWave3 update:d];
				
				if (LastOpenedStageCode >= 4) {
					[s_4_forestAir1 update:d];
					[s_4_forestAir2 update:d];
					[s_4_forestAir3 update:d];
					[s_4_forestAir4 update:d];
					[s_4_forestAir5 update:d];
					[s_4_forestAir6 update:d];
					
					if (LastOpenedStageCode >= 5) {
						[s_5_firing1 update:d];
						[s_5_firing2 update:d];
						[s_5_firing3 update:d];
						[s_5_firing4 update:d];
						[s_5_firing5 update:d];
						[s_5_firing6 update:d];
						[s_5_firing7 update:d];

						s_5_volcanoFire.opacity = s_5_volcanoFireDele;
						s_5_volcanoFireDele += (0.9f * (s_5_volcanoFireTopa - s_5_volcanoFireDele))*d;
						if (s_5_volcanoFireDele < 160.6f) {
							s_5_volcanoFireTopa = 255;
						}else if (s_5_volcanoFireDele > 254.4f) {
							s_5_volcanoFireTopa = 160;
						}
                        
                        for (int i = 0; i <lightningNum; i++) {
                            
                            [lightnings[i] update:d];
                        }
                        
                        for (int i = 0; i <firesNum; i++) {
                            
                            [fires[i] update:d];
                        }
					}
				}
			}
		}
	}
    
    [seaCloud2 update:d];
    [seaCloud3 update:d];
	[seaCloud4 update:d];
}

-(void)inStageCallback:(id)sender {
	NSLog(@"StageGOGO");
	switch ([sender tag]) {
		case STAGE_1:
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[PlayScene sceneWithStageCode:STAGE_1]]];
			
			break;
		case STAGE_2:
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[PlayScene sceneWithStageCode:STAGE_2]]];
			
			break;
		case STAGE_3:
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[PlayScene sceneWithStageCode:STAGE_3]]];
			
			break;
		case STAGE_4:
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[PlayScene sceneWithStageCode:STAGE_4]]];
			
			break;
		case STAGE_5:
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[PlayScene sceneWithStageCode:STAGE_5]]];
			
			break;
        case STAGE_6:
            if (![GameCondition sharedGameCondition].japanLock) {
                [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[PlayScene sceneWithStageCode:STAGE_6]]];
            }
			break;
		default:
			break;
	}
}

-(void)backCallBack:(id)sender {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameMain scene]]];
	
}

-(void)dealloc{
	NSLog(@"Called");
    free(lightnings);
    free(fires);
    
	[[CCTextureCache sharedTextureCache] removeAllTextures];
	[super dealloc];

}
@end
