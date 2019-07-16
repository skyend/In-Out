//
//  FinalRelayDisplayController.h
//  Memory0_0
//
//  Created by JinUng Han on 11. 4. 28..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class ParticleManager;
@class GameCondition;

@interface FinalRelayDisplayController : NSObject {
	CCLayer * BackGround;
	CCLayer * CoverLayer;
	CCSprite * finalRelayBackGround;
	
	
	
	CCLayer  * FRCoverLayer;
	CCSprite * FRMessage;
	CCSprite * FRMessage_moving;
	
	CCLayer  * MFRCoverLayer;
	CCSprite * MFRMessage;
	CCSprite * MFRMessage_moving;
	
	CCLayer  * CFRCoverLayer;
	CCSprite * CFRMessage;
	CCSprite * CFRMessage_moving;
	
	BOOL onFinalRelay;
	BOOL onMaxFinalRelay;
	
	BOOL FRMessageAni;
	float FRMessageAni_targetX;
	
	BOOL MFRMessageAni;
	float MFRMessageAni_targetX;
	
	BOOL CFRMessageAni;
	float CFRMessageAni_targetX;
	
	float PerfromNormaltoFinalRelay; //노멀에서 파이널 릴레이까지
	float PerfromFinalRelaytoMaxFinalRelay; //파이널 릴레이부터 맥스파이널릴레이까지
	
	float AnimationDelay_Elapsed;
	
	ParticleManager * orangeNormalParticler;
	ParticleManager * RedFinalParticler;
	ParticleManager * MaxFinalParticler;
    
    GameCondition * GC;
    float standardWindSpeed;
}

//@property float PerfromNormaltoFinalRelay;
//@property float PerfromFinalRelaytoMaxFinalRelay;

-(id)initWithLayer:(CCLayer*)BackGround_ coverLayer:(CCLayer*)CoverLayer_;

-(void)update:(ccTime)delta;
-(void)onFinalRelay;
-(void)onMaxFinalRelay;

-(void)offFinalRelay;

-(void)setPerfromNormaltoFinalRelay:(float)v;
-(void)setPerfromFinalRelaytoMaxFinalRelay:(float)v;

-(float)PerfromNormaltoFinalRelay;
-(float)PerfromFinalRelaytoMaxFinalRelay;

@end
