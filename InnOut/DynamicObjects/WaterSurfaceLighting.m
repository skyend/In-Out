//
//  WaterSurfaceLighting.m
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 7. 9..
//  Copyright 2011 -. All rights reserved.
//

#import "WaterSurfaceLighting.h"
#import "ShineEffect.h"

@implementation WaterSurfaceLighting

-(id)init{
    if ( (self = [super init] )) {
        objCount = 10;
        effectArr = malloc(sizeof(effectArr)*objCount);
        for(int i = 0; i < objCount ; i++){
            ShineEffect * shiinee = [[[ShineEffect alloc] initWithSource:@"stage3_Tyndall.png"] autorelease];
            shiinee.anchorPoint = ccp(0.5f,1);
            shiinee.position = ccp(240,300);
            [shiinee setOpacityRange:0 Max:1];
            [shiinee setShineNum:2];
            [shiinee setDelay:0];
            [shiinee setDuration:10];
            [shiinee setTransferShineRange:4];
            [shiinee setTransferDelayRange:6];
            [shiinee setTransferPositionRect:CGRectMake(20, 280, 400, 20)];
            [shiinee setTransferScaleYRange:100 Max:200];
            [shiinee setTransferScaleXRange:70 Max:100];
            [shiinee setAngleRange:-10 Max:20];
            [self addChild:shiinee];
            effectArr[i] = shiinee;
        }
    }
    return self;
}

-(void)update:(ccTime)delta {
    for (int i = 0; i < objCount; i++) {
        [(ShineEffect*)effectArr[i] update:delta];
    }
}

-(void)dealloc {
    free(effectArr);
    [super dealloc];
}
@end
