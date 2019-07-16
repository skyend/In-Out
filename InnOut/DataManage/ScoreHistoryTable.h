//
//  ScoreHistoryTable.h
//  Memory0_0
//
//  Created by JinUng Han on 11. 4. 19..
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConfig.h"
/*
typedef struct {
	char cCode;
	int rescueCount;
}RescueCharacterCount;
*/
//clist-0:10-1:20-2:10#score-202020#combo-m:10-t:30#time-30#rank:SSP#overClear:1#level-up:ok-to:2
@interface ScoreHistoryTable : NSObject <NSCoding> {
	
	NSMutableArray * RescueCharacterCodes;
	NSDictionary * RescueCharacterCount;
	unsigned long long socre;
	unsigned int  highCombo;
	unsigned int  totalCombo;
	float playTime;
	RANK rank;
	int levelUp;
	
}

//@property (assign,readonly) NSMutableDictionary * RescueCharacterCount;

@property unsigned long long  score;
@property unsigned int  highCombo;
@property unsigned int  totalCombo;
@property float playTime;
@property RANK rank;
@property int levelUp;

-(id)initWithRescueShapeCodes:(NSArray*)array_;
-(void)setRescueCharacterCount:(char)code_ count:(int)count_;
-(int)RescueCharacterCodes:(char)code_;
-(void)setRescueShapes:(NSArray*)array_;
@end
