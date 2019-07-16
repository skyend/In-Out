//
//  FireCave.m
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 7. 10..
//  Copyright 2011 -. All rights reserved.
//

#import "FireCave.h"


@implementation FireCave
-(id)init {
    if ( (self = [super init] )) {
        [self setTexture:[[CCTextureCache sharedTextureCache] addImage:@"stage5_inCave.png"]];
        [self setTextureRect:CGRectMake(0, 0, [[self texture] contentSize].width, [[self texture] contentSize].height)];
        
        reflexLight = [[[ShineEffect alloc] initWithSource:@"stage5_CaveReflexLight.png"] autorelease];
        [reflexLight setOpacityRange:0.4f Max:1];
        [reflexLight setDelay:0];
        [reflexLight setDuration:6];
        [reflexLight setTransferDurationRange:6];
        [reflexLight setShineNum:2];
        reflexLight.anchorPoint = ccp(0,1);
        reflexLight.position = ccp(0,224);
        [self addChild:reflexLight];
    }
    return self;
}

-(void)update:(ccTime)delta{
    [reflexLight update:delta];
}

-(void)dealloc{
 
    [super dealloc];
}

@end
