//
//  Cloud.m
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 12..
//  Copyright 2011 Student. All rights reserved.
//

#import "CloudEngine.h"
#import "Cloud.h"
@interface CloudEngine (privateMethods)
-(void)creatClouds;
@end


@implementation CloudEngine

-(id)init {
	if ( (self = [super init] ) ) {
        cloudsArr = nil;
        if ([GameCondition sharedGameCondition].stageCode == 2) {
            if (LastOpenedStageCode < 5) {
                cloudsArr = [[NSMutableArray alloc] init];
                
                [self creatClouds];
            }
        }else{
            cloudsArr = [[NSMutableArray alloc] init];
            
            [self creatClouds];
        }
		
		
	}
	NSLog(@"CloudEngine Initialize");
	return self;
}

-(void)creatClouds {
	for (int a = 0; a <7; a++) {
		Cloud *cloud = [[[Cloud alloc] initCloud] autorelease];
		[cloudsArr addObject:cloud];
		[self addChild:cloud];

		//NSLog(@"cloud retainCount:%d",[cloud retainCount]);
	}
}

-(void)update:(ccTime)delta {
    if (cloudsArr != nil) {
        for(Cloud * o in cloudsArr){
            [o update:delta];
        }
    }
	
}

-(void)dealloc {
    [cloudsArr release];
    [self removeAllChildrenWithCleanup:YES];
	[super dealloc];
	NSLog(@"CloudEngine Dealloc");
}

@end
