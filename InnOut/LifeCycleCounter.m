//
//  LifeCycleCounter.m
//  KeepinTheMind
//
//  Created by JinUng Han on 11. 5. 8..
//  Copyright 2011 Student. All rights reserved.
//

#import "LifeCycleCounter.h"

static LifeCycleCounter * _sharedObj = nil;

@implementation LifeCycleCounter
@synthesize allocated_BaseCharacter,deallocated_BaseCharacter;


+(LifeCycleCounter*)sharedLifeCounter {
	
	if (_sharedObj == nil) {
		_sharedObj = [[LifeCycleCounter alloc] init];
	}
	return _sharedObj;
}

-(id)init {

	if ( (self = [super init] )) {
		allocated_BaseCharacter = 0;
		deallocated_BaseCharacter = 0;
	}
	return self;
}

@end
