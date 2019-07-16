//
//  ScoreHistoryTable.m
//  Memory0_0
//
//  Created by JinUng Han on 11. 4. 19..
//  Copyright 2011 Student. All rights reserved.
//

#import "ScoreHistoryTable.h"


@implementation ScoreHistoryTable
@synthesize score,highCombo,totalCombo,playTime,rank,levelUp;

-(id)initWithRescueShapeCodes:(NSArray*)array_ {
	if ( (self = [super init] ) ) {
		//RescueCharacterCodes = [[NSMutableArray alloc] init];
		//RescueCharacterCount = [[NSMutableDictionary alloc] init];
		[self setRescueShapes:array_];
		socre = 0;
		highCombo = 0;
		totalCombo = 0;
		playTime = 0;
		rank = -1;
		levelUp = -1;
	}
	NSLog(@"ScoreHistoryTable Initialize");
	return self;
}

-(void)setRescueCharacterCount:(char)code_ count:(int)count_ { //캐릭터 코드별로 각각 구출카운트 저장
	BOOL is_thisCode = FALSE;
	
	for (int i = 0; i < [RescueCharacterCodes count]; i++) {
		if ([[RescueCharacterCodes objectAtIndex:i] intValue] == code_) {
			is_thisCode = TRUE;
		}
	}
	
	if (!is_thisCode) { //없다면
		NSNumber * codeValue = [[[NSNumber alloc] initWithInt:code_] autorelease];
		[RescueCharacterCodes addObject:codeValue];
		NSNumber * countValue = [[[NSNumber alloc] initWithInt:count_] autorelease];
		[RescueCharacterCount setValue:countValue forKey:[NSString stringWithFormat:@"%d",code_]];
	}else{ //있다면
		NSNumber * countValue = [[[NSNumber alloc] initWithInt:count_] autorelease];
		[RescueCharacterCount setValue:countValue forKey:[NSString stringWithFormat:@"%d",code_]];
	}
}

-(void)setRescueShapes:(NSArray*)array_ { //캐릭터 코드별로 각각 구출카운트 저장
	NSMutableDictionary * temp = [[[NSMutableDictionary alloc] init] autorelease];
	
	for (int i = 0 ; i < [array_ count]; i++) {
		int code = [[array_ objectAtIndex:i] intValue];
		NSArray * dicKeys = [NSArray arrayWithArray:[temp allKeys]];
		BOOL isKey = NO;
		printf("\nKeyCount:%d\n",[dicKeys count]);
		if ([dicKeys count] > 0) {
			for (int j = 0 ; j < [dicKeys count]; j++) {
				if ([[dicKeys objectAtIndex:j] intValue]== code) {
					isKey = YES;
				}
			}
		}
		
		if (!isKey) {
			NSNumber * num = [NSNumber numberWithInt:1];
			[temp setValue:num forKey:[NSString stringWithFormat:@"%d",code]];
		}else {
			NSNumber * num = [NSNumber numberWithInt:[[temp valueForKey:[NSString stringWithFormat:@"%d",code]] intValue]+1];
			[temp setValue:num forKey:[NSString stringWithFormat:@"%d",code]];
		}
		
	}
	//[RescueCharacterCount release];
	RescueCharacterCount = [[NSDictionary alloc] initWithDictionary:temp];
	NSLog(@"SetRescueShapeCodeCount:%@",[temp description]);
}

-(int)RescueCharacterCodes:(char)code_{
	
	return [[RescueCharacterCount valueForKey:[NSString stringWithFormat:@"%d",code_]] intValue];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	if (( self = [super init] )) {
		//RescueCharacterCodes = [[NSMutableArray alloc] initWithArray:[aDecoder decodeObjectForKey:@"key_RescueCharacterCodes"]];
		RescueCharacterCount = [[NSMutableDictionary alloc] initWithDictionary:[aDecoder decodeObjectForKey:@"key_RescueCharacterCount"]];
		score = [aDecoder decodeIntForKey:@"key_score"];
		highCombo = [aDecoder decodeIntForKey:@"key_maxCombo"];
		totalCombo = [aDecoder decodeIntForKey:@"key_totalCombo"];
		playTime = [aDecoder decodeFloatForKey:@"key_playTime"];
		rank = [aDecoder decodeIntForKey:@"key_rank"];
		levelUp = [aDecoder decodeIntForKey:@"key_levelUp"];
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	//[aCoder encodeObject:RescueCharacterCodes forKey:@"key_RescueCharacterCodes"];
	[aCoder encodeObject:RescueCharacterCount forKey:@"key_RescueCharacterCount"];
	[aCoder encodeInt:score forKey:@"key_score"];
	[aCoder encodeInt:highCombo forKey:@"key_maxCombo"];
	[aCoder encodeInt:totalCombo forKey:@"key_totalCombo"];
	[aCoder encodeFloat:playTime forKey:@"key_playTime"];
	[aCoder encodeInt:rank forKey:@"key_rank"];
	[aCoder encodeInt:levelUp forKey:@"key_levelUp"];
}

-(NSString*)description {
	NSString *des = [NSString stringWithFormat:@"{\nscore:%llu \nmaxCombo:%d \ntotalCombo:%d \nplayTime:%f \nrankCode:%d \nlevelUp:%d \nRescueCharacterCountDes:%@\n}",score,highCombo,totalCombo,playTime,rank,levelUp,[RescueCharacterCount description]];
	//NSLog(@"%@",des);
	return des;
}

-(void)dealloc {
	//[RescueCharacterCodes removeAllObjects];
	//[RescueCharacterCount removeAllObjects];
	//[RescueCharacterCodes release];
	[RescueCharacterCount release];
	
	[super dealloc];
	NSLog(@"ScoreHistroyTable Dealloc");
}
@end
