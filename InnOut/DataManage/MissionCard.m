//
//  MissionCard.m
//  KeepinTheMind
//
//  Created by JinUng Han on 11. 5. 11..
//  Copyright 2011 Student. All rights reserved.
//

#import "MissionCard.h"


@implementation MissionCard

-(id)initWithCode:(int)code_ value:(NSString*)Value_{
	if ( ( self = [super init] ) ) {
		if (code_ ==  MISSION_RESCUE_CHARACTER) {
			[self setTexture:[[CCTextureCache sharedTextureCache] addImage:@"MissionCard_CharacterRescue.png"]];
		}else {
			[self setTexture:[[CCTextureCache sharedTextureCache] addImage:@"MissionCard_CharacterRescue.png"]];
		}
		CGRect rect = CGRectZero;
		rect.size = [[self texture] contentSize];
		[self setTextureRect:rect];
		
		self.opacity = 200;
		//레이블 폰트 바꾸기
		CCLabelAtlas * valueLabel = [CCLabelAtlas labelWithString:Value_ charMapFile:@"numbers19.png" itemWidth:19 itemHeight:24 startCharMap:'.'];
		valueLabel.anchorPoint = ccp(0,0);
		valueLabel.position = ccp(4,4);
		[self addChild:valueLabel];
	}
	return self;
}

-(id)initWithCode:(int)code_ missionDic:(NSDictionary*)dic_{
	if ( ( self = [super init] ) ) {
		NSDictionary * dic = [dic_ valueForKey:[NSString stringWithFormat:@"%d",code_]];
		NSArray * keys = [dic allKeys];
		NSString * value = nil;
		for (int i = 0; i < [keys count]; i++) {
			if ([(NSString*)[keys objectAtIndex:i] isEqualToString:@"Overclear"] == NO && NO == [(NSString*)[keys objectAtIndex:i] isEqualToString:@"Clear"]) {
                if (value != nil) {
                    [value dealloc];
                }
				value = [[NSString alloc] initWithString:[dic valueForKey:[keys objectAtIndex:i]]]; //오버클리어도 아니고 클리어도 아닌 키의 값
			}
		}
		

		if (code_ ==  MISSION_RESCUE_CHARACTER) { //미션카드별 텍스쳐 적용 컨트롤
			[self setTexture:[[CCTextureCache sharedTextureCache] addImage:@"MissionCards_RescueCharacter.png"]];
		}else if (code_ == MISSION_TOTAL_COMBO_RECORD){
			[self setTexture:[[CCTextureCache sharedTextureCache] addImage:@"MissionCards_ComboRecord.png"]];
		}else if (code_ == MISSION_PLAYTIME_RECORD){
			[self setTexture:[[CCTextureCache sharedTextureCache] addImage:@"MissionCards_PlaytimeRecord.png"]];
		}else if (code_ == MISSION_SCORE_RECORD){
			[self setTexture:[[CCTextureCache sharedTextureCache] addImage:@"MissionCards_ScoreRecord.png"]];
		}else if (code_ == MISSION_COMBO_TECHNIQUE){
			[self setTexture:[[CCTextureCache sharedTextureCache] addImage:@"MissionCards_ComboTechnique.png"]];
		}else if (code_ == MISSION_HIGH_COMBO_RECORD){
			[self setTexture:[[CCTextureCache sharedTextureCache] addImage:@"MissionCards_HighComboRecord.png"]];
		}
		
		
		
		CGRect rect = CGRectZero;
		rect.size = [[self texture] contentSize];
		[self setTextureRect:rect];
		
		self.opacity = 200;
		//레이블 폰트 바꾸기
		CCLabelAtlas * valueLabel = [CCLabelAtlas labelWithString:@"0" charMapFile:@"numbers19.png" itemWidth:19 itemHeight:24 startCharMap:'.'];
        
        [valueLabel setAdjustWordBetween:-8];
		valueLabel.anchorPoint = ccp(0,0);
		valueLabel.position = ccp(4,4);
        [valueLabel setString:value];
        [value release];
		[self addChild:valueLabel];
	}
	return self;
}
@end
