//
//  SandMountain.m
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 6. 17..
//  Copyright 2011 -. All rights reserved.
//

#import "SandMountain.h"
#import "ScatterEffect.h"

@implementation SandMountain

-(id)initWithMountainImage:(NSString*)str {
    if ( (self = [super init]) ) {
        CCTexture2D * tex = [[CCTextureCache sharedTextureCache] addImage:str];
        CGRect rect = CGRectZero;
        rect.size = tex.contentSize;
        [self setTexture:tex];
        [self setTextureRect:rect];
        
        if ([str isEqualToString:@"stage2_SandMountain1.png"]) {
            casing = MountainCase_CASE1;
        }else if ([str isEqualToString:@"stage2_SandMountain2.png"]) {
            casing = MountainCase_CASE2;
        }else if ([str isEqualToString:@"stage2_SandMountain3.png"]) {
            casing = MountainCase_CASE3;
        }
        effectors = [[NSMutableArray alloc] init];
        
        if (casing == MountainCase_CASE1) {//stage2_SandDust
            ScatterEffect * ef1 = [[[ScatterEffect alloc] initWithFile:@"stage2_SandDust.png"] autorelease];
            [ef1 setAnchorPoint:ccp(0,0)];
            [ef1 setMinScale:ccp(1,1)];
            [ef1 setScalingTime:20];
            [ef1 setIncreaseScale:ccp(0.25f,0.1f)];
            [ef1 setBeginPosition:ccp(-rect.size.width,rect.size.height/2+10)];
            [ef1 setMovingSpeed:ccp(9.5f,ScatterEffect_Property_ValueNull)];
            [ef1 setMovingTime:20];
            [ef1 setBeginOpacity:255];
            [ef1 setTranslateOpacity:-12.5];
            [ef1 setTargetOpacty:0];
            
            [ef1 setRepeatToDoRandom:YES RandomRepeatRange:NSMakeRange(1, 2) RepeatInterval:0];
            [ef1 start];
            [self addChild:ef1];
            [effectors addObject:ef1];
            
        }else if(casing == MountainCase_CASE2){
            ScatterEffect * ef1 = [[[ScatterEffect alloc] initWithFile:@"stage2_SandDust.png"] autorelease];
            [ef1 setAnchorPoint:ccp(0,0)];
            [ef1 setMinScale:ccp(1,1)];
            [ef1 setScalingTime:5];
            [ef1 setIncreaseScale:ccp(1,0.1f)];
            [ef1 setBeginPosition:ccp(-rect.size.width+(ef1.contentSize.width*ef1.scaleX)-50,rect.size.height/2-40)];
            [ef1 setMovingSpeed:ccp(30,ScatterEffect_Property_ValueNull)];
            [ef1 setMovingTime:5];
            [ef1 setBeginOpacity:255];
            [ef1 setTranslateOpacity:-50];
            [ef1 setTargetOpacty:0];
            
            [ef1 setRepeatToDoRandom:YES RandomRepeatRange:NSMakeRange(1, 5) RepeatInterval:0];
            [ef1 start];
            [self addChild:ef1];
            [effectors addObject:ef1];
        }else if(casing == MountainCase_CASE3){
            ScatterEffect * ef1 = [[[ScatterEffect alloc] initWithFile:@"stage2_SandDust.png"] autorelease];
            [ef1 setAnchorPoint:ccp(0,0)];
            [ef1 setMinScale:ccp(1,1)];
            [ef1 setScalingTime:5];
            [ef1 setIncreaseScale:ccp(1,0.1f)];
            [ef1 setBeginPosition:ccp(-rect.size.width+(ef1.contentSize.width*ef1.scaleX)-50,rect.size.height/2-10)];
            [ef1 setMovingSpeed:ccp(30,ScatterEffect_Property_ValueNull)];
            [ef1 setMovingTime:5];
            [ef1 setBeginOpacity:255];
            [ef1 setTranslateOpacity:-50];
            [ef1 setTargetOpacty:0];
            
            [ef1 setRepeatToDoRandom:YES RandomRepeatRange:NSMakeRange(1, 5) RepeatInterval:0];
            [ef1 start];
            [self addChild:ef1];
            [effectors addObject:ef1];
        }
        
    }
    return self;
}

-(void)update:(ccTime)delta{
    //NSLog(@"시작");
    for (ScatterEffect * se in effectors){
        //NSLog(@"delta:%f aaa",delta);
        
        [se update:delta];
    }
    //NSLog(@"끝");
}
-(void)dealloc {
    
    [effectors removeAllObjects];
    [effectors release];
    [super dealloc];
}
@end
