//
//  GraphDisplay.h
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 6. 4..
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConfig.h"
#import "cocos2d.h"



typedef struct LLPoint LLPoint;

@interface GraphDisplay : CCNode {
    NSArray * dataList; // 데이터
    double    dataScaling; //데이터의 최대값이 32비트를 넘어가면 스케일링되어야 하기에 지정한 축적비율
    double     maxHeight; //그래프의 최대 높이
    double     widthInterval; //그래프값 마다의 간격
    NSRange   displayRange; // 데이터리스트의 그래프 표시 범위 
    CGRect    scissorBox; //그래프를 표시하는 범위
    double     sliding; //천천히 끝점 까지 슬라이딩되는 속도 (초당)
    CGPoint * outLineVertices;
    CGPoint * vertices;
    int verticesLength;
    
    double GraphScaleX;
    double GraphScaleY; //최대 높이가 넘어갈수록 스케일을 축소시킴
    double GraphPosX;
    
    int dataCount;
    unsigned long long maxOfvalue; //디스플레이되거나 디스플레이될 예정인 그래프에서 가장 높은 값
    unsigned long long valueHeader; //제일 마지막으로 보인 그래프의 값
    int dataListHeader; //제일 마지막으로 디스플레이된 데이터의 카운터
    CCLabelAtlas * dataListHeaderValue;
    CCLabelAtlas * dataListMaxOfValueValue;
    
    GLColorSet graphColor;
    GLColorSet graphOutLineColor;
    GLColorSet valueHeaderClor;
    GLColorSet maxOfValueColor;
    CGFloat valueHeaderXPos;
    CGFloat maxOfValueXPos;
    
    BOOL ratina;
    float scaleFactor;
}

@property GLColorSet graphColor;
@property GLColorSet graphOutLineColor;
@property GLColorSet valueHeaderClor;
@property GLColorSet maxOfValueColor;
@property CGFloat valueHeaderXPos;
@property CGFloat maxOfValueXPos;

-(id)initWithGraphData:(NSArray*)dataList_ MaxHeight:(double)maxHeight_ WidthInterval:(double)widthInterval_ DisplayDataRange:(NSRange)displayRange_ ScissorBox:(CGRect)scissorBox_ Slidng:(double)sliding_; 

-(void)GLErrorCheck;
-(void)reProgressWithNewData:(NSArray*)dataList_;
-(void)update:(ccTime)d;
@end
