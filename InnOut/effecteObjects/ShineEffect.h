//
//  ShineEffect.h
//  KeepinTheMind
//
//  Created by JinUng Han on 11. 5. 16..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DynamicObject.h"
//랜덤적인 발동 간격
//한번 발동시에 몇번 반짝일지 (랜덤가능 랜덤범위설정)
//이펙트 시작시 최소와 최대의 투명도
//이펙트 절정때 최소와 최대의 투명도

typedef enum {
    SE_Running,
    SE_Suspend,
    SE_Restart,
}SE_ControllFlags;

typedef enum{
    None,
    Lightning
}KindOfeffect;

@interface ShineEffect : DynamicObject {
    SE_ControllFlags state;
    
    float et;
    
    //Setting Values
    float duration;
    float transferDurationRange;
    
    int   shineNum;
    int   transferShineRange;
    
    float minOpacity; // 0 ~ 1
    float maxOpacity; // minOpacity ~ 1
    float minAngle; //0 ~ 360 //int
    float maxAngle; //minAngle ~ 360
    
    CGRect transferPositionRect;
    
    //백분율 0이상 기본값 100
    int minScaleX;
    int maxScaleX;
    int minScaleY;
    int maxScaleY;
    int minScale;
    int maxScale;
    
    float beginDelay;
    float delay;
    float transferDelayRange; // 10이 설정되면 -5 ~ +5 사이의 값으로 딜레이에 더해 적용한다.
    
    BOOL  runOrRest;
    BOOL  repeat;
    BOOL  randomAngle;
    //엇박이펙트 정해진 딜레이에 약간의 랜덤 값을더해 반복간격을 엇갈리게한다. //용도는 번개효과
    BOOL  transferBeatRest; // 딜레이 랜덤
    BOOL  transferBeat; // 이펙트 지속시간 랜덤
    BOOL  transferShine; // 반짝임 랜덤
    BOOL  transferPosition;
    BOOL  transferScaleX;
    BOOL  transferScaleY;
    BOOL  transferScale;
    BOOL  increaseScale;
    BOOL  increasePosition;
    
    //런타임중 동작제어 설정값
    CGRect increasePositionRangeRect;
    float minIncreaseScale;
    float maxIncreaseScale;
    
    //Run values
    BOOL initializeRunValues;
    float subOpacity;
    float subDuration;
    float subAngle;
    CGPoint subPosition;
    int subScaleX;
    int subScaleY;
    int subScale;
    float subDelay;
    int subShining;
    float subIncreaseScale;
    CGPoint subIncreasePosition;
    
    
    float opacityDelta; //투명도의 변화에서 변화하는 양
    int OTC; //Opacity translate Count
    int OTCounter;
    float TvPs; //투명도가 오르거나 내릴때 한번 소요되는 시간
    float TvPsRatio; //한번의 변화에 소요되는시간을 정해 시간변화값에 적용하는 변수
    float leaveDelta;
    
    KindOfeffect kindofEffect;
}
@property float duration; //필수
@property int shineNum;
@property float beginDelay;
@property KindOfeffect kindofEffect;

-(void)setDelay:(float)delay_;
-(void)setOpacityRange:(float)min_ Max:(float)max_;
-(void)setAngleRange:(float)min_ Max:(float)max_;

-(void)setTransferDelayRange:(float)TDR_;
-(void)setTransferShineRange:(int)TSR_;
-(void)setTransferDurationRange:(float)TDuR_;
-(void)setTransferScaleXRange:(float)min_ Max:(float)max_;
-(void)setTransferScaleYRange:(float)min_ Max:(float)max_;
-(void)setTransferScaleRange:(float)min_ Max:(float)max_;
-(void)setTransferPositionRect:(CGRect)rect__;
-(id)initWithSource:(NSString*)sourceImg_;

//런타임중 움직임 부여
//-(void)setIncreasePosition:(CGPoint)pt_;
//-(void)setIncreaseScale:(float)scale__;
-(void)setIncreasePositionRect:(CGRect)rect__;
-(void)setIncreaseScaleRange:(float)min_ Max:(float)max_;

-(void)runningControll:(SE_ControllFlags)flag;
-(void)stopRepeat;
-(void)playRepeat;

@end
