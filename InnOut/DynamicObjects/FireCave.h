//
//  FireCave.h
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 7. 10..
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DynamicObject.h"
#import "ShineEffect.h"

@interface FireCave : DynamicObject {
    ShineEffect * reflexLight;
}
-(id)init;

@end
