//
//  BubbleBubble.h
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 7. 5..
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"
#import "DynamicObject.h"

@class Bubble;
@class ProgressManager;

@interface BubbleBubble : DynamicObject {
    ProgressManager * runningPM;
    
	NSMutableArray * particleArr;
	int createParticleNum;
	int maintainParticleNum;
	CGRect createScope;
	
	int activatedParticleCount;
	
	int beginOpacity;
	int endOpacity;
}
@property (readonly) int createParticleNum;
@property int maintainParticleNum;
@property int activatedParticleCount;
@property CGRect createScope;

@property int beginOpacity;
@property int endOpacity;

-(id)initWithCount:(int)cretedParticleNum_ scope:(CGRect)createScope_;

-(void)update:(ccTime)dt;
@end
