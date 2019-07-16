//
//  GameMainScene.m
//  Memory0_0
//
//  Created by JinUng Han on 11. 3. 8..
//  Copyright 2011 Student. All rights reserved.
//

#import "GameMainScene.h"
#import "PlayScene.h"
#import "GameHeaders.h"
#import "StagePlacement.h"
#import "GameConfig.h"
#import "WorldMapScene.h"

#import "MyGraphScene.h"

#import "ShineEffect.h"

#import "CreditScene.h"
#import "GameCenterManager.h"
#import "GameCenterViewController.h"

@class StagePlacementManager;

#define B_START 0
#define B_MYGRAPH 1
#define B_HOWTO 2
#define B_OPTION 3
#define B_CREDIT 5

#define B_FACEBOOKLINK 14
#define B_TWITTERLINK 15

#define B_LeaderBoard 6
#define B_Achievement 7
#define B_LeaderBoard_GameCenter 8
#define B_LeaderBoard_OpenFeint 9
#define B_Achievement_GameCenter 10
#define B_Achievement_OpenFeint 11

#define B_MuteBGM 12
#define B_MuteSound 13


@interface GameMain (privateMethods)

-(BOOL)placeBackGround;
-(void)buttonCallback:(id)sender;
-(void)openOptionMenu:(ccTime)d;
//-(void)openLeaderBoardMenu:(ccTime)d;
//-(void)openAchievementMenu:(ccTime)d;
-(void)closeOptionMenu:(ccTime)d;
//-(void)closeLeaderBoardMenu:(ccTime)d;
//-(void)closeAchievementMenu:(ccTime)d;

@end


@implementation GameMain
@synthesize foregroundLayer;

+(id)scene {

	GameMain *gameMain = [GameMain node];
	
	CCScene *scene = [CCScene node];
	
    
	
	[scene addChild:gameMain];
	return scene;
}


-(id)init {
	
	if( (self = [super init]) ){
	
		backgroundLayer = [CCLayer node];
		hillOfBackField = [CCLayer node];
		foregroundLayer = [CCLayer node];
		ontheHillField  = [CCLayer node];
		coveringLayer   = [CCLayer node];
		effectLayer		= [CCLayer node];
		
		[self addChild:backgroundLayer];
		[self addChild:hillOfBackField];
		[self addChild:foregroundLayer];
		[self addChild:ontheHillField];
        [self addChild:effectLayer];
		[self addChild:coveringLayer];
		
		[GameCondition sharedGameCondition].stageCode = [[NSUserDefaults standardUserDefaults] integerForKey:Option_key_Last_Played_StageCode];
        
		//PM = [[ProgressManager alloc] initWithLayer:hillOfBackField field2:ontheHillField];
		PM = [[ProgressManager alloc] initWithLayerMode:hillOfBackField 
												 field2:ontheHillField 
												  cover:nil 
										backGroundLayer:backgroundLayer
												   mode:MAIN_ANMATION
											  whoCalled:self];
		
//		ShapeObjects = [[NSMutableArray alloc] init];
		
		[self placeBackGround];
		[self schedule:@selector(loop:)];
		
		self.isTouchEnabled = YES;
	
        
        //게임센터 뷰
        GameCenterViewCon = [[GameCenterViewController alloc] init];
        GameCenterViewCon.Main = self;
        
        

        
        NSLog(@"GameMainScene Initialize");
        return self;
	}
    
	
	return nil;
}

-(BOOL)placeBackGround {
	GameCondition * GC = [GameCondition sharedGameCondition];
	
    int lastPlayedStageCode = [[NSUserDefaults standardUserDefaults] integerForKey:Option_key_Last_Played_StageCode];
    if (lastPlayedStageCode == 0) {
        lastPlayedStageCode = 1;
    }
    currentLoadedStage = lastPlayedStageCode;
    //제일 마지막으로 플레이된 스테이지로 배경 초기화
	SPM = [[StagePlacementManager alloc] initStageWith3Layers:currentLoadedStage 
														   pm:PM 
											  backGroundLayer:backgroundLayer 
											  foreGroundLayer:foregroundLayer 
												  effectLayer:effectLayer
													useforAni:YES];
    
    //BGM
    [[AudioPlayer sharedAudioPlayer] allStopAudio];
    [[AudioPlayer sharedAudioPlayer] stageBGMSetting:currentLoadedStage];
    
    
	//최초로 GameCondition에 엑세스 함
	[[GameCondition sharedGameCondition] setSPM:SPM]; //SPM생성후 GameCondition 객체에게 넘겨줌
	[SPM release];

	OptionSubBack = [CCSprite spriteWithFile:@"blackDot.png"];
	LeaderBoardSubBack = [CCSprite spriteWithFile:@"blackDot.png"];
	AchievementSubBack = [CCSprite spriteWithFile:@"blackDot.png"];
	
	OptionSubBack.opacity = LeaderBoardSubBack.opacity = AchievementSubBack.opacity = 150;
	
	OptionSubBack.anchorPoint = ccp(1,0.5f);
	LeaderBoardSubBack.anchorPoint = ccp(0.5f,0); 
	AchievementSubBack.anchorPoint = ccp(0.5f,0);
	
	[coveringLayer addChild:OptionSubBack];
	[coveringLayer addChild:LeaderBoardSubBack];
	[coveringLayer addChild:AchievementSubBack];
	
	CCSprite *title = [CCSprite spriteWithFile:@"title.png"];
	[title setAnchorPoint:ccp(0.5f,0)];
	[title setPosition:ccp(240,160)];
	[coveringLayer addChild:title];
	
	
	CCMenuItem *b_start = [CCMenuItemImage itemFromNormalImage:@"MenuButtons_start.png" 
												 selectedImage:@"MenuButtons_start-d.png" 
														target:self
													  selector:@selector(buttonCallback:)];
	[b_start setTag:B_START];
	[b_start setPosition:ccp(230,130)];
	[b_start setAnchorPoint:ccp(1,0.5f)];
	
	CCMenuItem *b_mygraph = [CCMenuItemImage itemFromNormalImage:@"MenuButtons_mygraph.png" 
												 selectedImage:@"MenuButtons_mygraph-d.png"
														target:self
													  selector:@selector(buttonCallback:)];
	[b_mygraph setTag:B_MYGRAPH];
	[b_mygraph setPosition:ccp(250,130)];	
	[b_mygraph setAnchorPoint:ccp(0,0.5f)];

	CCMenuItem *b_option = [CCMenuItemImage itemFromNormalImage:@"MenuButtons_option.png" 
												 selectedImage:@"MenuButtons_option-d.png"
														target:self
													   selector:@selector(buttonCallback:)];
	[b_option setTag:B_OPTION];
	[b_option setPosition:ccp(360,40)];
	[b_option setAnchorPoint:ccp(0.5f,0.5f)];
	
	CCMenuItem *b_leaderBoard = [CCMenuItemImage itemFromNormalImage:@"LeaderBoard.png" 
												  selectedImage:@"b_GameCenter.png"
														 target:self
													   selector:@selector(buttonCallback:)];
	[b_leaderBoard setTag:B_LeaderBoard];
	[b_leaderBoard setPosition:ccp(120,40)];
	[b_leaderBoard setAnchorPoint:ccp(0.5f,0.5f)];
	
	CCMenuItem *b_achievement= [CCMenuItemImage itemFromNormalImage:@"Achievement.png" 
													 selectedImage:@"b_GameCenter.png"
															target:self
														  selector:@selector(buttonCallback:)];
	[b_achievement setTag:B_Achievement];
	[b_achievement setPosition:ccp(160,40)];
	[b_achievement setAnchorPoint:ccp(0.5f,0.5f)];
    
    CCMenuItem *b_facebook= [CCMenuItemImage itemFromNormalImage:@"MenuButtons_facebook.png" 
                                                      selectedImage:@"MenuButtons_facebook-d.png"
                                                             target:self
                                                           selector:@selector(buttonCallback:)];
	[b_facebook setTag:B_FACEBOOKLINK];
	[b_facebook setPosition:ccp(40,40)];
	[b_facebook setAnchorPoint:ccp(0.5f,0.5f)];
    
    CCMenuItem *b_twitter = [CCMenuItemImage itemFromNormalImage:@"MenuButtons_twitter.png" 
                                                      selectedImage:@"MenuButtons_twitter-d.png"
                                                             target:self
                                                           selector:@selector(buttonCallback:)];
	[b_twitter setTag:B_TWITTERLINK];
	[b_twitter setPosition:ccp(80,40)];
	[b_twitter setAnchorPoint:ccp(0.5f,0.5f)];
	
	CCMenuItem *b_credit = [CCMenuItemImage itemFromNormalImage:@"MenuButtons_credit.png" 
												  selectedImage:@"MenuButtons_credit-d.png" 
														 target:self 
													   selector:@selector(buttonCallback:)];
	[b_credit setTag:B_CREDIT];
	[b_credit setPosition:ccp(440,40)];
	[b_credit setAnchorPoint:ccp(0.5f,0.5f)];
	
	if( [GC onSound] )
		b_SwitchSound = [[CCMenuItemImage itemFromNormalImage:@"OptionButtons_Sound_On.png" selectedImage:@"OptionButtons_Sound_Off.png" target:self selector:@selector(buttonCallback:)] retain];
	else 
		b_SwitchSound = [[CCMenuItemImage itemFromNormalImage:@"OptionButtons_Sound_Off.png" selectedImage:@"OptionButtons_Sound_On.png" target:self selector:@selector(buttonCallback:)] retain];
	if( [GC onBGM] )
		b_SwitchBGM = [[CCMenuItemImage itemFromNormalImage:@"OptionButtons_BGM_On.png" selectedImage:@"OptionButtons_BGM_Off.png" target:self selector:@selector(buttonCallback:)] retain];
	else 
		b_SwitchBGM = [[CCMenuItemImage itemFromNormalImage:@"OptionButtons_BGM_Off.png" selectedImage:@"OptionButtons_BGM_On.png" target:self selector:@selector(buttonCallback:)] retain];
	
	[b_SwitchSound setTag:B_MuteSound];
	[b_SwitchSound setPosition:ccp(360,40)];
	[b_SwitchSound setAnchorPoint:ccp(0.5f,0.5f)];
	[b_SwitchSound setIsEnabled:NO];
	
	[b_SwitchBGM setTag:B_MuteBGM];
	[b_SwitchBGM setPosition:ccp(360,40)];
	[b_SwitchBGM setAnchorPoint:ccp(0.5f,0.5f)];
	[b_SwitchBGM setIsEnabled:NO];
	
//	b_LeaderBoard_GameCenter = [CCMenuItemImage itemFromNormalImage:@"MenuButtons_gameCenter.png" selectedImage:@"MenuButtons_gameCenter.png" target:self selector:@selector(buttonCallback:)];
//	b_LeaderBoard_OpenFeint = [CCMenuItemImage itemFromNormalImage:@"MenuButtons_openFeint.png" selectedImage:@"MenuButtons_openFeint.png" target:self selector:@selector(buttonCallback:)];
//	b_Achievement_GameCenter = [CCMenuItemImage itemFromNormalImage:@"MenuButtons_gameCenter.png" selectedImage:@"MenuButtons_gameCenter.png" target:self selector:@selector(buttonCallback:)];
//	b_Achievement_OpenFeint = [CCMenuItemImage itemFromNormalImage:@"MenuButtons_openFeint.png" selectedImage:@"MenuButtons_openFeint.png" target:self selector:@selector(buttonCallback:)];
//	
//	[b_LeaderBoard_GameCenter setTag:B_LeaderBoard_GameCenter];
//	[b_LeaderBoard_OpenFeint setTag:B_LeaderBoard_OpenFeint];
//	[b_Achievement_GameCenter setTag:B_Achievement_GameCenter];
//	[b_Achievement_OpenFeint setTag:B_Achievement_OpenFeint];
//	
//	[b_LeaderBoard_GameCenter setAnchorPoint:ccp(0.5f,0.5f)];
//	[b_LeaderBoard_OpenFeint setAnchorPoint:ccp(0.5f,0.5f)];
//	[b_Achievement_GameCenter setAnchorPoint:ccp(0.5f,0.5f)];
//	[b_Achievement_OpenFeint setAnchorPoint:ccp(0.5f,0.5f)];
//	
//	[b_LeaderBoard_GameCenter setPosition:ccp(40,40)];
//	[b_LeaderBoard_OpenFeint setPosition:ccp(40,40)];
//	[b_Achievement_GameCenter setPosition:ccp(80,40)];
//	[b_Achievement_OpenFeint setPosition:ccp(80,40)];
//	
//	[b_LeaderBoard_GameCenter setIsEnabled:NO];
//	[b_LeaderBoard_OpenFeint setIsEnabled:NO];
//	[b_Achievement_GameCenter setIsEnabled:NO];
//	[b_Achievement_OpenFeint setIsEnabled:NO];
	
	OptionSubBack.position = ccp(360,40);
//	LeaderBoardSubBack.position = ccp(39,40);
//	AchievementSubBack.position = ccp(79,40);
	
	OptionSubBack.scaleY = [[[CCTextureCache sharedTextureCache] textureForKey:@"OptionButtons_BGM_On.png"] contentSize].height-9;
//	LeaderBoardSubBack.scaleX = [[[CCTextureCache sharedTextureCache] textureForKey:@"MenuButtons_gameCenter.png"] contentSize].width-9;
//	AchievementSubBack.scaleX = [[[CCTextureCache sharedTextureCache] textureForKey:@"MenuButtons_gameCenter.png"] contentSize].width-9;
	
	CCMenu *mainMenuSet = [CCMenu menuWithItems:b_SwitchSound,b_SwitchBGM,b_start,b_mygraph,b_option,b_leaderBoard,b_achievement,b_credit,b_facebook,b_twitter,nil];
	[b_SwitchBGM release]; //생성시에 리테인걸어줌
	[b_SwitchSound release]; //리테인
	
	//[mainMenuSet alignItemsVertically];
	[mainMenuSet setPosition:ccp(0,0)];
	[coveringLayer addChild:mainMenuSet];
	
	

	openedOptionMenu = NO;
//	openedLeaderBoardMenu = NO;
//	openedAchievementMenu = NO;
	
//	FishShoals * fishShoals = [[[FishShoals alloc] FishShoalsWithSize:CGSizeMake(200, 100)] autorelease];
//    fishShoals.position = ccp(200,100);
//    [coveringLayer addChild:fishShoals];
//    [PM.otherAnimationObject addObject:fishShoals];
//    
//    BubbleBubble * bubbles = [[[BubbleBubble alloc] initWithCount:50 scope:CGRectMake(100, -200, 240, 200)] autorelease];
//    bubbles.beginOpacity = 200;
//    [coveringLayer addChild:bubbles];
//    [PM.otherAnimationObject addObject:bubbles];
    
//    WaterSurfaceLighting * aa = [[[WaterSurfaceLighting alloc] init] autorelease];
//    [coveringLayer addChild:aa];
//    [PM.otherAnimationObject addObject:aa];
    
    
	return YES;
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch*)touch withEvent:(UIEvent*)event {

	//CGPoint conPos = [self convertTouchToNodeSpace:touch];
	
//	moveGuidePoints = [[NSMutableArray alloc] init];
//	
//		
    
//    [[SoundManager sharedSM] playSound:@"Cartoon Accent 17.caf"];
    
	NSLog(@"ScreenTouch!");
	return YES;
}

-(void)ccTouchMoved:(UITouch*)touch withEvent:(UIEvent*)event {
//	CGPoint conPos = [self convertTouchToNodeSpace:touch];
//	
//	srandom(time(NULL));
//	
//	//NSLog(@"Random:%d",rand()%15);
//	BaseCharacter *rr = [[BaseCharacter alloc] initWithShape:1+rand()%7];
//	
//	
//	rr.position = conPos;
//	
//	[ontheHillField addChild:rr z:0];
//	
//	[moveGuidePoints addObject:rr];
//	[rr release];
//	
//	//NSLog(@"Touched x:%f y:%f",conPos.x,conPos.y);

}

-(void)ccTouchEnded:(UITouch*)touch withEvent:(UIEvent*)event {
	
	// 정해진 길의 가이드 라인 출력기
//	for(BaseCharacter *o in moveGuidePoints){
//
//		//printf("%d,%d,",(int)o.position.x,(int)o.position.y);
//	}
    NSLog(@"ScreenTouch!");
	//printf("\n Length:%d",[moveGuidePoints count]);
	
}

-(void)buttonCallback:(id)sender {
	GameCondition * GC = [GameCondition sharedGameCondition];
	UIView * topView = [[UIApplication sharedApplication] keyWindow];
    
    
	switch ([sender tag] ) {
		case B_START :
			NSLog(@"Start");
            
//            [[AudioPlayer sharedAudioPlayer] allStopAudio];
			//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[PlayScene sceneWithStageCode:STAGE_1]]];
            GC.stageCode = 0;
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[WorldMap scene]]];
			[[AudioPlayer sharedAudioPlayer] allStopAudio];
            [[AudioPlayer sharedAudioPlayer] playAudio:@"world.mp3"];
			//[self autorelease];
			break;
		case B_MYGRAPH :
            
			NSLog(@"MyGraph");
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[MyGraphScene scene]]];
			break;
		case B_OPTION :
			if (openedOptionMenu) {
				openedOptionMenu = NO; 
			}else {
				openedOptionMenu = YES;
			}

			NSLog(@"Option");
			break;
		case B_MuteBGM :
			NSLog(@"B_MuteBGM");
			if ([GC onBGM]) {//반대로 설정
				[GC BGMOff];
				[(CCSprite*)[(CCMenuItemImage*)b_SwitchBGM normalImage] setTexture:[[CCTextureCache sharedTextureCache] addImage:@"OptionButtons_BGM_Off.png"]];
				[(CCSprite*)[(CCMenuItemImage*)b_SwitchBGM selectedImage] setTexture:[[CCTextureCache sharedTextureCache] addImage:@"OptionButtons_BGM_On.png"]];
                
                [[AudioPlayer sharedAudioPlayer] allStopAudio];
			}else {
				[GC BGMOn];
				[(CCSprite*)[(CCMenuItemImage*)b_SwitchBGM normalImage] setTexture:[[CCTextureCache sharedTextureCache] addImage:@"OptionButtons_BGM_On.png"]];
				[(CCSprite*)[(CCMenuItemImage*)b_SwitchBGM selectedImage] setTexture:[[CCTextureCache sharedTextureCache] addImage:@"OptionButtons_BGM_Off.png"]];
                
                [[AudioPlayer sharedAudioPlayer] stageBGMSetting:currentLoadedStage];
			}
			
			break;
		case B_MuteSound :
			NSLog(@"B_MuteSound");
			
			if ([GC onSound]) {//반대로 설정
				[GC SoundOff];
				[(CCSprite*)[(CCMenuItemImage*)b_SwitchSound normalImage] setTexture:[[CCTextureCache sharedTextureCache] addImage:@"OptionButtons_Sound_Off.png"]];
				[(CCSprite*)[(CCMenuItemImage*)b_SwitchSound selectedImage] setTexture:[[CCTextureCache sharedTextureCache] addImage:@"OptionButtons_Sound_On.png"]];
			}else {
				[GC SoundOn];
				[(CCSprite*)[(CCMenuItemImage*)b_SwitchSound normalImage] setTexture:[[CCTextureCache sharedTextureCache] addImage:@"OptionButtons_Sound_On.png"]];
				[(CCSprite*)[(CCMenuItemImage*)b_SwitchSound selectedImage] setTexture:[[CCTextureCache sharedTextureCache] addImage:@"OptionButtons_Sound_Off.png"]];
			}

			break;
		case B_HOWTO :
			NSLog(@"HowTo");
			break;
		case B_Achievement :
			NSLog(@"B_Achievement");
//			if (openedAchievementMenu) {
//				openedAchievementMenu = NO; 
//			}else {
//				openedAchievementMenu = YES;
//			}
            if ([[GameCondition sharedGameCondition] gameCenterLoginSuccessed]) {
                [topView addSubview:[GameCenterViewCon view]];
                //NSLog(@"Call AchievmentView\nSubViews:%@",[[topView subviews] description]);
                [GameCenterViewCon showArchboard];
            }
            
			break;
		case B_LeaderBoard :
			NSLog(@"B_LeaderBoard");
//			if (openedLeaderBoardMenu) {
//				openedLeaderBoardMenu = NO; 
//			}else {
//				openedLeaderBoardMenu = YES;
//			}
            if ([[GameCondition sharedGameCondition] gameCenterLoginSuccessed]) {
                [topView addSubview:[GameCenterViewCon view]];
                //NSLog(@"Call LeaderboardView\nSubViews:%@",[[topView subviews] description]);
                [GameCenterViewCon showLeaderboard];
            }
			break;
		case B_TWITTERLINK :
            if (1) {
                NSURL *url = [NSURL URLWithString:[@"https://twitter.com/HotChocoMaker" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                [[UIApplication sharedApplication] openURL:url];
                NSLog(@"B_TWITTERLINK");
            }
            
            
			break;
		case B_FACEBOOKLINK :
            if (1) {
                NSURL *url = [NSURL URLWithString:[@"http://www.facebook.com/profile.php?id=100003226714603" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                [[UIApplication sharedApplication] openURL:url];
                NSLog(@"B_FACEBOOKLINK");
            }
			break;
            
		case B_CREDIT :
			NSLog(@"Credit");
//            [[AudioPlayer sharedAudioPlayer] allStopAudio];
            
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[CreditScene scene]]];
			break;
		default:
			break;
	}
}

-(void)loop:(ccTime)delta 
{
	[PM centerProgressLoop:delta];
	
	if (openedOptionMenu) {
		[self openOptionMenu:delta];
	}else {
		[self closeOptionMenu:delta];
	}
//	if (openedAchievementMenu) {
//		[self openAchievementMenu:delta];
//	}else {
//		[self closeAchievementMenu:delta];
//	}
//	if (openedLeaderBoardMenu) {
//		[self openLeaderBoardMenu:delta];
//	}else {
//		[self closeLeaderBoardMenu:delta];
//	}
//    
//   
    
	
}

-(void)openOptionMenu:(ccTime)d {
	b_SwitchBGM.position = ccp(b_SwitchBGM.position.x + (0.9f * (280 - b_SwitchBGM.position.x))*d*10 ,b_SwitchBGM.position.y);
	b_SwitchSound.position = ccp(b_SwitchSound.position.x + (0.9f * (320 - b_SwitchSound.position.x))*d*10 ,b_SwitchSound.position.y);
	OptionSubBack.scaleX = 360 - b_SwitchBGM.position.x;
	//[(CCMenuItemImage*)[coveringLayer getChildByTag:B_OPTION] setScale:5];   
	[b_SwitchBGM setIsEnabled:YES];
	[b_SwitchSound setIsEnabled:YES];
}

//-(void)openLeaderBoardMenu:(ccTime)d{
//	b_LeaderBoard_OpenFeint.position = ccp(b_LeaderBoard_OpenFeint.position.x,b_LeaderBoard_OpenFeint.position.y + (0.9f * (80 - b_LeaderBoard_OpenFeint.position.y))*d*10 );
//	b_LeaderBoard_GameCenter.position = ccp(b_LeaderBoard_GameCenter.position.x,b_LeaderBoard_GameCenter.position.y + (0.9f * (120 - b_LeaderBoard_GameCenter.position.y))*d*10 );
//	LeaderBoardSubBack.scaleY = b_LeaderBoard_GameCenter.position.y - 40;
//	//[(CCMenuItemImage*)[coveringLayer getChildByTag:B_OPTION] setScale:5];   
//	[b_LeaderBoard_OpenFeint setIsEnabled:YES];
//	[b_LeaderBoard_GameCenter setIsEnabled:YES];
//}
//
//-(void)openAchievementMenu:(ccTime)d{
//	b_Achievement_OpenFeint.position = ccp(b_Achievement_OpenFeint.position.x,b_Achievement_OpenFeint.position.y + (0.9f * (80 - b_Achievement_OpenFeint.position.y))*d*10 );
//	b_Achievement_GameCenter.position = ccp(b_Achievement_GameCenter.position.x,b_Achievement_GameCenter.position.y + (0.9f * (120 - b_Achievement_GameCenter.position.y))*d*10 );
//	AchievementSubBack.scaleY = b_Achievement_GameCenter.position.y - 40;
//	//[(CCMenuItemImage*)[coveringLayer getChildByTag:B_OPTION] setScale:5];   
//	[b_Achievement_OpenFeint setIsEnabled:YES];
//	[b_Achievement_GameCenter setIsEnabled:YES];
//}



-(void)closeOptionMenu:(ccTime)d{
	b_SwitchBGM.position = ccp(b_SwitchBGM.position.x + (0.9f * (360 - b_SwitchBGM.position.x))*d*10 ,b_SwitchBGM.position.y);
	b_SwitchSound.position = ccp(b_SwitchSound.position.x + (0.9f * (360 - b_SwitchSound.position.x))*d*10 ,b_SwitchSound.position.y);
	OptionSubBack.scaleX = 360 - b_SwitchBGM.position.x;
	[b_SwitchBGM setIsEnabled:NO];
	[b_SwitchSound setIsEnabled:NO];
}

//-(void)closeLeaderBoardMenu:(ccTime)d{
//	b_LeaderBoard_OpenFeint.position = ccp(b_LeaderBoard_OpenFeint.position.x,b_LeaderBoard_OpenFeint.position.y + (0.9f * (40 - b_LeaderBoard_OpenFeint.position.y))*d*10 );
//	b_LeaderBoard_GameCenter.position = ccp(b_LeaderBoard_GameCenter.position.x,b_LeaderBoard_GameCenter.position.y + (0.9f * (40 - b_LeaderBoard_GameCenter.position.y))*d*10 );
//	LeaderBoardSubBack.scaleY = b_LeaderBoard_GameCenter.position.y - 40;
//	//[(CCMenuItemImage*)[coveringLayer getChildByTag:B_OPTION] setScale:5];   
//	[b_LeaderBoard_OpenFeint setIsEnabled:NO];
//	[b_LeaderBoard_GameCenter setIsEnabled:NO];
//}
//
//-(void)closeAchievementMenu:(ccTime)d{
//	b_Achievement_OpenFeint.position = ccp(b_Achievement_OpenFeint.position.x,b_Achievement_OpenFeint.position.y + (0.9f * (40 - b_Achievement_OpenFeint.position.y))*d*10 );
//	b_Achievement_GameCenter.position = ccp(b_Achievement_GameCenter.position.x,b_Achievement_GameCenter.position.y + (0.9f * (40 - b_Achievement_GameCenter.position.y))*d*10 );
//	AchievementSubBack.scaleY = b_Achievement_GameCenter.position.y - 40;
//	//[(CCMenuItemImage*)[coveringLayer getChildByTag:B_OPTION] setScale:5];   
//	[b_Achievement_OpenFeint setIsEnabled:NO];
//	[b_Achievement_GameCenter setIsEnabled:NO];
//}

-(void)closeGameCenterView{
    UIView * topView = [[UIApplication sharedApplication] keyWindow];
    [[[topView subviews] objectAtIndex:1] removeFromSuperview];
    
//    NSLog(@"closeView");
//    NSLog(@"SubViews:%@",[[topView subviews] description]);

}


-(void)dealloc {
	
	[self unschedule:@selector(loop:)];

	[GameCenterViewCon release];
//    for (BaseCharacter * o in ShapeObjects){
//        NSLog(@"BaseCharacter RetainCount:%d",[o retainCount]);
//    }
//	[ShapeObjects removeAllObjects];
//    NSLog(@"ShapeObjects ObjCounts:%d",[ShapeObjects count]);
//	[ShapeObjects release];
    
	//[PM ExitPlayScene];
    [self removeAllChildrenWithCleanup:YES];
	[PM release];
	//[SPM release];
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    
    
    
	[super dealloc];
	
	NSLog(@"GameMainScene Dealloc");
	
}

@end
