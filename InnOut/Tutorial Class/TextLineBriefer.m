//
//  TextLineBriefer.m
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 7. 28..
//  Copyright 2011 -. All rights reserved.
//

#import "TextLineBriefer.h"


@implementation TextLineBriefer

@synthesize completeBrief;
@synthesize completeClose;
@synthesize running;
//@synthesize briefEnd;

#pragma mark -
#pragma mark === initialize ===

-(id)initWithLineText:(NSString*)txtImg_ Map:(NSString*)mapStr_ ProSpeed:(float)proSpeed_ {
    if ( (self = [super init] )) {
        [self setTexture:[[CCTextureCache sharedTextureCache] addImage:txtImg_]];
		[self setTextureRect:CGRectMake(0, 0, [[self texture] contentSize].width, [[self texture] contentSize].height)];
        maxWidth = [[self texture] contentSize].width;
        self.anchorPoint = ccp(0.5f,0);
        
        mapArr = [[NSArray alloc] initWithArray:[mapStr_ componentsSeparatedByString:@","] copyItems:YES];
        //[[mapStr_ componentsSeparatedByString:@","] retain];
        
        maxMapIndex = [mapArr count]-2;
        mapHeader = 0;
        
        proSpeed = proSpeed_;
        self.opacity = 0;
        subOpacity = 1;
    }
    return self;
}

#pragma mark -
#pragma mark === update ===

-(void)update:(ccTime)d {
    if (running) {
        
        time += d;
        if (!completeBrief) {
            if (time >= proSpeed) {
                time -= proSpeed;
                mapHeader ++;
                [self setTextureRect:CGRectMake(0, 0, [[mapArr objectAtIndex:mapHeader] floatValue], [[self texture] contentSize].height)];
                self.opacity = subOpacity*255;
                if (mapHeader == maxMapIndex) {
                    completeBrief = YES;
                    //running = NO;
                    time = 0;
                }
            }
        }
        
        
    }
    
    if(close){
        subOpacity += (0.9f * (0 - subOpacity))*d*5;
        
        if (subOpacity < 0.1f) {
            subOpacity = 0;
            
            completeClose = YES;
            close = NO;
        }
        
        self.opacity = subOpacity*255;
    }
}

#pragma mark -
#pragma mark === controll ===

-(void)run{
    running = YES;
    time = 0;
}
-(void)stop{
    running = NO;
}
-(void)close{
    close = YES;
}

#pragma mark -
#pragma mark === dealloc ===
-(void)dealloc{
    for(NSString * str in mapArr){
        //NSLog(@"Point retainCount:%d",[str retainCount]);
    }
    [mapArr release];
    [super dealloc];
}
@end
