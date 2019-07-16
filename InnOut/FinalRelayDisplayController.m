//
//  FinalRelayDisplayController.m
//  Memory0_0
//
//  Created by JinUng Han on 11. 4. 28..
//  Copyright 2011 Student. All rights reserved.
//

#import "FinalRelayDisplayController.h"

#import "ParticleManager.h"
#import "GameCondition.h"

float floatMarkOut(float v) {
	if (v < 0) {
		return v * -1;
	}else {
		return v;
	}
}


@implementation FinalRelayDisplayController
//@synthesize PerfromNormaltoFinalRelay,PerfromFinalRelaytoMaxFinalRelay;

-(id)initWithLayer:(CCLayer*)BackGround_ coverLayer:(CCLayer*)CoverLayer_ {
	
	if ( (self = [super init]) ) {
		CoverLayer = CoverLayer_;
		BackGround = BackGround_;
		
//		finalRelayBackGround = [CCSprite spriteWithFile:@"finalRelay_back_02.png"];
//		finalRelayBackGround.anchorPoint = ccp(0,0);
//		finalRelayBackGround.position = ccp(0,0);
//		finalRelayBackGround.opacity = 0;
//		finalRelayBackGround.scaleX = 480;
//		//[finalRelayBackGround setBlendFunc:(ccBlendFunc){GL_DST_COLOR,GL_ONE_MINUS_SRC_ALPHA}];
//		//[CoverLayer addChild:finalRelayBackGround z:20];
//		[BackGround addChild:finalRelayBackGround z:20];
		
		
		//FinalRelay init
		FRCoverLayer = [CCLayer node];
		[FRCoverLayer setVisible:NO];
		[CoverLayer addChild:FRCoverLayer];
		
		
		FRMessage = [CCSprite spriteWithFile:@"FinalRelayMessage.png"];
		FRMessage.anchorPoint = ccp(0.5f,0.5f);
		FRMessage.position = ccp(480+(FRMessage.contentSize.width/2),160);
		
		FRMessage_moving = [CCSprite spriteWithFile:@"FinalRelayMessage_moving.png"];
		FRMessage_moving.anchorPoint = ccp(0.5f,0.5f);
		FRMessage_moving.position = ccp(480+(FRMessage.contentSize.width/2),160);
		
		[FRCoverLayer addChild:FRMessage];
		[FRCoverLayer addChild:FRMessage_moving];
		
		FRMessageAni = NO;
		FRMessageAni_targetX = 480+(FRMessage.contentSize.width/2);
		//FinalRelay init end
		
		//MaxFinalRelay init
		MFRCoverLayer = [CCLayer node];
		[MFRCoverLayer setVisible:NO];
		[CoverLayer addChild:MFRCoverLayer];
		
		
		MFRMessage = [CCSprite spriteWithFile:@"MaxFinalRelayMessage.png"];
		MFRMessage.anchorPoint = ccp(0.5f,0.5f);
		MFRMessage.position = ccp(480+(MFRMessage.contentSize.width/2),160);
		
		MFRMessage_moving = [CCSprite spriteWithFile:@"MaxFinalRelayMessage_moving.png"];
		MFRMessage_moving.anchorPoint = ccp(0.5f,0.5f);
		MFRMessage_moving.position = ccp(480+(MFRMessage.contentSize.width/2),160);
		
		[MFRCoverLayer addChild:MFRMessage];
		[MFRCoverLayer addChild:MFRMessage_moving];
		
		MFRMessageAni = NO;
		MFRMessageAni_targetX = 480+(MFRMessage.contentSize.width/2);
		//MaxFinalRelay init end
		
		//CancelFinalRelay init
		CFRCoverLayer = [CCLayer node];
		[CFRCoverLayer setVisible:NO];
		[CoverLayer addChild:CFRCoverLayer];
		
		
		CFRMessage = [CCSprite spriteWithFile:@"CancelFinalRelayMessage.png"];
		CFRMessage.anchorPoint = ccp(0.5f,0.5f);
		CFRMessage.position = ccp(-(CFRMessage.contentSize.width/2),160);
		
		CFRMessage_moving = [CCSprite spriteWithFile:@"CancelFinalRelayMessage_moving.png"];
		CFRMessage_moving.anchorPoint = ccp(0.5f,0.5f);
		CFRMessage_moving.position = ccp(-(CFRMessage.contentSize.width/2),160);
		
		[CFRCoverLayer addChild:CFRMessage];
		[CFRCoverLayer addChild:CFRMessage_moving];
		
		CFRMessageAni = NO;
		CFRMessageAni_targetX = 240;
		//FinalRelay init end

		
		//수치초기화
		PerfromNormaltoFinalRelay = 0;
		PerfromFinalRelaytoMaxFinalRelay = 0;
		AnimationDelay_Elapsed = 0;
		
		//파티클 이펙트 초기화
		orangeNormalParticler = [[[ParticleManager alloc] initWithKind:CODE_ORRANGE ParticleNum:20 maintainParticleNum:0 scope:CGRectMake(180, -100, 80, 100)] autorelease];
		orangeNormalParticler.beginOpacity = 120;
		[BackGround addChild:orangeNormalParticler z:1.1f];
		
		RedFinalParticler =[[[ParticleManager alloc] initWithKind:CODE_RED ParticleNum:20 maintainParticleNum:0 scope:CGRectMake(120, -150, 240, 150)] autorelease];
		RedFinalParticler.beginOpacity = 200;
		[BackGround addChild:RedFinalParticler z:1.2f];
		
		MaxFinalParticler = [[[ParticleManager alloc] initWithKind:CODE_PURPLE ParticleNum:10 maintainParticleNum:0 scope:CGRectMake(100, -100, 280, 100)] autorelease];
		[BackGround addChild:MaxFinalParticler z:1.3f];
        
        //파이널릴레이에따른 풍속조절
        GC = [GameCondition sharedGameCondition];
        standardWindSpeed = GC.windSpeed;
		
	}
	NSLog(@"FinalRelayDisplayController Initialize");
	return self;
}

-(void)update:(ccTime)delta {
	
	if (FRMessageAni) {
		FRMessage.position = ccp(FRMessage.position.x + (0.999f * (FRMessageAni_targetX - FRMessage.position.x))*delta*10,160);
		FRMessage_moving.position = ccp(FRMessage_moving.position.x + (0.999f * (FRMessageAni_targetX - FRMessage_moving.position.x))*delta*10,160);
		
		
		float nearCenterDistance = floatMarkOut(FRMessage.position.x - FRMessageAni_targetX);
		if (nearCenterDistance < 0.1f) {
			FRMessage.position = ccp(FRMessageAni_targetX,160);
			FRMessage_moving.position = ccp(FRMessageAni_targetX,160);
			
			AnimationDelay_Elapsed += delta;
			if (AnimationDelay_Elapsed > 0.5f) {
				FRMessageAni_targetX = -(FRMessage.contentSize.width/2);
				
				float nearEndPointDistance = floatMarkOut(FRMessage.position.x - FRMessageAni_targetX);
				if (nearEndPointDistance < 0.1f) {
					FRMessage.position = ccp(FRMessageAni_targetX,160);
					FRMessage_moving.position = ccp(FRMessageAni_targetX,160);
					FRMessageAni = NO;
				}
			}
		}
		
		if (nearCenterDistance < 40) {
			int fadeRatio = nearCenterDistance/40 * 255;
			FRMessage_moving.opacity = fadeRatio;
		}

	}
	
	if (MFRMessageAni) {
		MFRMessage.position = ccp(MFRMessage.position.x + (0.999f * (MFRMessageAni_targetX - MFRMessage.position.x))*delta*10,160);
		MFRMessage_moving.position = ccp(MFRMessage_moving.position.x + (0.999f * (MFRMessageAni_targetX - MFRMessage_moving.position.x))*delta*10,160);
			
		float nearCenterDistance = floatMarkOut(MFRMessage.position.x - MFRMessageAni_targetX);
		if (nearCenterDistance < 0.1f) {
			MFRMessage.position = ccp(MFRMessageAni_targetX,160);
			MFRMessage_moving.position = ccp(MFRMessageAni_targetX,160);
				
			AnimationDelay_Elapsed += delta;
			if (AnimationDelay_Elapsed > 0.5f) {
				MFRMessageAni_targetX = -(MFRMessage.contentSize.width/2);
					
				float nearEndPointDistance = floatMarkOut(MFRMessage.position.x - MFRMessageAni_targetX);
				if (nearEndPointDistance < 0.1f) {
					MFRMessage.position = ccp(MFRMessageAni_targetX,160);
					MFRMessage_moving.position = ccp(MFRMessageAni_targetX,160);
					MFRMessageAni = NO;
				}
			}
		}
			
		if (nearCenterDistance < 40) {
			int fadeRatio = nearCenterDistance/40 * 255;
			MFRMessage_moving.opacity = fadeRatio;
		}
	}
	
	//캔슬메세지
	if (CFRMessageAni) {
		CFRMessage.position = ccp(CFRMessage.position.x + (0.99f * (CFRMessageAni_targetX - CFRMessage.position.x))*delta*10,160);
		CFRMessage_moving.position = ccp(CFRMessage_moving.position.x + (0.99f * (CFRMessageAni_targetX - CFRMessage_moving.position.x))*delta*10,160);
		
		float nearCenterDistance = floatMarkOut(CFRMessage.position.x - CFRMessageAni_targetX);
		if (nearCenterDistance < 0.1f) {
			CFRMessage.position = ccp(CFRMessageAni_targetX,160);
			CFRMessage_moving.position = ccp(CFRMessageAni_targetX,160);
			
			AnimationDelay_Elapsed += delta;
			if (AnimationDelay_Elapsed > 0.5f) {
				CFRMessageAni_targetX = 480+(CFRMessage.contentSize.width/2);
				
				float nearEndPointDistance = floatMarkOut(CFRMessage.position.x - CFRMessageAni_targetX);
				if (nearEndPointDistance < 0.1f) {
					CFRMessage.position = ccp(CFRMessageAni_targetX,160);
					CFRMessage_moving.position = ccp(CFRMessageAni_targetX,160);
					CFRMessageAni = NO;
				}
			}
			
		}
		
		if (nearCenterDistance < 40) {
			int fadeRatio = nearCenterDistance/40 * 255;
			CFRMessage_moving.opacity = fadeRatio;
		}
		
	}//캔슬메세지 끝
		
	//finalRelayBackGround.opacity += (0.9f * ((PerfromFinalRelaytoMaxFinalRelay * 255) - finalRelayBackGround.opacity)) *delta *10;

	
	//Particler
	[orangeNormalParticler update:delta];
	orangeNormalParticler.maintainParticleNum = PerfromNormaltoFinalRelay * orangeNormalParticler.createParticleNum;

	[RedFinalParticler update:delta];
	RedFinalParticler.maintainParticleNum = PerfromFinalRelaytoMaxFinalRelay * RedFinalParticler.createParticleNum;
	
	
	if (onFinalRelay) {
		//orangeNormalParticler.maintainParticleNum = PerfromFinalRelaytoMaxFinalRelay * orangeNormalParticler.createParticleNum;
	}else {
		//orangeNormalParticler.maintainParticleNum = PerfromFinalRelaytoMaxFinalRelay * orangeNormalParticler.createParticleNum;
	}

    GC.windSpeed = standardWindSpeed + (standardWindSpeed*PerfromFinalRelaytoMaxFinalRelay); //맥스파이널릴레이에서 풍속 2배
}

-(void)onFinalRelay{
	onFinalRelay = YES;
	FRMessageAni = YES;
	FRMessageAni_targetX = 240;
	
	[FRCoverLayer setVisible:YES];
	AnimationDelay_Elapsed = 0;
	FRMessage.position = ccp(480+(FRMessage.contentSize.width/2),160);
	FRMessage_moving.position = ccp(480+(FRMessage.contentSize.width/2),160);
	
}

-(void)onMaxFinalRelay{
	MFRMessageAni = YES;
	MFRMessageAni_targetX = 240;
	
	[MFRCoverLayer setVisible:YES];
	AnimationDelay_Elapsed = 0;
	MFRMessage.position = ccp(480+(MFRMessage.contentSize.width/2),160);
	MFRMessage_moving.position = ccp(480+(MFRMessage.contentSize.width/2),160);
	
	MaxFinalParticler.maintainParticleNum = MaxFinalParticler.createParticleNum;
}

-(void)offFinalRelay{
	onFinalRelay = NO;
	onMaxFinalRelay = NO;
	PerfromNormaltoFinalRelay = 0;
	PerfromFinalRelaytoMaxFinalRelay = 0;
	
	AnimationDelay_Elapsed = 0;
	CFRMessageAni = YES;
	CFRMessageAni_targetX = 240;
	[CFRCoverLayer setVisible:YES];
	CFRMessage.position = ccp(-(CFRMessage.contentSize.width/2),160);
	CFRMessage_moving.position = ccp(-(CFRMessage_moving.contentSize.width/2),160);
	
	MaxFinalParticler.maintainParticleNum = 0;
}

-(void)setPerfromNormaltoFinalRelay:(float)v {
	PerfromNormaltoFinalRelay = 0.2f+ v * 0.8f;
	//PerfromNormaltoFinalRelay = v;
}
-(void)setPerfromFinalRelaytoMaxFinalRelay:(float)v{
	PerfromFinalRelaytoMaxFinalRelay = 0.2f + v * 0.8f;
}

-(float)PerfromNormaltoFinalRelay{
	return PerfromNormaltoFinalRelay;
}
-(float)PerfromFinalRelaytoMaxFinalRelay{
	return PerfromFinalRelaytoMaxFinalRelay;
}

-(void)dealloc {
    GC.windSpeed = standardWindSpeed; //게임이 끝날때 죽으므로 
	[FRCoverLayer removeChild:FRMessage cleanup:YES];
	[FRCoverLayer removeChild:FRMessage_moving cleanup:YES];
	
	//[BackGround removeChild:finalRelayBackGround cleanup:YES];
	[CoverLayer removeChild:FRCoverLayer cleanup:YES];
	[super dealloc];
	NSLog(@"FinalRelayDisplayController Dealloc");
}

@end
