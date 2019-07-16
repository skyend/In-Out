//
//  MyGraphScene.m
//  KeepInTheMind
//
//  Created by JinWoong Han on 11. 6. 6..
//  Copyright 2011 -. All rights reserved.
//
#import "GameConfig.h"
#import "MyGraphScene.h"
#import "GraphDisplay.h"
#import "GameCondition.h"
#import "ScoreHistoryTable.h"
#import "GameMainScene.h"
#import "TextLineBriefer.h"
#import "MissionCard.h"
#import "GraphTouchObserver.h"
#import "MissionClearTable.h"
#import "GameHeaders.h"
#import "GameCenterManager.h"

#define BGL 0  //BehindGroundLayer
#define FGL 1  //ForeGroundLayer 
#define EL  2  //EffectLayer 
#define FL  3  //FelidLayer

GLColorSet GLColorSetMake(float r,float g,float b,float a){
    GLColorSet colorSet;
    colorSet.red = r;
    colorSet.green = g;
    colorSet.blue = b;
    colorSet.alpha = a;
    return colorSet;
}

typedef enum {
    Order_BackGroundBlind,
    Order_GraphBackBlind,
    Order_ScoreGraph,
    Order_ComboGraph,
    Order_textContentsBlind,
    Order_textContents, //
    Order_GraphWindow,
    Order_windowButtons, //
    Order_MisstionCards, //
    Order_touch
}contentOrder;

typedef enum {
    tag_arrowLeft,
    tag_arrowRight,
    tag_home
}button;

@interface MyGraphScene (privateMethods)
-(void)settingBackGround:(NSDictionary*)stageObjectsDic;
-(void)update:(ccTime)d;
-(void)highVelocityLoop:(ccTime)aTimer;
-(void)settingGraphs:(StageCode)stageCode_;
-(void)dataRenewal:(StageCode)stageCode_;
-(void)buttonDown:(id)sel_;
-(void)buttonDisable:(button)name;
-(void)buttonEnable:(button)name;
-(void)reBriefingInit:(StageCode)stageCode_;
-(void)settingMissionCards:(NSDictionary*)infoDic_;

-(void)cardArrangeLoop:(ccTime)d;

-(void)setObjectProperty:(NSDictionary*)o Object:(CCSprite *)oo;
-(void)settingObjects:(NSDictionary*)o t_layerCode:(int)LayerCode;
-(void)addChild:(CCSprite*)oo z:(float)z_ t_layerCode:(int)LayerCode;
-(void)setGameCenterData:(unsigned long long)n_worldUserCount Ranking:(unsigned long long)n_worldRanking topScore:(unsigned long long)n_worldTopScore;
-(void)setTopLevel:(int) n_worldTopLevel;
-(void)AfterGameCenterLoading:(StageCode)stageCode_;
@end

@implementation MyGraphScene

+(id)scene {
	
	MyGraphScene *myGraphScene = [MyGraphScene node];
	
	CCScene *scene = [CCScene node];
	
	
	[scene addChild:myGraphScene];
    
	return scene;
}

#pragma mark -
#pragma mark === Initialize ===
-(id)init {
    if ( (self = [super init] )) {
        
        //[[CCDirector sharedDirector] enableRetinaDisplay:NO];
        GameCondition * GC = [GameCondition sharedGameCondition];
        
        
        if( [[CCDirector sharedDirector] contentScaleFactor] == 2.0f){
            NSLog(@"Retina");
            ratina = YES;
        }else if( [[CCDirector sharedDirector] contentScaleFactor] == 1.0f){
            ratina = NO;
        }
        
        lastStageCode = [[(NSArray*)[[GC possibleStageCode] componentsSeparatedByString:@","] lastObject] intValue]; //제일마지막으로 열린 스테이지부터 보여줌 사용가능한 스테이지
        
        ///히든스테이지 업데이트 후에 적용될 부분
        //재팬락이 걸려있다면 스테이지6의 그래프를 볼수없다
        if (GC.japanLock) {
            if (lastStageCode == 6) {
                lastStageCode = 5;
            }
        }
        
        superLayer = [CCLayer node];
        backGroundLayer = [CCLayer node];
        foreGroundLayer = [CCLayer node];
        effectLayer = [CCLayer node];
        contentsLayer = [CCLayer node];
        
        [self addChild:superLayer];
        [superLayer addChild:backGroundLayer];
        [superLayer addChild:foreGroundLayer];
        [superLayer addChild:effectLayer];
        [superLayer addChild:contentsLayer];
        
        BackGroundBlinder = [CCSprite spriteWithFile:@"Graph_backGroundBlind.png"];
        BackGroundBlinder.anchorPoint = ccp(0,0);
        BackGroundBlinder.position = ccp(0,0);
        BackGroundBlinder.scaleX = 480;
        [contentsLayer addChild:BackGroundBlinder z:Order_BackGroundBlind];
        
        GraphWindow = [CCSprite spriteWithFile:@"GraphWindow.png"];
        [GraphWindow setAnchorPoint:ccp(0.5f,0)];
        [GraphWindow setPosition:ccp(240,74)];
        [contentsLayer addChild:GraphWindow z:Order_GraphWindow];
        
        GraphBackGround = [CCSprite spriteWithFile:@"blackDot.png"];
        GraphBackGround.anchorPoint = ccp(0,0);
        GraphBackGround.position = ccp(6,77);
        GraphBackGround.scaleX = 468;
        GraphBackGround.scaleY = 235;
        GraphBackGround.opacity = 130;
        [contentsLayer addChild:GraphBackGround z:Order_GraphBackBlind];
        
        arrowLeft = [CCMenuItemImage itemFromNormalImage:@"Graph_arrow.png" selectedImage:@"Graph_arrow.png" target:self selector:@selector(buttonDown:)];
        arrowLeft.tag = tag_arrowLeft;
        arrowLeft.scaleX = -1;
        arrowLeft.anchorPoint = ccp(0.5f,0.5f);
        arrowLeft.position = ccp(-50,-55);
        arrowRight = [CCMenuItemImage itemFromNormalImage:@"Graph_arrow.png" selectedImage:@"Graph_arrow.png" target:self selector:@selector(buttonDown:)];
        arrowRight.tag = tag_arrowRight;
        arrowRight.anchorPoint = ccp(0.5f,0.5f);
        arrowRight.position = ccp(50,-55);
        
        home = [CCMenuItemImage itemFromNormalImage:@"TapToScreenIcon_Main.png" selectedImage:@"TapToScreenIcon_Main.png" target:self selector:@selector(buttonDown:)];
        home.tag = tag_home;
        home.anchorPoint = ccp(0.5f,0.5f);
        home.position = ccp(0,-55);
        
        CCMenu * menu = [CCMenu menuWithItems:arrowLeft,arrowRight,home, nil];
        
        [contentsLayer addChild:menu z:Order_windowButtons];
        
        int lastPlayedStageCode = [[NSUserDefaults standardUserDefaults] integerForKey:Option_key_Last_Played_StageCode];
        if (lastPlayedStageCode == 0) {
            lastPlayedStageCode = 1;
        }
        
        ViewingStageCode = lastPlayedStageCode;
        if (ViewingStageCode == 1) {
            [self buttonDisable:tag_arrowLeft];
        }
        if (ViewingStageCode == lastStageCode) {
            [self buttonDisable:tag_arrowRight];
        }
        NSLog(@"LastStageCode:%d",lastStageCode);
        
        
        textContentsLayer = [CCLayer node];
        [contentsLayer addChild:textContentsLayer z:Order_textContents];
        
        CCSprite * textContentsBlind = [CCSprite spriteWithFile:@"Graph_horizontal.png"];
        textContentsBlind.anchorPoint = ccp(0,0);
        textContentsBlind.position = ccp(7,82);
        textContentsBlind.scaleY = 232;
        [contentsLayer addChild:textContentsBlind z:Order_textContentsBlind];
        
        [self dataRenewal:ViewingStageCode];
        
        touchObserver = [[[GraphTouchObserver alloc] init] autorelease];
        [self addChild:touchObserver z:Order_touch];
        
        [self schedule:@selector(highVelocityLoop:)];
    }
    return self;
}

//CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];



#pragma mark -
#pragma mark === Data Display ===
-(void)dataRenewal:(StageCode)stageCode_{
    [[GameCondition sharedGameCondition] settingProfile];
    [[GameCondition sharedGameCondition] settingStagePlayInfo:stageCode_];
    
    NSString *stageFilePath = [NSString stringWithFormat:@"Stage%d",stageCode_];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:stageFilePath ofType:@"plist"];
    
    //스테이지 정보
	NSDictionary *stageObjectsDic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    //카드정보
    NSArray * ClearObjects = [stageObjectsDic valueForKey:@"ClearObjectsWithCode"]; //참조객체
    
    //미션ㅌ카드 정보 가공
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	NSArray * applicableMissionCodesDBArr = [[[NSArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:DB_key_ApplicableMissionCodes]]] autorelease];
	NSArray * applicableMissionCodesAtStage = [[[NSArray alloc] initWithArray:[(NSString*)[applicableMissionCodesDBArr objectAtIndex:stageCode_] componentsSeparatedByString:@","]] autorelease];
	
	NSMutableDictionary * ClearObjectsValuesAtCode = [[[NSMutableDictionary alloc] init] autorelease];
	
	NSLog(@"activation MissionCode :%@",[applicableMissionCodesAtStage description]);
	for (int i = 0; i < [applicableMissionCodesAtStage count]; i++ ) {
		int missionCode = [[applicableMissionCodesAtStage objectAtIndex:i] intValue];
		
		NSString * missionObjectStr = [ClearObjects objectAtIndex:missionCode];
		NSArray * missionArticles = [missionObjectStr componentsSeparatedByString:@" "];
		
		NSMutableDictionary * missionInfo = [[[NSMutableDictionary alloc] init] autorelease];
		
		for (int j = 0; j < [missionArticles count]; j++) {
			NSArray * dividedMissionArticle = [[missionArticles objectAtIndex:j] componentsSeparatedByString:@":"];
			NSString * keyAtMissionInfo = [dividedMissionArticle objectAtIndex:0];
			NSString * ValueAtMissionArticle = [dividedMissionArticle objectAtIndex:1];
			[missionInfo setObject:ValueAtMissionArticle forKey:keyAtMissionInfo];
			
			//미션정보 셋팅은 끝 이제 미션읽어서 체크루틴만들기
		}
		
		[ClearObjectsValuesAtCode setObject:missionInfo forKey:[NSString stringWithFormat:@"%d",missionCode]];
		NSLog(@"MissionCodes :%d",missionCode);
	}

    NSArray * totalWay  = [stageObjectsDic valueForKey:@"FieldWay"];
	
	NSString * twLength = (NSString*)[totalWay objectAtIndex:0];
	
	NSArray * twWayRoad = [(NSString*)[totalWay objectAtIndex:1] componentsSeparatedByString:@","];
    
	totalWay = [NSArray arrayWithObjects:twLength,twWayRoad,nil];
    
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

    
    
    [self settingBackGround:stageObjectsDic];
    [self settingGraphs:stageCode_];
    [self reBriefingInit:stageCode_];
    [self settingMissionCards:ClearObjectsValuesAtCode];
    [self AfterGameCenterLoading:stageCode_];
    
}

-(void)reBriefingInit:(StageCode)stageCode_{
    GameCondition * GC = [GameCondition sharedGameCondition];
    [textContentsLayer removeAllChildrenWithCleanup:YES];
    //NSString * name = [NSString stringWithString:[GameCondition sharedGameCondition].user_name];
    
    //Size 
    //float briefSpeed = 0.1f;
    float numberScaling = 1;
    //float beginY = 295;
    //float lineSpace = 25;
    //uint line = 0;
    
    
    
    
    

    
    if ([GameCondition sharedGameCondition].lang == Language_ko) {
        CCSprite * table = [CCSprite spriteWithFile:@"Graph_texts_ko.png"];
        table.anchorPoint = ccp(0,1);
        table.position = ccp(20,300);
        [textContentsLayer addChild:table];
        //line = 0;
        //Line 0//
//        userName = [CCLabelTTF labelWithString:name fontName:@"Marker Felt" fontSize:11];
//        userName.anchorPoint = ccp(0,0.5f);
//        userName.position = ccp(100,beginY + (lineSpace * line++));
//        [textContentsLayer addChild:userName];
        
        CCLabelAtlas * levelStr = [CCLabelAtlas labelWithString:@"0" charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
        [levelStr setAdjustWordBetween:-10];
        [levelStr setAnchorPoint:ccp(0,0.5f)];
        [levelStr setPosition:ccp(50,290)];
        levelStr.scale = numberScaling;
        
        NSMutableString * modify_levelStr = [NSMutableString stringWithFormat:@"%d",(GC.level)];
        if ([modify_levelStr length] > 3) {
            int length = [modify_levelStr length];
            int pushCommaCount = roundf(length/3);
            
            for (int i = 1; i <= pushCommaCount; i++) {
                if(length%3 == 0){
                    if (i != pushCommaCount) {
                        [modify_levelStr insertString:@"." atIndex:[modify_levelStr length]-((i*3)+i-1)]; 
                    }
                }else{
                    [modify_levelStr insertString:@"." atIndex:[modify_levelStr length]-((i*3)+i-1)];  
                } 
            }
        }
        
        [levelStr setString:[NSString stringWithFormat:@"%@",modify_levelStr]];
        [textContentsLayer addChild:levelStr];
            
       
        CCLabelAtlas * needExp = [CCLabelAtlas labelWithString:@"0" charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
        [needExp setAdjustWordBetween:-17/2];
        [needExp setAnchorPoint:ccp(0,0.5f)];
        [needExp setPosition:ccp(76,236)];
        needExp.scale = numberScaling;
        NSMutableString * modify_n_needExp = [NSMutableString stringWithFormat:@"%llu",GC.maxExp - GC.havingExp];
        if ([modify_n_needExp length] > 3) {
            int length = [modify_n_needExp length];
            int pushCommaCount = roundf(length/3);
            
            for (int i = 1; i <= pushCommaCount; i++) {
                if(length%3 == 0){
                    if (i != pushCommaCount) {
                        [modify_n_needExp insertString:@"." atIndex:[modify_n_needExp length]-((i*3)+i-1)]; 
                    }
                }else{
                    [modify_n_needExp insertString:@"." atIndex:[modify_n_needExp length]-((i*3)+i-1)];  
                } 
            }
        }
        [needExp setString:[NSString stringWithFormat:@"%@",modify_n_needExp]];
        [textContentsLayer addChild:needExp];
        
        
        CCLabelAtlas * highScore = [CCLabelAtlas labelWithString:@"0" charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
        [highScore setAdjustWordBetween:-17/2];
        [highScore setAnchorPoint:ccp(0,0.5f)];
        [highScore setPosition:ccp(120,200)];
        highScore.scale = numberScaling;
        
        NSMutableString * modify_n_highScore = [NSMutableString stringWithFormat:@"%llu",GC.highScore];
        if ([modify_n_highScore length] > 3) {
            int length = [modify_n_highScore length];
            int pushCommaCount = roundf(length/3);
            
            for (int i = 1; i <= pushCommaCount; i++) {
                if(length%3 == 0){
                    if (i != pushCommaCount) {
                        [modify_n_highScore insertString:@"." atIndex:[modify_n_highScore length]-((i*3)+i-1)]; 
                    }
                }else{
                    [modify_n_highScore insertString:@"." atIndex:[modify_n_highScore length]-((i*3)+i-1)];  
                } 
            }
        }
        [highScore setString:[NSString stringWithFormat:@"%@",modify_n_highScore]];
        [textContentsLayer addChild:highScore];
        
        CCLabelAtlas * worldTopScore = [CCLabelAtlas labelWithString:@"0" charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
        [worldTopScore setAdjustWordBetween:-17/2];
        [worldTopScore setAnchorPoint:ccp(0,0.5f)];
        [worldTopScore setPosition:ccp(80,183)];
        worldTopScore.scale = numberScaling;
        
//        NSMutableString * modify_n_worldTopScore = [NSMutableString stringWithFormat:@"%llu",n_worldTopScore];
//        if ([modify_n_worldTopScore length] > 3) {
//            int length = [modify_n_worldTopScore length];
//            int pushCommaCount = roundf(length/3);
//            
//            for (int i = 1; i <= pushCommaCount; i++) {
//                if(length%3 == 0){
//                    if (i != pushCommaCount) {
//                        [modify_n_worldTopScore insertString:@"." atIndex:[modify_n_worldTopScore length]-((i*3)+i-1)]; 
//                    }
//                }else{
//                    [modify_n_worldTopScore insertString:@"." atIndex:[modify_n_worldTopScore length]-((i*3)+i-1)];  
//                } 
//            }
//        }
//        [worldTopScore setString:[NSString stringWithFormat:@"%@",modify_n_worldTopScore]];
//        [textContentsLayer addChild:worldTopScore];
        
        CCLabelAtlas * totalCombo = [CCLabelAtlas labelWithString:@"0" charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
        [totalCombo setAdjustWordBetween:-17/2];
        [totalCombo setAnchorPoint:ccp(0,0.5f)];
        [totalCombo setPosition:ccp(47,164)];
        totalCombo.scale = numberScaling;
        
        NSMutableString * modify_totalCombo = [NSMutableString stringWithFormat:@"%d",stageTotalCombo];
        if ([modify_totalCombo length] > 3) {
            int length = [modify_totalCombo length];
            int pushCommaCount = roundf(length/3);
            
            for (int i = 1; i <= pushCommaCount; i++) {
                if(length%3 == 0){
                    if (i != pushCommaCount) {
                        [modify_totalCombo insertString:@"." atIndex:[modify_totalCombo length]-((i*3)+i-1)]; 
                    }
                }else{
                    [modify_totalCombo insertString:@"." atIndex:[modify_totalCombo length]-((i*3)+i-1)];  
                } 
            }
        }
        [totalCombo setString:[NSString stringWithFormat:@"%@",modify_totalCombo]];
        [textContentsLayer addChild:totalCombo];
        
        CCLabelAtlas * highCombo = [CCLabelAtlas labelWithString:@"0" charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
        [highCombo setAdjustWordBetween:-17/2];
        [highCombo setAnchorPoint:ccp(0,0.5f)];
        [highCombo setPosition:ccp(73,146)];
        highCombo.scale = numberScaling;
        
        NSMutableString * modify_highCombo = [NSMutableString stringWithFormat:@"%d",GC.highCombo];
        if ([modify_highCombo length] > 3) {
            int length = [modify_highCombo length];
            int pushCommaCount = roundf(length/3);
            
            for (int i = 1; i <= pushCommaCount; i++) {
                if(length%3 == 0){
                    if (i != pushCommaCount) {
                        [modify_highCombo insertString:@"." atIndex:[modify_highCombo length]-((i*3)+i-1)]; 
                    }
                }else{
                    [modify_highCombo insertString:@"." atIndex:[modify_highCombo length]-((i*3)+i-1)];  
                } 
            }
        }
        [highCombo setString:[NSString stringWithFormat:@"%@",modify_highCombo]];
        [textContentsLayer addChild:highCombo];
       
        
    }else if ([GameCondition sharedGameCondition].lang == Language_en){
        CCSprite * table = [CCSprite spriteWithFile:@"Graph_texts_en.png"];
        table.anchorPoint = ccp(0,1);
        table.position = ccp(20,300);
        [textContentsLayer addChild:table];
        //line = 0;
        //Line 0//
        //        userName = [CCLabelTTF labelWithString:name fontName:@"Marker Felt" fontSize:11];
        //        userName.anchorPoint = ccp(0,0.5f);
        //        userName.position = ccp(100,beginY + (lineSpace * line++));
        //        [textContentsLayer addChild:userName];
        
        CCLabelAtlas * levelStr = [CCLabelAtlas labelWithString:@"0" charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
        [levelStr setAdjustWordBetween:-20/2];
        [levelStr setAnchorPoint:ccp(0,0.5f)];
        [levelStr setPosition:ccp(55,290)];
        levelStr.scale = numberScaling;
        
        NSMutableString * modify_levelStr = [NSMutableString stringWithFormat:@"%d",(GC.level)];
        if ([modify_levelStr length] > 3) {
            int length = [modify_levelStr length];
            int pushCommaCount = roundf(length/3);
            
            for (int i = 1; i <= pushCommaCount; i++) {
                if(length%3 == 0){
                    if (i != pushCommaCount) {
                        [modify_levelStr insertString:@"." atIndex:[modify_levelStr length]-((i*3)+i-1)]; 
                    }
                }else{
                    [modify_levelStr insertString:@"." atIndex:[modify_levelStr length]-((i*3)+i-1)];  
                } 
            }
        }
        
        [levelStr setString:[NSString stringWithFormat:@"%@",modify_levelStr]];
        [textContentsLayer addChild:levelStr];
        
        
        CCLabelAtlas * worldRanking = [CCLabelAtlas labelWithString:@"0" charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
        [worldRanking setAdjustWordBetween:-17/2];
        [worldRanking setAnchorPoint:ccp(0,0.5f)];
        [worldRanking setPosition:ccp(98,272)];
        worldRanking.scale = numberScaling;
        
//        NSMutableString * modify_n_worldRanking = [NSMutableString stringWithFormat:@"%llu",n_worldRanking];
//        if ([modify_n_worldRanking length] > 3) {
//            int length = [modify_n_worldRanking length];
//            int pushCommaCount = roundf(length/3);
//            
//            for (int i = 1; i <= pushCommaCount; i++) {
//                if(length%3 == 0){
//                    if (i != pushCommaCount) {
//                        [modify_n_worldRanking insertString:@"." atIndex:[modify_n_worldRanking length]-((i*3)+i-1)]; 
//                    }
//                }else{
//                    [modify_n_worldRanking insertString:@"." atIndex:[modify_n_worldRanking length]-((i*3)+i-1)];  
//                } 
//            }
//        }
//        
//        NSMutableString * modify_n_worldUserCount = [NSMutableString stringWithFormat:@"%llu",n_worldUserCount];
//        if ([modify_n_worldUserCount length] > 3) {
//            int length = [modify_n_worldUserCount length];
//            int pushCommaCount = roundf(length/3);
//            
//            for (int i = 1; i <= pushCommaCount; i++) {
//                if(length%3 == 0){
//                    if (i != pushCommaCount) {
//                        [modify_n_worldUserCount insertString:@"." atIndex:[modify_n_worldUserCount length]-((i*3)+i-1)]; 
//                    }
//                }else{
//                    [modify_n_worldUserCount insertString:@"." atIndex:[modify_n_worldUserCount length]-((i*3)+i-1)];  
//                } 
//            }
//        }
//        
//        [worldRanking setString:[NSString stringWithFormat:@"%@/ %@",modify_n_worldRanking,modify_n_worldUserCount]];
//        [textContentsLayer addChild:worldRanking];
//        
//        CCLabelAtlas * topLevel = [CCLabelAtlas labelWithString:@"0" charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
//        [topLevel setAdjustWordBetween:-17/2];
//        [topLevel setAnchorPoint:ccp(0,0.5f)];
//        [topLevel setPosition:ccp(105,255)];
//        topLevel.scale = numberScaling;
//        
//        NSMutableString * modify_n_worldTopLevel = [NSMutableString stringWithFormat:@"%d",n_worldTopLevel];
//        if ([modify_n_worldTopLevel length] > 3) {
//            int length = [modify_n_worldTopLevel length];
//            int pushCommaCount = roundf(length/3);
//            
//            for (int i = 1; i <= pushCommaCount; i++) {
//                if(length%3 == 0){
//                    if (i != pushCommaCount) {
//                        [modify_n_worldTopLevel insertString:@"." atIndex:[modify_n_worldTopLevel length]-((i*3)+i-1)]; 
//                    }
//                }else{
//                    [modify_n_worldTopLevel insertString:@"." atIndex:[modify_n_worldTopLevel length]-((i*3)+i-1)];  
//                } 
//            }
//        }
//        [topLevel setString:[NSString stringWithFormat:@"%@",modify_n_worldTopLevel]];
//        [textContentsLayer addChild:topLevel];
        
        CCLabelAtlas * needExp = [CCLabelAtlas labelWithString:@"0" charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
        [needExp setAdjustWordBetween:-17/2];
        [needExp setAnchorPoint:ccp(0,0.5f)];
        [needExp setPosition:ccp(83,236)];
        needExp.scale = numberScaling;
        NSMutableString * modify_n_needExp = [NSMutableString stringWithFormat:@"%llu",GC.maxExp - GC.havingExp];
        if ([modify_n_needExp length] > 3) {
            int length = [modify_n_needExp length];
            int pushCommaCount = roundf(length/3);
            
            for (int i = 1; i <= pushCommaCount; i++) {
                if(length%3 == 0){
                    if (i != pushCommaCount) {
                        [modify_n_needExp insertString:@"." atIndex:[modify_n_needExp length]-((i*3)+i-1)]; 
                    }
                }else{
                    [modify_n_needExp insertString:@"." atIndex:[modify_n_needExp length]-((i*3)+i-1)];  
                } 
            }
        }
        [needExp setString:[NSString stringWithFormat:@"%@",modify_n_needExp]];
        [textContentsLayer addChild:needExp];
        
        
        CCLabelAtlas * highScore = [CCLabelAtlas labelWithString:@"0" charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
        [highScore setAdjustWordBetween:-17/2];
        [highScore setAnchorPoint:ccp(0,0.5f)];
        [highScore setPosition:ccp(115,200)];
        highScore.scale = numberScaling;
        
        NSMutableString * modify_n_highScore = [NSMutableString stringWithFormat:@"%llu",GC.highScore];
        if ([modify_n_highScore length] > 3) {
            int length = [modify_n_highScore length];
            int pushCommaCount = roundf(length/3);
            
            for (int i = 1; i <= pushCommaCount; i++) {
                if(length%3 == 0){
                    if (i != pushCommaCount) {
                        [modify_n_highScore insertString:@"." atIndex:[modify_n_highScore length]-((i*3)+i-1)]; 
                    }
                }else{
                    [modify_n_highScore insertString:@"." atIndex:[modify_n_highScore length]-((i*3)+i-1)];  
                } 
            }
        }
        [highScore setString:[NSString stringWithFormat:@"%@",modify_n_highScore]];
        [textContentsLayer addChild:highScore];
        
        CCLabelAtlas * worldTopScore = [CCLabelAtlas labelWithString:@"0" charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
        [worldTopScore setAdjustWordBetween:-17/2];
        [worldTopScore setAnchorPoint:ccp(0,0.5f)];
        [worldTopScore setPosition:ccp(106,183)];
        worldTopScore.scale = numberScaling;
        
//        NSMutableString * modify_n_worldTopScore = [NSMutableString stringWithFormat:@"%llu",n_worldTopScore];
//        if ([modify_n_worldTopScore length] > 3) {
//            int length = [modify_n_worldTopScore length];
//            int pushCommaCount = roundf(length/3);
//            
//            for (int i = 1; i <= pushCommaCount; i++) {
//                if(length%3 == 0){
//                    if (i != pushCommaCount) {
//                        [modify_n_worldTopScore insertString:@"." atIndex:[modify_n_worldTopScore length]-((i*3)+i-1)]; 
//                    }
//                }else{
//                    [modify_n_worldTopScore insertString:@"." atIndex:[modify_n_worldTopScore length]-((i*3)+i-1)];  
//                } 
//            }
//        }
//        [worldTopScore setString:[NSString stringWithFormat:@"%@",modify_n_worldTopScore]];
//        [textContentsLayer addChild:worldTopScore];
        
        CCLabelAtlas * totalCombo = [CCLabelAtlas labelWithString:@"0" charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
        [totalCombo setAdjustWordBetween:-17/2];
        [totalCombo setAnchorPoint:ccp(0,0.5f)];
        [totalCombo setPosition:ccp(88,164)];
        totalCombo.scale = numberScaling;
        
        NSMutableString * modify_totalCombo = [NSMutableString stringWithFormat:@"%d",stageTotalCombo];
        if ([modify_totalCombo length] > 3) {
            int length = [modify_totalCombo length];
            int pushCommaCount = roundf(length/3);
            
            for (int i = 1; i <= pushCommaCount; i++) {
                if(length%3 == 0){
                    if (i != pushCommaCount) {
                        [modify_totalCombo insertString:@"." atIndex:[modify_totalCombo length]-((i*3)+i-1)]; 
                    }
                }else{
                    [modify_totalCombo insertString:@"." atIndex:[modify_totalCombo length]-((i*3)+i-1)];  
                } 
            }
        }
        [totalCombo setString:[NSString stringWithFormat:@"%@",modify_totalCombo]];
        [textContentsLayer addChild:totalCombo];
        
        CCLabelAtlas * highCombo = [CCLabelAtlas labelWithString:@"0" charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
        [highCombo setAdjustWordBetween:-17/2];
        [highCombo setAnchorPoint:ccp(0,0.5f)];
        [highCombo setPosition:ccp(80,146)];
        highCombo.scale = numberScaling;
        
        NSMutableString * modify_highCombo = [NSMutableString stringWithFormat:@"%d",GC.highCombo];
        if ([modify_highCombo length] > 3) {
            int length = [modify_highCombo length];
            int pushCommaCount = roundf(length/3);
            
            for (int i = 1; i <= pushCommaCount; i++) {
                if(length%3 == 0){
                    if (i != pushCommaCount) {
                        [modify_highCombo insertString:@"." atIndex:[modify_highCombo length]-((i*3)+i-1)]; 
                    }
                }else{
                    [modify_highCombo insertString:@"." atIndex:[modify_highCombo length]-((i*3)+i-1)];  
                } 
            }
        }

        [highCombo setString:[NSString stringWithFormat:@"%@",modify_highCombo]];
        [textContentsLayer addChild:highCombo];
    }
    
}

#pragma mark -
#pragma mark === Setting ===
-(void)settingGraphs:(StageCode)stageCode_{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    GameCondition * GC = [GameCondition sharedGameCondition];
    
    if (scoreGraph != nil) {
        [contentsLayer removeChild:scoreGraph cleanup:YES];
    }
    if (comboGraph != nil) {
        [contentsLayer removeChild:comboGraph cleanup:YES];
    }
    
    NSArray * scoreTables = [[[NSArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:getStageInfoKey(GC.selectedUserSlot, stageCode_, StageInfo_key_SCORE_HISTORY_TABLES)]]] autorelease]; //직접 유저디폴트의 정보를 받아옴
    
    NSMutableArray * scoreList = [[[NSMutableArray alloc] init] autorelease]; //스코어만 빼내서 담을 공간
    for (int i = 0; i < [scoreTables count]; i++) {
        NSNumber * n = [NSNumber numberWithUnsignedLongLong:[[scoreTables objectAtIndex:i] score]];
        NSLog(@"score:%llu",[n unsignedLongLongValue]);
        [scoreList addObject:n];
    }
    NSLog(@"socreList:%d",[scoreList count]);
    scoreGraph = [[[GraphDisplay alloc] initWithGraphData:scoreList MaxHeight:160 WidthInterval:20 DisplayDataRange:NSMakeRange(0, 10) ScissorBox:CGRectMake(6, 80, 468, 235) Slidng:10] autorelease];
    scoreGraph.position = ccp(6,80);
    [contentsLayer addChild:scoreGraph z:Order_ScoreGraph];
    [scoreGraph setGraphColor:GLColorSetMake(0.5f, 0, 0, 0.1f)];
    [scoreGraph setValueHeaderClor:GLColorSetMake(0.5f, 0.0f, 0.0f, 0.3f)];
    [scoreGraph setGraphOutLineColor:GLColorSetMake(0.7f, 0, 0, 0.8f)];
    [scoreGraph setValueHeaderXPos:460];
    [scoreGraph setMaxOfValueXPos:460];
    [scoreGraph setMaxOfValueColor:GLColorSetMake(1, 0, 0, 0.9f)];
    
    stageTotalCombo = 0;
    NSMutableArray * comboList = [[[NSMutableArray alloc] init] autorelease]; //스코어만 빼내서 담을 공간
    for (int i = 0; i < [scoreTables count]; i++) {
        NSNumber * n = [NSNumber numberWithUnsignedInt:[[scoreTables objectAtIndex:i] highCombo]];
        [comboList addObject:n];
        
        stageTotalCombo += [[scoreTables objectAtIndex:i] totalCombo];
    }
    comboGraph = [[[GraphDisplay alloc] initWithGraphData:comboList MaxHeight:100 WidthInterval:15 DisplayDataRange:NSMakeRange(0, 10) ScissorBox:CGRectMake(6, 80, 468, 235) Slidng:10] autorelease];
    comboGraph.position = ccp(6,80);
    [contentsLayer addChild:comboGraph z:Order_ComboGraph];
    [comboGraph setGraphColor:GLColorSetMake(0.45f, 0.5f, 0, 0.6f)];
    [comboGraph setGraphOutLineColor:GLColorSetMake(0.96f, 1, 0, 0.4f)];
    [comboGraph setValueHeaderClor:GLColorSetMake(0.45f, 0.5f, 0.0f, 0.6f)];
    [comboGraph setValueHeaderXPos:350];
    [comboGraph setMaxOfValueXPos:350];
    [comboGraph setMaxOfValueColor:GLColorSetMake(1, 1, 0, 0.9f)];
    
    NSLog(@"combo Board : %@",[comboList description]);
}

-(void)settingMissionCards:(NSDictionary*)infoDic_{
    if (CardLayer == nil) {
        CardLayer = [CCLayer node];
    }else{
        [contentsLayer removeChild:CardLayer cleanup:YES];
        CardLayer = [CCLayer node];
    }
    CardLayer.position = ccp(50,0);
    [contentsLayer addChild:CardLayer];
    
//    CardLayer = [CCLayer node];
    NSString * langStr;
    if ([GameCondition sharedGameCondition].lang == Language_ko) {
        langStr = [NSString stringWithString:@"ko"];
    }else if ([GameCondition sharedGameCondition].lang == Language_en) {
        langStr = [NSString stringWithString:@"en"];
    }else {
        langStr = [NSString stringWithString:@"en"];
    }
    
    NSDictionary * missionDic = infoDic_;
    for (int i = 0; i < 6; i++) {
        if (i == 0) {
            MC1 = [CCSprite node];
            MissionCard * clearMissionCard = [[[MissionCard alloc] initWithCode:i missionDic:missionDic] autorelease];
            [MC1 addChild:clearMissionCard];
            MC1.anchorPoint = ccp(0,0.5f);
            MC1.position = ccp(20*i,30);
            [CardLayer addChild:MC1];
        }else if (i == 1) {
            MC2 = [CCSprite node];
            MissionCard * clearMissionCard = [[[MissionCard alloc] initWithCode:i missionDic:missionDic] autorelease];
            [MC2 addChild:clearMissionCard];
            MC2.anchorPoint = ccp(0,0.5f);
            MC2.position = ccp(20*i,30);
            [CardLayer addChild:MC2];
        }else if (i == 2) {
            MC3 = [CCSprite node];
            MissionCard * clearMissionCard = [[[MissionCard alloc] initWithCode:i missionDic:missionDic] autorelease];
            [MC3 addChild:clearMissionCard];
            MC3.anchorPoint = ccp(0,0.5f);
            MC3.position = ccp(20*i,30);
            [CardLayer addChild:MC3];
        }else if (i == 3) {
            MC4 = [CCSprite node];
            MissionCard * clearMissionCard = [[[MissionCard alloc] initWithCode:i missionDic:missionDic] autorelease];
            [MC4 addChild:clearMissionCard];
            MC4.anchorPoint = ccp(0,0.5f);
            MC4.position = ccp(20*i,30);
            [CardLayer addChild:MC4];
        }else if (i == 4) {
            MC5 = [CCSprite node];
            MissionCard * clearMissionCard = [[[MissionCard alloc] initWithCode:i missionDic:missionDic] autorelease];
            [MC5 addChild:clearMissionCard];
            MC5.anchorPoint = ccp(0,0.5f);
            MC5.position = ccp(20*i,30);
            [CardLayer addChild:MC5];
        }else if (i == 5) {
            MC6 = [CCSprite node];
            MissionCard * clearMissionCard = [[[MissionCard alloc] initWithCode:i missionDic:missionDic] autorelease];
            [MC6 addChild:clearMissionCard];
            MC6.anchorPoint = ccp(0,0.5f);
            MC6.position = ccp(20*i,30);
            [CardLayer addChild:MC6];
        }
        

        if (i == 0) {
            CCSprite * te = [CCSprite spriteWithFile:[NSString stringWithFormat:@"missionCard_description_%@_RescueCharacter.png",langStr]];
            te.anchorPoint = ccp(0,0.5f);
            te.position = ccp(40,0);
            [MC1 addChild:te z:-1];
            [MC1 setContentSize:CGSizeMake(te.position.x + te.contentSize.width,0)];
            
            int ClearCount = [(MissionClearTable*)[[[GameCondition sharedGameCondition] MissionClearedTables] valueForKey:@"0"] clearCount];
            CCLabelAtlas * clearCountLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d",ClearCount] charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
            clearCountLabel.anchorPoint = ccp(0,0);
            
            clearCountLabel.position = ccp(75,-14.5f);
            [MC1 addChild:clearCountLabel];
            
            int OverClearCount = [(MissionClearTable*)[[[GameCondition sharedGameCondition] MissionClearedTables] valueForKey:@"0"] overClearCount];
            CCLabelAtlas * overClearCountLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d",OverClearCount] charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
            overClearCountLabel.anchorPoint = ccp(0,0);
            overClearCountLabel.position = ccp(174,-14.5f);
            [MC1 addChild:overClearCountLabel];
            
        }else if(i == 1){
            CCSprite * te = [CCSprite spriteWithFile:[NSString stringWithFormat:@"missionCard_description_%@_ComboRecord.png",langStr]];
            te.anchorPoint = ccp(0,0.5f);
            te.position = ccp(40,0);
            [MC2 addChild:te z:-1];
            [MC2 setContentSize:CGSizeMake(te.position.x + te.contentSize.width,0)];
            
            int ClearCount = [(MissionClearTable*)[[[GameCondition sharedGameCondition] MissionClearedTables] valueForKey:@"1"] clearCount];
            CCLabelAtlas * clearCountLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d",ClearCount] charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
            clearCountLabel.anchorPoint = ccp(0,0);
            if ([GameCondition sharedGameCondition].lang == Language_ko) {
                clearCountLabel.position = ccp(75,-14.5f);
            }else if ([GameCondition sharedGameCondition].lang == Language_en) {
                clearCountLabel.position = ccp(75,-22.0f);
            }
            
            [MC2 addChild:clearCountLabel];
            
            int OverClearCount = [(MissionClearTable*)[[[GameCondition sharedGameCondition] MissionClearedTables] valueForKey:@"1"] overClearCount];
            CCLabelAtlas * overClearCountLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d",OverClearCount] charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
            overClearCountLabel.anchorPoint = ccp(0,0);
            if ([GameCondition sharedGameCondition].lang == Language_ko) {
                overClearCountLabel.position = ccp(174,-14.5f);
            }else if ([GameCondition sharedGameCondition].lang == Language_en) {
                overClearCountLabel.position = ccp(174,-22.0f);
            }
            [MC2 addChild:overClearCountLabel];
        }else if(i == 2){
            CCSprite * te = [CCSprite spriteWithFile:[NSString stringWithFormat:@"missionCard_description_%@_PlaytimeRecord.png",langStr]];
            te.anchorPoint = ccp(0,0.5f);
            te.position = ccp(40,0);
            [MC3 addChild:te z:-1];
            [MC3 setContentSize:CGSizeMake(te.position.x + te.contentSize.width,0)];
            
            int ClearCount = [(MissionClearTable*)[[[GameCondition sharedGameCondition] MissionClearedTables] valueForKey:@"2"] clearCount];
            CCLabelAtlas * clearCountLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d",ClearCount] charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
            clearCountLabel.anchorPoint = ccp(0,0);
            if ([GameCondition sharedGameCondition].lang == Language_ko) {
                clearCountLabel.position = ccp(75,-14.5f);
            }else if ([GameCondition sharedGameCondition].lang == Language_en) {
                clearCountLabel.position = ccp(75,-14.5f);
            }
            
            [MC3 addChild:clearCountLabel];
            
            int OverClearCount = [(MissionClearTable*)[[[GameCondition sharedGameCondition] MissionClearedTables] valueForKey:@"2"] overClearCount];
            CCLabelAtlas * overClearCountLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d",OverClearCount] charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
            overClearCountLabel.anchorPoint = ccp(0,0);
            if ([GameCondition sharedGameCondition].lang == Language_ko) {
                overClearCountLabel.position = ccp(174,-14.5f);
            }else if ([GameCondition sharedGameCondition].lang == Language_en) {
                overClearCountLabel.position = ccp(174,-14.5f);
            }

            [MC3 addChild:overClearCountLabel];
        }else if(i == 3){
            CCSprite * te = [CCSprite spriteWithFile:[NSString stringWithFormat:@"missionCard_description_%@_ScoreRecord.png",langStr]];
            te.anchorPoint = ccp(0,0.5f);
            te.position = ccp(40,0);
            [MC4 addChild:te z:-1];
            [MC4 setContentSize:CGSizeMake(te.position.x + te.contentSize.width,0)];
            
            int ClearCount = [(MissionClearTable*)[[[GameCondition sharedGameCondition] MissionClearedTables] valueForKey:@"3"] clearCount];
            CCLabelAtlas * clearCountLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d",ClearCount] charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
            clearCountLabel.anchorPoint = ccp(0,0);
            if ([GameCondition sharedGameCondition].lang == Language_ko) {
                clearCountLabel.position = ccp(75,-14.5f);
            }else if ([GameCondition sharedGameCondition].lang == Language_en) {
                clearCountLabel.position = ccp(75,-22.0f);
            }
            
            [MC4 addChild:clearCountLabel];
            
            int OverClearCount = [(MissionClearTable*)[[[GameCondition sharedGameCondition] MissionClearedTables] valueForKey:@"3"] overClearCount];
            CCLabelAtlas * overClearCountLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d",OverClearCount] charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
            overClearCountLabel.anchorPoint = ccp(0,0);
            if ([GameCondition sharedGameCondition].lang == Language_ko) {
                overClearCountLabel.position = ccp(174,-14.5f);
            }else if ([GameCondition sharedGameCondition].lang == Language_en) {
                overClearCountLabel.position = ccp(174,-22.0f);
            }
            
            [MC4 addChild:overClearCountLabel];
        }else if(i == 4){
            CCSprite * te = [CCSprite spriteWithFile:[NSString stringWithFormat:@"missionCard_description_%@_ComboTechnique.png",langStr]];
            te.anchorPoint = ccp(0,0.5f);
            te.position = ccp(40,0);
            [MC5 addChild:te z:-1];
            [MC5 setContentSize:CGSizeMake(te.position.x + te.contentSize.width,0)];
            
            int ClearCount = [(MissionClearTable*)[[[GameCondition sharedGameCondition] MissionClearedTables] valueForKey:@"4"] clearCount];
            CCLabelAtlas * clearCountLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d",ClearCount] charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
            clearCountLabel.anchorPoint = ccp(0,0);
            if ([GameCondition sharedGameCondition].lang == Language_ko) {
                clearCountLabel.position = ccp(75,-14.5f);
            }else if ([GameCondition sharedGameCondition].lang == Language_en) {
                clearCountLabel.position = ccp(75,-22.0f);
            }
            
            [MC5 addChild:clearCountLabel];
            
            int OverClearCount = [(MissionClearTable*)[[[GameCondition sharedGameCondition] MissionClearedTables] valueForKey:@"4"] overClearCount];
            CCLabelAtlas * overClearCountLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d",OverClearCount] charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
            overClearCountLabel.anchorPoint = ccp(0,0);
            if ([GameCondition sharedGameCondition].lang == Language_ko) {
                overClearCountLabel.position = ccp(174,-14.5f);
            }else if ([GameCondition sharedGameCondition].lang == Language_en) {
                overClearCountLabel.position = ccp(174,-22.0f);
            }
            
            [MC5 addChild:overClearCountLabel];
        }else if(i == 5){
            CCSprite * te = [CCSprite spriteWithFile:[NSString stringWithFormat:@"missionCard_description_%@_HighComboRecord.png",langStr]];
            te.anchorPoint = ccp(0,0.5f);
            te.position = ccp(40,0);
            [MC6 addChild:te z:-1];
            [MC6 setContentSize:CGSizeMake(te.position.x + te.contentSize.width,0)];
            
            int ClearCount = [(MissionClearTable*)[[[GameCondition sharedGameCondition] MissionClearedTables] valueForKey:@"5"] clearCount];
            CCLabelAtlas * clearCountLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d",ClearCount] charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
            clearCountLabel.anchorPoint = ccp(0,0);
            if ([GameCondition sharedGameCondition].lang == Language_ko) {
                clearCountLabel.position = ccp(75,-14.5f);
            }else if ([GameCondition sharedGameCondition].lang == Language_en) {
                clearCountLabel.position = ccp(75,-22.0f);
            }
            [MC6 addChild:clearCountLabel];
            
            int OverClearCount = [(MissionClearTable*)[[[GameCondition sharedGameCondition] MissionClearedTables] valueForKey:@"5"] overClearCount];
            CCLabelAtlas * overClearCountLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d",OverClearCount] charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
            overClearCountLabel.anchorPoint = ccp(0,0);
            if ([GameCondition sharedGameCondition].lang == Language_ko) {
                overClearCountLabel.position = ccp(174,-14.5f);
            }else if ([GameCondition sharedGameCondition].lang == Language_en) {
                overClearCountLabel.position = ccp(174,-22.0f);
            }
            
            [MC6 addChild:overClearCountLabel];
        }
        
        
        
        
    }
    ShowCardIndex = 5;

    
}



#pragma mark -
#pragma mark === BackGroundStage ===
-(void)settingBackGround:(NSDictionary*)stageObjectsDic{
    if (otherAnimationObject == nil) {
        otherAnimationObject = [[NSMutableArray alloc] init];
    }else{
        [otherAnimationObject removeAllObjects];
    }
    [backGroundLayer removeAllChildrenWithCleanup:YES];
    [foreGroundLayer removeAllChildrenWithCleanup:YES];
    [effectLayer removeAllChildrenWithCleanup:YES];
    
    NSArray * BackGroundObject = [NSArray arrayWithArray:[stageObjectsDic valueForKey:@"BackGroundObjects"]];
	NSArray * ForeGroundObject = [NSArray arrayWithArray:[stageObjectsDic valueForKey:@"ForeGroundObjects"]];
	NSArray * EffectObject = [NSArray arrayWithArray:[stageObjectsDic valueForKey:@"EffectObjects"]];

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
}

#pragma mark -
#pragma mark === Button Methods ===
-(void)buttonDown:(id)sender {
    
    
    if ([sender tag] == tag_home) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameMain scene]]];
    }else if([sender tag] == tag_arrowLeft){
        if (ViewingStageCode-1 >= 1) {
            ViewingStageCode --;
            [self dataRenewal:ViewingStageCode];
            if (1 == ViewingStageCode) {
                [self buttonDisable:tag_arrowLeft];
            }
            
            [[AudioPlayer sharedAudioPlayer] allStopAudio];
            [[AudioPlayer sharedAudioPlayer] stageBGMSetting:ViewingStageCode];
            
            [self buttonEnable:tag_arrowRight];
        }
    }else if([sender tag] == tag_arrowRight){
        if (ViewingStageCode <= lastStageCode+1) {
            ViewingStageCode ++;
            [self dataRenewal:ViewingStageCode];
            
            [[AudioPlayer sharedAudioPlayer] allStopAudio];
            [[AudioPlayer sharedAudioPlayer] stageBGMSetting:ViewingStageCode];
            
            if (lastStageCode == ViewingStageCode) {
                [self buttonDisable:tag_arrowRight];
            }
            [self buttonEnable:tag_arrowLeft];
        }
    }
    
}

-(void)buttonDisable:(button)name{
    if (name == tag_arrowLeft) {
        [arrowLeft setIsEnabled:NO];
        [arrowLeft setVisible:NO];
    }else if(name == tag_arrowRight){
        [arrowRight setIsEnabled:NO];
        [arrowRight setVisible:NO];
    }
}

-(void)buttonEnable:(button)name{
    if (name == tag_arrowLeft) {
        [arrowLeft setIsEnabled:YES];
        [arrowLeft setVisible:YES];
    }else if(name == tag_arrowRight){
        [arrowRight setIsEnabled:YES];
        [arrowRight setVisible:YES];
    }
}

#pragma mark -
#pragma mark === Loop ===
-(void)highVelocityLoop:(ccTime)aTimer {
    float d = aTimer;//[aTimer timeInterval];
    timeCount += d;


/**/
    if (scoreGraph != nil) {
        [scoreGraph update:d];
    }
    if (comboGraph != nil) {
        [comboGraph update:d];
    }
    
    if (timeCount > 10) {
        //[self dataRenewal:1];
        timeCount = 0;
    }
    //printf("aa/");
    
    
    [self cardArrangeLoop:d];
    
    for (DynamicObject * o in otherAnimationObject){
        [o update:d];
    }
    
}

-(void)cardArrangeLoop:(ccTime)d{
    if (touchObserver.touching) {
        if (touchObserver.beginPos.y < 70) {
            
            if (touchObserver.moving) {
                if (ShowCardIndex == 5) {
                    mc6Speed += [touchObserver vectorX];
                }else if (ShowCardIndex == 4) {
                    mc5Speed += [touchObserver vectorX];
                }else if (ShowCardIndex == 3) {
                    mc4Speed += [touchObserver vectorX];
                }else if (ShowCardIndex == 2) {
                    mc3Speed += [touchObserver vectorX];
                }else if (ShowCardIndex == 1) {
                    mc2Speed += [touchObserver vectorX];
                }else if (ShowCardIndex == 0) {
                    mc1Speed += [touchObserver vectorX];
                }
            }
        }
    }
    
    float speedDown = 0.7f;
    
    if (mc6Speed > 0) {
        if (MC6.position.x > 450) {
            MC6.position = ccp(450,MC6.position.y);
            mc6Speed = 0;
            ShowCardIndex = 4;
        }else{
            MC6.position = ccp(MC6.position.x + mc6Speed,MC6.position.y);
            mc6Speed *= speedDown;
        }
    }else if(mc6Speed < 0){
        if (MC6.position.x < 100) {
            MC6.position = ccp(100,MC6.position.y);
            mc6Speed = 0;
            ShowCardIndex = 5;
        }else{
            MC6.position = ccp(MC6.position.x + mc6Speed,MC6.position.y);
            mc6Speed *= speedDown;
        }
    }
    
    if (mc5Speed > 0) {
        if (MC5.position.x > 430) {
            MC5.position = ccp(430,MC5.position.y);
            mc5Speed = 0;
            ShowCardIndex = 3;
        }else{
            MC5.position = ccp(MC5.position.x + mc5Speed,MC5.position.y);
            mc5Speed *= speedDown;
        }
    }else if(mc5Speed < 0){
        if (MC5.position.x <= 80) {
            MC5.position = ccp(80,MC5.position.y);
            mc5Speed = 0;
            ShowCardIndex = 5;
        }else{
            MC5.position = ccp(MC5.position.x + mc5Speed,MC5.position.y);
            mc5Speed *= speedDown;
        }
    }
    
    if (mc4Speed > 0) {
        if (MC4.position.x > 410) {
            MC4.position = ccp(410,MC4.position.y);
            mc4Speed = 0;
            ShowCardIndex = 2;
        }else{
            MC4.position = ccp(MC4.position.x + mc4Speed,MC4.position.y);
            mc4Speed *= speedDown;
        }
    }else if(mc4Speed < 0){
        if (MC4.position.x <= 60) {
            MC4.position = ccp(60,MC4.position.y);
            mc4Speed = 0;
            ShowCardIndex = 4;
        }else{
            MC4.position = ccp(MC4.position.x + mc4Speed,MC4.position.y);
            mc4Speed *= speedDown;
        }
    }
    if (mc3Speed > 0) {
        if (MC3.position.x > 390) {
            MC3.position = ccp(390,MC3.position.y);
            mc3Speed = 0;
            ShowCardIndex = 1;
        }else{
            MC3.position = ccp(MC3.position.x + mc3Speed,MC3.position.y);
            mc3Speed *= speedDown;
        }
    }else if(mc3Speed < 0){
        if (MC3.position.x <= 40) {
            MC3.position = ccp(40,MC3.position.y);
            mc3Speed = 0;
            ShowCardIndex = 3;
        }else{
            MC3.position = ccp(MC3.position.x + mc3Speed,MC3.position.y);
            mc3Speed *= speedDown;
        }
    }
    if (mc2Speed > 0) {
        if (MC2.position.x > 370) {
            MC2.position = ccp(370,MC2.position.y);
            mc2Speed = 0;
            //ShowCardIndex = 0;
        }else{
            MC2.position = ccp(MC2.position.x + mc2Speed,MC2.position.y);
            mc2Speed *= speedDown;
        }
    }else if(mc2Speed < 0){
        if (MC2.position.x <= 20) {
            MC2.position = ccp(20,MC2.position.y);
            mc2Speed = 0;
            ShowCardIndex = 2;
        }else{
            MC2.position = ccp(MC2.position.x + mc2Speed,MC2.position.y);
            mc2Speed *= speedDown;
        }
    }
}

#pragma mark -
#pragma mark === Stage ===
-(void)settingObjects:(NSDictionary*)o t_layerCode:(int)LayerCode {
	NSString * usingClassName = [NSString stringWithString:[o valueForKey:@"Class"]];
	NSString * objectName = [NSString stringWithString:[o valueForKey:@"Name"]];
	int zPos = -1 * (totalZDistance - [[o valueForKey:@"ZdistanceBengintoEnd"] intValue]);
	
    if ([objectName isEqualToString:@"door"])return;
	
	if ([usingClassName isEqualToString:@"CCSprite"]) {
		
		CCSprite * oo = [CCSprite spriteWithFile:[o valueForKey:@"initFile"]];
		[[oo texture] setAliasTexParameters];
		
		[self setObjectProperty:o Object:oo];
		[self addChild:oo z:zPos t_layerCode:LayerCode];
		
	}else if ([usingClassName isEqualToString:@"Sun"]) {
		Sun * oo = [[[Sun alloc] initSun] autorelease];
		[self setObjectProperty:o Object:oo];
		[self addChild:oo z:zPos t_layerCode:LayerCode];
		
		if ([[o valueForKey:@"Active"] boolValue])[otherAnimationObject addObject:oo];
		
	}else if ([usingClassName isEqualToString:@"CloudEngine"]) {
		CloudEngine * oo = [[[CloudEngine alloc] init] autorelease];
		[self setObjectProperty:o Object:oo];
		[self addChild:oo z:zPos t_layerCode:LayerCode];
		
		if ([[o valueForKey:@"Active"] boolValue])[otherAnimationObject addObject:oo];
		
	}else if ([usingClassName isEqualToString:@"WindMill"]) {
		
		WindMill * oo = [[[WindMill alloc] init] autorelease];
		[self setObjectProperty:o Object:oo];
		[self addChild:oo z:zPos t_layerCode:LayerCode];
		
		if ([[o valueForKey:@"Active"] boolValue])[otherAnimationObject addObject:oo];
		
	}else if ([usingClassName isEqualToString:@"SandStorm"]) {
		
		SandStorm * oo = [[[SandStorm alloc] init] autorelease];
		[self setObjectProperty:o Object:oo];
		[self addChild:oo z:zPos t_layerCode:LayerCode];
		
		if ([[o valueForKey:@"Active"] boolValue])[otherAnimationObject addObject:oo];
		
	}else if ([usingClassName isEqualToString:@"SandMountain"]) {
		
		SandMountain * oo = [[[SandMountain alloc] initWithMountainImage:[o valueForKey:@"initFile"]] autorelease];
		[self setObjectProperty:o Object:oo];
		[self addChild:oo z:zPos t_layerCode:LayerCode];
		
		if ([[o valueForKey:@"Active"] boolValue])[otherAnimationObject addObject:oo];
		
	}else if ([usingClassName isEqualToString:@"VolcanoMountain"]) {
		
		VolcanoMountain * oo = [[[VolcanoMountain alloc] initWithFile:[o valueForKey:@"initFile"]] autorelease];
		[self setObjectProperty:o Object:oo];
		[self addChild:oo z:zPos t_layerCode:LayerCode];
		
		if ([[o valueForKey:@"Active"] boolValue])[otherAnimationObject addObject:oo];
		
	}else if ([usingClassName isEqualToString:@"FishShoals"]) {
        NSArray * valuesArr = [(NSString*)[o valueForKey:@"initValues"] componentsSeparatedByString:@","];
        //CGSize:w,h
        FishShoals * oo = [[[FishShoals alloc] FishShoalsWithSize:CGSizeMake([[valuesArr objectAtIndex:0] intValue],[[valuesArr objectAtIndex:1] intValue])] autorelease];
        
        [self setObjectProperty:o Object:oo];
        [self addChild:oo z:zPos t_layerCode:LayerCode];
        if ([[o valueForKey:@"Active"] boolValue])[otherAnimationObject addObject:oo];
		
    }else if ([usingClassName isEqualToString:@"BubbleBubble"]) {
        NSArray * valuesArr = [(NSString*)[o valueForKey:@"initValues"] componentsSeparatedByString:@","];
        //initValue = Count,CGRect:x,y,w,h,BeginOpacity
        
        BubbleBubble * oo = [[[BubbleBubble alloc] initWithCount:[[valuesArr objectAtIndex:0] intValue] scope:CGRectMake([[valuesArr objectAtIndex:1] intValue], [[valuesArr objectAtIndex:2] intValue], [[valuesArr objectAtIndex:3] intValue], [[valuesArr objectAtIndex:4] intValue])] autorelease];
        oo.beginOpacity = [[valuesArr objectAtIndex:5] intValue];
        
        [self setObjectProperty:o Object:oo];
        [self addChild:oo z:zPos t_layerCode:LayerCode];
        if ([[o valueForKey:@"Active"] boolValue])[otherAnimationObject addObject:oo];
		
    }else if ([usingClassName isEqualToString:@"WaterSurfaceLighting"]) {
        WaterSurfaceLighting * oo = [[[WaterSurfaceLighting alloc] init] autorelease];
        
        [self setObjectProperty:o Object:oo];
        [self addChild:oo z:zPos t_layerCode:LayerCode];
        if ([[o valueForKey:@"Active"] boolValue])[otherAnimationObject addObject:oo];
		
    }else if ([usingClassName isEqualToString:@"Tree"]) {
        Tree * oo = [[[Tree alloc] initWithTreeSource:[o valueForKey:@"initFile"]] autorelease];
        
        [self setObjectProperty:o Object:oo];
        [self addChild:oo z:zPos t_layerCode:LayerCode];
        if ([[o valueForKey:@"Active"] boolValue])[otherAnimationObject addObject:oo];
		
    }else if ([usingClassName isEqualToString:@"ReflexWaterSurface"]) {
        ReflexWaterSurface * oo = [[[ReflexWaterSurface alloc] init] autorelease];
        
        [self setObjectProperty:o Object:oo];
        [self addChild:oo z:zPos t_layerCode:LayerCode];
        if ([[o valueForKey:@"Active"] boolValue])[otherAnimationObject addObject:oo];
		
    }else if ([usingClassName isEqualToString:@"RealVolcano"]) {
        RealVolcano * oo = [[[RealVolcano alloc] initWithMountain:[o valueForKey:@"initFile"]] autorelease];
        
        [self setObjectProperty:o Object:oo];
        [self addChild:oo z:zPos t_layerCode:LayerCode];
        if ([[o valueForKey:@"Active"] boolValue])[otherAnimationObject addObject:oo];
		
    }else if ([usingClassName isEqualToString:@"FireCave"]) {
        FireCave * oo = [[[FireCave alloc] init] autorelease];
        
        [self setObjectProperty:o Object:oo];
        [self addChild:oo z:zPos t_layerCode:LayerCode];
        if ([[o valueForKey:@"Active"] boolValue])[otherAnimationObject addObject:oo];		
    }else if ([usingClassName isEqualToString:@"BackGroundLightning"]) {
        BackGroundLightning * oo = [[[BackGroundLightning alloc] init] autorelease];
        
        [self setObjectProperty:o Object:oo];
        [self addChild:oo z:zPos t_layerCode:LayerCode];
        if ([[o valueForKey:@"Active"] boolValue])[otherAnimationObject addObject:oo];
		
    }else if ([usingClassName isEqualToString:@"Stage2Sky"]) {
        Stage2Sky * oo = [[[Stage2Sky alloc] init] autorelease];
        
        [self setObjectProperty:o Object:oo];
        [self addChild:oo z:zPos t_layerCode:LayerCode];
        if ([[o valueForKey:@"Active"] boolValue])[otherAnimationObject addObject:oo];
		
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

-(void)AfterGameCenterLoading:(StageCode)stageCode_{
    
    GKLeaderboard *board = [[[GKLeaderboard alloc] init] autorelease];
    if (board != nil)
    {
        board.range = NSMakeRange(1, 10);
        //board.timeScope = GKLeaderboardTimeScopeAllTime;
        board.playerScope = GKLeaderboardPlayerScopeGlobal;
        switch (stageCode_) {
            case STAGE_1 :
                board.category = [NSString stringWithFormat:@"rb_stage1"];
                break;
            case STAGE_2 :
                board.category = [NSString stringWithFormat:@"rb_stage2"];
                break;
            case STAGE_3 :
                board.category = [NSString stringWithFormat:@"rb_stage3"];
                break;
            case STAGE_4 :
                board.category = [NSString stringWithFormat:@"rb_stage4"];
                break;
            case STAGE_5 :
                board.category = [NSString stringWithFormat:@"rb_stage5"];
                break;
            case STAGE_6 :
                board.category = [NSString stringWithFormat:@"rb_stage6"];
                break;
            default:
                break;
        }
        
        [board loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
            if (error == nil)
            {
                if ([board localPlayerScore]==nil){
                    NSLog(@"localplayer nil!");
                    [self setGameCenterData:0 Ranking:0 topScore:0];
                }else {
//                    NSLog(@"%@",[[board localPlayerScore] description]);
//                    NSLog(@"%@",[scores description]);
                    int64_t topScore = 0;
                    if (scores != nil) {
                        if ([scores count] > 0) {
                            GKScore * topScoreData = [scores objectAtIndex:0];
                            topScore = [topScoreData value];
                            
                        }
                    }
                    
                    [self setGameCenterData:999999999 Ranking:[[board localPlayerScore] rank] topScore:topScore];
                    
                }
                //NSLog(@"Scores:%@",[scores description]); 
            } else {
                NSLog(@"error 1st fetch");
                [self setGameCenterData:0 Ranking:0 topScore:0];
            }
        }];
        
    }
    
    GKLeaderboard *levelboard = [[[GKLeaderboard alloc] init] autorelease];
    if (board != nil)
    {
        levelboard.range = NSMakeRange(1, 10);
        //board.timeScope = GKLeaderboardTimeScopeAllTime;
        levelboard.playerScope = GKLeaderboardPlayerScopeGlobal;
        levelboard.category = [NSString stringWithFormat:@"rb_level"];
        
        [levelboard loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
            if (error == nil)
            {
                if ([board localPlayerScore]==nil){
                    NSLog(@"localplayer nil!");
                    [self setTopLevel:0];
                }else {
                    if ([scores count] >= 1) {
                        GKScore * levelData = [scores objectAtIndex:0];
                        int64_t topLeb = [levelData value];
                        [self setTopLevel:topLeb];
                    }else{
                        [self setTopLevel:0];
                    }
                    
                }
                //NSLog(@"Scores:%@",[scores description]); 
            } else {
                NSLog(@"error 1st fetch");
                [self setTopLevel:0];
            }
        }];
        
    }

    
}
-(void)setGameCenterData:(unsigned long long)n_worldUserCount Ranking:(unsigned long long)n_worldRanking topScore:(unsigned long long)n_worldTopScore{
    float numberScaling = 1;

    
    CCLabelAtlas * worldRanking = [CCLabelAtlas labelWithString:@"0" charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
    [worldRanking setAdjustWordBetween:-17/2];
    [worldRanking setAnchorPoint:ccp(0,0.5f)];
    if ([GameCondition sharedGameCondition].lang == Language_ko) {
        [worldRanking setPosition:ccp(72,272)];
    }else if ([GameCondition sharedGameCondition].lang == Language_en){
        [worldRanking setPosition:ccp(98,272)];
    }
    
    worldRanking.scale = numberScaling;
    
    NSMutableString * modify_n_worldRanking = [NSMutableString stringWithFormat:@"%llu",n_worldRanking];
    if ([modify_n_worldRanking length] > 3) {
        int length = [modify_n_worldRanking length];
        int pushCommaCount = roundf(length/3);
        
        for (int i = 1; i <= pushCommaCount; i++) {
            if(length%3 == 0){
                if (i != pushCommaCount) {
                    [modify_n_worldRanking insertString:@"." atIndex:[modify_n_worldRanking length]-((i*3)+i-1)]; 
                }
            }else{
                [modify_n_worldRanking insertString:@"." atIndex:[modify_n_worldRanking length]-((i*3)+i-1)];  
            } 
        }
    }
    
    NSMutableString * modify_n_worldUserCount = [NSMutableString stringWithFormat:@"%llu",n_worldUserCount];
    if ([modify_n_worldUserCount length] > 3) {
        int length = [modify_n_worldUserCount length];
        int pushCommaCount = roundf(length/3);
        
        for (int i = 1; i <= pushCommaCount; i++) {
            if(length%3 == 0){
                if (i != pushCommaCount) {
                    [modify_n_worldUserCount insertString:@"." atIndex:[modify_n_worldUserCount length]-((i*3)+i-1)]; 
                }
            }else{
                [modify_n_worldUserCount insertString:@"." atIndex:[modify_n_worldUserCount length]-((i*3)+i-1)];  
            } 
        }
    }
    
    //[worldRanking setString:[NSString stringWithFormat:@"%@/ %@",modify_n_worldRanking,modify_n_worldUserCount]];
    [worldRanking setString:[NSString stringWithFormat:@"%@",modify_n_worldRanking]];
    [textContentsLayer addChild:worldRanking];
    
    
    
    CCLabelAtlas * worldTopScore = [CCLabelAtlas labelWithString:@"0" charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
    [worldTopScore setAdjustWordBetween:-17/2];
    [worldTopScore setAnchorPoint:ccp(0,0.5f)];
    
    if ([GameCondition sharedGameCondition].lang == Language_ko) {
        [worldTopScore setPosition:ccp(80,183)];
    }else if ([GameCondition sharedGameCondition].lang == Language_en){
        [worldTopScore setPosition:ccp(106,183)];
    }
    worldTopScore.scale = numberScaling;
    
    NSMutableString * modify_n_worldTopScore = [NSMutableString stringWithFormat:@"%llu",n_worldTopScore];
    if ([modify_n_worldTopScore length] > 3) {
        int length = [modify_n_worldTopScore length];
        int pushCommaCount = roundf(length/3);
        
        for (int i = 1; i <= pushCommaCount; i++) {
            if(length%3 == 0){
                if (i != pushCommaCount) {
                    [modify_n_worldTopScore insertString:@"." atIndex:[modify_n_worldTopScore length]-((i*3)+i-1)]; 
                }
            }else{
                [modify_n_worldTopScore insertString:@"." atIndex:[modify_n_worldTopScore length]-((i*3)+i-1)];  
            } 
        }
    }
    [worldTopScore setString:[NSString stringWithFormat:@"%@",modify_n_worldTopScore]];
    [textContentsLayer addChild:worldTopScore];
}

-(void)setTopLevel:(int) n_worldTopLevel{
    float numberScaling = 1;
    
    
    
    CCLabelAtlas * topLevel = [CCLabelAtlas labelWithString:@"0" charMapFile:@"graph_numbers_16.png" itemWidth:16 itemHeight:17 startCharMap:'.'];
    [topLevel setAdjustWordBetween:-17/2];
    [topLevel setAnchorPoint:ccp(0,0.5f)];
    if ([GameCondition sharedGameCondition].lang == Language_ko) {
        [topLevel setPosition:ccp(67,255)];
    }else if ([GameCondition sharedGameCondition].lang == Language_en){
        [topLevel setPosition:ccp(105,255)];
    }
    topLevel.scale = numberScaling;
    
    NSMutableString * modify_n_worldTopLevel = [NSMutableString stringWithFormat:@"%d",n_worldTopLevel];
    if ([modify_n_worldTopLevel length] > 3) {
        int length = [modify_n_worldTopLevel length];
        int pushCommaCount = roundf(length/3);
        
        for (int i = 1; i <= pushCommaCount; i++) {
            if(length%3 == 0){
                if (i != pushCommaCount) {
                    [modify_n_worldTopLevel insertString:@"." atIndex:[modify_n_worldTopLevel length]-((i*3)+i-1)]; 
                }
            }else{
                [modify_n_worldTopLevel insertString:@"." atIndex:[modify_n_worldTopLevel length]-((i*3)+i-1)];  
            } 
        }
    }
    [topLevel setString:[NSString stringWithFormat:@"%@",modify_n_worldTopLevel]];
    [textContentsLayer addChild:topLevel];
}



#pragma mark -
#pragma mark === Dealloc ===
-(void)dealloc {
    [otherAnimationObject removeAllObjects];
    [otherAnimationObject release];
    [super dealloc];
}
@end