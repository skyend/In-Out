//
//  CreditScene.m
//  KEEPINGSHAPE
//
//  Created by JinWoong Han on 11. 8. 11..
//  Copyright 2011 -. All rights reserved.
//

#import "CreditScene.h"
#import "GameMainScene.h"
#import "GraphTouchObserver.h"
#import "AudioPlayer.h"
#import "SoundManager.h"

@interface CreditScene (privateMethods)
-(void)update:(ccTime)d;
-(void)backToMain:(id)sender;
-(void)resetGame:(id)sender;
@end



@implementation CreditScene

+(id)scene {
	
	CreditScene *creditScene = [CreditScene node];
	
	CCScene *scene = [CCScene node];
	
	
	[scene addChild:creditScene];
    
    
	return scene;
}

-(id)init {
    if ( (self = [super init] )) {
        touchLayer = [[[GraphTouchObserver alloc] init] autorelease];
        [self addChild:touchLayer];
        layer = [CCLayer node];
        [self addChild:layer];
        
        noise = [[[FrameAnimator alloc] initWithAnimationSheet:@"noise2000.jpg" FrameMap:@"0/1,3/4" FrameLength:4 FrameSize:CGSizeMake(480, 320) _FPS:24 Begin:0 Delay:0 Restart:0] autorelease];
        noise.anchorPoint = ccp(0,0);
        noise.scale = 1;
        [noise noGambbak];
        [layer addChild:noise];
        
        int randomCode = rand()%5 + 1;
        CCSprite * stageBack = [CCSprite spriteWithFile:[NSString stringWithFormat:@"thumbnail_s%d.jpg",randomCode]];
        stageBack.anchorPoint = ccp(0,0);
        stageBack.scale = 2;
        stageBack.opacity = 30;
        [layer addChild:stageBack];
        
        textSlide = [CCSprite node];
        textSlide.anchorPoint = ccp(0.5f,0);
        textSlide.position = ccp(240,40);
        [layer addChild:textSlide];
        
        CCSprite * text1 = [CCSprite spriteWithFile:@"credit_text01.png"];
        text1.anchorPoint = ccp(0.5f,1);
        text1.position = ccp(0,0);
        [textSlide addChild:text1];
        
        CCSprite * text2 = [CCSprite spriteWithFile:@"credit_text02.png"];
        text2.anchorPoint = ccp(0.5f,1);
        text2.position = ccp(0,[text1 contentSize].height*-1);
        [textSlide addChild:text2];
        
        textSlideHeight = [text1 contentSize].height + [text2 contentSize].height;
        
        CCSprite * noiseMask = [CCSprite spriteWithFile:@"noise2000_mask.png"];
        noiseMask.anchorPoint = ccp(0,0);
        noiseMask.opacity = 255;
        [layer addChild:noiseMask];
        
        CCMenuItem * home = [CCMenuItemImage itemFromNormalImage:@"TapToScreenIcon_Main.png" selectedImage:@"TapToScreenIcon_Main.png" target:self selector:@selector(backToMain:)];
        home.position = ccp(240,20);
        
        CCMenuItem * resetButton = [CCMenuItemImage itemFromNormalImage:@"ResetButton.png" selectedImage:@"ResetButton-d.png" target:self selector:@selector(resetGame:)];
        resetButton.position = ccp(10,10);
        resetButton.anchorPoint = ccp(0,0);
        CCMenu * menus = [CCMenu menuWithItems:resetButton, nil];
        menus.anchorPoint = ccp(0,0);
        menus.position = ccp(0,0);
        [layer addChild:menus];
        [layer addChild:home];
        
        homeShine = [[[ShineEffect alloc] initWithFile:@"TapToScreenIcon_MainOutLine.png"] autorelease];
        homeShine.position = ccp(240,20);
        [homeShine setOpacityRange:0 Max:1];
        [homeShine setDelay:0];
        [homeShine setDuration:1];
        [homeShine setBeginDelay:0];
        [layer addChild:homeShine];
        
        
        
        [self schedule:@selector(update:)];
        run = YES;
        
        [[AudioPlayer sharedAudioPlayer] allStopAudio];
        [[AudioPlayer sharedAudioPlayer] playAudio:@"Tennessee Twister Long.caf"];
        
        slideSpeed = 0.5f;
        
        return self;
    }
    return nil;
}

-(void)update:(ccTime)d{
    if (run) {
        [noise update:d];
        [homeShine update:d];
        
        if ([touchLayer touching]) {
            if (touchLayer.beginPos.x > 200 && touchLayer.beginPos.x < 280 && touchLayer.beginPos.y < 60) {
                touched = YES;
                [[SoundManager sharedSM] playButtonTouchBegin];
            }
        }
        
        if (touched) {
            if ([touchLayer end]) {
                if (touchLayer.endPos.x > 200 && touchLayer.endPos.x < 280 && touchLayer.endPos.y < 60) {
                    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameMain scene]]];
                    [[SoundManager sharedSM] playSound:@"376.wav"];
                    run = NO;
                }
            }
        }
        
        
        
        textSlide.position = ccp(240,textSlide.position.y + slideSpeed);
        if ([textSlide position].y - 320 > textSlideHeight) {
            textSlide.position = ccp(240,10);
        }
        
        
    }
    
    
}

-(void)dealloc {
    [[AudioPlayer sharedAudioPlayer] stopAudio:@"Tennessee Twister Long.caf"];
    [super dealloc];
}

-(void)backToMain:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameMain scene]]];
}

-(void)resetGame:(id)sender{
    [[GameCondition sharedGameCondition] superInitialize];
}

@end
