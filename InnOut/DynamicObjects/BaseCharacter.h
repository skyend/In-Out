//
//  BaseCharacter.h
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 9..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"
/*
typedef enum{
	WALKING,
	STOPING,
	ARRIVED,
	DISAPPEAR,
	APPEAR,
	STANDBY, //판별전에 대기함
	COMEIN,
	GOOUT,
	DIED
}State;
*/
@class TutorialManager;

typedef enum{
	FRONT,
	BACK
}LayerPosition;


@interface BaseCharacter : CCLayer {
	CCLayer * superLayer;
	
	char shapeCode;
	char characterCode;
	
	CCSprite *body;
	CCSprite *bodyShadow;
	CGFloat JumpPos;
	CGFloat gravity;
	BOOL JumpUandD;
	
	char kind;
	CCTexture2D *ctex;
	//CGFloat speed; //나중에 싱글톤객체로 재조정 할것 옵션으로
	CGFloat opacity; // 0~1
	CGFloat deltaCount;
	
	State state;
	LayerPosition layerPos;
	
	int LocationinWay;
	
	CGPoint targetSpot;
	CGFloat moveToDis;
	int currentZDirection;
	float progressedDisInsection;
	
	CGPoint prevSpot;
	float currentLocationInWay;
	float ZdistanceForCurrentTargetpoint; // 목표지점 까지 남은 Z 거리
	float ZtotalDistance;
	float virtualScale;
	//CGPoint vector;
    
    BOOL mustNoticeToTM;
    TutorialManager * TM;

}
@property char shapeCode;
@property char characterCode;
@property (readonly) State state;
//@property CGPoint targetSpot;
@property LayerPosition layerPos;
@property int LocationinWay;
@property CGFloat opacity;
@property int currentZDirection;
@property float ZdistanceForCurrentTargetpoint;

-(id)initWithShape:(char)ShapeCode;
-(id)initWithPos:(char)ShapeCode LayerPos:(LayerPosition)alayerPos Position:(CGPoint)pos superLayer:(CCLayer*)superLayer_;

-(void)update:(ccTime)delta;


-(void)setTargetSpot:(CGPoint)pos_ ;
-(CGPoint)targetSpot;

-(void)setTutorialManager:(TutorialManager*)tm_;
-(void)deleteRefTM;
-(void)setState:(State)state_;

@end
