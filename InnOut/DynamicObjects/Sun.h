//
//  Sun.h
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 17..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DynamicObject.h"

@interface Sun : DynamicObject {
	CCSprite *sun;
}
-(id)initSun;
@property (assign) CCSprite *sun;

@end
