//
//  BackGroundLightning.m
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 7. 11..
//  Copyright 2011 -. All rights reserved.
//

#import "BackGroundLightning.h"


@implementation BackGroundLightning
-(id)init{
    if ( (self = [super init] )) {
        if (LastOpenedStageCode >= 5) {
            lightningNum = 20;
            lightning = malloc(sizeof(ShineEffect*)*lightningNum);
            for (int i = 0; i <lightningNum; i++) {
                ShineEffect * sh = [[[ShineEffect alloc] initWithSource:[NSString stringWithFormat:@"stage5_Lightning0%d.png",i%9+1]] autorelease];
                sh.anchorPoint = ccp(0.5f,0);
                [sh setOpacityRange:0 Max:1];
                [sh setShineNum:2];
                [sh setDelay:20];
                [sh setDuration:0.5f];
                [sh setBeginDelay:rand()%40];
                [sh setTransferShineRange:2];
                [sh setTransferDelayRange:30];
                [sh setTransferDurationRange:0.3f];
                [sh setTransferPositionRect:CGRectMake(15, 154, 450, 20)];
                //[sh setKindofEffect:Lightning];
                
                [self addChild:sh];
                lightning[i] = sh;
            }
        }
        
    }
    return self;
}

-(void)update:(ccTime)delta{
    if (LastOpenedStageCode >= 5) {
        for (int i = 0; i <lightningNum; i++) {
            [lightning[i] update:delta];
        }
    }
    
}

-(void)dealloc {
    if (LastOpenedStageCode >= 5) {
        free(lightning);
    }
    
    [super dealloc];
}
@end
