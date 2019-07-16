//
//  VolcanoMountain.m
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 6. 19..
//  Copyright 2011 -. All rights reserved.
//

#import "VolcanoMountain.h"


@implementation VolcanoMountain
-(id)initWithFile:(NSString *)filename_{
    if ( (self = [super init] ) ) {
        
        CCTexture2D * tex = [[CCTextureCache sharedTextureCache] addImage:filename_];
        CGRect rect = CGRectZero;
        rect.size = tex.contentSize;
        [self setTexture:tex];
        [self setTextureRect:rect];
        if (LastOpenedStageCode >= 5) {
            //[self setTextureRect:CGRectZero];
        }
        /*
        if (LastOpenedStageCode >= 1) {
            CCSprite * volcanoCloud = [CCSprite spriteWithFile:@"stage5_volcano1Smoke.png"];
            volcanoCloud.anchorPoint= ccp(0.5f,0);
            volcanoCloud.position = ccp(200,81);
            [self addChild:volcanoCloud];
            
            
            //CCSprite * magmaGlow = [CCSprite spriteWithFile:@"stage5_volcanoFire.png"];
            magmaGlow = [[[ShineEffect alloc] initWithSource:@"stage5_volcanoFire.png"] autorelease];
            magmaGlow.anchorPoint= ccp(0.5f,0);
            magmaGlow.position = ccp(320,60);
            [magmaGlow setDelay:0];
            [magmaGlow setShineNum:2];
            [magmaGlow setDuration:4];
            [magmaGlow setTransferDurationRange:4];
            [magmaGlow setOpacityRange:0.4f Max:0.9f];
            [self addChild:magmaGlow];
            
            lightningNum = 7;
            lightnings = malloc(sizeof(ShineEffect*)*lightningNum);
            for (int i = 0; i <lightningNum; i++) {
                ShineEffect * lightning = [[[ShineEffect alloc] initWithSource:[NSString stringWithFormat:@"stage5_Lightning0%d.png",i%9+1]] autorelease];
                lightning.anchorPoint = ccp(0.5f,0);
                [lightning setOpacityRange:0 Max:1];
                [lightning setShineNum:2];
                [lightning setDelay:6];
                [lightning setDuration:0.5f];
                [lightning setBeginDelay:rand()%40];
                [lightning setTransferShineRange:2];
                [lightning setTransferDelayRange:10];
                [lightning setTransferDurationRange:0.3f];
                [lightning setTransferPositionRect:CGRectMake(300, 60, 20, 20)];
                [lightning setAngleRange:-20 Max:20];
                [lightning setTransferScaleRange:50 Max:80];
                [self addChild:lightning];
                lightnings[i] = lightning;
            }
            
            firesNum = 15;
            fires = malloc(sizeof(ShineEffect*)*firesNum);
            for (int i = 0; i <firesNum; i++) {
                ShineEffect * fire = [[[ShineEffect alloc] initWithSource:[NSString stringWithFormat:@"stage5_VolcanoSmoke0%d.png",i%6+1]] autorelease];
                fire.anchorPoint = ccp(0.5f,0);
                [fire setOpacityRange:0 Max:0.8f];
                [fire setShineNum:2];
                [fire setDelay:0];
                [fire setDuration:4];
                [fire setBeginDelay:rand()%10];
                [fire setTransferShineRange:2];
                //[fire setTransferDelayRange:10];
                [fire setTransferDurationRange:6];
                [fire setTransferPositionRect:CGRectMake(340, 70, 20, 20)];
                [fire setIncreasePositionRect:CGRectMake(-20, 15, 4, 30)];
                [fire setIncreaseScaleRange:0.1f Max:0.2f];
                [fire setAngleRange:-20 Max:20];
                [fire setTransferScaleRange:50 Max:80];
                [self addChild:fire];
                fires[i] = fire;
            }

        }
        */
        NSLog(@"LastOpenedStageCode:%d",LastOpenedStageCode);
        
        CCSprite * cloud1 = [CCSprite spriteWithFile:@"stage2_sandStorm02.png"];
        cloud1.scale = 4.0f;
        cloud1.position = ccp(340,80); 
        cloud1.opacity = 150;
        CCSprite * cloud2 = [CCSprite spriteWithFile:@"stage2_sandStorm03.png"];
        cloud2.scale = 3.5f;
        cloud2.scaleY = 4;
        cloud2.position = ccp(300,60); 
        cloud2.opacity = 140;
        CCSprite * cloud3 = [CCSprite spriteWithFile:@"stage2_sandStorm01.png"];
        cloud3.scale = 4.5f;
        cloud3.scaleY = 5;
        cloud3.position = ccp(380,70); 
        cloud3.opacity = 170;
        
        [self addChild:cloud1];
        [self addChild:cloud2];
        [self addChild:cloud3];
        
    }
    return self;
}

-(void)update:(ccTime)delta {
//    if (magmaGlow != nil) {
//        [magmaGlow update:delta];
//    }
//    
//    
//    for (int i = 0; i <lightningNum; i++) {
//        
//        [lightnings[i] update:delta];
//    }
//    
//    for (int i = 0; i <firesNum; i++) {
//        
//        [fires[i] update:delta];
//    }
}

-(void)dealloc {
    [super dealloc];
}
@end
