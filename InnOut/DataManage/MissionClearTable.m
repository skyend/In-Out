//
//  MissionClearTable.m
//  Memory0_0
//
//  Created by JinUng Han on 11. 4. 19..
//  Copyright 2011 Student. All rights reserved.
//

#import "MissionClearTable.h"


@implementation MissionClearTable

-(id)init {
	if ( (self = [super init] ) ) {
		
	}
	NSLog(@"MissionClearTable Initialize");
	return self;
}

-(int)mCode { return table.mCode;}
-(void)setMCode:(int)code_ { table.mCode = code_; }
-(int)clearCount {return table.clearedCount;}
-(void)setClearCount:(int)clearCount_ {table.clearedCount = clearCount_;}
-(int)overClearCount {return table.overClearedCount;}
-(void)setOverClearCount:(int)overClearCount_ {table.overClearedCount = overClearCount_;}


-(void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeInt:[self mCode] forKey:@"key_mCode"];
	[encoder encodeInt:[self clearCount] forKey:@"key_clearCount"];
	[encoder encodeInt:[self overClearCount] forKey:@"key_overClearCount"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
	if ( (self = [super init] ) ) {
		[self setMCode:[aDecoder decodeIntForKey:@"key_mCode"]];
		[self setClearCount:[aDecoder decodeIntForKey:@"key_clearCount"]];
		[self setOverClearCount:[aDecoder decodeIntForKey:@"key_overClearCount"]];
	}
	return self;
}

-(NSString*)description {
	return [NSString stringWithFormat:@"MissionClearTable {\nMission Code:%d \nClearCount:%d \nOverClearCount:%d \n}",table.mCode,table.clearedCount,table.overClearedCount];
}


-(void)dealloc {
	
	[super dealloc];
	NSLog(@"MissionClearTable Dealloc");
}
@end
