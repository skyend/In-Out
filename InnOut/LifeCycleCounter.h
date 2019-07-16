//
//  LifeCycleCounter.h
//  KeepinTheMind
//
//  Created by JinUng Han on 11. 5. 8..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LifeCycleCounter : NSObject {

	int allocated_BaseCharacter;
	int deallocated_BaseCharacter;
}

@property int allocated_BaseCharacter;
@property int deallocated_BaseCharacter;

+(LifeCycleCounter*)sharedLifeCounter;

@end
