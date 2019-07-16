//
//  Bubble.h
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 7. 5..
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class BubbleBubble;

@interface Bubble : CCSprite {

	BOOL activated;
	
	BubbleBubble * MyManager;
	float elapsedTime;
	
	CGRect recycleScope;
	
	CGPoint tp;
    
    float disappearYpos;
    float controllOpacity;
}

-(void)activate;
-(void)unActivate;


-(id)initWithBubble:(BubbleBubble*)MyManager_;
-(void)update:(ccTime)dt;
@end
