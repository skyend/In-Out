//
//  ScatterEffect.m
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 6. 17..
//  Copyright 2011 -. All rights reserved.
//

#import "ScatterEffect.h"



//움직임 움직임 속도
//스케일의 x,y각각 따로 컨트롤
//

@implementation ScatterEffect
@synthesize movingSpeed,maxScale,increaseScale,targetPosition,movingTime,scalingTime,translateOpacity,targetOpacty,opacityAniTime;

-(id)initWithFile:(NSString*)file_{
    if ( (self = [super init] )) {
        CCTexture2D * tex = [[CCTextureCache sharedTextureCache] addImage:file_];
        CGRect rect = CGRectZero;
        rect.size = tex.contentSize;
        [self setTexture:tex];
        [self setTextureRect:rect];
        
        movingSpeed = ccp(ScatterEffect_Property_ValueNull,ScatterEffect_Property_ValueNull);
        targetPosition = ccp(ScatterEffect_Property_ValueNull,ScatterEffect_Property_ValueNull);
        movingTime = ScatterEffect_Property_ValueNull;
        
        increaseScale = ccp(ScatterEffect_Property_ValueNull,ScatterEffect_Property_ValueNull);
        maxScale = ccp(ScatterEffect_Property_ValueNull,ScatterEffect_Property_ValueNull);
        scalingTime = ScatterEffect_Property_ValueNull;
        
        translateOpacity = ScatterEffect_Property_ValueNull;
        targetOpacty = ScatterEffect_Property_ValueNull;
        opacityAniTime = ScatterEffect_Property_ValueNull;
        
        minScale = ccp(1,1);
        beginOpacity = 255;
        subOpacity = subOpacity;
        
        eT = 0;
        
        
    }
    return self;
}

-(void)start{
    run = movingRun = scalingRun = opacityRun = YES;
    eT = 0;
    self.position = beginPosition;
    subOpacity = beginOpacity;
    self.opacity = subOpacity;
    self.scaleX = minScale.x;
    self.scaleY = minScale.y;

    if (randomRepeat) { //랜덤 리핏이 설정되어있다면 시작하는순간 다시시작할 간격을 랜덤으로 정해둔다
        repeatInterval = randomRepeatRange.location + rand()%randomRepeatRange.length;
    }
}

-(void)setRepeatToDoRandom:(BOOL)randomRepeat_ RandomRepeatRange:(NSRange)randomRepeatRange_ RepeatInterval:(float)repeatInterval_{
    repeat = YES;
    randomRepeat = randomRepeat_;
    randomRepeatRange = randomRepeatRange_;
    repeatInterval = randomRepeat? repeatInterval_:repeatInterval;
}

-(void)update:(ccTime)d{

    if (run) {
        eT += d;
        
        if (movingRun == YES) { //무빙액션
            //NSLog(@"movingRun == YES");
            //목표점까지의 애니메이션인가 지정한시간동안의 애니메이션인가
            if (targetPosition.x != ScatterEffect_Property_ValueNull || targetPosition.y != ScatterEffect_Property_ValueNull) { //목표점이 설정되었다면
                //NSLog(@"aa");
                BOOL XArrived = NO;
                BOOL YArrived = NO;
                if (movingSpeed.x != ScatterEffect_Property_ValueNull){
                    if (movingSpeed.x < 0) { // 부호 -
                        if (self.position.x > targetPosition.x) // 이동속도가 -일때 목표점보다 현재 지점이 높으면 이동
                            self.position = ccp(self.position.x + movingSpeed.x*d, self.position.y);
                        else 
                            XArrived = YES;
                    
                    }else{//부호 +
                        if (self.position.x < targetPosition.x) // 이동속도가 +일때 목표점보다 현재 지점이 낮은값이면 이동
                            self.position = ccp(self.position.x + movingSpeed.x*d, self.position.y);
                        else
                            XArrived = YES;
                    }
                }else{
                    XArrived = YES;
                }
                
                if (movingSpeed.y != ScatterEffect_Property_ValueNull){
                    if (movingSpeed.y < 0) { //부호 -
                        if (self.position.y > targetPosition.y) // 이동속도가 -일때 목표점보다 현재 지점이 높으면 이동
                            self.position = ccp(self.position.x, self.position.y + movingSpeed.y*d);
                        else
                            YArrived = YES;

                    }else{//부호 +
                        if (self.position.y < targetPosition.y) // 이동속도가 -일때 목표점보다 현재 지점이 높으면 이동
                            self.position = ccp(self.position.x, self.position.y + movingSpeed.y*d);
                        else
                            YArrived = YES;
                    }
                }else{
                    YArrived = YES;
                }
               
                
                if (XArrived == YES && YArrived == YES) movingRun = NO; // XY둘다 끝났으면 했으면 그만
                
            }else if (movingTime != ScatterEffect_Property_ValueNull){ //지정된 시간동안 애니메이션
                //NSLog(@"movingTime != 0");
                if (movingTime < eT){  //현재까지의 누적된 시간이 움직임의 시간을 초과했을때
                    movingRun = NO; //그만작동
                }else{
                    //NSLog(@"moving!! d:%f",d);
                    if (movingSpeed.x != ScatterEffect_Property_ValueNull)
                        self.position = ccp(self.position.x + movingSpeed.x*d, self.position.y);
                    if (movingSpeed.y != ScatterEffect_Property_ValueNull)
                        self.position = ccp(self.position.x, self.position.y + movingSpeed.y*d);
                }
                
            }else{//아무것도 설정된게 없다면
                movingRun = NO;
            }
            
            
        }
        if (scalingRun == YES) {
            //목표점까지의 애니메이션인가 지정한시간동안의 애니메이션인가
            if (maxScale.x != ScatterEffect_Property_ValueNull || maxScale.y != ScatterEffect_Property_ValueNull) { //목표점이 설정되었다면
                BOOL XArrived = NO;
                BOOL YArrived = NO;
                if (increaseScale.x != ScatterEffect_Property_ValueNull){
                    if (increaseScale.x < 0) { // 부호 -
                        if (self.scaleX > maxScale.x) 
                            self.scaleX += increaseScale.x*d;
                        else 
                            XArrived = YES;
                    
                    }else{//부호 +
                        if (self.scaleX < maxScale.x) 
                            self.scaleX += increaseScale.x*d;
                        else
                            XArrived = YES;
                    }
                }else{
                    XArrived = YES;
                }
                
                if (increaseScale.y != ScatterEffect_Property_ValueNull){
                    if (increaseScale.y < 0) { //부호 -
                        if (self.scaleY > maxScale.y)
                            self.scaleY += increaseScale.y*d;
                        else
                            YArrived = YES;
                    
                    }else{//부호 +
                        if (self.scaleY < maxScale.y) 
                            self.scaleY += increaseScale.y*d;
                        else
                            YArrived = YES;
                    }
                }else{
                    YArrived = YES;
                }
                
                
                if (XArrived == YES && YArrived == YES) scalingRun = NO; // XY둘다 끝났으면 했으면 그만
                
            }else if (scalingTime != ScatterEffect_Property_ValueNull){ //지정된 시간동안 애니메이션
                if (scalingTime < eT){  //현재까지의 누적된 시간이 움직임의 시간을 초과했을때
                    scalingRun = NO; //그만작동
                }else{
                    //NSLog(@"increaseSacleX:%f",increaseScale.x);
                    if (increaseScale.x != ScatterEffect_Property_ValueNull)
                        self.scaleX += increaseScale.x*d;
                    if (increaseScale.y != ScatterEffect_Property_ValueNull)
                        self.scaleY += increaseScale.y*d;
                }
            }else{
                scalingRun = NO;
            }
            
        }
        if (opacityRun == YES) {
            if (targetOpacty != ScatterEffect_Property_ValueNull) {
                subOpacity += translateOpacity*d;
                //NSLog(@"subOpacity:%f",subOpacity);
                if (translateOpacity < 0) { //부호 -
                    if (subOpacity <= targetOpacty) {
                        opacityRun = NO;
                    }
                }else {
                    if (subOpacity >= targetOpacty) {
                        opacityRun = NO;
                    }
                }
            }else if(opacityAniTime != ScatterEffect_Property_ValueNull){
                subOpacity += translateOpacity*d;
                if (opacityAniTime < eT) {
                    opacityRun = NO;
                }
            }else{
                opacityRun = NO;
            }
            
            //투명도 범위값 교정
            if (subOpacity > 255) {
                subOpacity = 255;
            }else if(subOpacity < 0){
                subOpacity = 0;
            }
            
            self.opacity = (int)subOpacity;
            //NSLog(@"self.opacity:%d",self.opacity);
        }
        
        if (movingRun == NO && scalingRun == NO && opacityRun == NO){//모든 애니메이션이 끝나면
            //NSLog(@"====================All Ani End=================");
            run = NO;
            eT = 0;
        }
        
    }else{ //런이 끝나면
        //NSLog(@"Repeat Stay eT:%f",eT);
        
        eT += d;
        if (repeat)
            if (repeatInterval < eT)
                [self start];
         
    }
}

-(void)setBeginOpacity:(GLubyte)beginOpacity_{
    beginOpacity = beginOpacity_;
    subOpacity = beginOpacity;
    self.opacity = beginOpacity;
}

-(void)setBeginPosition:(CGPoint)beginPosition_{
    beginPosition = beginPosition_;
    self.position = beginPosition;
}

-(void)setMinScale:(CGPoint)minScale_{
    minScale = minScale_;
    self.scaleX = minScale.x;
    self.scaleY = minScale.y;
}

@end
