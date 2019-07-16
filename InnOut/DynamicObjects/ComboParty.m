//
//  ComboParty.m
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 22..
//  Copyright 2011 Student. All rights reserved.
//

#import "ComboParty.h"
#import "NodeTweener.h"

@implementation ComboParty

-(id)init {
	if ( ( self = [super init] ) ) {
		combo = [CCSprite spriteWithFile:@"Image_PlayGame_notifications_combo.png"];
		[[combo texture] setAliasTexParameters];
		
		comboText = [CCLabelAtlas labelWithString:@"" charMapFile:@"Combo_Text_numbers27.png" itemWidth:27 itemHeight:41 startCharMap:'.'];
		//combo.scale = 0.5f;
		combo.anchorPoint = ccp(0,0);
		combo.position = ccp(0,0);
		
		comboText.anchorPoint = ccp(1,0);
		comboText.position = ccp(0,0);
		[self addChild:combo];
		[self addChild:comboText];
	}
	NSLog(@"ComboParty Initialize");
	return self;
}

-(void)setComboText:(int)comboCount {
	[comboText setString:[NSString stringWithFormat:@"%d",comboCount]];
}

-(void)update:(ccTime)delta {
	
}

-(void) setOpacity:(GLubyte) anOpacity{ 
	//하위노드에겐 투명도변경의 영향이 미치지 않아 직접적으로 영향을 미치도록 세터를 재정의함
	[super setOpacity:anOpacity];
	comboText.opacity = [super opacity];
	combo.opacity = [super opacity];
}

-(void)dealloc {
	[super dealloc];
	NSLog(@"ComboParty Dealloc");
}

@end
