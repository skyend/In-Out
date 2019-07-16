//
//  RealVolcano.m
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 7. 10..
//  Copyright 2011 -. All rights reserved.
//

#import "RealVolcano.h"


@implementation RealVolcano
-(id)initWithMountain:(NSString*)sourceMountain_{
    if ( (self = [super init] )) {
        [self setTexture:[[CCTextureCache sharedTextureCache] addImage:sourceMountain_]];
        [self setTextureRect:CGRectMake(0, 0, [[self texture] contentSize].width, [[self texture] contentSize].height)];
        
        
        magmaGlow = nil;
        
        if ([sourceMountain_ isEqualToString:@"stage5_Volcano1.png"]) {
            if (LastOpenedStageCode >= 5) {
                CCSprite * volcanoCloud = [CCSprite spriteWithFile:@"stage5_volcano1Smoke.png"];
                volcanoCloud.anchorPoint= ccp(0.5f,0);
                volcanoCloud.position = ccp(187,191);
                [self addChild:volcanoCloud];
                
                
                //CCSprite * magmaGlow = [CCSprite spriteWithFile:@"stage5_volcanoFire.png"];
                magmaGlow = [[[ShineEffect alloc] initWithSource:@"stage5_volcanoFire.png"] autorelease];
                magmaGlow.anchorPoint= ccp(0.5f,0);
                magmaGlow.position = ccp(198,50);
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
                    [lightning setTransferPositionRect:CGRectMake(180, 199, 20, 20)];
                    [lightning setAngleRange:-20 Max:20];
                    [lightning setTransferScaleRange:50 Max:80];
                    [self addChild:lightning];
                    lightnings[i] = lightning;
                }
                
                firesNum = 30;
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
                    [fire setTransferPositionRect:CGRectMake(180, 199, 20, 20)];
                    [fire setIncreasePositionRect:CGRectMake(-20, 15, 4, 30)];
                    [fire setIncreaseScaleRange:0.1f Max:0.2f];
                    [fire setAngleRange:-20 Max:20];
                    [fire setTransferScaleRange:50 Max:80];
                    [self addChild:fire];
                    fires[i] = fire;
                }
            }
            
            
        }else if ([sourceMountain_ isEqualToString:@"stage5_Volcano2.png"]){
            if (LastOpenedStageCode >= 5) {
                CCSprite * volcanoCloud = [CCSprite spriteWithFile:@"stage5_volcano2Smoke.png"];
                volcanoCloud.anchorPoint= ccp(0.5f,0);
                volcanoCloud.position = ccp(120,49);
                if ([GameCondition sharedGameCondition].stageCode == STAGE_2) {
                    volcanoCloud.scaleY = 1.5f;
                }
                
                [self addChild:volcanoCloud];
                
                
                
                //            //CCSprite * magmaGlow = [CCSprite spriteWithFile:@"stage5_volcanoFire.png"];
                //            magmaGlow = [[[ShineEffect alloc] initWithSource:@"stage5_volcanoFire.png"] autorelease];
                //            magmaGlow.anchorPoint= ccp(0.5f,0);
                //            magmaGlow.position = ccp(198,50);
                //            [magmaGlow setDelay:0];
                //            [magmaGlow setShineNum:2];
                //            [magmaGlow setDuration:4];
                //            [magmaGlow setTransferDurationRange:4];
                //            [magmaGlow setOpacityRange:0.4f Max:0.9f];
                //            [self addChild:magmaGlow];
                
                lightningNum = 10;
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
                    [lightning setTransferPositionRect:CGRectMake(17, 70, 140, 30)];
                    [lightning setAngleRange:-20 Max:20];
                    [lightning setTransferScaleRange:50 Max:80];
                    [self addChild:lightning];
                    lightnings[i] = lightning;
                }
                
                firesNum = 50;
                fires = malloc(sizeof(ShineEffect*)*firesNum);
                for (int i = 0; i <firesNum; i++) {
                    ShineEffect * fire = [[[ShineEffect alloc] initWithSource:[NSString stringWithFormat:@"stage5_VolcanoSmoke0%d.png",i%6+1]] autorelease];
                    fire.anchorPoint = ccp(0.5f,0);
                    [fire setOpacityRange:0 Max:0.8f];
                    
                    [fire setDelay:0];
                    
                    [fire setBeginDelay:rand()%10];
                    //[fire setTransferShineRange:2];
                    //[fire setTransferDelayRange:10];
                    [fire setTransferDurationRange:6];
                    
                    [fire setIncreaseScaleRange:0.1f Max:0.2f];
                    [fire setAngleRange:-20 Max:20];
                    [fire setTransferScaleRange:30 Max:55];
                    
                    if (i < (firesNum / 3) ) {
                        [fire setShineNum:1];
                        [fire setDuration:2];
                        [fire setTransferPositionRect:CGRectMake(35, 58, 5, 5)];
                        [fire setIncreasePositionRect:CGRectMake(-8, 15, 8, 30)];
                    }else if (i < (firesNum / 3)*2 + 3) {
                        [fire setShineNum:2];
                        [fire setDuration:3];
                        [fire setTransferPositionRect:CGRectMake(115, 86, 5, 5)];
                        [fire setIncreasePositionRect:CGRectMake(-12, 15, 12, 30)];
                    }else{
                        [fire setShineNum:2];
                        [fire setDuration:3];
                        [fire setTransferPositionRect:CGRectMake(175, 50, 5, 5)];
                        [fire setIncreasePositionRect:CGRectMake(-14, 15, 14, 30)];
                    }
                    
                    [self addChild:fire];
                    fires[i] = fire;
                }
            }
            if ([GameCondition sharedGameCondition].stageCode == 2) {
                self.scaleX = -1;
            }

        }
        
        
        
        
    }
    return self;
}
-(void)update:(ccTime)delta
{
    if (LastOpenedStageCode >= 5) {
        if (magmaGlow != nil) {
            [magmaGlow update:delta];
        }
        
        
        for (int i = 0; i <lightningNum; i++) {
            
            [lightnings[i] update:delta];
        }
        
        for (int i = 0; i <firesNum; i++) {
            
            [fires[i] update:delta];
        }
    }
    
}

-(void)dealloc{
    free(lightnings);
    free(fires);
    
    [super dealloc];
}
@end
