//
//  ShineEffect.m
//  KeepinTheMind
//
//  Created by JinUng Han on 11. 5. 16..
//  Copyright 2011 Student. All rights reserved.
//

#import "ShineEffect.h"
#import "SoundManager.h"
#import "AudioPlayer.h"

@interface ShineEffect (privateMethods)
-(void)initRunValue;
-(void)repeatEffect;
@end

@implementation ShineEffect
@synthesize duration,shineNum,beginDelay,kindofEffect;

-(id)initWithSource:(NSString*)sourceImg_{
    if ( (self = [ super init] )) {
        [self setTexture:[[CCTextureCache sharedTextureCache] addImage:sourceImg_]];
		[self setTextureRect:CGRectMake(0, 0, [[self texture] contentSize].width, [[self texture] contentSize].height)];
        
        et = 0;
        duration = 0;
        shineNum = 1;
        minOpacity = 0;
        maxOpacity = 1;
        minAngle = 0;
        maxAngle = 0;
        beginDelay = 0;
        delay = 0;
        transferDelayRange = 0;
        transferShineRange = 0;
        transferDurationRange = 0;
        
        repeat = NO;
        randomAngle = NO;
        transferBeat = NO;
        transferShine = NO;
        transferBeatRest = NO;
        transferPosition = NO;
        transferScaleX = NO;
        transferScaleY = NO;
        increasePosition = NO;
        increaseScale = NO;
        
        state = SE_Running;
    }
    return self;
}

-(void)update:(ccTime)delta {
    
    if (state == SE_Running) {
        et += delta;
        
        if (runOrRest) {
            if (et >= beginDelay) {
                [self initRunValue]; //이펙트 작동전에 설정된 변수로 작동변수 초기화
                //NSLog(@"aa");
                if (OTCounter%2 == 1) { //홀수이면 증가
                    subOpacity += opacityDelta*(delta+leaveDelta)*TvPsRatio;
                    if (subOpacity > 1) {
                        subOpacity = 1;
                        [self initRunValue];
                    }
                }else{
                    subOpacity -= opacityDelta*(delta+leaveDelta)*TvPsRatio;
                    if (subOpacity < 0) {
                        subOpacity = 0;
                        
                    }
                }
                
                leaveDelta = 0; //더했으니 0으로 비움
                
                if (et-beginDelay >= TvPs*OTCounter) {
                    leaveDelta = (et-beginDelay)-(OTCounter*TvPs);
                    
                    if (OTCounter%2 == 1) {
                        subOpacity = maxOpacity;
                    }else{
                        subOpacity = minOpacity;
                    }
                    
                    OTCounter ++;
                    if (OTCounter == OTC+1) {
                        runOrRest = NO; //휴식기
                        et = 0;
                    }
                }
                //NSLog(@"LeaveDelta:%f",leaveDelta);
                //NSLog(@"opacity:%f int:%d",subOpacity*255,(int)(subOpacity*255));
                //NSLog(@"subOpacity:%f",subOpacity);
                self.position = ccp(self.position.x+subIncreasePosition.x*delta,self.position.y+subIncreasePosition.y*delta);
                if (increaseScale) {
                    subScale += (subIncreaseScale*100)*delta;
                    self.scale = subScale * 0.01f;
                }
                
                self.opacity = (int)(subOpacity*255);
                
            }
        }else{
            if (repeat) {
                if (et > subDelay) {
                    [self repeatEffect];
                }
            }
            
        }
    }
    
}

-(void)initRunValue{
    if (initializeRunValues) { //초기화 되었다면 그후부터 무시
        return;
    }
    subOpacity = minOpacity;
    self.opacity = (int)(minOpacity* 255);
    subDuration = (transferBeat)? duration + (transferDurationRange/2 - (((rand()%100)*transferDurationRange)/100)):duration;
    subDelay = (transferBeatRest)? delay + (transferDelayRange/2 - (((rand()%100)*transferDelayRange)/100)):delay;
    subShining = (transferShine)? shineNum + (transferShineRange/2 - (((rand()%100)*transferShineRange)/100)):shineNum;
    
    if (transferScale) { //
        subScale = (transferScale)? minScale + rand()%(maxScale-minScale):self.scale * 100;
        self.scale = subScale * 0.01f;
    }else{
        subScaleX = (transferScaleX)? minScaleX + rand()%(maxScaleX-minScaleX):self.scaleX * 100;
        self.scaleX = subScaleX * 0.01;
        subScaleY = (transferScaleY)? minScaleY + rand()%(maxScaleY-minScaleY):self.scaleY * 100;
        self.scaleY = subScaleY * 0.01;
    }
    
    
    subPosition = (transferPosition)? ccp(transferPositionRect.origin.x + rand()%(int)transferPositionRect.size.width,transferPositionRect.origin.y + rand()%(int)transferPositionRect.size.height):self.position;
    self.position = subPosition;
    subAngle = (randomAngle)? minAngle+rand()%(int)(maxAngle-minAngle):self.rotation;
    self.rotation = subAngle;
    
    subIncreaseScale = (increaseScale)? ((minIncreaseScale*10000)+rand()%(int)((maxIncreaseScale-minIncreaseScale)*10000))*0.0001f :0;
    subIncreasePosition = (increasePosition)? ccp(((increasePositionRangeRect.origin.x*10000)+rand()%(int)((increasePositionRangeRect.size.width-increasePositionRangeRect.origin.x)*10000))*0.0001f,((increasePositionRangeRect.origin.y*10000)+rand()%(int)((increasePositionRangeRect.size.height-increasePositionRangeRect.origin.y)*10000))*0.0001f) : ccp(0,0);
    
    OTC = subShining*2;
    OTCounter = 1;
    TvPs = subDuration/OTC;
    TvPsRatio = 1/TvPs;
    opacityDelta = maxOpacity - minOpacity;
    
    switch (kindofEffect) {
        case Lightning:
            [[AudioPlayer sharedAudioPlayer] playEffectSound:@"Thunder and Lightning 1.caf"];
            break;
            
        default:
            break;
    }
    
    initializeRunValues = YES;
}

-(void)repeatEffect {
    initializeRunValues = NO;
    runOrRest = YES;
    et = beginDelay;
}

-(void)setDelay:(float)delay_{
    delay = delay_;
    repeat = YES;
}

-(void)setOpacityRange:(float)min_ Max:(float)max_{
    self.opacity = min_*255;
    minOpacity = min_;
    maxOpacity = max_;
}

-(void)setAngleRange:(float)min_ Max:(float)max_{
    minAngle = min_;
    maxAngle = max_;
    randomAngle = YES;
}

-(void)setTransferDelayRange:(float)TDR_{
    transferDelayRange = TDR_;
    transferBeatRest = YES;
}
-(void)setTransferDurationRange:(float)TDuR_{
    transferDurationRange = TDuR_;
    transferBeat = YES;
}
-(void)setTransferShineRange:(int)TSR_{
    transferShineRange = TSR_;
    transferShine = YES;
}
-(void)setTransferScaleXRange:(float)min_ Max:(float)max_{
    minScaleX = min_;
    maxScaleX = max_;
    transferScaleX = YES;
}
-(void)setTransferScaleYRange:(float)min_ Max:(float)max_{
    minScaleY = min_;
    maxScaleY = max_;
    transferScaleY = YES;
}
-(void)setTransferScaleRange:(float)min_ Max:(float)max_{
    minScale = min_;
    maxScale = max_;
    transferScale = YES;
}
-(void)setTransferPositionRect:(CGRect)rect__{
    transferPositionRect = rect__;
    transferPosition = YES;
}

//-(void)setIncreasePosition:(CGPoint)pt_{}
-(void)setIncreasePositionRect:(CGRect)rect__{
    increasePositionRangeRect = rect__;
    increasePosition = YES;
}

-(void)setIncreaseScaleRange:(float)min_ Max:(float)max_{
    minIncreaseScale = min_;
    maxIncreaseScale = max_;
    increaseScale = YES;
}

-(void)runningControll:(SE_ControllFlags)flag{
    state = flag;
    
    if (state == SE_Restart) {
        [self repeatEffect];
        state = SE_Running;
    }
    
}

-(void)stopRepeat {
    repeat = NO;
}

-(void)playRepeat {
    repeat = YES;
}

@end
