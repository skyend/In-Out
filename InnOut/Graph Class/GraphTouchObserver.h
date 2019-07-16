//
//  GraphTouchObserver.h
//  KEEPINGSHAPE
//
//  Created by JinWoong Han on 11. 8. 10..
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GraphTouchObserver : CCLayer {
    BOOL touching;
    BOOL moving;
    BOOL end;
    CGPoint beginPos;
    CGPoint vector;
    CGPoint prevVector;
    CGPoint endPos;
    
    CGPoint prevPos;
    
    BOOL oneMoved;
}

@property BOOL touching;
@property BOOL moving;
@property BOOL end;
@property CGPoint beginPos;
//@property CGPoint vector;
@property CGPoint endPos;

-(float)vectorX;
-(float)vectorY;
@end
