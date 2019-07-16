//
//  Cloud.h
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 12..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameCondition.h"

@interface Cloud : CCSprite {
	GLfloat weight;
	GLfloat speed;
	
	//NSString *cloudPath;
}
-(void)update:(ccTime)delta;
-(id)initCloud;
@end
