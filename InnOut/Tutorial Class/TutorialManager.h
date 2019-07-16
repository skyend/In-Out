//
//  TutorialAndHintManager.h
//  Memory0_0
//
//  Created by JinUng Han on 11. 4. 30..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ShineEffect.h"

@class ProgressManager;
@class BaseCharacter;
typedef BaseCharacter * ShapeID;
typedef BaseCharacter * CharacterID;

@interface TutorialManager : CCLayer {

	ProgressManager * PM;
	CCLayer * CoverLayer;
	
	BOOL	run;
	BOOL    extinction;
	CCSprite * animation;
	NSMutableArray * aniFrames;
	int aniframe;
	float tickElapsedTime;
	float elapsedTime;
	float currentframe;
	int FPS;
	
    ShineEffect * inGesture;
    ShineEffect * outGesture;
    
    NSArray * PMsShapeObject;
    
    ShapeID Ap;
    ShapeID Ar;
    ShapeID P;
    ShapeID P2;
    
    BaseCharacter * cAp;
    float cApSubOpacity;
    BaseCharacter * cAr;
    BaseCharacter * cP;
    BaseCharacter * cP2;
    BaseCharacter * cOut;
    float cOutSubOpacity;
    
    ShineEffect * targetSelector1;
    ShineEffect * targetSelector2;
    
    CCSprite * blinder;
    float blinderTXscale;
    
    float tutorialAniTime;
    
    NSMutableArray * refMeObjects;
    
    CCSprite * dialogueWindow;
    float subDialogueWindowOpa;
    
    BOOL windowAniRun;
    BOOL openedWindow;
    BOOL windowOpenComplete;
    BOOL windowCloseComplete;
    
    
    LangCode lang;
    uint step;
    BOOL runBriefing;
    float briefingTime;
    
    NSMutableArray * step1_Texts;
    float s1Et;
    BOOL s1_closing;
    int s1_completeCount;
    NSMutableArray * step2_Texts;
    float s2Et;
    NSMutableArray * step3_Texts;
    float s3Et;
    NSMutableArray * step4_Texts;
    float s4Et;
    NSMutableArray * step5_Texts;
    float s5Et;
    BOOL s5_midCheck;
    int s5_completeCount;
    NSMutableArray * step6_Texts;
    float s6Et;
    NSMutableArray * step7_Texts;
    float s7Et;
    BOOL s7_closing;
    int s7_completeCount;
    NSMutableArray * step8_Texts;
    float s8Et;
    
    BOOL briefing;
    BOOL gestureGuideOn;
    BOOL gestureGuideInit;
    
    ShineEffect * gestureGuideOut;
    ShineEffect * gestureGuideIn;
    ShineEffect * gestureGuideTutoClose;
    ShineEffect * gestureGuideTouch;
    BOOL doneGesture;
    BOOL doneTutoCloseGesture;
    
    BOOL touchStandbyState; //터치대기상태
    BOOL onTouch; //터치가되면
}

-(id)initWithLayers:(CCLayer*)CoverLayer_ pm:(ProgressManager*)PM_;
-(void)update:(ccTime)dt;
-(void)begin;
-(void)endTutorial;
-(void)stop;
-(void)inputStatefromShape:(id)shapeID PrevState:(State)prevState_ CurrentState:(State)currentState_;

@property (assign) NSMutableArray * refMeObjects;

@end
