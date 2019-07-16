//
//  SandStorm.m
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 6. 16..
//  Copyright 2011 -. All rights reserved.
//

#import "SandStorm.h"

@implementation SandStorm

-(id)init {
    if ( (self = [super init] )) {
        
        SandStormWave = [[NSMutableArray alloc] init];
        
        for(int i = 0 ; i < 7 ; i++){
            CCSprite * s = [CCSprite spriteWithFile:[NSString stringWithFormat:@"stage2_sandStorm0%d.png",1+(i%4)]];
            s.scaleX =  1.5f;
            s.anchorPoint = ccp (0,0.5f);
            s.position = ccp( 0 , 0 );
            if (i == 0) {
                s.position = ccp(-15,0);
                StormHeadIndex = i;
            }else{
                CCSprite * prevO = [SandStormWave objectAtIndex:i-1];
                s.position = ccp(prevO.position.x + prevO.contentSize.width - 15,0);
            }
            [SandStormWave addObject:s];
            [self addChild:s];
        }
       // NSLog(@"sandStorm");
    }
    return self;
}

-(void)update:(ccTime)delta {
    GameCondition * GC = [GameCondition sharedGameCondition];
    wind = (GC.windSpeed/(2+self.position.y/10))*self.scaleX;
    
    
    for ( CCSprite * o in SandStormWave){
        o.position = ccp(o.position.x+(wind*delta),0);
        if (o.position.x > 480/2) {
            o.position = ccp(-75,0);
        }
    }
    
}

-(void)setOpacity:(GLubyte)opacity__ {
    for (CCSprite * o in SandStormWave){
        o.opacity = opacity__;
    }
}

-(void)dealloc{
    [SandStormWave release];
    [super dealloc];
}
@end
