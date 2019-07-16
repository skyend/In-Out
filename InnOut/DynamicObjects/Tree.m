//
//  Tree.m
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 7. 9..
//  Copyright 2011 -. All rights reserved.
//

#import "Tree.h"

//forest_air.png

@implementation Tree
-(id)initWithTreeSource:(NSString*)source_{
    if ( (self = [super init]) ) {
        [self setTexture:[[CCTextureCache sharedTextureCache] addImage:source_]];
		[self setTextureRect:CGRectMake(0, 0, [[self texture] contentSize].width, [[self texture] contentSize].height)];
        
        NSString * treeNumber = [source_ substringWithRange:NSMakeRange(11, 2)];
        forestAir1 = nil;
        if ([treeNumber isEqualToString:@"01"]) {
            forestAir1 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"forest_air.png" Begin:1 Delay:1 Restart:-1 DiffusionSpeed:1.0f DiffusionScale:8.0f] autorelease];
            forestAir1.position = ccp(445,130);
            [forestAir1 setBeginOpacity:255];
            [forestAir1 setBeginScale:2];
            [self addChild:forestAir1];
            
            shineNum = rand()%10 + 10;
            shineArr = malloc( sizeof(ShineEffect*)*shineNum);
            for (int i = 0; i < shineNum ; i++) {
                ShineEffect * sh = [[[ShineEffect alloc] initWithSource:@"stage4_Light.png"] autorelease];
                sh.anchorPoint = ccp(0.5f,1);
                sh.position = ccp(240,300);
                [sh setOpacityRange:0 Max:1];
                [sh setShineNum:1];
                [sh setDelay:0];
                [sh setDuration:10];
                [sh setTransferDelayRange:6];
                [sh setTransferPositionRect:CGRectMake(90, 280, 300, 40)];
                [sh setTransferScaleRange:100 Max:200];
                [sh setAngleRange:0 Max:360];
                [sh setAngleRange:-10 Max:20];
                [self addChild:sh];
                shineArr[i] = sh;
            }
            
            shineNum2 = rand()%3 + 2;
            shineArr2 = malloc( sizeof(ShineEffect*)*shineNum2);
            for (int i = 0; i < shineNum2 ; i++) {
                ShineEffect * shiinee = [[[ShineEffect alloc] initWithSource:@"stage3_Tyndall.png"] autorelease];
                shiinee.anchorPoint = ccp(0.5f,1);
                shiinee.position = ccp(240,300);
                [shiinee setOpacityRange:0 Max:1];
                [shiinee setShineNum:2];
                [shiinee setDelay:0];
                [shiinee setDuration:10];
                [shiinee setTransferShineRange:4];
                [shiinee setTransferDelayRange:6];
                [shiinee setTransferPositionRect:CGRectMake(40, 200, 400, 100)];
                [shiinee setTransferScaleYRange:70 Max:100];
                [shiinee setTransferScaleXRange:30 Max:60];
                [shiinee setAngleRange:-10 Max:20];
                [self addChild:shiinee];
                shineArr2[i] = shiinee;
                
            }
            
        }else if ([treeNumber isEqualToString:@"02"]){
            forestAir1 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"forest_air2.png" Begin:0 Delay:1 Restart:-1 DiffusionSpeed:1.0f DiffusionScale:6.0f] autorelease];
            forestAir1.position = ccp(50,100);
            [forestAir1 setBeginOpacity:255];
            [forestAir1 setBeginScale:2];
            [self addChild:forestAir1];
            
            shineNum2 = rand()%3 + 2;
            shineArr2 = malloc( sizeof(ShineEffect*)*shineNum2);
            for (int i = 0; i < shineNum2 ; i++) {
                ShineEffect * shiinee = [[[ShineEffect alloc] initWithSource:@"stage3_Tyndall.png"] autorelease];
                shiinee.anchorPoint = ccp(0.5f,1);
                shiinee.position = ccp(240,300);
                [shiinee setOpacityRange:0 Max:1];
                [shiinee setShineNum:2];
                [shiinee setDelay:0];
                [shiinee setDuration:10];
                [shiinee setTransferShineRange:4];
                [shiinee setTransferDelayRange:6];
                [shiinee setTransferPositionRect:CGRectMake(40, 200, 400, 100)];
                [shiinee setTransferScaleYRange:70 Max:100];
                [shiinee setTransferScaleXRange:30 Max:60];
                [shiinee setAngleRange:-10 Max:20];
                [self addChild:shiinee];
                shineArr2[i] = shiinee;
            }
            
        }else if ([treeNumber isEqualToString:@"03"]){
            forestAir1 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"forest_air3.png" Begin:0 Delay:1 Restart:-1 DiffusionSpeed:1.0f DiffusionScale:rand()%4 + 3] autorelease];
            forestAir1.position = ccp([[self texture] contentSize].width/2,rand()%50 + 80);
            [forestAir1 setBeginOpacity:255];
            [forestAir1 setBeginScale:2];
            [self addChild:forestAir1];
            
            shineNum2 = rand()%3 + 2;
            shineArr2 = malloc( sizeof(ShineEffect*)*shineNum2);
            for (int i = 0; i < shineNum2 ; i++) {
                ShineEffect * shiinee = [[[ShineEffect alloc] initWithSource:@"stage3_Tyndall.png"] autorelease];
                shiinee.anchorPoint = ccp(0.5f,1);
                shiinee.position = ccp(240,300);
                [shiinee setOpacityRange:0 Max:1];
                [shiinee setShineNum:2];
                [shiinee setDelay:0];
                [shiinee setDuration:10];
                [shiinee setTransferShineRange:4];
                [shiinee setTransferDelayRange:6];
                [shiinee setTransferPositionRect:CGRectMake(0, 100, 100, 100)];
                [shiinee setTransferScaleYRange:70 Max:100];
                [shiinee setTransferScaleXRange:30 Max:60];
                [shiinee setAngleRange:-10 Max:20];
                [self addChild:shiinee];
                shineArr2[i] = shiinee;
                
            }
        }else if ([treeNumber isEqualToString:@"04"]){
            forestAir1 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"forest_air4.png" Begin:0 Delay:1 Restart:-1 DiffusionSpeed:1.0f DiffusionScale:rand()%4 + 3] autorelease];
            forestAir1.position = ccp([[self texture] contentSize].width/2,rand()%50 + 80);
            [forestAir1 setBeginOpacity:255];
            [forestAir1 setBeginScale:2];
            [self addChild:forestAir1];
            
            shineNum2 = rand()%3 + 2;
            shineArr2 = malloc( sizeof(ShineEffect*)*shineNum2);
            for (int i = 0; i < shineNum2 ; i++) {
                ShineEffect * shiinee = [[[ShineEffect alloc] initWithSource:@"stage3_Tyndall.png"] autorelease];
                shiinee.anchorPoint = ccp(0.5f,1);
                shiinee.position = ccp(240,300);
                [shiinee setOpacityRange:0 Max:1];
                [shiinee setShineNum:2];
                [shiinee setDelay:0];
                [shiinee setDuration:10];
                [shiinee setTransferShineRange:4];
                [shiinee setTransferDelayRange:6];
                [shiinee setTransferPositionRect:CGRectMake(0, 100, 100, 100)];
                [shiinee setTransferScaleYRange:70 Max:100];
                [shiinee setTransferScaleXRange:30 Max:60];
                [shiinee setAngleRange:-10 Max:20];
                [self addChild:shiinee];
                shineArr2[i] = shiinee;
                
            }
        }else if ([treeNumber isEqualToString:@"05"]){
//            forestAir1 = [[[DiffusionEffect alloc] initWithFileAndTimes:@"forest_air2.png" Begin:0 Delay:1 Restart:-1 DiffusionSpeed:1.0f DiffusionScale:rand()%4 + 3] autorelease];
//            forestAir1.position = ccp([[self texture] contentSize].width/2,rand()%50 + 80);
//            [forestAir1 setBeginOpacity:255];
//            [forestAir1 setBeginScale:2];
//            [self addChild:forestAir1];
            shineNum2 = rand()%3 + 2;
            shineArr2 = malloc( sizeof(ShineEffect*)*shineNum2);
            for (int i = 0; i < shineNum2 ; i++) {
                ShineEffect * shiinee = [[[ShineEffect alloc] initWithSource:@"stage3_Tyndall.png"] autorelease];
                shiinee.anchorPoint = ccp(0.5f,1);
                shiinee.position = ccp(240,300);
                [shiinee setOpacityRange:0 Max:1];
                [shiinee setShineNum:2];
                [shiinee setDelay:0];
                [shiinee setDuration:10];
                [shiinee setTransferShineRange:4];
                [shiinee setTransferDelayRange:6];
                [shiinee setTransferPositionRect:CGRectMake(0, 100, 100, 100)];
                [shiinee setTransferScaleYRange:70 Max:100];
                [shiinee setTransferScaleXRange:30 Max:60];
                [shiinee setAngleRange:-10 Max:20];
                [self addChild:shiinee];
                shineArr2[i] = shiinee;
                
            }
        }
        
        
    }
    return self;
}
-(void)update:(ccTime)delta {
    if (forestAir1 != nil) {
        [forestAir1 update:delta];
    }
    
    if (shineNum > 0) {
        for (int i = 0; i < shineNum ; i++) {
            [shineArr[i] update:delta];
        }
    }
    
    if (shineNum2 > 0) {
        for (int i = 0; i < shineNum2 ; i++) {
            [shineArr2[i] update:delta];
        }
    }
    
}

-(void)dealloc {
    free(shineArr);
    free(shineArr2);
    [super dealloc];
}
@end
