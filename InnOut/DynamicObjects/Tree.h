//
//  Tree.h
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 7. 9..
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DynamicObject.h"
#import "DiffusionEffect.h"
#import "ShineEffect.h"

@interface Tree : DynamicObject {
    DiffusionEffect * forestAir1;
    
    ShineEffect **shineArr;
    int shineNum;
    
    ShineEffect **shineArr2;
    int shineNum2;
}
-(id)initWithTreeSource:(NSString*)source_;
-(void)update:(ccTime)delta;
@end
