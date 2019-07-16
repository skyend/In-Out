//
//  ComboParty.h
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 22..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DynamicObject.h"
@class NodeTweener;

@interface ComboParty : DynamicObject {
	CCSprite * combo;
	CCLabelAtlas *comboText;
}
-(void)setComboText:(int)comboCount;
-(void)setOpacity:(GLubyte)_opacity;

@end
