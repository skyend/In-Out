//
//  ScatterEffect.h
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 6. 17..
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//코코스2D이미지 이펙터 명: 흩어퍼지는 이펙터
//초기화인수 이미지파일명
//이동,크기조절,투명도를 조합하여 이펙트를 구현할수있으며
//각 부문마다 시간,목표변화값 둘중의 하나의 방법으로 애니메이션이 가능하다.
//시간,목표변화값 모두 설정될시 목표변화값에 의한 애니메이션만 작동한다.
//시간기반 이펙팅 설정시 변화하는시간,매초당 변화값을 설정해야하며
//목표변화값 이펙팅설정시 목표변화값,매초 변화값을 설정해야한다.
//모두 설정후에 루프가 작동하도록 상위루프에서 실행을 시켜주고
//마지막으로 스타트 명령을 내린후 설정을 마친다

//주의 : 투명도,포지션,스케일 값은 이펙터 인터페이스에 명시된 메소드외의 조작은 금지한다.
#define ScatterEffect_Property_ValueNull -999999

@interface ScatterEffect : CCSprite {
    float eT; //경과시간
    
    
    
    BOOL run;
    BOOL movingRun;
    BOOL scalingRun;
    BOOL opacityRun;
    
    //MovingAni
    CGPoint beginPosition;
    CGPoint movingSpeed;
    CGPoint targetPosition; //0이상이면 작동
    float movingTime; //0이상이면 작동
    
    //Scaling Ani
    CGPoint increaseScale; //매초증가하는 스케일값
    CGPoint maxScale; //최대증가스케일
    CGPoint minScale;
    float scalingTime; //0이상이면 작동
    
    //opacity Ani
    float subOpacity; // substitute : 대신하는사람 Opacity
    GLubyte beginOpacity;
    float translateOpacity; //투명도 변화값
    int targetOpacty;
    float opacityAniTime;
    
    //한세트로 세팅하는것들
    //발동간격
    BOOL repeat;
    BOOL randomRepeat; //랜덤으로 발동할거냐
    NSRange randomRepeatRange; //한다면 어느범위로
    float repeatInterval; //랜덤이 아니라면 간격설정

}

@property CGPoint movingSpeed;
@property CGPoint targetPosition;
@property float movingTime;

@property CGPoint increaseScale;
@property CGPoint maxScale;
@property float scalingTime;

@property float translateOpacity;
@property int targetOpacty;
@property float opacityAniTime;

-(id)initWithFile:(NSString*)file_;
-(void)start;
-(void)setRepeatToDoRandom:(BOOL)randomRepeat_ RandomRepeatRange:(NSRange)randomRepeatRange_ RepeatInterval:(float)repeatInterval_;

-(void)update:(ccTime)d;

-(void)setBeginOpacity:(GLubyte)beginOpacity_;
-(void)setBeginPosition:(CGPoint)beginPosition_;
-(void)setMinScale:(CGPoint)minScale_;

@end
