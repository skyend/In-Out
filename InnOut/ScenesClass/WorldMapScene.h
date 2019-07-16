//
//  WorldMapScene.h
//  KeepinTheMind
//
//  Created by JinUng Han on 11. 5. 13..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Sun.h"
#import "GameConfig.h"
#import "GameHeaders.h"

@class DiffusionEffect;
@class CloudEngine;
@class WindMill;
@class FallingEffect;
@class FrameAnimator;
@class ShineEffect;

@interface WorldMap : CCLayer {
	int LastOpenedStageCode;
	
	CCSprite * backSky;
	CCLayer * worldLayer;
	CCLayer * natureLayer;
	CCSprite * world;
	WindMill * windMill1;
	WindMill * windMill2;
	WindMill * windMill3;
	
	Sun * ssun;
	CloudEngine * cloudEngine;
	CloudEngine * cloudEngine2;
	CCSprite * sunShine; int sunShineTopa; float sunShinedele;
	CCSprite * sunShine2; int sunShine2Topa; float sunShine2dele;
	
	CCMenuItem * b_stage1;
	CCMenuItem * b_stage2;
	CCMenuItem * b_stage3;
	CCMenuItem * b_stage4;
	CCMenuItem * b_stage5;
	CCMenuItem * b_stage6;
    
	CCSprite * banPlaceStage2;
	CCSprite * banPlaceStage3;
	CCSprite * banPlaceStage4;
	CCSprite * banPlaceStage5;
	
	DiffusionEffect * s_2_dust1;
	FallingEffect	* s_2_fallingRock1;
	
	DiffusionEffect * s_2_dust2;
	FallingEffect	* s_2_fallingRock2;
	
	DiffusionEffect * s_2_dust3;
	FallingEffect	* s_2_fallingRock3;
	
	DiffusionEffect * s_2_dust4;
	FallingEffect	* s_2_fallingRock4;
	
	DiffusionEffect * s_2_dust5;
	FallingEffect	* s_2_fallingRock5;
	
	DiffusionEffect * s_2_dust6;
	FallingEffect	* s_2_fallingRock6;
	
	DiffusionEffect * s_2_dust7;
	FallingEffect	* s_2_fallingRock7;
	
	FrameAnimator * s_2_windEffect;
	FrameAnimator * s_2_windEffect2;
	
	DiffusionEffect * s_3_cascadeClode1;
	DiffusionEffect * s_3_cascadeClode2;
	DiffusionEffect * s_3_cascadeClode3;
	DiffusionEffect * s_3_cascadeClode4;
	DiffusionEffect * s_3_cascadeClode5;
	DiffusionEffect * s_3_cascadeClode6;
	DiffusionEffect * s_3_cascadeClode7;
	DiffusionEffect * s_3_blueVapor1;
	DiffusionEffect * s_3_blueVapor2;
	DiffusionEffect * s_3_blueVapor3;
	DiffusionEffect * s_3_pondWave1;
	DiffusionEffect * s_3_pondWave2;
	DiffusionEffect * s_3_pondWave3;
	
	DiffusionEffect * s_4_forestAir1;
	DiffusionEffect * s_4_forestAir2;
	DiffusionEffect * s_4_forestAir3;
	DiffusionEffect * s_4_forestAir4;
	DiffusionEffect * s_4_forestAir5;
	DiffusionEffect * s_4_forestAir6;
	
	DiffusionEffect * s_5_firing1;
	DiffusionEffect * s_5_firing2;
	DiffusionEffect * s_5_firing3;
	DiffusionEffect * s_5_firing4;
	DiffusionEffect * s_5_firing5;
	DiffusionEffect * s_5_firing6;
	DiffusionEffect * s_5_firing7;
    
    int lightningNum;
    ShineEffect ** lightnings;
    
    int firesNum;
    ShineEffect ** fires;
    
	CCSprite * s_5_volcanoFire; float s_5_volcanoFireTopa; float s_5_volcanoFireDele;
	
    ShineEffect * seaCloud4;
    ShineEffect * seaCloud3;
    ShineEffect * seaCloud2;
    
	float worldYmove;
	float Ycount;
}
+(id)scene;

@end
