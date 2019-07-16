//
//  GraphDisplay.m
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 6. 4..
//  Copyright 2011 -. All rights reserved.
//

#import "GraphDisplay.h"



void ccFillPoly( CGPoint *poli, int points, BOOL closePolygon )
{
    // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
    // Needed states: GL_VERTEX_ARRAY,
    // Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY, GL_COLOR_ARRAY
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    
    glVertexPointer(2, GL_FLOAT, 0, poli);
    if( closePolygon )
        // glDrawArrays(GL_LINE_LOOP, 0, points);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, points);
    else
        glDrawArrays(GL_LINE_STRIP, 0, points);
    
    // restore default state
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glEnable(GL_TEXTURE_2D);
}

@implementation GraphDisplay
@synthesize graphColor,graphOutLineColor,valueHeaderClor,maxOfValueColor,valueHeaderXPos,maxOfValueXPos;



-(id)initWithGraphData:(NSArray*)dataList_ MaxHeight:(double)maxHeight_ WidthInterval:(double)widthInterval_ DisplayDataRange:(NSRange)displayRange_ ScissorBox:(CGRect)scissorBox_ Slidng:(double)sliding_ {
    if ( (self = [super init] )) {
        scaleFactor = [[CCDirector sharedDirector] contentScaleFactor];
        dataList = [[NSArray alloc] initWithArray:dataList_];
        maxHeight = maxHeight_;
        widthInterval  = widthInterval_;
        displayRange = displayRange_;
        scissorBox = scissorBox_;
        sliding = sliding_*scaleFactor;
        
        GraphScaleX = 1;
        GraphScaleY = 1;
        GraphPosX = (scissorBox.origin.x*scaleFactor)  + (scissorBox.size.width*scaleFactor);
        
        //레티나 체크 레티나도 정상작동하도록 수정해야함 #################
        //################코드 수정ㄱ#ㄱㄱ#########################
        

        
        unsigned long long valueOfmax = 0;
        for (NSNumber * n in dataList){
            //NSLog(@"%llu",[n unsignedLongLongValue]);
            valueOfmax = MAX(valueOfmax, [n unsignedLongLongValue]); //최대값 구하기
        }
        //NSString *valueLength = [NSString stringWithFormat:@"%lld",valueOfmax];
        dataScaling = 4;
        //NSLog(@"aa1");
        
        //NSLog(@"%lld",valueOfmax);
        
        dataCount = [dataList count];
        verticesLength = (dataCount*2);

        CGPoint * tempPoints = (CGPoint*)malloc(sizeof(CGPoint)*verticesLength);
        
        for (int i = 0; i < dataCount; i++) {
            
            float rocateX = (widthInterval * i)*scaleFactor;
            float rocateY = (([[dataList objectAtIndex:i] unsignedLongLongValue] * 1.0f)/dataScaling)*scaleFactor; //dataSacling
            tempPoints[i*2] = ccp(rocateX , 0);//floor;
            tempPoints[i*2+1] = ccp(rocateX , rocateY);//top;
            NSLog(@"x:%f y:%f",rocateX,rocateY);
        }
        vertices = tempPoints;
       //NSLog(@"aa3");
        //아웃라인 모델링데이터
//        CGPoint * tempOutLinePoints = (CGPoint*)malloc(sizeof(CGPoint)*dataCount+2);
//        for(int i = 0; i < dataCount+2; i++){
//            if (i == 0) {
//                tempOutLinePoints[i] = ccp(0,0);
//                printf("\n i:%d , dataCount+2:%d",i,dataCount+2);
//            }else if(i == dataCount+2-1){ //젤 마지막 값
//                tempOutLinePoints[i] = ccp(widthInterval*dataCount,0);
//                printf("\n i:%d , dataCount+2:%d",i,dataCount+2);
//            }else{
//                int rocateX = widthInterval * i-1;
//                int rocateY = [[dataList objectAtIndex:i-1] intValue];
//                tempOutLinePoints[i] = ccp(rocateX,rocateY);
//                printf("\n i:%d , dataCount+2:%d",i,dataCount+2);
//            }
//        }
        CGPoint * tempOutLinePoints = (CGPoint*)malloc(sizeof(CGPoint)*dataCount);
        for(int i = 0; i < dataCount; i++){
            int rocateX = widthInterval * i;
            float rocateY = ([[dataList objectAtIndex:i] unsignedLongLongValue]/dataScaling);
            tempOutLinePoints[i] = ccp(rocateX,rocateY);
           //printf("\n i:%d , dataCount+2:%d",i,dataCount);
        }
        outLineVertices = tempOutLinePoints;
        //NSLog(@"aa4");
        dataListHeaderValue = [CCLabelAtlas labelWithString:@"00" charMapFile:@"GameText-score11.png" itemWidth:11 itemHeight:17 startCharMap:'.'];
        [dataListHeaderValue setAdjustWordBetween:-5/2];
        [dataListHeaderValue setAnchorPoint:ccp(0,0)];
        [self addChild:dataListHeaderValue];
        //NSLog(@"aa5");
        dataListMaxOfValueValue = [CCLabelAtlas labelWithString:@"00" charMapFile:@"GameText-score11.png" itemWidth:11 itemHeight:17 startCharMap:'.'];
        [dataListMaxOfValueValue setAdjustWordBetween:-5/2];
        [dataListMaxOfValueValue setAnchorPoint:ccp(0,0)];
        [self addChild:dataListMaxOfValueValue];
        //NSLog(@"aa6");
    }
    return self;
}
-(void)reProgressWithNewData:(NSArray*)dataList_{

}

-(void)update:(ccTime)d{

    if (dataListHeader < dataCount-1) {
        GraphPosX -= sliding*d;
    }
    //NSLog(@"up1");
    //double movedX = (((scissorBox.size.width*scaleFactor)-(widthInterval*scaleFactor))-GraphPosX); //이동량을 구함
    double movedX = (((scissorBox.size.width*scaleFactor)-(3*scaleFactor))-GraphPosX); //이동량을 구함
    double distanceX = fabs(movedX);
    //NSLog(@"movedX:%f",movedX);
    if (movedX >= 0) { //헤더포인트를 지난후
        dataListHeader = (distanceX / (widthInterval*scaleFactor)); //이동량과 데이터간의 간격을 이용해서 마지막으로 디스플레이된 데이터값의 인덱스를 구함
        double dataListHeaderPrimeNum = ( distanceX / (widthInterval*scaleFactor)) -  dataListHeader;
        if (dataListHeaderPrimeNum > 0.99f) { //.99에 도달하면 헤더에 해당하는 점수를 계산하기위해 교정해줌 
            dataListHeaderPrimeNum = 1;
        }
        if (dataListHeader < dataCount-1) {
            int delta = [[dataList objectAtIndex:dataListHeader+1] unsignedLongLongValue] - [[dataList objectAtIndex:dataListHeader] unsignedLongLongValue]; // 데이터와 데이터 사이의 변화량
            
            if (([[dataList objectAtIndex:dataListHeader] unsignedLongLongValue] + (delta * dataListHeaderPrimeNum)) < 0) {
                valueHeader = 0;
            }else{
                valueHeader = ([[dataList objectAtIndex:dataListHeader] unsignedLongLongValue] + (delta * dataListHeaderPrimeNum));
            }
            NSLog(@"valueHeader:%llu",valueHeader);
            maxOfvalue = MAX(valueHeader, maxOfvalue);
            NSLog(@"valueHeader:%llu dataListHeaderPrimeNum:%f dataListHeader:%d movedX:%f",valueHeader,dataListHeaderPrimeNum,dataListHeader,movedX);
            NSLog(@"Number at DataListHeader:%llu",[[dataList objectAtIndex:dataListHeader] unsignedLongLongValue]);
        }
    //NSLog(@"up2");
        if (valueHeader > maxHeight) {
            GraphScaleY = fmin(GraphScaleY,maxHeight/(valueHeader/dataScaling));
        }
    
    
        [dataListHeaderValue setPosition:ccp(valueHeaderXPos+5,((valueHeader/dataScaling)*GraphScaleY))];
        
        NSMutableString * headerValueStr = [NSMutableString stringWithFormat:@"%llu",(valueHeader)];
        if ([headerValueStr length] > 3) {
            int length = [headerValueStr length];
            int pushCommaCount = roundf(length/3);
            
            for (int i = 1; i <= pushCommaCount; i++) {
                if(length%3 == 0){
                    if (i != pushCommaCount) {
                        [headerValueStr insertString:@"." atIndex:[headerValueStr length]-((i*3)+i-1)]; 
                    }
                }else{
                    [headerValueStr insertString:@"." atIndex:[headerValueStr length]-((i*3)+i-1)];  
                } 
            }
        }
        [dataListHeaderValue setString:headerValueStr];
        
        
        [dataListMaxOfValueValue setPosition:ccp(maxOfValueXPos+5,((maxOfvalue/dataScaling)*GraphScaleY))];
        
        NSMutableString * maxOfValueValueStr = [NSMutableString stringWithFormat:@"%llu",(maxOfvalue)];
        if ([maxOfValueValueStr length] > 3) {
            int length = [maxOfValueValueStr length];
            int pushCommaCount = roundf(length/3);
            
            for (int i = 1; i <= pushCommaCount; i++) {
                if(length%3 == 0){
                    if (i != pushCommaCount) {
                        [maxOfValueValueStr insertString:@"." atIndex:[maxOfValueValueStr length]-((i*3)+i-1)]; 
                    }
                }else{
                    [maxOfValueValueStr insertString:@"." atIndex:[maxOfValueValueStr length]-((i*3)+i-1)];  
                } 
            }
        }
        [dataListMaxOfValueValue setString:maxOfValueValueStr];
        
        //NSLog(@"ValueHeader:%llu maxOfValue:%llu",valueHeader,maxOfvalue);
    //NSLog(@"up3");
        if (dataListHeaderValue.position.y > 15) {
            if (valueHeaderXPos > 220) {
                dataListHeaderValue.anchorPoint = ccp(1,1);
                [dataListMaxOfValueValue setAnchorPoint:ccp(1,0)];
            }else{
                dataListHeaderValue.anchorPoint = ccp(0,1);
                [dataListMaxOfValueValue setAnchorPoint:ccp(0,0)];
            }
            
        }else{
            if (valueHeaderXPos > 220) {
                dataListHeaderValue.anchorPoint = ccp(1,0);
                [dataListMaxOfValueValue setAnchorPoint:ccp(1,0)];
            }else {
                dataListHeaderValue.anchorPoint = ccp(0,0);
                [dataListMaxOfValueValue setAnchorPoint:ccp(0,0)];
            }
        }
    }
}

-(void)draw {
    glLineWidth(1);
    //glEnable(GL_BLEND);
    //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    //glEnable(GL_POINT_SMOOTH);
    //glHint(GL_POINT_SMOOTH_HINT, GL_NICEST);
    //glEnable(GL_LINE_SMOOTH);
    //glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
    //glEnable(GL_SMOOTH);
     //glHint(GL_SMOOTH_, GL_NICEST);
    
    glEnable(GL_SCISSOR_TEST); //가위박스 사용
    glScissor(scissorBox.origin.x*scaleFactor,scissorBox.origin.y*scaleFactor,scissorBox.size.width *scaleFactor,scissorBox.size.height*scaleFactor); //가위박스 영역설정

    //NSLog(@"draw1");
    //그래프 그리기///////////////////////////////
    //그래프를 그리기위한 매트릭스 설정
    glPushMatrix();
    glScalef(GraphScaleX, GraphScaleY, 0);
    
    //NSLog(@"draw1-1");
    glTranslatef(GraphPosX, 0, 0);
    //NSLog(@"draw1-2");
    glColor4f(graphColor.red, graphColor.green, graphColor.blue, graphColor.alpha);
    //[self GLErrorCheck];
    ccFillPoly(vertices, verticesLength, YES);

    //[self GLErrorCheck];
   // NSLog(@"draw1-3");
    glColor4f(graphOutLineColor.red, graphOutLineColor.green, graphOutLineColor.blue, graphOutLineColor.alpha);
    //glColor4f(1, 1, 1, 1);
    ccDrawPoly(outLineVertices, dataCount, NO);
   // NSLog(@"draw2");
    //그래프 그리기 끝///////////////////////////
    //매트릭스 원상태로
    glPopMatrix();

    //그래프 헤더그리기//////////////////////////////////
    glColor4f(valueHeaderClor.red, valueHeaderClor.green, valueHeaderClor.blue, valueHeaderClor.alpha);
    ccDrawLine(ccp(0,(valueHeader/dataScaling)*GraphScaleY), ccp((ratina)? 480:480,(valueHeader/dataScaling)*GraphScaleY));
    //ccDrawLine(ccp(scissorBox.size.width-(widthInterval), 0),ccp(scissorBox.size.width-(widthInterval), (ratina)? 320:320));
    //NSLog(@"draw3");
    //그래프 헤더그리기//////////////////////////////////
    glColor4f(maxOfValueColor.red, maxOfValueColor.green, maxOfValueColor.blue, maxOfValueColor.alpha);
    ccDrawLine(ccp(0,(maxOfvalue/dataScaling)*GraphScaleY), ccp((ratina)? 480:480,(maxOfvalue/dataScaling)*GraphScaleY));
    
    glDisable(GL_SCISSOR_TEST);//가위박스 적용해제
    //NSLog(@"draw4");
    //glDisable(GL_BLEND);
}
-(void)GLErrorCheck{
    int error = glGetError();
    switch (error) {
        case GL_INVALID_ENUM :
            NSLog(@"GL_INVALID_ENUM");
            break;
        case GL_INVALID_VALUE:
             NSLog(@"GL_INVALID_VALUE");
            break;
        case GL_INVALID_OPERATION:
             NSLog(@"GL_INVALID_OPERATION");
            break;
        case GL_STACK_OVERFLOW:
             NSLog(@"GL_STACK_OVERFLOW");
            break;
        case GL_STACK_UNDERFLOW:
             NSLog(@"GL_STACK_UNDERFLOW");
            break;
        case GL_OUT_OF_MEMORY:
             NSLog(@"GL_OUT_OF_MEMORY");
            break;
        case GL_NO_ERROR:
             NSLog(@"GL_NO_ERROR");
            break;
        default:
            break;
    }
}
-(void)dealloc {

    [dataList release];
    free(outLineVertices);
    free(vertices);//할당한 메모리해제
    
    [super dealloc];
}

@end
