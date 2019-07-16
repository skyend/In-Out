//
//  StagePlacement.m
//  Memory0_0
//
//  Created by JinUng Han on 11. 4. 2..
//  Copyright 2011 Student. All rights reserved.
//

#import "StagePlacement.h"
#import "GameHeaders.h"


#define BGL 0  //BehindGroundLayer
#define FGL 1  //ForeGroundLayer 
#define EL  2  //EffectLayer 
#define FL  3  //FelidLayer

@interface StagePlacementManager (privateMethos)
-(NSDictionary *)loadStagePlist:(int)stageCode_;
-(void)settingStage;
-(void)setObjectProperty:(NSDictionary*)o Object:(CCSprite *)oo;
-(void)settingObjects:(NSDictionary*)o t_layerCode:(int)LayerCode;
-(void)addChild:(CCSprite*)oo z:(float)z_ t_layerCode:(int)LayerCode;

@end

@implementation StagePlacementManager
@synthesize stageCode;

-(id)initStageWith3Layers:(uint)StageCode_ 
					   pm:(ProgressManager*)PM_
		  backGroundLayer:(CCLayer*)backGroundLayer_ 
		  foreGroundLayer:(CCLayer*)foreGroundLayer_ 
			  effectLayer:(CCLayer*)effectLayer_
				useforAni:(BOOL)UFA_
{
	useForAnimation = UFA_;
	self = [self initStageWith3Layers:StageCode_ pm:PM_ backGroundLayer:backGroundLayer_ foreGroundLayer:foreGroundLayer_ effectLayer:effectLayer_];
	
	return self;
}

-(id)initStageWith3Layers:(uint)StageCode_ 
					   pm:(ProgressManager*)PM_
		  backGroundLayer:(CCLayer*)backGroundLayer_ 
		  foreGroundLayer:(CCLayer*)foreGroundLayer_ 
			  effectLayer:(CCLayer*)effectLayer_
				
{
	
	if ( ( self = [super init] ) ) {
		stageCode = StageCode_;
        [GameCondition sharedGameCondition].stageCode = stageCode;
		PM = PM_;
		
		backGroundLayer = backGroundLayer_;
		foreGroundLayer = foreGroundLayer_;
		effectLayer = effectLayer_;
		
		//스테이지 정보 로드
		stageObjectsDic = [[[self loadStagePlist:stageCode] copy] autorelease]; //스테이지 코드에 해당하는 스테이지정보를 로드해서 변수에 저장

		[self settingStage]; //스테이지 정보를 변수에 저장

	}
	NSLog(@"StagePlacement Initialize");
	return self;
}


-(NSDictionary *)loadStagePlist:(int)stageCode_ {
	NSString *stageFilePath = [NSString stringWithFormat:@"Stage%d",stageCode_];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:stageFilePath ofType:@"plist"];
    
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];

	//NSAssert( dict != nil, @"Stage%d: file not found",stageCode_);
	
	return dict;
}


-(void)settingStage{
	if (!useForAnimation) {

		BeginStepSpeed = [[stageObjectsDic valueForKey:@"BeginStepSpeed"] floatValue];
		BeginCreatePeroid = [[stageObjectsDic valueForKey:@"BeginCreatePeroid"] floatValue];
		MaxLevel_StepSpeed = [[stageObjectsDic valueForKey:@"MaxLevel_CreatePeroid"] floatValue];
		MaxLevel_CreatePeroid = [[stageObjectsDic valueForKey:@"MaxLevel_StepSpeed"] floatValue];
		FinalRelayStartingComboPoint = [[stageObjectsDic valueForKey:@"FinalRelayStartingComboPoint"] intValue];
		MaxFinalRelayComboPoint = [[stageObjectsDic valueForKey:@"MaxFinalRelayComboPoint"] intValue];
		StanbyCounting = [[stageObjectsDic valueForKey:@"StanbyCounting"] intValue];
		BeginLife = [[stageObjectsDic valueForKey:@"BeginLife"] intValue];
		BeginHint = [[stageObjectsDic valueForKey:@"BeginHint"] intValue];
		StageMaxLevel = [[stageObjectsDic valueForKey:@"StageMaxLevel"] intValue];
		StageSkilledLevelMaxExpTable = [stageObjectsDic valueForKey:@"StageLevelMaxExpTable"];
		ExpJumpValue = [[stageObjectsDic valueForKey:@"ExpJumpValue"] floatValue];
		ScoreJumpValue = [[stageObjectsDic valueForKey:@"ScoreJumpValue"] floatValue];
		AppearenceCharacterCodes = [stageObjectsDic valueForKey:@"AppearenceCharacterCodes"];
		ClearObjects = [stageObjectsDic valueForKey:@"ClearObjectsWithCode"]; //참조객체
		
		NSString * prevStepStr = [NSString stringWithString:[stageObjectsDic valueForKey:@"PrevStep"]];
		if ([prevStepStr isEqualToString:@"One"]) {
			PrevStep = PREVSTEP_ONE;
		}else if ([prevStepStr isEqualToString:@"Two"]) {
			PrevStep = PREVSTEP_TWO;
		}else if ([prevStepStr isEqualToString:@"Three"]) {
			PrevStep = PREVSTEP_THREE;
		}
		
		
		[[GameCondition sharedGameCondition] settingFromSPM:BeginStepSpeed 
													beginCP:BeginCreatePeroid
											   maxStepSpeed:MaxLevel_StepSpeed 
											maxCreatePeroid:MaxLevel_CreatePeroid
							   finalRelayStartingComboPoint:FinalRelayStartingComboPoint
									maxFinalRelayComboPoint:MaxFinalRelayComboPoint
												stanbyCount:StanbyCounting
												   prevStep:PrevStep
												  beginLife:BeginLife 
												  beginHint:BeginHint 
											  stageMaxLevel:StageMaxLevel
							   stageSkilledLevelMaxExpTable:StageSkilledLevelMaxExpTable
											   expJumpValue:ExpJumpValue
											 scoreJumpValue:ScoreJumpValue
								   appearenceCharacterCodes:AppearenceCharacterCodes
											   clearObjects:ClearObjects
														spm:self];
		
		
		
	}else{
        
        AppearenceCharacterCodes = [stageObjectsDic valueForKey:@"AppearenceCharacterCodes"];
        [[GameCondition sharedGameCondition] setUsingCharacterCodesFromSPM:AppearenceCharacterCodes];
    }
	
	//[StageSkilledLevelMaxExpTable release];
	
	totalWay  = [stageObjectsDic valueForKey:@"FieldWay"];
	
	NSString * twLength = (NSString*)[totalWay objectAtIndex:0];
	
	NSArray * twWayRoad = [(NSString*)[totalWay objectAtIndex:1] componentsSeparatedByString:@","] ;

    NSLog(@"twWayRoad RetainCount:%d",[twWayRoad retainCount]);

	totalWay = [NSArray arrayWithObjects:twLength,twWayRoad,nil];
    NSLog(@"twWayRoad RetainCount:%d",[twWayRoad retainCount]);
	if(PM != nil)
		[PM setTotalFieldWays:totalWay];

	//총 거리와 z거리 측정
	wayTotalDistance = 0;
	totalZDistance = 0;
	for(int i = 0; i < [twLength intValue]-1 ; i++){
	
		int pointIndex = i * 3;
		float currentX = [[[totalWay objectAtIndex:1] objectAtIndex:pointIndex] intValue];
		float currentY = [[[totalWay objectAtIndex:1] objectAtIndex:pointIndex+1] intValue];
		int currentZdirection = [[[totalWay objectAtIndex:1] objectAtIndex:pointIndex+2] intValue];
		
		pointIndex = (i+1) * 3; //다음 포인트
		float nextX = [[[totalWay objectAtIndex:1] objectAtIndex:pointIndex] intValue];
		float nextY = [[[totalWay objectAtIndex:1] objectAtIndex:pointIndex+1] intValue];
		//int	nextZdirection = [[[totalWay objectAtIndex:1] objectAtIndex:pointIndex+2] intValue];
		
		
		float xdis = abs( nextX - currentX );
		float ydis = abs( nextY - currentY );
		
		float wdis = sqrt( (xdis * xdis) + (ydis * ydis) );
		wayTotalDistance += wdis;
		
		if (currentZdirection == 1) { //1이면 전진
			totalZDistance += ydis;
		}
		
	}
	
	[GameCondition sharedGameCondition].wayTotalDistance = wayTotalDistance;
	[GameCondition sharedGameCondition].totalZDistance = totalZDistance;
	
	NSLog(@"Way Total forwardstep Distance:%f",totalZDistance);
	NSLog(@"Way Total distance :%f",wayTotalDistance);
						
	
	//NSLog(@"behindWay Description:%@",[behindWay description]);
	//behindWay: [(String)Length,(Array)WayRoad]
	//Way index:0 = (String)Length
	//Way index:2 = (Array)WayRoad
	
	BackGroundObject = [NSArray arrayWithArray:[stageObjectsDic valueForKey:@"BackGroundObjects"]];
	ForeGroundObject = [NSArray arrayWithArray:[stageObjectsDic valueForKey:@"ForeGroundObjects"]];
	EffectObject = [NSArray arrayWithArray:[stageObjectsDic valueForKey:@"EffectObjects"]];
	//BackGround Setting
	//int itemIndex = 0;
	for(NSDictionary * o in BackGroundObject) {
		//NSLog(@"item %d(Dic)",itemIndex++);
		[self settingObjects:o t_layerCode:BGL];
	}
	
	for(NSDictionary * o in ForeGroundObject) {
		[self settingObjects:o t_layerCode:FGL];
	}
	
	for(NSDictionary * o in EffectObject) {
		[self settingObjects:o t_layerCode:EL];
	}
	//모든 불러오기후 모든 재 할당이 끝나면 로드한 dic객체 풀어주기
	NSLog(@"twWayRoad RetainCount:%d",[twWayRoad retainCount]);
}


-(void)settingObjects:(NSDictionary*)o t_layerCode:(int)LayerCode {
	NSString * usingClassName = [NSString stringWithString:[o valueForKey:@"Class"]];
	NSString * objectName = [NSString stringWithString:[o valueForKey:@"Name"]];
	int zPos = -1 * (totalZDistance - [[o valueForKey:@"ZdistanceBengintoEnd"] intValue]);
	
	if (useForAnimation) { //애니메이션용으로 셋팅할때 제외할 객체들을 이프문으로 등록후 해당이 되면 스킵
		if ([objectName isEqualToString:@"door"])return;
	}
	
	if ([usingClassName isEqualToString:@"CCSprite"]) {
		
		CCSprite * oo = [CCSprite spriteWithFile:[o valueForKey:@"initFile"]];
		[[oo texture] setAliasTexParameters];
		
		[self setObjectProperty:o Object:oo];
		[self addChild:oo z:zPos t_layerCode:LayerCode];
		
	}else if ([usingClassName isEqualToString:@"Sun"]) {
		Sun * oo = [[[Sun alloc] initSun] autorelease];
		[self setObjectProperty:o Object:oo];
		[self addChild:oo z:zPos t_layerCode:LayerCode];
		
		if(PM != nil)if ([[o valueForKey:@"Active"] boolValue])[[PM otherAnimationObject] addObject:oo];
		
	}else if ([usingClassName isEqualToString:@"CloudEngine"]) {
		CloudEngine * oo = [[[CloudEngine alloc] init] autorelease];
		[self setObjectProperty:o Object:oo];
		[self addChild:oo z:zPos t_layerCode:LayerCode];
		
		if(PM != nil)if ([[o valueForKey:@"Active"] boolValue])[[PM otherAnimationObject] addObject:oo];
		
	}else if ([usingClassName isEqualToString:@"WindMill"]) {
		
		WindMill * oo = [[[WindMill alloc] init] autorelease];
		[self setObjectProperty:o Object:oo];
		[self addChild:oo z:zPos t_layerCode:LayerCode];
		
		if(PM != nil)if ([[o valueForKey:@"Active"] boolValue])[[PM otherAnimationObject] addObject:oo];
		
	}else if ([usingClassName isEqualToString:@"SandStorm"]) {
		
		SandStorm * oo = [[[SandStorm alloc] init] autorelease];
		[self setObjectProperty:o Object:oo];
		[self addChild:oo z:zPos t_layerCode:LayerCode];
		
		if(PM != nil)if ([[o valueForKey:@"Active"] boolValue])[[PM otherAnimationObject] addObject:oo];
		
	}else if ([usingClassName isEqualToString:@"SandMountain"]) {
		
		SandMountain * oo = [[[SandMountain alloc] initWithMountainImage:[o valueForKey:@"initFile"]] autorelease];
		[self setObjectProperty:o Object:oo];
		[self addChild:oo z:zPos t_layerCode:LayerCode];
		
		if(PM != nil)if ([[o valueForKey:@"Active"] boolValue])[[PM otherAnimationObject] addObject:oo];
		
	}else if ([usingClassName isEqualToString:@"VolcanoMountain"]) {
		
		VolcanoMountain * oo = [[[VolcanoMountain alloc] initWithFile:[o valueForKey:@"initFile"]] autorelease];
		[self setObjectProperty:o Object:oo];
		[self addChild:oo z:zPos t_layerCode:LayerCode];
		
		if(PM != nil)if ([[o valueForKey:@"Active"] boolValue])[[PM otherAnimationObject] addObject:oo];
		
	}else if ([usingClassName isEqualToString:@"FishShoals"]) {
        NSArray * valuesArr = [(NSString*)[o valueForKey:@"initValues"] componentsSeparatedByString:@","];
        
        FishShoals * oo = [[[FishShoals alloc] FishShoalsWithSize:CGSizeMake([[valuesArr objectAtIndex:0] intValue],[[valuesArr objectAtIndex:1] intValue])] autorelease];
        
        [self setObjectProperty:o Object:oo];
        [self addChild:oo z:zPos t_layerCode:LayerCode];
        if(PM != nil)if ([[o valueForKey:@"Active"] boolValue])[[PM otherAnimationObject] addObject:oo];
        NSLog(@"FishShoals retainCOunt:%d",[oo retainCount]);
        
    }else if ([usingClassName isEqualToString:@"BubbleBubble"]) {
        NSArray * valuesArr = [(NSString*)[o valueForKey:@"initValues"] componentsSeparatedByString:@","];
        //initValue = Count,CGRect:x,y,w,h,BeginOpacity
        
        BubbleBubble * oo = [[[BubbleBubble alloc] initWithCount:[[valuesArr objectAtIndex:0] intValue] scope:CGRectMake([[valuesArr objectAtIndex:1] intValue], [[valuesArr objectAtIndex:2] intValue], [[valuesArr objectAtIndex:3] intValue], [[valuesArr objectAtIndex:4] intValue])] autorelease];
        oo.beginOpacity = [[valuesArr objectAtIndex:5] intValue];
        
        [self setObjectProperty:o Object:oo];
        [self addChild:oo z:zPos t_layerCode:LayerCode];
        if(PM != nil)if ([[o valueForKey:@"Active"] boolValue])[[PM otherAnimationObject] addObject:oo];
		
    }else if ([usingClassName isEqualToString:@"WaterSurfaceLighting"]) {
        WaterSurfaceLighting * oo = [[[WaterSurfaceLighting alloc] init] autorelease];
        
        [self setObjectProperty:o Object:oo];
        [self addChild:oo z:zPos t_layerCode:LayerCode];
        if(PM != nil)if ([[o valueForKey:@"Active"] boolValue])[[PM otherAnimationObject] addObject:oo];
		
    }else if ([usingClassName isEqualToString:@"Tree"]) {
        Tree * oo = [[[Tree alloc] initWithTreeSource:[o valueForKey:@"initFile"]] autorelease];
        
        [self setObjectProperty:o Object:oo];
        [self addChild:oo z:zPos t_layerCode:LayerCode];
        if(PM != nil)if ([[o valueForKey:@"Active"] boolValue])[[PM otherAnimationObject] addObject:oo];
		
    }else if ([usingClassName isEqualToString:@"ReflexWaterSurface"]) {
        ReflexWaterSurface * oo = [[[ReflexWaterSurface alloc] init] autorelease];
        
        [self setObjectProperty:o Object:oo];
        [self addChild:oo z:zPos t_layerCode:LayerCode];
        if(PM != nil)if ([[o valueForKey:@"Active"] boolValue])[[PM otherAnimationObject] addObject:oo];
		
    }else if ([usingClassName isEqualToString:@"RealVolcano"]) {
        RealVolcano * oo = [[[RealVolcano alloc] initWithMountain:[o valueForKey:@"initFile"]] autorelease];
        
        [self setObjectProperty:o Object:oo];
        [self addChild:oo z:zPos t_layerCode:LayerCode];
        if(PM != nil)if ([[o valueForKey:@"Active"] boolValue])[[PM otherAnimationObject] addObject:oo];
		
    }else if ([usingClassName isEqualToString:@"FireCave"]) {
        FireCave * oo = [[[FireCave alloc] init] autorelease];
        
        [self setObjectProperty:o Object:oo];
        [self addChild:oo z:zPos t_layerCode:LayerCode];
        if(PM != nil)if ([[o valueForKey:@"Active"] boolValue])[[PM otherAnimationObject] addObject:oo];		
    }else if ([usingClassName isEqualToString:@"BackGroundLightning"]) {
        BackGroundLightning * oo = [[[BackGroundLightning alloc] init] autorelease];
        
        [self setObjectProperty:o Object:oo];
        [self addChild:oo z:zPos t_layerCode:LayerCode];
        if(PM != nil)if ([[o valueForKey:@"Active"] boolValue])[[PM otherAnimationObject] addObject:oo];
		
    }else if ([usingClassName isEqualToString:@"Stage2Sky"]) {
        Stage2Sky * oo = [[[Stage2Sky alloc] init] autorelease];
        
        [self setObjectProperty:o Object:oo];
        [self addChild:oo z:zPos t_layerCode:LayerCode];
        if(PM != nil)if ([[o valueForKey:@"Active"] boolValue])[[PM otherAnimationObject] addObject:oo];
		
    }
}

-(void)setObjectProperty:(NSDictionary*)o Object:(CCSprite*)oo {
    //if ([[o valueForKey:@"AnchorPointX"] floatValue] != 0.5f && [[o valueForKey:@"AnchorPointY"] floatValue] != 0.5f) {
        oo.anchorPoint = ccp([[o valueForKey:@"AnchorPointX"] floatValue],[[o valueForKey:@"AnchorPointY"] floatValue]);
    //}
	
    if ([[o valueForKey:@"PositionX"] floatValue] != 0) {
        oo.position = ccp([[o valueForKey:@"PositionX"] floatValue],oo.position.y);
    }
    if ([[o valueForKey:@"PositionY"] floatValue] != 0) {
        oo.position = ccp(oo.position.x,[[o valueForKey:@"PositionY"] floatValue]);
    }
    if ([[o valueForKey:@"Scale"] floatValue] != 1) {
        oo.scale =  [[o valueForKey:@"Scale"] floatValue];
    }
    if ([[o valueForKey:@"Opacity"] intValue] != 255) {
        oo.opacity = [[o valueForKey:@"Opacity"] intValue];
    }
	
}


-(void)addChild:(CCSprite*)oo z:(float)z_ t_layerCode:(int)LayerCode {
	switch (LayerCode) {
		case BGL:
			[backGroundLayer addChild:oo z:z_];
			break;
		case FGL:
			[foreGroundLayer addChild:oo z:z_];
			break;
		case EL:
			[effectLayer addChild:oo z:z_];
			break;
		default:
			break;
	}
}


-(void)dealloc {
	
	
	//NSLog(@"stageObjectsDic retainCount:%d",[stageObjectsDic retainCount]);

	//[stageObjectsDic release];
	[super dealloc];
	NSLog(@"StagePlacement Dealloc");
}
@end
