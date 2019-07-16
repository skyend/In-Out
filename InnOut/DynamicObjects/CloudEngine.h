//
//  Cloud.h
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 12..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DynamicObject.h"

@interface CloudEngine : DynamicObject {
	NSMutableArray *cloudsArr; 
}
-(id)init;

-(void)update:(ccTime)delta;
@end
