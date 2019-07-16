//
//  ReflexWaterSurface.m
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 7. 10..
//  Copyright 2011 -. All rights reserved.
//

#import "ReflexWaterSurface.h"


@implementation ReflexWaterSurface
-(id)init {
    if ( (self = [super init] )) {
        [self setTexture:[[CCTextureCache sharedTextureCache] addImage:@"stage4_River.jpg"]];
        [self setTextureRect:CGRectMake(0, 0, [[self texture] contentSize].width, [[self texture] contentSize].height)];
        shineNum = rand()%10 + 10;
        shineArr = malloc( sizeof(ShineEffect*)*shineNum);
        for (int i = 0; i < shineNum ; i++) {
            ShineEffect * sh = [[[ShineEffect alloc] initWithSource:@"stage4_Light.png"] autorelease];
            sh.anchorPoint = ccp(0.5f,1);
            sh.position = ccp(240,300);
            [sh setOpacityRange:0 Max:1];
            [sh setShineNum:3];
            [sh setDelay:0];
            [sh setDuration:4];
            [sh setTransferShineRange:4];
            [sh setTransferDelayRange:6];
            [sh setTransferPositionRect:CGRectMake(100, 0, 240, 50)];
            [sh setTransferScaleRange:70 Max:100];
            [sh setAngleRange:0 Max:360];
            [sh setAngleRange:-10 Max:20];
            [self addChild:sh];
            shineArr[i] = sh;
        }
    }
    return self;
}
-(void)update:(ccTime)delta{
    if (shineNum > 0) {
        for (int i = 0; i < shineNum ; i++) {
            [shineArr[i] update:delta];
        }
    }
}

-(void)dealloc{
    free(shineArr);
    [super dealloc];
}
@end
