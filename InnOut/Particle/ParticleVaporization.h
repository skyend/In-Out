//
//  ParticleCircle.h
//  Memory0_0
//
//  Created by JinUng Han on 11. 4. 29..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"

@class ParticleManager;

@interface ParticleVaporization : CCSprite {
	BOOL activated;
	
	ParticleManager * MyManager;
	float elapsedTime;
	
	CGRect recycleScope;
	
	CGPoint tp;
}

-(void)activate;
-(void)unActivate;


-(id)initWithKind:(ParticleImgCode)code_ myManager:(ParticleManager*)MyManager_;
-(void)update:(ccTime)dt;
@end
