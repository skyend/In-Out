//
//  TextLineBriefer.h
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 7. 28..
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TextLineBriefer : CCSprite {
    float maxWidth;
    NSArray * mapArr;
    float proSpeed;
    int mapHeader;
    int maxMapIndex;
    
    float time;
    
    BOOL running;
    BOOL completeBrief;
    //BOOL briefEnd;
    BOOL close;
    BOOL completeClose;
    
    float subOpacity;
}

//check complete from Outside
@property (readonly,nonatomic) BOOL completeBrief;
//@property (nonatomic) BOOL briefEnd;
@property (readonly,nonatomic) BOOL completeClose;
@property (readonly,nonatomic) BOOL running;

-(id)initWithLineText:(NSString*)txtImg_ Map:(NSString*)mapStr_ ProSpeed:(float)proSpeed_;

-(void)update:(ccTime)d;

-(void)run;
-(void)stop;
-(void)close;

@end
