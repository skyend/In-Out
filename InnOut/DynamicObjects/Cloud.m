//
//  Cloud.m
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 12..
//  Copyright 2011 Student. All rights reserved.
//

#import "Cloud.h"
@interface Cloud (privateMethods)
-(void)resetCloud;

@end

@implementation Cloud

-(id)initCloud {
	
	if ( (self = [super init]) ) {
		srandom(time(NULL));

		[self resetCloud];

		//NSLog(@"Weight W:%f",weight);
	}
	NSLog(@"Cloud Initialize");
	return self;
}

-(void)resetCloud {
	NSString *path = [NSString stringWithFormat:@"Object_Cloud_0%d.png",1+rand()%6];
	
	
	CCTexture2D * tex = [[CCTextureCache sharedTextureCache] addImage:path];
	//[tex setAliasTexParameters];
	
	CGRect rect = CGRectZero;
	rect.size = tex.contentSize;
	
	[self setTexture:tex];
	[self setTextureRect:rect];
	self.anchorPoint = CGPointZero;
	self.position = ccp(rand()%530 - 50,130+rand()%120);
	weight = (rect.size.width * rect.size.height)*0.01;
}

-(void)update:(ccTime)delta
{
	speed = [[GameCondition sharedGameCondition] windSpeed]*(1/weight);
	
	self.position = ccp(self.position.x + speed*delta,self.position.y);
	if (self.position.x > 480) {
		[self resetCloud];
		self.position = ccp(-self.textureRect.size.width,self.position.y);
	}
}

-(void)dealloc {
	//NSLog(@"Cloud dealloc");
	[super dealloc];
	NSLog(@"Cloud Dealloc");
}

@end
