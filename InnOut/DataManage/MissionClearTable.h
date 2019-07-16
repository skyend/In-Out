//
//  MissionClearTable.h
//  Memory0_0
//
//  Created by JinUng Han on 11. 4. 19..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConfig.h"

@interface MissionClearTable : NSObject <NSCoding> {
	struct_missionCleardTable table;
}
//@property (assign) struct_missionCleardTable table;
-(int)mCode;
-(void)setMCode:(int)code_;
-(int)clearCount;
-(void)setClearCount:(int)clearCount_;
-(int)overClearCount;
-(void)setOverClearCount:(int)overClearCount_;

@end
