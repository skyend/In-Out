//
//  MissionCard.h
//  KeepinTheMind
//
//  Created by JinUng Han on 11. 5. 11..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"

@interface MissionCard : CCSprite {

}
-(id)initWithCode:(int)code_ value:(NSString*)Value_;
-(id)initWithCode:(int)code_ missionDic:(NSDictionary*)dic_;
@end
