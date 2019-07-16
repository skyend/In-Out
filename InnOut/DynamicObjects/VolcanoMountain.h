//
//  VolcanoMountain.h
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 6. 19..
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DynamicObject.h"
#import "ShineEffect.h"

@interface VolcanoMountain : DynamicObject {

    ShineEffect ** lightnings;
    int lightningNum;
    ShineEffect * magmaGlow;
    
    int firesNum;
    ShineEffect ** fires;
}
-(id)initWithFile:(NSString *)filename_;
@end
