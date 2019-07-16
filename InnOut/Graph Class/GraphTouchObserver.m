//
//  GraphTouchObserver.m
//  KEEPINGSHAPE
//
//  Created by JinWoong Han on 11. 8. 10..
//  Copyright 2011 -. All rights reserved.
//

#import "GraphTouchObserver.h"
#import "SoundManager.h"

@implementation GraphTouchObserver
@synthesize touching,moving,end,beginPos,endPos;


-(id)init {
    if ( (self = [super init] )) {
    
        
        self.anchorPoint = ccp(0,0);
        self.position = ccp(0,0);
        self.isTouchEnabled = YES;
    }
    return self;
}



-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch*)touch withEvent:(UIEvent*)event {	
	CGPoint conPos = [self convertTouchToNodeSpace:touch];
    
    end = NO;
    beginPos = conPos;
    touching = YES;
    prevPos = conPos;
    
    oneMoved = NO;
    
    if (beginPos.y < 70)
        [[SoundManager sharedSM] playButtonTouchBegin];
    
	return YES;
}

-(void)ccTouchMoved:(UITouch*)touch withEvent:(UIEvent*)event {
	CGPoint conPos = [self convertTouchToNodeSpace:touch];
    vector = ccp(-1*(prevPos.x-conPos.x),-1*(prevPos.y-conPos.y));
    
    //NSLog(@"vector x:%f y:%f",vector.x,vector.y);
    prevPos = conPos;
    moving = YES;
    
    //처음 드래그가 실행됐을때
    if (!oneMoved) {
        oneMoved = YES;
        
        [[SoundManager sharedSM] dragCardSE]; 
        //드래그중 방향을 바꿧을때
    }else{
        if(vector.x < 0){ //벡터x가 -이면 
            if (prevVector.x > 0) {
               [[SoundManager sharedSM] dragCardSE]; 
            }
        }else{
            if (prevVector.x < 0) {
                [[SoundManager sharedSM] dragCardSE];
            }
        }
    }
    
    prevVector = vector;
}

-(void)ccTouchEnded:(UITouch*)touch withEvent:(UIEvent*)event {
	CGPoint conPos = [self convertTouchToNodeSpace:touch];
    
    endPos = conPos;
    end = YES;
    
    touching = NO;
    moving = NO;
    
    if (beginPos.y < 70)
        [[SoundManager sharedSM] playButtonTouch];
}

-(float)vectorX {
    float vector_ = vector.x;
    vector = CGPointMake(0, vector.y);
    return vector_;
}
-(float)vectorY {
    float vector_ = vector.y;
    vector = CGPointMake(vector.x, 0);
    return vector_;
}

-(void)dealloc {
    [super dealloc];
    
}

@end
