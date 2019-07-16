//
//  ParticleManager.h
//  Memory0_0
//
//  Created by JinUng Han on 11. 4. 29..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"


@class ParticleVaporization;

@interface ParticleManager: CCSprite {
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

-(id)initWithKind:(ParticleImgCode)code_ ParticleNum:(int)cretedParticleNum_ maintainParticleNum:(int)maintainParticleNum_ scope:(CGRect)createScope_;

-(void)update:(ccTime)dt;
@end
