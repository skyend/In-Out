//
//  FrameAnimator.m
//  KeepinTheMind
//
//  Created by JinUng Han on 11. 5. 15..
//  Copyright 2011 Student. All rights reserved.
//

#import "FrameAnimator.h"


@implementation FrameAnimator

//FrameLength 필요없듬
-(id)initWithAnimationSheet:(NSString *)filePath_ FrameMap:(NSString *)map_ FrameLength:(int)frameLength_ FrameSize:(CGSize)frameSize_ _FPS:(int)FPS_ Begin:(float)begin_ Delay:(float)delay_ Restart:(float)restart_{
	if ( (self = [super init] )) {
		[self setTexture:[[CCTextureCache sharedTextureCache] addImage:filePath_]];
		frameRects = [[NSMutableArray alloc] init];
	
		NSArray * heightsSet = [map_ componentsSeparatedByString:@","];
		for (int w = 0 ; w < [heightsSet count]; w++){
			NSArray * widthsSet = [(NSString*)[heightsSet objectAtIndex:w] componentsSeparatedByString:@"/"];
			
			for (int h = 0 ; h < [widthsSet count]; h++) {
				NSValue * rect = [NSValue valueWithCGRect:CGRectMake(w * frameSize_.width, h * frameSize_.height, frameSize_.width, frameSize_.height)];
				[frameRects addObject:rect];
			}
		}
		currentFrame = 0;
		[self setTextureRect:[(NSValue*)[frameRects objectAtIndex:currentFrame] CGRectValue]]; 
		et = 0;
		
		FPS = FPS_;
		begin = begin_;
		restart = restart_;
		delay = delay_;
		runEt = 0;
		runAni = YES;
        Gambbak = YES;
		self.visible = NO;
	}
	return self;
}

-(void)update:(ccTime)d {
	et += d;
	
	if (runAni) {
		if (begin < et) {
			self.visible = YES;
			runEt += d;
			if (runEt > 1.0f/FPS) {
				runEt -= 1.0f/FPS;
				if ([frameRects count] > currentFrame ) {
					currentFrame ++;
                    
                    
					
				}else {
					currentFrame = 0;
					endEt = et;
					runAni = NO;
                    if (Gambbak) {
                        self.visible = NO;
                    }
					
				}
                
				if (currentFrame > [frameRects count])
                    currentFrame = [frameRects count]-1;
                
                @try{
                    //NSLog(@"currentFrame:%d maxCount:%d",currentFrame,[frameRects count]);
                    [self setTextureRect:[(NSValue*)[frameRects objectAtIndex:currentFrame] CGRectValue]];
                    
                } @catch (NSException * e){
                    NSLog(@"Frame Error");
                }

			}
		}
	}
	
	if (!runAni) {
		if (delay != -1) {
			if (et - endEt > delay) {
				[self repeatAni];
			}
		}else if (restart != -1) {
			if (et > restart) {
				[self restartAni];
			}
		}
	}
	
	
}

-(void)restartAni {
	runAni = YES;
	et = 0;
	runEt = 0;
}

-(void)repeatAni {
	runAni = YES;
	et = begin;
	runEt = 0;
}
-(void)noGambbak{
    Gambbak = NO;
}
-(void)dealloc {
	
	[frameRects removeAllObjects];
	[frameRects release];
	[super dealloc];
}

@end
