//
//  Stage2Sky.m
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 7. 13..
//  Copyright 2011 -. All rights reserved.
//

#import "Stage2Sky.h"
#import "GameCondition.h"

@implementation Stage2Sky

-(id)init{
    if ( (self = [super init])) {
        
        if (LastOpenedStageCode >= 5) {
            CCTexture2D * tex = [[CCTextureCache sharedTextureCache] addImage:@"stage5_Sky.jpg"];
            CGRect rect = CGRectZero;
            rect.size = tex.contentSize;
            [self setTexture:tex];
            [self setTextureRect:rect];
            
            self.scaleY = 3;
            self.opacity = 30;
        }else{
            CCTexture2D * tex = [[CCTextureCache sharedTextureCache] addImage:@"worldMap_back.jpg"];
            CGRect rect = CGRectZero;
            rect.size = tex.contentSize;
            [self setTexture:tex];
            [self setTextureRect:rect];
            
        }
        
    }
    return self;
}

@end
