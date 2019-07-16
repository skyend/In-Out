//
//  DynamicObject.m
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 10..
//  Copyright 2011 Student. All rights reserved.
//

#import "DynamicObject.h"


@implementation DynamicObject

-(id)init {
	
	if ( (self = [ super init] )) {
		self.anchorPoint = ccp(0.5f,0.5f);
        
        //최종적으로 열린 스테이지코드 알아내기
		GameCondition * GC = [GameCondition sharedGameCondition];
		NSString *possibleStageCode = [GC possibleStageCode];
		NSArray * pscodes = [possibleStageCode componentsSeparatedByString:@","];
		LastOpenedStageCode = 1; //최소1 test 5
		for (NSString * str in pscodes) {
			LastOpenedStageCode = fmax([str intValue], LastOpenedStageCode);
		}
        
        
	}
	//NSLog(@"DynamicObject Initialize");
	return self;
}
	
//update: will be must Overriding
-(void)update:(ccTime)delta{
	
	
}

-(void)dealloc {
	//[self removeAllChildrenWithCleanup:YES];
	[super dealloc];
	//NSLog(@"DynamicObject Dealloc");
}

@end
