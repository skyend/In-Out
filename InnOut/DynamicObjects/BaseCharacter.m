//
//  BaseCharacter.m
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 9..
//  Copyright 2011 Student. All rights reserved.
//

#import "BaseCharacter.h"
//#import "GameConfig.h"
//#import "GameMainScene.h"
#import "GameCondition.h"
#import "TutorialManager.h"
#import "ProgressManager.h"

double Distance(CGPoint p1,CGPoint p2){
	double _distance;
	_distance = sqrt( pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2) );
	
	//printf("\n w:%f h:%f p2.y:%f p1.y:%f distance:%f \n\n",p2.x - p1.x,p2.y - p1.y,p2.y,p1.y,_distance);
	return _distance;
}

@interface BaseCharacter (privateMethods)

-(void)setSpriteWithImage:(NSString *)path;

@end

@implementation BaseCharacter
@synthesize shapeCode,characterCode,state,layerPos,LocationinWay,opacity;
@synthesize currentZDirection,ZdistanceForCurrentTargetpoint;

-(id)initWithPos:(char)ShapeCode LayerPos:(LayerPosition)alayerPos Position:(CGPoint)pos superLayer:(CCLayer*)superLayer_{
	self = [self initWithShape:ShapeCode];
	superLayer = superLayer_;
	layerPos = alayerPos;
	LocationinWay = 0;
	self.position = pos;
	//speed = 100; //초당 이동거리
	deltaCount = 0;
	gravity = 9.8f;
	
	currentLocationInWay = 0;
	progressedDisInsection = 0;
	ZtotalDistance = [GameCondition sharedGameCondition].totalZDistance;
	ZdistanceForCurrentTargetpoint = ZtotalDistance;
	targetSpot = pos;
	
	
	
	return self;
}

-(id)initWithShape:(char)ShapeCode {
	shapeCode = ShapeCode;
	characterCode = ShapeCode;
	
	if ( (self = [super init]) ) {
		
		id actionUp;
		
		switch (ShapeCode) {
			case C_Rectangle:
				[self setSpriteWithImage:@"C_rect.png"];
				actionUp = [CCJumpBy actionWithDuration:1.7f position:ccp(0,0) height:20 jumps:3];
				break;
			case C_Triangle:
				[self setSpriteWithImage:@"C_triangle.png"];
				actionUp = [CCJumpBy actionWithDuration:1.7f position:ccp(0,0) height:22 jumps:3];
				break;
			case C_Circle:
				[self setSpriteWithImage:@"C_circle.png"];
				actionUp = [CCJumpBy actionWithDuration:1.7f position:ccp(0,0) height:24 jumps:3];
				break;
			case C_Pentagon:
				[self setSpriteWithImage:@"C_pentagon.png"];
				actionUp = [CCJumpBy actionWithDuration:1.7f position:ccp(0,0) height:26 jumps:3];
				break;
			case C_Rectangle2:
				[self setSpriteWithImage:@"C_rect2.png"];
				shapeCode = C_Rectangle; // 쉐이프 코드는 도형의 형태가 근본적으로 같으므로 다른 외모의 캐릭터 생성후 도형의 코드는 통일시켜주기위함
				actionUp = [CCJumpBy actionWithDuration:1.5f position:ccp(0,0) height:24 jumps:3];
				break;
			case C_Triangle2:
				[self setSpriteWithImage:@"C_triangle2.png"];
				shapeCode = C_Triangle;
				actionUp = [CCJumpBy actionWithDuration:1.5f position:ccp(0,0) height:26 jumps:3];
				break;
			case C_Circle2:
				[self setSpriteWithImage:@"C_circle2.png"];
				shapeCode = C_Circle;
				actionUp = [CCJumpBy actionWithDuration:1.5f position:ccp(0,0) height:28 jumps:3];
				break;
			default:
				//NSLog(@"undefined ShapeCode!!");
				[self setSpriteWithImage:@"C_rect.png"];
				actionUp = [CCJumpBy actionWithDuration:1.5f position:ccp(0,0) height:28 jumps:99];
			break;
		}
		kind = ShapeCode;
		
		self.anchorPoint = ccp(0.5f,0);
		
		opacity = 1;
        GameCondition * GC = [GameCondition sharedGameCondition];
		if (GC.stageCode == STAGE_3) { //스테이지3은 수중동굴임 그러므로 중력의 영향이 감축되므로 점프의 그게 반동이 느릴것임 
            actionUp = [CCJumpBy actionWithDuration:5 position:ccp(0,0) height:20+rand()%10 jumps:2];
        }
		
		
		[body runAction:[CCRepeatForever actionWithAction:actionUp]];
		
		mustNoticeToTM = NO;
	}
	
	self.state = STOPING;
	
	//NSLog(@"++++++BaseCharacter Initialize");
	return self;
	
}

-(void)setSpriteWithImage:(NSString*)path
{
	body = [[CCSprite alloc] init]; //몸체
	ctex = [[CCTextureCache sharedTextureCache] addImage:path];
	//[ctex setAliasTexParameters];
	
	CGRect rect = CGRectZero;
	rect.size = ctex.contentSize;
	[body setTexture:ctex];
	[body setTextureRect:rect];
	[body setAnchorPoint:ccp(0.5f,0)];
	[self addChild:body z:1];
	[body release];
	
	bodyShadow = [[CCSprite alloc] init]; //그림자
	ctex = [[CCTextureCache sharedTextureCache] addImage:@"C_shadow.png"];
	[ctex setAliasTexParameters];
	
	rect = CGRectZero;
	rect.size = ctex.contentSize;
	[bodyShadow setTexture:ctex];
	[bodyShadow setTextureRect:rect];
	[bodyShadow setAnchorPoint:ccp(0.5f,0)];
	[bodyShadow setPosition:ccp(0,-10)];
    [self addChild:bodyShadow z:0];
    
    if ([GameCondition sharedGameCondition].stageCode == STAGE_3) { //물속스테이지 에서 그림자 끄기
        bodyShadow.visible = NO;
    }
	
	[bodyShadow release];
}

-(void)update:(ccTime)delta
{
	deltaCount += delta; //어따쓰는거임?

	if (state == WALKING) {
		
		double zdis = Distance(prevSpot, targetSpot);
		
		float xspeed = [GameCondition sharedGameCondition].stepSpeed * (( targetSpot.x - prevSpot.x ) / zdis);
		float yspeed = [GameCondition sharedGameCondition].stepSpeed * (( targetSpot.y - prevSpot.y ) / zdis) ;
		
		
		CGPoint v = CGPointMake(xspeed*delta,yspeed*delta);
		
		progressedDisInsection += Distance(ccp(0,0), ccp(v.x,v.y));
		//printf("\nxSpeed:%f ySpeed:%f",xspeed,yspeed);
		//printf("\nVx:%f Vy:%f \n",v.x,v.y);
		
		/*
		if (v.x < 0) { //음수
			if (self.position.x + v.x  < targetSpot.x) {
				//NSLog(@"de x -");
				float de = targetSpot.x - (self.position.x+v.x);
				v.x = v.x + de;
			}
		}else{
			if (self.position.x + v.x > targetSpot.x) {
				//NSLog(@"de x +");
				float de = (self.position.x + v.x) - targetSpot.x;
				v.x = v.x - de;
			}
		}
		
		if (v.y < 0) {
			if (self.position.y + v.y < targetSpot.y) {
				//NSLog(@"de Y -");
				float de = targetSpot.y - (self.position.y + v.y);
				v.y = v.y + de;
			}
		}else {
			if (self.position.y + v.y > targetSpot.y) {
				//NSLog(@"de Y +");
				float de = (self.position.y + v.y) - targetSpot.y;
				v.y = v.y - de;
			}
		}//*/


		//if (abs(targetSpot.x) - abs(self.position.x) < 1 && abs(targetSpot.y) - abs(self.position.y) < 1) {
		if ( Distance(prevSpot, targetSpot) - progressedDisInsection < 0.1 ){
			self.state = STOPING;
			self.position = targetSpot;
			//NSLog(@"STOPING");
		}else {
			self.position = ccp(self.position.x + v.x,self.position.y + v.y);
		}

		
	
		//전진이면 남은 거리에서 빼고 후진이면 남은 거리에서 더하기를 한다.
		if (currentZDirection == 1) { //전진
			if (v.y < 0) { //음수면
				ZdistanceForCurrentTargetpoint += v.y;
			}else if (v.y > 0) {
				ZdistanceForCurrentTargetpoint += v.y * -1;
			}
			//NSLog(@"목표점 까지 남은거리 :%f",ZdistanceForCurrentTargetpoint);
		}else if (currentZDirection == -1) { //후진
			if (v.y < 0) {
				ZdistanceForCurrentTargetpoint += v.y * -1;
			}else if (v.y > 0) {
				ZdistanceForCurrentTargetpoint += v.y;
			}
			
		}
		
		virtualScale = 0.2f + ( (ZtotalDistance - ZdistanceForCurrentTargetpoint) / ZtotalDistance ) * 0.8f ;
		body.scale = virtualScale;
		bodyShadow.scale = virtualScale * ((1-body.position.y/100)/1);
		
		[superLayer reorderChild:self z:(-1*ZdistanceForCurrentTargetpoint)];
		
        State prevState = state;
		if (ZdistanceForCurrentTargetpoint <= 1) {
			//NSLog(@"Arrived ZdistanceForCurrentTargetpoint:%f",ZdistanceForCurrentTargetpoint);
            
			state = ARRIVED;
            
            //state = DISAPPEAR;
            if (mustNoticeToTM) {
                if (TM != NULL) {
                    [TM inputStatefromShape:self PrevState:prevState CurrentState:ARRIVED];
                }
            }
			
		}
		
		
		
		
	}else if (state == DISAPPEAR) {
		//NSLog(@"Disappear");
		self.opacity -= 5*delta;
		//self.scale += 0.04f*delta;
		body.scale += 0.04f*delta;
		bodyShadow.scale = body.scale;
		//NSLog(@"%dㅁㅁㅁ",[self opacity]);
		if (self.opacity <= 0) {
			//NSLog(@"DIED");
			self.opacity = 0;
			//NSLog(@"죽기직전 목표점 까지 남은 z거리 :%f",ZdistanceForCurrentTargetpoint);
			state = DIED;
            if (mustNoticeToTM) {
                //[TM inputStatefromShape:self PrevState:DISAPPEAR CurrentState:DIED];
            }
			//[body 
		}
		body.opacity = bodyShadow.opacity = opacity*255;
		
	}else if (state == COMEIN) {
		self.opacity -= 0.1f;
		//NSLog(@"%dㅁㅁㅁ",[self opacity]);
		if (self.opacity <= 0) {
			//NSLog(@"DIED");
			self.opacity = 0;
			state = DIED;
            
            if (mustNoticeToTM) {
                //[TM inputStatefromShape:self PrevState:COMEIN CurrentState:DIED];
            }
		}
		body.opacity = bodyShadow.opacity = opacity*255;
		
		CGPoint xySidesDis = CGPointMake(targetSpot.x-self.position.x,targetSpot.y - self.position.y);
		
		CGFloat distance = sqrt(pow(xySidesDis.x,2)+pow(xySidesDis.y,2))/([GameCondition sharedGameCondition].stepSpeed * delta);
		//NSLog(@"xyRatio:%f to1 x:%f y:%f",distance,xySidesDis.x/distance,xySidesDis.y/distance);
		
		CGPoint v = CGPointMake(xySidesDis.x/distance, xySidesDis.y/distance);
		
		self.position = ccp(self.position.x+v.x,self.position.y + v.y);
		
		

		
	}else if (state == GOOUT) {
		float speed = 300 * delta;
		body.position = ccp(body.position.x-speed,body.position.y+speed);
		self.position = ccp(self.position.x-speed,body.position.y+speed);
		body.rotation = body.rotation+2000*delta;
		//self.scale 
		if (body.rotation > 360*2) {
			state = DIED;
            
            if (mustNoticeToTM) {
                //[TM inputStatefromShape:self PrevState:GOOUT CurrentState:DIED];
            }
		}
		
	}
	
	//bodyShadow.scale = 1 - body.position.y/100;
}

-(void)setTargetSpot:(CGPoint)pos_ { //
	prevSpot = targetSpot;
	targetSpot = pos_;
	//CGPoint xySidesDis = CGPointMake(targetSpot.x-self.position.x,targetSpot.y - self.position.y);
	//CGFloat distance = sqrt( pow(xySidesDis.x,2) + pow(xySidesDis.y,2) );// / [GameCondition sharedGameCondition].stepSpeed;
	
	
	moveToDis = Distance(prevSpot, targetSpot);
	
	progressedDisInsection = 0;
}

-(CGPoint)targetSpot {
	return targetSpot;
}

-(void)setTutorialManager:(TutorialManager*)tm_{
    TM = tm_;
    mustNoticeToTM = YES;
}

-(void)deleteRefTM{
    TM = NULL;
    mustNoticeToTM = NO;
    NSLog(@"deleteTM");
}

-(void)setState:(State)state_{
    
    if (mustNoticeToTM) {
        if (TM != NULL) {
            [TM inputStatefromShape:self PrevState:state CurrentState:state_];
        }
        
    }
    state = state_;
}

-(void)dealloc {
    
    if (mustNoticeToTM) {
        [[TM refMeObjects] removeObject:self];
        TM = nil;
        mustNoticeToTM = NO;
    }
    
    
	[self removeAllChildrenWithCleanup:YES];
	//NSLog(@"deallocShape");

	[super dealloc];
	//NSLog(@"-------BaseCharacter Dealloc");
}

@end
