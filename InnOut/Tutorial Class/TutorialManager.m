//
//  TutorialAndHintManager.m
//  Memory0_0
//
//  Created by JinUng Han on 11. 4. 30..
//  Copyright 2011 Student. All rights reserved.
//

#import "TutorialManager.h"
#import "ProgressManager.h"
#import "GameCondition.h"
#import "BaseCharacter.h"
#import "TextLineBriefer.h"

//if (timeCheck(i, bar_prevTime, bar_TimeCycle))NSLog(@"%f초",i);

//game_state == GAME_PAUSING
//game_state == GAME_PLAYING

//튜토리얼은 게임 시작시에 실행되어야만한다.
BOOL timeCheck (float checkTime, float prevTime, float currentTime){
	if (currentTime >= checkTime) {
		if (prevTime <= checkTime) {
			return YES;
		}
	}
	
	return NO;
}


@interface TutorialManager (privateMethods) 
-(void)initialize;
-(void)showingWindow;
-(void)closingWindow;
-(void)stopGameRun;
-(void)initText;
-(void)tutorialLoop:(ccTime)d;
-(void)onGestures:(BOOL)In_ Out:(BOOL)Out_ TutoC:(BOOL)TutoC_ Touch:(BOOL)Touch_;
-(void)offGestures;
-(void)onTouchStandbyState;
-(void)onTouchOk;
@end


@implementation TutorialManager
@synthesize refMeObjects;


#pragma mark -
#pragma mark === Initialize ===
-(id)initWithLayers:(CCLayer*)CoverLayer_ pm:(ProgressManager*)PM_ {

	if ( (self = [super init] )) {
		PM = PM_;
		CoverLayer = CoverLayer_;
		
		[CoverLayer addChild:self];
		
		
		
		[self initialize];
	}
	NSLog(@"TutorialManager Initialize");
	return self;
}


-(void)initialize {
	aniFrames = [[NSMutableArray alloc] init];
	
	CCTexture2D * aniSheet = [[CCTextureCache sharedTextureCache] addImage:@"tuto_ani_sheet192x50_f28.png"];
	CGSize oneFrameRect = CGSizeMake(192, 50);
	
	int frameCount = 0;
	
	for (int x = 0 ; x < 3; x++) {
		for (int y = 0; y < 10; y++) {
			if (frameCount < 28) {
				CCSpriteFrame * oneFrame = [CCSpriteFrame frameWithTexture:aniSheet rect:CGRectMake(oneFrameRect.width * x,
																											oneFrameRect.height * y, 
																											oneFrameRect.width, 
																											oneFrameRect.height)];
				[aniFrames addObject:oneFrame];
				frameCount++;
				
			}
		}
	}
	FPS = 24;
	elapsedTime = 0;
	currentframe = 0;
	tickElapsedTime = 0;
	
    CCSprite * tutoTable = [CCSprite spriteWithFile:@"tuto_table.png"];
    tutoTable.anchorPoint = ccp(0.5f,0);
    tutoTable.position = ccp(240,210);
    [self addChild:tutoTable];
    
	animation = [CCSprite spriteWithTexture:[(CCSpriteFrame*)[aniFrames objectAtIndex:currentframe] texture]  rect:CGRectMake(0,0,oneFrameRect.width,oneFrameRect.height)];
	[self addChild:animation];
	animation.anchorPoint = ccp(0.5f,0.0f);
	animation.position = ccp(240,220);
	animation.visible = NO;
//	
//	nearingPoint = ccp(animation.position.x-animation.contentSize.width/2 + 20,animation.position.y + 15);
//	standbyPoint = ccp(animation.position.x-animation.contentSize.width/2 + 70,animation.position.y + 15);
//	recentPass1Point = ccp(animation.position.x-animation.contentSize.width/2 + 100,animation.position.y + 15);
//	recentPass2Point = ccp(animation.position.x-animation.contentSize.width/2 + 140,animation.position.y + 15);
//	recentPass3Point = ccp(animation.position.x-animation.contentSize.width/2 + 180,animation.position.y + 15);
	
    //		CCSprite * InFollower = [CCSprite spriteWithFile:@"Image_inform_in.png"];
   
    //		CCSprite * OutFollower = [CCSprite spriteWithFile:@"Image_inform_out.png"];
    
    Ap = nil;
    Ar = nil;
    P  = nil;
    P2 = nil;
    cAp = nil;
    cAr = nil;
    cP  = nil;
    cP2 = nil;
    
    PMsShapeObject = PM.ShapeObjects;
    
    targetSelector1 = [[[ShineEffect alloc] initWithSource:@"tuto_Selector.png"] autorelease];
    [targetSelector1 setShineNum:1];
    [targetSelector1 setDuration:1];
    [targetSelector1 setDelay:0];
    [targetSelector1 setOpacityRange:0 Max:1];
    [targetSelector1 runningControll:SE_Suspend];
    targetSelector1.anchorPoint = ccp(0.5f,0);
    targetSelector1.position = ccp(213,235);
    targetSelector1.scaleX = 1.2f;
    [targetSelector1 setBlendFunc:(ccBlendFunc){GL_DST_COLOR,GL_ONE}];
    [self addChild:targetSelector1];
    
    targetSelector2 = [[[ShineEffect alloc] initWithSource:@"tuto_Selector.png"] autorelease];
    [targetSelector2 setShineNum:1];
    [targetSelector2 setDuration:1];
    [targetSelector2 setDelay:0];
    [targetSelector2 setOpacityRange:0 Max:1];
    [targetSelector2 runningControll:SE_Suspend];
    targetSelector2.anchorPoint = ccp(0.5f,0);
    targetSelector2.position = ccp(260,235);
    targetSelector2.scaleX = 1.2f;
    [targetSelector2 setBlendFunc:(ccBlendFunc){GL_DST_COLOR,GL_ONE}];
    [self addChild:targetSelector2];
    
    
    CCSprite * miniDoor = [CCSprite spriteWithFile:@"door.png"];
    miniDoor.anchorPoint = ccp(0.5f,0);
    miniDoor.position = ccp(213,225);
    miniDoor.scale = 0.4f;
    [self addChild:miniDoor];
    
    blinder = [CCSprite spriteWithFile:@"blackDot.png"];
    blinder.anchorPoint = ccp(0,0);
    blinder.scaleY = 320;
    blinder.position = ccp(0,0);
    blinder.scaleX = 0;
    blinder.opacity = 100;
    blinderTXscale = 0;
    [self addChild:blinder z:-1];
    
    refMeObjects = [[NSMutableArray alloc] init];
    
    
    dialogueWindow = [CCSprite spriteWithFile:@"tuto_dialogue_window.png"];
    dialogueWindow.anchorPoint = ccp(0.5f,0.5f);
    dialogueWindow.position = ccp(240,200);
    dialogueWindow.opacity = 0;
    dialogueWindow.scale = 0.5f;
    subDialogueWindowOpa = dialogueWindow.opacity/1;
    [self addChild:dialogueWindow];
    
    [self initText];
    step = 1;
    
    [self schedule:@selector(update:)];
    
}

-(void)initText{
    lang = [GameCondition sharedGameCondition].lang;
    
    step1_Texts = [[NSMutableArray alloc] init];
    step2_Texts = [[NSMutableArray alloc] init];
    step3_Texts = [[NSMutableArray alloc] init];
    step4_Texts = [[NSMutableArray alloc] init];
    step5_Texts = [[NSMutableArray alloc] init];
    step6_Texts = [[NSMutableArray alloc] init];
    step7_Texts = [[NSMutableArray alloc] init];
    step8_Texts = [[NSMutableArray alloc] init];
    /*KO
     1::,9.35,18.35,28.95,38.3,46.95,53.2,60.25,66.9,
     2::,9,18.75,21.5,30.9,34,44.2,52.4,61.8,64.9,74.3,84.1,93.5,96.2,105.2,115,117.35,123.6,129.1,135.75,140.05,147.45,151.8,161.15,170.95,180.35,188.55,191.3,201.45,211.25,220.25,231.6,241.75,251.15,260.55,271.5,284,294.95,304.75,328.6,338.8,350.5,359.5,370.1,382.2,391.2,401,
     3::,9,19.15,28.15,38.3,40.65,44.6,54.35,64.15,73.15,75.9,77.85,84.5,88.4,102.85,110.7,117.35,126.75,136.9,145.5,155.3,165.85,172.5,175.65,179.95,191.7,202.25,211.25,221.4,231.6,241.75,251.55,261.3,272.65,282.45,291.85,303.95,314.9,325.1,335.65,345.85,356.4,367.35,378.7,387.7,397.45,406.45,416.25,419.75,
     4::,9.75,19.15,30.9,41.05,52,62.2,71.55,81.35,91.15,102.1,112.25,121.65,131.45,140.05,149.05,158.8,162.35,
     5::,9.35,21.5,31.65,37.95,48.1,57.1,66.1,69.6,79,92.3,101.3,110.7,120.85,129.5,138.85,142.8
     6::,9,19,22.15,30.55,40.05,49.6,59.15,62.2,71.35,80.55,82.8,93.1,101.9,111.8,121,123.25,133.6,142.75,152.3,155.35,164.9,173.25,183.2,193.5,194.25,204.55,214.1,224.05,233.6,235.1,245.4,255.35,265.25,274.05,283.2,293.1,
     7::,8.75,18.7,27.85,37.8,39.7,43.9,50.75,56.5,61.45,70.2,80.15,88.9,92.75,101.5,103.05,114.9,124.05,132.8,134.35,145.8,154.55,164.5,174.05,181.3,
     8::,9.55,11.05,21.75,30.55,40.85,41.6,52.65,61.8,71.75,73.25,84.7,92.75,102.3,111.45,121.35,124.8,
     9::,9.9,18.7,28.25,38.55,40.45,50.35,59.1,60.65,71.35,81.25,90.4,99.55,101.05,111.75,121.3,132.75,136.55,146.85,157.15,165.55,169.35,171.25,181.55,190.7,200.6,204.05,212.45,223.1,224.25,234.55,245.25,252.85,255.15,265.85,275,285.3,292.15,300.55,310.05,318.85,323.4,332.2,341.75,351.25,355.1,
     10::,9.15,17.95,28.25,37.75,46.9,56.05,59.1,62.95,72.85,82.4,91.15,94.95,104.5,112.5,114.8,125.5,135.8,136.55,147.6,157.5,165.9,175.45,185.35,188.4,200.6,210.55,219.7,228.45,230.35,235.7,242.95,248.65,252.1,261.65,271.15,280.7,283.75,294.45,295.6,306.65,315.8,326.85,328,336.4,345.15,356.2,365,367.3,
     11::,9.9,11.05,23.25,30.9,41.95,43.5,53,62.55,70.95,73.6,83.9,93.85,103.35,112.5,121.65,131.2,133.1,
     12::,9.55,19.85,28.25,38.55,49.95,59.5,69.05,78.55,90.8,99.95,110.25,115.2,125.1,135,144.55,147.6,156.4,166.65,168.6,178.9,188.8,189.55,200.25,210.15,210.9,222.35,231.5,241.05,242.2,253.25,262,271.95,273.45,278.8,287.95,298.25,306.65,310.05,312.35,323.05,332.6,340.95,344.8,
     13::,8.8,18.7,27.85,39.3,40.45,50.35,59.1,61.4,70.95,80.85,91.55,100.7,101.85,112.15,121.3,131.2,133.1,142.25,153.3,164.4,174.3,183.85,185.75,196.4,204.8,214.35,216.65,226.95,237.6,248.3,257.8,267.35,268.9,279.55,288.35,290.6,300.9,310.05,318.45,328.75,332.2,
     14::,9.9,19.45,27.85,38.55,39.65,43.85,47.3,52.25,62.15,71.7,80.5,83.55,93.05,96.1,105.65,115.2,124.35,126.65,136.55,146.1,155.6,165.15,167.45,
     15::,9.9,19.45,29.35,30.5,39.65,49.95,59.9,62.15,71.7,82,91.55,100.7,109.45,119.4,123.95,
     16::,9.15,18.7,28.25,40.45,49.95,59.9,62.55,72.1,80.85,91.55,92.7,96.5,106.4,116.7,125.1,129.3,138.45,147.2,157.5,159.45,161.7,173.55,181.55,183.05,193.75,203.65,213.95,222.35,224.25,234.95,244.1,253.25,255.15,259.75,269.65,279.55,288.7,292.15,300.9,310.85,320.35,
     17::,8.8,18.7,29,37.4,39.65,50.35,61.4,71.35,80.85,83.15,92.7,103,103.75,115.2,123.95,133.85,135,145.3,156.4,165.15,174.3,183.45,192.25,196.05,205.55,214.75,224.65,233.05,233.8,239.9,242.55,248.3,257.05,267,276.9,279.55,289.5,290.6,301.7,311.2,320.75,322.3,332.95,342.1,351.65,360.05,366.9,
     18::,9.15,19.1,28.25,38.9,40.8,50.75,52.65,61.4,71.7,73.6,85.05,93.85,103.35,111.75,122.05,125.5,
     19::,8.8,19.1,27.45,30.15,40.45,50.35,59.5,69.8,70.95,80.5,91.55,99.95,103,112.9,122.05,131.2,140.75,149.9,152.95,
     20::,9.9,19.1,29,31.65,40.45,50.35,60.25,62.15,71.35,83.15,83.55,92.7,102.6,112.5,115.95,124.7,133.85,137.3,147.2,148.35,159.05,167.05,180,191.1,199.85,209,220.45,221.95,231.15,233.05,243.7,253.25,254.75,265.05,274.6,284.15,293.7,302.45,305.1,314.25,325.35,336.4,346.3,355.45,358.15,367.65,369.55,379.85,389.4,398.55,
     21::,10.3,11.85,22.9,31.65,35.1,44.25,52.65,61.8,64.85,74,84.3,93.05,94.95,104.9,115.2,124.35,133.85,136.15,146.1,156.4,165.15,174.3,183.45,189.15,
     22::,10.3,19.1,28.25,30.15,39.65,50.35,51.9,61.4,71.35,79.7,82.75,93.05,102.6,112.15,120.9,131.95,134.25,143.8,152.2,162.1,170.85,172,183.45,193.35,202.15,204.05,215.5,224.25,233.8,235.7,245.6,255.9,263.95,265.45,276.9,278.4,289.85,298.65,307,309.3,320.35,329.55,338.3,349,350.9,
     23::,5.35,13.75,18.3,25.2,30.5,33.95,40.8,48.05,51.5,56.05,63.7,71.35,77.8,82,84.65,95.75,104.15,115.55,126.65,138.05,
     24::,9.15,19.1,27.85,38.15,47.3,48.45,59.1,69.4,78.2,87.75,91.15,94.2,101.05,110.25,119.75,129.3,132.75,141.9,147.6,153.7,164,173.9,175.05,186.1,194.9,204.05,213.6,216.65
     25::9.4,11.55,21,30.85,41.15,43.3,53.15,61.75,72.05,73.75,84.05,93.9,94.75,104.6,114.9,124.75,133.35,141.95,144.5,149.2,156.1,165.1,175.8,185.25,188.65,198.1,210.95,219.95,229,231.1,241.85,251.7,261.15,270.15,272.7,282.15,290.7,300.6,303.6,313,322.9,332.75,341.35,349.9,354.2,358.05,372.2,359.35,375.2
*/
    /*EN
     1::,30.75,42.55,69.35,92.6,
     2::,40.2,91,115.05,126.85,149.35,167.85,198.6,218.7,252.95,303.8,322.3,355.8,390.05,401.9,421.2,
     3::,31.5,63.45,84.7,128.05,154.85,178.1,212,249.8,275.8,321.5,330.2,353.05,370.75,399.9,
     4::,35.05,41.35,50.85,93.8,105.2,127.65,145,189.15,219.45,282.1,288.4,291.95,294.7,295.1,
     5::,60.3,74.85,101.65,120.55,162.75,182.8,210.4,242.7,274.65,287.25,296.3,308.5,
     6::,35.85,74.1,84.3,107.15,145,150.1,150.9,157.2,158.4,
     7::,29.55,61.45,106.4,116.25,155.65,164.7,165.1,165.1,
     8::,31.5,52.4,81.95,91,132.8,143.8,193.85,221.85,248.6,258.1,272.25,303.4,338.85,368.4,392.85,417.25,
     9::,35.05,67,95.35,160.35,183.2,189.5,207.65,
     10::,23.25,63.45,91.4,100.1,140.25,145.8,145.8,156.4,
     11::,27.2,56.35,91.4,111.5,153.25,173.35,195.05,241.9,261.25,292.35,311.25,345.55,369.2,380.6,433.8,
     12::,15.75,26,68.95,100.1,120.95,164.7,199,232.85,260.45,292.75,322.3,392.45,396,398.35,412.55,
     13::,25.6,51.2,80.4,91,125.7,138.3,139.1,153.25,175.75,183.6,
     14::,27.6,59.1,90.6,110.7,153.25,173.75,193.45,239.95,262,279.35,309.3,328.2,363.65,390.45,397.15,399.9,408.6,427.1,
     15::,17.75,63.85,85.5,107.95,126.85,156.8,190.3,221.45,230.9,258.1,271.1,290,317.95,352.65,379.85,406.25,414.1,414.9,420.4,422,
     16::,39,68.15,123.7,127.25,136.7,137.5,144.6,145,
     17::,26,52.8,83.15,92.6,128.45,131.2,131.2,138.7,138.7,139.5,
     18::,27.2,57.55,92.2,115.45,125.3,171,191.9,209.6,240.35,273.05,305.35,326.25,372.35,375.9,375.9,378.65,381,
     19::,30.35,65,81.95,109.15,139.9,167.45,186.35,211.6,213.15,214.75,243.9,275.4,303.8,359.75,363.3,376.3,369.2,
     20::,28,41.75,67.75,97.7,120.55,143.05,153.25,170.6,196.6,221.85,234.05,255.7,285.25,286.05,286.45,287.25,288,
     21::,22.45,56.35,102.05,122.15,152.9,164.7,211.2,247.45,292.35,314.05,347.5,364.85,401.9,434.6,437.35,437.35,
     22::,16.15,35.45,54.75,90.25,108.35,144.2,165.9,183.6,206.05,219.05,243.5,274.25,350.3,390.85,392.85,393.2,
     23::,39.8,72.9,119,132,149.75,173.75,192.3,234.45,248.6,275.8,317.55,317.95,317.95,317.95,
     24::,39.8,80.75,113.1,162.75,166.25,166.25,166.25,166.65,
     25::,16.15,35.45,60.3,72.5,100.45,118.2,154.05,189.15,217.1,271.1,271.5,272.65,276.2,285.65,289.6,290.4
     */
    
    if (lang == Language_ko) {
        
        //Step1 initialize
        TextLineBriefer * step1_1 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_1-1.png" Map:@"9.35,18.35,28.95,38.3,46.95,53.2,60.25,66.9,73" ProSpeed:0.1f] autorelease];
        step1_1.anchorPoint = ccp(0,0);
        step1_1.position = ccp(30,192);
        [step1_1 run];
        TextLineBriefer * step1_2 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_1-2.png" Map:@"9,18.75,21.5,30.9,34,44.2,52.4,61.8,64.9,74.3,84.1,93.5,96.2,105.2,115,117.35,123.6,129.1,135.75,140.05,147.45,151.8,161.15,170.95,180.35,188.55,191.3,201.45,211.25,220.25,231.6,241.75,251.15,260.55,271.5,284,294.95,304.75,328.6,338.8,350.5,359.5,370.1,382.2,391.2,401," ProSpeed:0.1f] autorelease];
        step1_2.anchorPoint = ccp(0,0);
        step1_2.position = ccp(25,177);
        TextLineBriefer * step1_3 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_1-3.png" Map:@"9,19.15,28.15,38.3,40.65,44.6,54.35,64.15,73.15,75.9,77.85,84.5,88.4,102.85,110.7,117.35,126.75,136.9,145.5,155.3,165.85,172.5,175.65,179.95,191.7,202.25,211.25,221.4,231.6,241.75,251.55,261.3,272.65,282.45,291.85,303.95,314.9,325.1,335.65,345.85,356.4,367.35,378.7,387.7,397.45,406.45,416.25,419.7,425," ProSpeed:0.1f] autorelease];
        step1_3.anchorPoint = ccp(0,0);
        step1_3.position = ccp(25,162);
        
        //Step1 Add
        [step1_Texts addObject:step1_1];
        [self addChild:step1_1];
        [step1_Texts addObject:step1_2];
        [self addChild:step1_2];
        [step1_Texts addObject:step1_3];
        [self addChild:step1_3];
        
        
        //-----
        //Step2 initialize
        TextLineBriefer * step2_1 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_2-1.png" Map:@"9.75,19.15,30.9,41.05,52,62.2,71.55,81.35,91.15,102.1,112.25,121.65,131.45,140.05,149.05,158.8,162.35," ProSpeed:0.1f] autorelease];
        step2_1.anchorPoint = ccp(0.5f,0);
        step2_1.position = ccp(240,177);
        [step2_1 run];
        
        //Step2 Add
        [step2_Texts addObject:step2_1];
        [self addChild:step2_1];
        
        
        
        //-----
        //Step3 initialize
        TextLineBriefer * step3_1 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_3-1.png" Map:@"9.35,21.5,31.65,37.95,48.1,57.1,66.1,69.6,79,92.3,101.3,110.7,120.85,129.5,138.85,142.8,145" ProSpeed:0.1f] autorelease];
        step3_1.anchorPoint = ccp(0,0);
        step3_1.position = ccp(25,192);
        [step3_1 run];
        
        TextLineBriefer * step3_2 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_3-2.png" Map:@"9,19,22.15,30.55,40.05,49.6,59.15,62.2,71.35,80.55,82.8,93.1,101.9,111.8,121,123.25,133.6,142.75,152.3,155.35,164.9,173.25,183.2,193.5,194.25,204.55,214.1,224.05,233.6,235.1,245.4,255.35,265.25,274.05,283.2,293.1,300" ProSpeed:0.1f] autorelease];
        step3_2.anchorPoint = ccp(0,0);
        step3_2.position = ccp(25,177);
        
        TextLineBriefer * step3_3 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_3-3.png" Map:@"8.75,18.7,27.85,37.8,39.7,43.9,50.75,56.5,61.45,70.2,80.15,88.9,92.75,101.5,103.05,114.9,124.05,132.8,134.35,145.8,154.55,164.5,174.05,181.3,189" ProSpeed:0.1f] autorelease];
        step3_3.anchorPoint = ccp(0,0);
        step3_3.position = ccp(25,162);
        
        //Step3 Add
        [step3_Texts addObject:step3_1];
        [self addChild:step3_1];
        [step3_Texts addObject:step3_2];
        [self addChild:step3_2];
        [step3_Texts addObject:step3_3];
        [self addChild:step3_3];
        
        
        //-----
        //Step4 initialize
        TextLineBriefer * step4_1 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_4-1.png" Map:@"9.55,11.05,21.75,30.55,40.85,41.6,52.65,61.8,71.75,73.25,84.7,92.75,102.3,111.45,121.35,124.8,129" ProSpeed:0.1f] autorelease];
        step4_1.anchorPoint = ccp(0,0);
        step4_1.position = ccp(25,192);
        [step4_1 run];
        TextLineBriefer * step4_2 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_4-2.png" Map:@"9.9,18.7,28.25,38.55,40.45,50.35,59.1,60.65,71.35,81.25,90.4,99.55,101.05,111.75,121.3,132.75,136.55,146.85,157.15,165.55,169.35,171.25,181.55,190.7,200.6,204.05,212.45,223.1,224.25,234.55,245.25,252.85,255.15,265.85,275,285.3,292.15,300.55,310.05,318.85,323.4,332.2,341.75,351.25,355.1,360" ProSpeed:0.1f] autorelease];
        step4_2.anchorPoint = ccp(0,0);
        step4_2.position = ccp(25,177);

        TextLineBriefer * step4_3 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_4-3.png" Map:@"9.15,17.95,28.25,37.75,46.9,56.05,59.1,62.95,72.85,82.4,91.15,94.95,104.5,112.5,114.8,125.5,135.8,136.55,147.6,157.5,165.9,175.45,185.35,188.4,200.6,210.55,219.7,228.45,230.35,235.7,242.95,248.65,252.1,261.65,271.15,280.7,283.75,294.45,295.6,306.65,315.8,326.85,328,336.4,345.15,356.2,365,367.3,380" ProSpeed:0.1f] autorelease];
        step4_3.anchorPoint = ccp(0,0);
        step4_3.position = ccp(25,162);

        //Step4 Add
        [step4_Texts addObject:step4_1];
        [self addChild:step4_1];
        [step4_Texts addObject:step4_2];
        [self addChild:step4_2];
        [step4_Texts addObject:step4_3];
        [self addChild:step4_3];
        
        
        
        //-----
        //Step5 initialize
        TextLineBriefer * step5_1 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_5-1.png" Map:@"9.9,11.05,23.25,30.9,41.95,43.5,53,62.55,70.95,73.6,83.9,93.85,103.35,112.5,121.65,131.2,133.1,140" ProSpeed:0.1f] autorelease];
        step5_1.anchorPoint = ccp(0,0);
        step5_1.position = ccp(25,192);
        [step5_1 run];
        TextLineBriefer * step5_2 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_5-2.png" Map:@"9.55,19.85,28.25,38.55,49.95,59.5,69.05,78.55,90.8,99.95,110.25,115.2,125.1,135,144.55,147.6,156.4,166.65,168.6,178.9,188.8,189.55,200.25,210.15,210.9,222.35,231.5,241.05,242.2,253.25,262,271.95,273.45,278.8,287.95,298.25,306.65,310.05,312.35,323.05,332.6,340.95,344.8,350" ProSpeed:0.1f] autorelease];
        step5_2.anchorPoint = ccp(0,0);
        step5_2.position = ccp(25,177);
        
        TextLineBriefer * step5_3 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_5-3.png" Map:@"8.8,18.7,27.85,39.3,40.45,50.35,59.1,61.4,70.95,80.85,91.55,100.7,101.85,112.15,121.3,131.2,133.1,142.25,153.3,164.4,174.3,183.85,185.75,196.4,204.8,214.35,216.65,226.95,237.6,248.3,257.8,267.35,268.9,279.55,288.35,290.6,300.9,310.05,318.45,328.75,332.2,340" ProSpeed:0.1f] autorelease];
        step5_3.anchorPoint = ccp(0,0);
        step5_3.position = ccp(25,162);
        
        TextLineBriefer * step5_4 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_5-4.png" Map:@"9.9,19.45,27.85,38.55,39.65,43.85,47.3,52.25,62.15,71.7,80.5,83.55,93.05,96.1,105.65,115.2,124.35,126.65,136.55,146.1,155.6,165.15,167.45,175" ProSpeed:0.1f] autorelease];
        step5_4.anchorPoint = ccp(0,0);
        step5_4.position = ccp(25,177);
        
        //Step5 Add
        [step5_Texts addObject:step5_1];
        [self addChild:step5_1];
        [step5_Texts addObject:step5_2];
        [self addChild:step5_2];
        [step5_Texts addObject:step5_3];
        [self addChild:step5_3];
        [step5_Texts addObject:step5_4];
        [self addChild:step5_4];
        
        //-----
        //Step6 initialize
        TextLineBriefer * step6_1 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_6-1.png" Map:@"9.9,19.45,29.35,30.5,39.65,49.95,59.9,62.15,71.7,82,91.55,100.7,109.45,119.4,123.95,129" ProSpeed:0.1f] autorelease];
        step6_1.anchorPoint = ccp(0,0);
        step6_1.position = ccp(25,192);
        [step6_1 run];
        TextLineBriefer * step6_2 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_6-2.png" Map:@"9.15,18.7,28.25,40.45,49.95,59.9,62.55,72.1,80.85,91.55,92.7,96.5,106.4,116.7,125.1,129.3,138.45,147.2,157.5,159.45,161.7,173.55,181.55,183.05,193.75,203.65,213.95,222.35,224.25,234.95,244.1,253.25,255.15,259.75,269.65,279.55,288.7,292.15,300.9,310.85,320.35,325,329" ProSpeed:0.1f] autorelease];
        step6_2.anchorPoint = ccp(0,0);
        step6_2.position = ccp(25,177);
        
        TextLineBriefer * step6_3 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_6-3.png" Map:@"8.8,18.7,29,37.4,39.65,50.35,61.4,71.35,80.85,83.15,92.7,103,103.75,115.2,123.95,133.85,135,145.3,156.4,165.15,174.3,183.45,192.25,196.05,205.55,214.75,224.65,233.05,233.8,239.9,242.55,248.3,257.05,267,276.9,279.55,289.5,290.6,301.7,311.2,320.75,322.3,332.95,342.1,351.65,360.05,366.9,370" ProSpeed:0.1f] autorelease];
        step6_3.anchorPoint = ccp(0,0);
        step6_3.position = ccp(25,162);
        
        //Step6 Add
        [step6_Texts addObject:step6_1];
        [self addChild:step6_1];
        [step6_Texts addObject:step6_2];
        [self addChild:step6_2];
        [step6_Texts addObject:step6_3];
        [self addChild:step6_3];
        
        //-----
        //Step7 initialize
        TextLineBriefer * step7_1 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_7-1.png" Map:@"9.15,19.1,28.25,38.9,40.8,50.75,52.65,61.4,71.7,73.6,85.05,93.85,103.35,111.75,122.05,125.5,130" ProSpeed:0.1f] autorelease];
        step7_1.anchorPoint = ccp(0.5f,0);
        step7_1.position = ccp(240,192);
        [step7_1 run];
        TextLineBriefer * step7_2 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_7-2.png" Map:@"8.8,19.1,27.45,30.15,40.45,50.35,59.5,69.8,70.95,80.5,91.55,99.95,103,112.9,122.05,131.2,140.75,149.9,152.95,160" ProSpeed:0.1f] autorelease];
        step7_2.anchorPoint = ccp(0,0);
        step7_2.position = ccp(25,177);
 
        TextLineBriefer * step7_3 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_7-3.png" Map:@"9.9,19.1,29,31.65,40.45,50.35,60.25,62.15,71.35,83.15,83.55,92.7,102.6,112.5,115.95,124.7,133.85,137.3,147.2,148.35,159.05,167.05,180,191.1,199.85,209,220.45,221.95,231.15,233.05,243.7,253.25,254.75,265.05,274.6,284.15,293.7,302.45,305.1,314.25,325.35,336.4,346.3,355.45,358.15,367.65,369.55,379.85,389.4,398.55,398.55,398.55,398.55,398.55,398.55,398.55,398.55,398.55,398.55,398.55,398.55,398.55,398.55" ProSpeed:0.1f] autorelease];
        step7_3.anchorPoint = ccp(0,0);
        step7_3.position = ccp(25,162);

        TextLineBriefer * step7_4 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_7-4.png" Map:@"10.3,11.85,22.9,31.65,35.1,44.25,52.65,61.8,64.85,74,84.3,93.05,94.95,104.9,115.2,124.35,133.85,136.15,146.1,156.4,165.15,174.3,183.45,189.15,199" ProSpeed:0.1f] autorelease];
        step7_4.anchorPoint = ccp(0,0);
        step7_4.position = ccp(25,192);

        TextLineBriefer * step7_5 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_7-5.png" Map:@"10.3,19.1,28.25,30.15,39.65,50.35,51.9,61.4,71.35,79.7,82.75,93.05,102.6,112.15,120.9,131.95,134.25,143.8,152.2,162.1,170.85,172,183.45,193.35,202.15,204.05,215.5,224.25,233.8,235.7,245.6,255.9,263.95,265.45,276.9,278.4,289.85,298.65,307,309.3,320.35,329.55,338.3,349,350.9,360" ProSpeed:0.1f] autorelease];
        step7_5.anchorPoint = ccp(0,0);
        step7_5.position = ccp(25,177);
    
        TextLineBriefer * step7_6 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_7-6.png" Map:@"5.35,13.75,18.3,25.2,30.5,33.95,40.8,48.05,51.5,56.05,63.7,71.35,77.8,82,84.65,95.75,104.15,115.55,126.65,138.05," ProSpeed:0.1f] autorelease];
        step7_6.anchorPoint = ccp(0.5f,0);
        step7_6.position = ccp(240,162);

        
        //Step7 Add
        [step7_Texts addObject:step7_1];
        [self addChild:step7_1];
        [step7_Texts addObject:step7_2];
        [self addChild:step7_2];
        [step7_Texts addObject:step7_3];
        [self addChild:step7_3];
        [step7_Texts addObject:step7_4];
        [self addChild:step7_4];
        [step7_Texts addObject:step7_5];
        [self addChild:step7_5];
        //[step7_Texts addObject:step7_6];
        //[self addChild:step7_6];
        
        //-----
        //Step8 initialize
        TextLineBriefer * step8_1 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_8-1.png" Map:@"9.15,19.1,27.85,38.15,47.3,48.45,59.1,69.4,78.2,87.75,91.15,94.2,101.05,110.25,119.75,129.3,132.75,141.9,147.6,153.7,164,173.9,175.05,186.1,194.9,204.05,213.6,216.65" ProSpeed:0.1f] autorelease];
        step8_1.anchorPoint = ccp(0.5f,0);
        step8_1.position = ccp(240,185);
        [step8_1 run];
        
        TextLineBriefer * step8_2 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_ko_d_8-2.png" Map:@"9.4,11.55,21,30.85,41.15,43.3,53.15,61.75,72.05,73.75,84.05,93.9,94.75,104.6,114.9,124.75,133.35,141.95,144.5,149.2,156.1,165.1,175.8,185.25,188.65,198.1,210.95,219.95,229,231.1,241.85,251.7,261.15,270.15,272.7,282.15,290.7,300.6,303.6,313,322.9,332.75,341.35,349.9,354.2,358.05,372.2,359.35,375.2" ProSpeed:0.1f] autorelease];
        step8_2.anchorPoint = ccp(0.5f,0);
        step8_2.position = ccp(240,170);

        //Step8 Add
        [step8_Texts addObject:step8_1];
        [self addChild:step8_1];
        [step8_Texts addObject:step8_2];
        [self addChild:step8_2];
    }else if(lang == Language_en){
        //Step1 initialize
        TextLineBriefer * step1_1 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_1-1.png" Map:@"30.75,42.55,69.35,92.6,92.6,92.6,92.6" ProSpeed:0.1f] autorelease];
        step1_1.anchorPoint = ccp(0,0);
        step1_1.position = ccp(30,192);
        [step1_1 run];
        
        TextLineBriefer * step1_2 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_1-2.png" Map:@"40.2,91,115.05,126.85,149.35,167.85,198.6,218.7,252.95,303.8,322.3,355.8,390.05,401.9,421.2,421.2,421.2,421.2" ProSpeed:0.15f] autorelease];
        step1_2.anchorPoint = ccp(0,0);
        step1_2.position = ccp(30,177);
        
        TextLineBriefer * step1_3 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_1-3.png" Map:@"31.5,63.45,84.7,128.05,154.85,178.1,212,249.8,275.8,321.5,330.2,353.05,370.75,399.9,399.9,399.9,399.9,399.9,399.9,399.9,399.9,399.9,399.9,399.9,399.9,399.9,399.9,399.9" ProSpeed:0.15f] autorelease];
        step1_3.anchorPoint = ccp(0,0);
        step1_3.position = ccp(30,162);
        
        TextLineBriefer * step1_4 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_1-4.png" Map:@"35.05,41.35,50.85,93.8,105.2,127.65,145,189.15,219.45,282.1,288.4,291.95,294.7,295.1,295.1,295.1" ProSpeed:0.15f] autorelease];
        step1_4.anchorPoint = ccp(0,0);
        step1_4.position = ccp(30,192);
        
        TextLineBriefer * step1_5 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_1-5.png" Map:@"60.3,74.85,101.65,120.55,162.75,182.8,210.4,242.7,274.65,287.25,296.3,308.5,308.5,308.5,308.5" ProSpeed:0.15f] autorelease];
        step1_5.anchorPoint = ccp(0,0);
        step1_5.position = ccp(30,177);
        
        //Step1 Add
        [step1_Texts addObject:step1_1];
        [self addChild:step1_1];
        [step1_Texts addObject:step1_2];
        [self addChild:step1_2];
        [step1_Texts addObject:step1_3];
        [self addChild:step1_3];
        [step1_Texts addObject:step1_4];
        [self addChild:step1_4];
        [step1_Texts addObject:step1_5];
        [self addChild:step1_5];
        
        //-----
        //Step2 initialize
        TextLineBriefer * step2_1 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_2-1.png" Map:@"35.85,74.1,84.3,107.15,145,150.1,150.9,157.2,158.4,158.4,158.4" ProSpeed:0.15f] autorelease];
        step2_1.anchorPoint = ccp(0.5f,0);
        step2_1.position = ccp(240,177);
        [step2_1 run];
        
        //Step2 Add
        [step2_Texts addObject:step2_1];
        [self addChild:step2_1];
        
        
        
        //-----
        //Step3 initialize
        TextLineBriefer * step3_1 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_3-1.png" Map:@"29.55,61.45,106.4,116.25,155.65,164.7,165.1,165.1,165.1,165.1,165.1" ProSpeed:0.15f] autorelease];
        step3_1.anchorPoint = ccp(0,0);
        step3_1.position = ccp(25,192);
        [step3_1 run];
        
        TextLineBriefer * step3_2 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_3-2.png" Map:@"31.5,52.4,81.95,91,132.8,143.8,193.85,221.85,248.6,258.1,272.25,303.4,338.85,368.4,392.85,417.25,417.25,417.25,417.25" ProSpeed:0.15f] autorelease];
        step3_2.anchorPoint = ccp(0,0);
        step3_2.position = ccp(25,177);
        
        TextLineBriefer * step3_3 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_3-3.png" Map:@"35.05,67,95.35,160.35,183.2,189.5,207.65,207.65,207.65,207.65" ProSpeed:0.15f] autorelease];
        step3_3.anchorPoint = ccp(0,0);
        step3_3.position = ccp(25,162);
        
        //Step3 Add
        [step3_Texts addObject:step3_1];
        [self addChild:step3_1];
        [step3_Texts addObject:step3_2];
        [self addChild:step3_2];
        [step3_Texts addObject:step3_3];
        [self addChild:step3_3];
        
        
        //-----
        //Step4 initialize
        TextLineBriefer * step4_1 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_4-1.png" Map:@"23.25,63.45,91.4,100.1,140.25,145.8,145.8,156.4,156.4,156.4" ProSpeed:0.15f] autorelease];
        step4_1.anchorPoint = ccp(0,0);
        step4_1.position = ccp(25,192);
        [step4_1 run];
        TextLineBriefer * step4_2 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_4-2.png" Map:@"27.2,56.35,91.4,111.5,153.25,173.35,195.05,241.9,261.25,292.35,311.25,345.55,369.2,380.6,433.8,433.8,433.8,433.8" ProSpeed:0.15f] autorelease];
        step4_2.anchorPoint = ccp(0,0);
        step4_2.position = ccp(25,177);
        
        TextLineBriefer * step4_3 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_4-3.png" Map:@"15.75,26,68.95,100.1,120.95,164.7,199,232.85,260.45,292.75,322.3,392.45,396,398.35,412.55,412.55,412.55,412.55" ProSpeed:0.15f] autorelease];
        step4_3.anchorPoint = ccp(0,0);
        step4_3.position = ccp(25,162);
        
        //Step4 Add
        [step4_Texts addObject:step4_1];
        [self addChild:step4_1];
        [step4_Texts addObject:step4_2];
        [self addChild:step4_2];
        [step4_Texts addObject:step4_3];
        [self addChild:step4_3];
        
        
        
        //-----
        //Step5 initialize
        TextLineBriefer * step5_1 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_5-1.png" Map:@"25.6,51.2,80.4,91,125.7,138.3,139.1,153.25,175.75,183.6,183.6,183.6,183.6" ProSpeed:0.15f] autorelease];
        step5_1.anchorPoint = ccp(0,0);
        step5_1.position = ccp(25,192);
        [step5_1 run];
        TextLineBriefer * step5_2 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_5-2.png" Map:@"27.6,59.1,90.6,110.7,153.25,173.75,193.45,239.95,262,279.35,309.3,328.2,363.65,390.45,397.15,399.9,408.6,427.1,427.1,427.1,427.1" ProSpeed:0.15f] autorelease];
        step5_2.anchorPoint = ccp(0,0);
        step5_2.position = ccp(25,177);
        
        TextLineBriefer * step5_3 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_5-3.png" Map:@"17.75,63.85,85.5,107.95,126.85,156.8,190.3,221.45,230.9,258.1,271.1,290,317.95,352.65,379.85,406.25,414.1,414.9,420.4,422,422,422,422" ProSpeed:0.15f] autorelease];
        step5_3.anchorPoint = ccp(0,0);
        step5_3.position = ccp(25,162);
        
        TextLineBriefer * step5_4 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_5-4.png" Map:@"39,68.15,123.7,127.25,136.7,137.5,144.6,145,145,145,145" ProSpeed:0.15f] autorelease];
        step5_4.anchorPoint = ccp(0,0);
        step5_4.position = ccp(25,177);
        
        //Step5 Add
        [step5_Texts addObject:step5_1];
        [self addChild:step5_1];
        [step5_Texts addObject:step5_2];
        [self addChild:step5_2];
        [step5_Texts addObject:step5_3];
        [self addChild:step5_3];
        [step5_Texts addObject:step5_4];
        [self addChild:step5_4];
        
        //-----
        //Step6 initialize
        TextLineBriefer * step6_1 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_6-1.png" Map:@"26,52.8,83.15,92.6,128.45,131.2,131.2,138.7,138.7,139.5,139.5,139.5,139.5" ProSpeed:0.15f] autorelease];
        step6_1.anchorPoint = ccp(0,0);
        step6_1.position = ccp(25,192);
        [step6_1 run];
        TextLineBriefer * step6_2 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_6-2.png" Map:@"27.2,57.55,92.2,115.45,125.3,171,191.9,209.6,240.35,273.05,305.35,326.25,372.35,375.9,375.9,378.65,381,381,381,381" ProSpeed:0.15f] autorelease];
        step6_2.anchorPoint = ccp(0,0);
        step6_2.position = ccp(25,177);
        
        TextLineBriefer * step6_3 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_6-3.png" Map:@"28,41.75,67.75,97.7,120.55,143.05,153.25,170.6,196.6,221.85,234.05,255.7,285.25,286.05,286.45,287.25,300,300,300,300" ProSpeed:0.15f] autorelease];
        step6_3.anchorPoint = ccp(0,0);
        step6_3.position = ccp(25,162);
        
        //Step6 Add
        [step6_Texts addObject:step6_1];
        [self addChild:step6_1];
        [step6_Texts addObject:step6_2];
        [self addChild:step6_2];
        [step6_Texts addObject:step6_3];
        [self addChild:step6_3];
        
        //-----
        //Step7 initialize
        TextLineBriefer * step7_1 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_7-1.png" Map:@"28,41.75,67.75,97.7,120.55,143.05,153.25,170.6,196.6,221.85,234.05,255.7,285.25,286.05,286.45,287.25,288,288,288,288,288" ProSpeed:0.15f] autorelease];
        step7_1.anchorPoint = ccp(0.5f,0);
        step7_1.position = ccp(240,192);
        [step7_1 run];
        TextLineBriefer * step7_2 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_7-2.png" Map:@"22.45,56.35,102.05,122.15,152.9,164.7,211.2,247.45,292.35,314.05,347.5,364.85,401.9,434.6,437.35,437.35,437.35,437.35,437.35" ProSpeed:0.15f] autorelease];
        step7_2.anchorPoint = ccp(0,0);
        step7_2.position = ccp(25,177);
        
        TextLineBriefer * step7_3 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_7-3.png" Map:@"16.15,35.45,54.75,90.25,108.35,144.2,165.9,183.6,206.05,219.05,243.5,274.25,350.3,390.85,392.85,393.2,393.2,393.2,393.2" ProSpeed:0.15f] autorelease];
        step7_3.anchorPoint = ccp(0,0);
        step7_3.position = ccp(25,162);
        
        TextLineBriefer * step7_4 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_7-4.png" Map:@"39.8,72.9,119,132,149.75,173.75,192.3,234.45,248.6,275.8,317.55,317.95,317.95,317.95,317.95,317.95,317.95" ProSpeed:0.15f] autorelease];
        step7_4.anchorPoint = ccp(0,0);
        step7_4.position = ccp(25,192);
        
        TextLineBriefer * step7_5 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_7-5.png" Map:@"39.8,80.75,113.1,162.75,166.25,166.25,166.25,166.65,166.65,166.65,166.65" ProSpeed:0.15f] autorelease];
        step7_5.anchorPoint = ccp(0,0);
        step7_5.position = ccp(25,177);
        
        //Step7 Add
        [step7_Texts addObject:step7_1];
        [self addChild:step7_1];
        [step7_Texts addObject:step7_2];
        [self addChild:step7_2];
        [step7_Texts addObject:step7_3];
        [self addChild:step7_3];
        [step7_Texts addObject:step7_4];
        [self addChild:step7_4];
        //[step7_Texts addObject:step7_5];
        //[self addChild:step7_5];
        
        //-----
        //Step8 initialize
        TextLineBriefer * step8_1 = [[[TextLineBriefer alloc] initWithLineText:@"tuto_en_d_8-1.png" Map:@"16.15,35.45,60.3,72.5,100.45,118.2,154.05,189.15,217.1,271.1,271.5,272.65,276.2,285.65,289.6,290.4,290.4,290.4,290.4" ProSpeed:0.15f] autorelease];
        step8_1.anchorPoint = ccp(0.5f,0);
        step8_1.position = ccp(240,177);
        [step8_1 run];
        
        [step8_Texts addObject:step8_1];
        [self addChild:step8_1];
    }
    
    gestureGuideOut = [[[ShineEffect alloc] initWithSource:@"Image_inform_out.png"] autorelease];
    gestureGuideOut.anchorPoint = ccp(0,0);
    gestureGuideOut.position = ccp(10,10);
    gestureGuideOut.opacity = 0;
    [gestureGuideOut setOpacityRange:0 Max:1];
    [gestureGuideOut setShineNum:1];
    [gestureGuideOut setDuration:2];
    [gestureGuideOut setDelay:0];
    [gestureGuideOut runningControll:SE_Suspend];
    [self addChild:gestureGuideOut];
    
    gestureGuideIn = [[[ShineEffect alloc] initWithSource:@"Image_inform_in.png"] autorelease];
    gestureGuideIn.anchorPoint = ccp(1,0);
    gestureGuideIn.position = ccp(470,10);
    gestureGuideIn.opacity = 0;
    [gestureGuideIn setBeginDelay:0.5f];
    [gestureGuideIn setOpacityRange:0 Max:1];
    [gestureGuideIn setShineNum:1];
    [gestureGuideIn setDuration:2];
    [gestureGuideIn setDelay:0];
    [gestureGuideIn runningControll:SE_Suspend];
    [self addChild:gestureGuideIn];
    
    gestureGuideTutoClose = [[[ShineEffect alloc] initWithSource:@"tuto_v_gesture.png"] autorelease];
    gestureGuideTutoClose.anchorPoint = ccp(0.5f,0);
    gestureGuideTutoClose.position = ccp(240,30);
    gestureGuideTutoClose.opacity = 0;
    [gestureGuideTutoClose setOpacityRange:0 Max:1];
    [gestureGuideTutoClose setShineNum:1];
    [gestureGuideTutoClose setDuration:2];
    [gestureGuideTutoClose setDelay:0];
    [gestureGuideTutoClose runningControll:SE_Suspend];
    [self addChild:gestureGuideTutoClose];
    
    gestureGuideTouch = [[[ShineEffect alloc] initWithSource:@"tuto_touch_gesture.png"] autorelease];
    gestureGuideTouch.anchorPoint = ccp(0.5f,0);
    gestureGuideTouch.position = ccp(240,30);
    gestureGuideTouch.opacity = 0;
    [gestureGuideTouch setOpacityRange:0 Max:1];
    [gestureGuideTouch setShineNum:1];
    [gestureGuideTouch setDuration:1];
    [gestureGuideTouch setDelay:0];
    [gestureGuideTouch runningControll:SE_Suspend];
    [self addChild:gestureGuideTouch];
    
}


#pragma mark -
#pragma mark === Update ===
-(void)update:(ccTime)dt {
 
	if (PM.game_state == GAME_PAUSING) {
        return;
    }
    
    
	if (run) {
		elapsedTime += dt;
		tickElapsedTime += dt;
	
		BOOL frameChange = NO;
		if ( (1.0f/FPS) <= tickElapsedTime) {
			currentframe++;
			tickElapsedTime -= (1.0f/FPS);
			frameChange = YES;
		}
	 
		if (frameChange) {
			aniframe ++;
			if (aniframe > 27) {
				aniframe = 0;
			}
			[animation setTextureRect:[(CCSpriteFrame*)[aniFrames objectAtIndex:aniframe] rect]];
		} //뒷판 애니메이션
		

			
        if ([PMsShapeObject count] > 0) { //Ap에 캐릭터 넣는과정
            if (Ap == nil) {
                
                Ap = [PMsShapeObject objectAtIndex:0];
                

                if (Ap == Ar) {
                    //NSLog(@"같다고 씌발");
                }
                [Ap setTutorialManager:self];
                [refMeObjects addObject:Ap];
                
                //비주얼부분
                cAp = [[[BaseCharacter alloc] initWithShape:[Ap characterCode]] autorelease];
                cAp.position = ccp(0,250);
                cAp.anchorPoint = ccp(0.5f,0);
                
                cApSubOpacity = 0;
                cAp.opacity = cApSubOpacity;
                //캐릭터 크기별 스케일 고정 코드 넣기
                cAp.scale = 0.3f;
                
                [self addChild:cAp];
                //NSLog(@"add");
            }
        }	

        //각 슬롯에 맞게 캐릭터 움직임
		if (cAp != nil) {
            cAp.position = ccp(0,240);
            cApSubOpacity += (0.95f * (255 - cApSubOpacity));
            cAp.opacity = cApSubOpacity;
        }
        if (cAr != nil) {
            cAr.position = ccp(cAr.position.x + (0.8f * (46 - cAr.position.x) )*dt , cAr.position.y);
        }
        if (cP  != nil) {
            cP.position = ccp(cP.position.x + (0.8f * (92 - cP.position.x) )*dt , cP.position.y);
        }
        if (cP2 != nil) {
            cP2.position = ccp(cP2.position.x + (0.8f * (138 - cP2.position.x) )*dt , cP2.position.y);
        }
        if (cOut != nil) {
            cOut.position = ccp(cOut.position.x + (0.8f * (174 - cOut.position.x) )*dt , cOut.position.y);
            
            cOutSubOpacity += (0.95f * (0 - cOutSubOpacity));
            cOut.opacity = cOutSubOpacity;
        }
        
        
        
        //튜토리얼 진행 프로그래밍
        [targetSelector1 update:dt];
        [targetSelector2 update:dt];
        blinder.scaleX += (0.9f * (blinderTXscale - blinder.scaleX))*(dt*10);
        
        
        if (windowAniRun) {
            if (openedWindow) {
                subDialogueWindowOpa += (0.9f * (1 - subDialogueWindowOpa))*dt*4;
                dialogueWindow.scale += (0.9f * (1 - dialogueWindow.scale))*dt*10;
                if (subDialogueWindowOpa > 0.8f) {
                    subDialogueWindowOpa = 1;
                    windowOpenComplete = YES;
                    windowAniRun = NO;
                    //NSLog(@"openComplete");
                    
                }else{
                    windowOpenComplete = NO;
                }
                
                dialogueWindow.opacity = subDialogueWindowOpa*255;
            }else{
                subDialogueWindowOpa += (0.9f * (0 - subDialogueWindowOpa))*dt*10;
                dialogueWindow.scale += (0.9f * (0.5f - dialogueWindow.scale))*dt;
                if (subDialogueWindowOpa < 0.2f) {
                    subDialogueWindowOpa = 0;
                    windowCloseComplete = YES;
                    windowAniRun = NO;
                    //NSLog(@"closeComplete");
                    
                    //튜토리얼 제거 명령이 올라오면
                    if (doneTutoCloseGesture) {
                        [PM deleteTM];
                    }
                }else{
                    windowCloseComplete = NO;
                }
                dialogueWindow.opacity = subDialogueWindowOpa*255;
            }
            
            
            
        }
        
        //게임 재개가능하도록 키 입력받음
        if (PM.game_state == GAME_FROM_TUTORIAL_PUASE) {
            
            //브리핑중이 아닐때 키입력을 받을수있음
            if (briefing == NO) {
                if (step != 8) {
                    if ([PM checkUserCommand:0]) {
                        doneGesture = YES; //제스춰 성공시에 튜토리얼루프에서 판단후 넘김
                        
                    }
                }
               
            }else{
                
            }
            
        }
        
        //튜토리얼을 완료했을때는 언제든지 튜토리얼 종료가 가능함
        //[GameCondition sharedGameCondition].hasLearnTutorial = YES; // test용
        if ([GameCondition sharedGameCondition].hasLearnTutorial == YES){
            //NSLog(@"튜토리얼 제거가능");
            if ([PM checkTutorialEndCommand]){
                doneTutoCloseGesture = YES;
                if (step != 8) {
                    [self endTutorial];
                    [PM tutoCloserRemove];
                }
            }
        }
        
        [PM buttonDownInvalidation];
        
        if (touchStandbyState) {
            if ([GameCondition sharedGameCondition].touchingPlayScene) {
                onTouch = YES;
            }
        }
        
        [self tutorialLoop:dt];
        
        [gestureGuideIn update:dt];
        [gestureGuideOut update:dt];
        [gestureGuideTutoClose update:dt];
        [gestureGuideTouch update:dt];

        
        
        
        
	}else {
		//소멸모션과 함께 종료됨
	}

}

-(void)tutorialLoop:(ccTime)d{
    if (runBriefing) {
        briefingTime += d;
        
        if (lang == Language_ko) {
            ///* Step1 *///
            if (step == 1) {
                for (int i = 0 ; i < [step1_Texts count] ; i++){
                    TextLineBriefer * o = [step1_Texts objectAtIndex:i];
                    
                    //브리핑 애니메이션 완료시에
                    if ([o running]) {
                        if ([o completeBrief]) {
                            
                            //마지막 브리핑 라인이 아니라면
                            if (i < [step1_Texts count] - 1) {
                                TextLineBriefer * nexto = [step1_Texts objectAtIndex:i+1];
                                
                                NSLog(@"next");
                                //다음 브리핑 라인을 작동
                                if ([nexto running] == NO) {
                                    [o stop];
                                    [nexto run];
                                }
                                
                            }
                        }
                    }
                }
                
                int completeCount = 0;
                if (!s1_closing) {
                    if (!touchStandbyState) { //터치대기상태가 아니면
                        for (int j = 0 ; j < [step1_Texts count]; j++) {
                            if ([[step1_Texts objectAtIndex:j] completeBrief]) {
                                completeCount ++;
                                if (completeCount == 2) {
                                    [self onGestures:YES Out:YES TutoC:NO Touch:NO];
                                    
                                }
                                
                                if (completeCount == 3) {
                                    [self offGestures];
                                    [self onTouchStandbyState];//터치대기상태로 만들어 다음으로 넘길준비를 한다
                                    s1_closing = YES;
                                }
                                
                            }
                        }
                    }
                }
                
                //스탭 브리핑 완료
                if (s1_completeCount <= 3) {
                    s1_completeCount = MAX(completeCount, s1_completeCount);
                }
                
                // NSLog(@"completeCount:%d [step1_Texts count]:%d",completeCount,[step1_Texts count]);
                if (s1_completeCount == [step1_Texts count]) {
                    s1Et += d;
                    if (s1Et > 1) {
                        
                        //터치가 입력되면 현재 브리핑을 끝내고 다음 준비
                        if (onTouch) {
                            NSLog(@"aaa");
                            [self onTouchOk];
                            
                            
                            for(TextLineBriefer * o in step1_Texts){
                                [o close];
                            }
                        }
                        
                    }
                }
                
                int closedCount = 0;
                for(TextLineBriefer * o in step1_Texts){
                    [o update:d];
                    if ([o completeClose]) {
                        closedCount ++;
                        if (closedCount == [step1_Texts count]) {
                            step++;
                            briefing = YES;
                            [self offGestures];
                            
                        }
                    }
                }
                ///* Step2 *///
            }else if(step == 2){
                for (int i = 0 ; i < [step2_Texts count] ; i++){
                    TextLineBriefer * o = [step2_Texts objectAtIndex:i];
                    
                    //브리핑 애니메이션 완료시에
                    if ([o running]) {
                        if ([o completeBrief]) {
                            
                            //마지막 브리핑 라인이 아니라면
                            if (i < [step2_Texts count] - 1) {
                                TextLineBriefer * nexto = [step2_Texts objectAtIndex:i+1];
                                
                                NSLog(@"next");
                                //다음 브리핑 라인을 작동
                                if ([nexto running] == NO) {
                                    [o stop];
                                    [nexto run];
                                }
                                
                            }
                        }
                    }
                }
                
                int completeCount = 0;
                for (int j = 0 ; j < [step2_Texts count]; j++) {
                    if ([[step2_Texts objectAtIndex:j] completeBrief]) {
                        completeCount ++;
                    }
                }
                
                if (s1_completeCount <= 1) {
                    s1_completeCount = MAX(completeCount, s1_completeCount);
                }
                
                // NSLog(@"completeCount:%d [step1_Texts count]:%d",completeCount,[step1_Texts count]);
                if (completeCount == [step2_Texts count]) {
                    s2Et += d;
                    if (s2Et > 1) {
                        for(TextLineBriefer * o in step2_Texts){
                            [o close];
                        }
                    }
                }
                
                int closedCount = 0;
                for(TextLineBriefer * o in step2_Texts){
                    [o update:d];
                    if ([o completeClose]) {
                        closedCount ++;
                        if (closedCount == [step2_Texts count]) {
                            step++;
                            briefing = YES;
                            
                        }
                    }
                }
                
                ///* Step3 *///
            }else if(step == 3){ 
                for (int i = 0 ; i < [step3_Texts count] ; i++){
                    TextLineBriefer * o = [step3_Texts objectAtIndex:i];
                    
                    //브리핑 애니메이션 완료시에
                    if ([o running]) {
                        if ([o completeBrief]) {
                            
                            //마지막 브리핑 라인이 아니라면
                            if (i < [step3_Texts count] - 1) {
                                TextLineBriefer * nexto = [step3_Texts objectAtIndex:i+1];
                                
                                NSLog(@"next");
                                //다음 브리핑 라인을 작동
                                if ([nexto running] == NO) {
                                    [o stop];
                                    [nexto run];
                                }
                                
                            }
                        }
                    }
                }
                
                int completeCount = 0;
                for (int j = 0 ; j < [step3_Texts count]; j++) {
                    if ([[step3_Texts objectAtIndex:j] completeBrief]) {
                        completeCount ++;
                        if (completeCount == 3) {
                            [self onGestures:NO Out:YES TutoC:NO Touch:NO];
                            
                        }
                    }
                }
                // NSLog(@"completeCount:%d [step1_Texts count]:%d",completeCount,[step1_Texts count]);
                if (completeCount == [step3_Texts count]) {
                    briefing = NO;
                    s3Et += d;
                    if (doneGesture) {
                        doneGesture = NO; //사용자의 제스쳐를 튜토리얼루프에서 감지한후에 플래그 끔
                        //if (s3Et > 1) {
                            for(TextLineBriefer * o in step3_Texts){
                                [o close];
                            }
                        //}
                    }
                    
                }
                
                int closedCount = 0;
                for(TextLineBriefer * o in step3_Texts){
                    [o update:d];
                    if ([o completeClose]) {
                        closedCount ++;
                        if (closedCount == [step3_Texts count]) {
                            step++;
                            briefing = YES;
                            
                            //제스춰 성공후 튜토리얼 글자 지운후에 창 닫고 게임 재개
                            [self closingWindow];
                            [self offGestures];
                        }
                    }
                }
                
                ///* Step4444444444 *///
            }else if(step == 4){   
                for (int i = 0 ; i < [step4_Texts count] ; i++){
                    TextLineBriefer * o = [step4_Texts objectAtIndex:i];
                    
                    //브리핑 애니메이션 완료시에
                    if ([o running]) {
                        if ([o completeBrief]) {
                            
                            //마지막 브리핑 라인이 아니라면
                            if (i < [step4_Texts count] - 1) {
                                TextLineBriefer * nexto = [step4_Texts objectAtIndex:i+1];
                                
                                NSLog(@"next");
                                //다음 브리핑 라인을 작동
                                if ([nexto running] == NO) {
                                    [o stop];
                                    [nexto run];
                                }
                                
                            }
                        }
                    }
                }
                
                int completeCount = 0;
                for (int j = 0 ; j < [step4_Texts count]; j++) {
                    if ([[step4_Texts objectAtIndex:j] completeBrief]) {
                        completeCount ++;
                        if (completeCount == 3) {
                            [self onGestures:NO Out:YES TutoC:NO Touch:NO];
                            
                        }
                    }
                }
                // NSLog(@"completeCount:%d [step1_Texts count]:%d",completeCount,[step1_Texts count]);
                if (completeCount == [step4_Texts count]) {
                    briefing = NO;
                    s4Et += d;
                    if (doneGesture) {
                        doneGesture = NO; //사용자의 제스쳐를 튜토리얼루프에서 감지한후에 플래그 끔
                        //if (s4Et > 1) {
                            for(TextLineBriefer * o in step4_Texts){
                                [o close];
                            }
                        //}
                    }
                    
                }
                
                int closedCount = 0;
                for(TextLineBriefer * o in step4_Texts){
                    [o update:d];
                    if ([o completeClose]) {
                        closedCount ++;
                        if (closedCount == [step4_Texts count]) {
                            step++;
                            briefing = YES;
                            
                            //제스춰 성공후 튜토리얼 글자 지운후에 창 닫고 게임 재개
                            [self closingWindow];
                            [self offGestures];
                        }
                    }
                }
                
                ///* Step5555555 *///
            }else if(step == 5){ 
                for (int i = 0 ; i < [step5_Texts count] ; i++){
                    TextLineBriefer * o = [step5_Texts objectAtIndex:i];
                    
                    //브리핑 애니메이션 완료시에
                    if ([o running]) {
                        if ([o completeBrief]) {
                            
                            //마지막 브리핑 라인이 아니라면
                            if (i < [step5_Texts count] - 1) {
                                TextLineBriefer * nexto = [step5_Texts objectAtIndex:i+1];
                                
                                NSLog(@"next");
                                //다음 브리핑 라인을 작동
                                if ([nexto running] == NO) {
                                    if (touchStandbyState) {
                                        if (onTouch) {
                                            //[self onTouchOk];
                                            [o stop];
                                            [nexto run];
                                        }
                                    }else{
                                        if (i == 2) {
                                            if (s5_completeCount == 3) {
                                                [o stop];
                                                [nexto run];
                                            }
                                        }else{
                                            [o stop];
                                            [nexto run];  
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                }
                
                int completeCount = 0;
                for (int j = 0 ; j < [step5_Texts count]; j++) {
                    if ([[step5_Texts objectAtIndex:j] completeBrief]) {
                        completeCount ++;
                        if (completeCount == 3) {
                            if (s5_midCheck == NO) {
                                s5_midCheck = YES;
                                [self onTouchStandbyState];
                            }
                            if (touchStandbyState) {
                                if (onTouch) {
                                    for (int s5i = 0; s5i < 3; s5i++) {
                                        [[step5_Texts objectAtIndex:s5i] close];
                                        
                                    }
                                    
                                    [self onTouchOk];
                                    [self offGestures];
                                    
                                    
                                }
                            }
                            
                            
                        }
                        
                        if (completeCount == 4) {
                            [self onGestures:YES Out:NO TutoC:NO Touch:NO];
                            
                        }
                    }
                }
                
                //스탭 브리핑 완료
                if (s5_completeCount <= 4) {
                    s5_completeCount = MAX(completeCount, s5_completeCount);
                }
                
                
                // NSLog(@"completeCount:%d [step1_Texts count]:%d",completeCount,[step1_Texts count]);
                if (completeCount == [step5_Texts count]) {
                    briefing = NO;
                    s5Et += d;
                    if (doneGesture) {
                        doneGesture = NO; //사용자의 제스쳐를 튜토리얼루프에서 감지한후에 플래그 끔
                        //if (s5Et > 1) {
                            for(TextLineBriefer * o in step5_Texts){
                                [o close];
                            }
                        //}
                    }
                    
                }
                
                int closedCount = 0;
                for(TextLineBriefer * o in step5_Texts){
                    [o update:d];
                    if ([o completeClose]) {
                        closedCount ++;
                        if (closedCount == [step5_Texts count]) {
                            step++;
                            briefing = YES;
                            
                            //제스춰 성공후 튜토리얼 글자 지운후에 창 닫고 게임 재개
                            [self closingWindow];
                            [self offGestures];
                        }
                    }
                }
                
                ///* Step666666 *///
            }else if(step == 6){
                for (int i = 0 ; i < [step6_Texts count] ; i++){
                    TextLineBriefer * o = [step6_Texts objectAtIndex:i];
                    
                    //브리핑 애니메이션 완료시에
                    if ([o running]) {
                        if ([o completeBrief]) {
                            
                            //마지막 브리핑 라인이 아니라면
                            if (i < [step6_Texts count] - 1) {
                                TextLineBriefer * nexto = [step6_Texts objectAtIndex:i+1];
                                
                                NSLog(@"next");
                                //다음 브리핑 라인을 작동
                                if ([nexto running] == NO) {
                                    [o stop];
                                    [nexto run];
                                }
                                
                            }
                        }
                    }
                }
                
                int completeCount = 0;
                for (int j = 0 ; j < [step6_Texts count]; j++) {
                    if ([[step6_Texts objectAtIndex:j] completeBrief]) {
                        completeCount ++;
                        if (completeCount == 3) {
                            [self onGestures:YES Out:NO TutoC:NO Touch:NO];
                            
                        }
                    }
                }
                // NSLog(@"completeCount:%d [step1_Texts count]:%d",completeCount,[step1_Texts count]);
                if (completeCount == [step6_Texts count]) {
                    briefing = NO;
                    s6Et += d;
                    if (doneGesture) {
                        doneGesture = NO; //사용자의 제스쳐를 튜토리얼루프에서 감지한후에 플래그 끔
                        //if (s6Et > 1) {
                            for(TextLineBriefer * o in step6_Texts){
                                [o close];
                            }
                        //}
                    }
                    
                }
                
                int closedCount = 0;
                for(TextLineBriefer * o in step6_Texts){
                    [o update:d];
                    if ([o completeClose]) {
                        closedCount ++;
                        if (closedCount == [step6_Texts count]) {
                            step++;
                            briefing = YES;
                            
                            //제스춰 성공후 튜토리얼 글자 지운후에 창 닫고 게임 재개
                            //[self closingWindow];
                            [self offGestures];
                        }
                    }
                }
                
                ///* Step7777777 *///
            }else if(step == 7){
                for (int i = 0 ; i < [step7_Texts count] ; i++){
                    TextLineBriefer * o = [step7_Texts objectAtIndex:i];
                    
                    //브리핑 애니메이션 완료시에
                    if ([o running]) {
                        if ([o completeBrief]) {
                            
                            //마지막 브리핑 라인이 아니라면
                            if (i < [step7_Texts count] - 1) {
                                TextLineBriefer * nexto = [step7_Texts objectAtIndex:i+1];
                                
                                NSLog(@"next");
                                //다음 브리핑 라인을 작동
                                if ([nexto running] == NO) {
                                    [o stop];
                                    [nexto run];
                                }
                                
                            }
                        }
                    }
                }
                
                int completeCount = 0;
                for (int j = 0 ; j < [step7_Texts count]; j++) {
                    if ([[step7_Texts objectAtIndex:j] completeBrief]) {
                        completeCount ++;
                        if (completeCount == 3) {
                            for (int s7i = 0; s7i < 3; s7i++) {
                                [[step7_Texts objectAtIndex:s7i] close];
                            }
                            
                        }
                    }
                }
                // NSLog(@"completeCount:%d [step1_Texts count]:%d",completeCount,[step1_Texts count]);
                if (completeCount == [step7_Texts count]) {
                    briefing = NO;
                    s7Et += d;
                    if (s7Et > 2) {
                        for(TextLineBriefer * o in step7_Texts){
                            [o close];
                        }
                    }
                    
                }
                
                int closedCount = 0;
                for(TextLineBriefer * o in step7_Texts){
                    [o update:d];
                    if ([o completeClose]) {
                        closedCount ++;
                        if (closedCount == [step7_Texts count]) {
                            step++;
                            briefing = YES;
                            
                            //제스춰 성공후 튜토리얼 글자 지운후에 창 닫고 게임 재개
                            //[self closingWindow];
                            [self offGestures];
                        }
                    }
                }
                
                
                
            }else if(step == 8){
                
                for (int i = 0 ; i < [step8_Texts count] ; i++){
                    TextLineBriefer * o = [step8_Texts objectAtIndex:i];
                    
                    //브리핑 애니메이션 완료시에
                    if ([o running]) {
                        if ([o completeBrief]) {
                            
                            //마지막 브리핑 라인이 아니라면
                            if (i < [step8_Texts count] - 1) {
                                TextLineBriefer * nexto = [step8_Texts objectAtIndex:i+1];
                                
                                NSLog(@"next");
                                //다음 브리핑 라인을 작동
                                if ([nexto running] == NO) {
                                    [o stop];
                                    [nexto run];
                                }
                                
                            }
                        }
                    }
                }
                
                int completeCount = 0;
                for (int j = 0 ; j < [step8_Texts count]; j++) {
                    if ([[step8_Texts objectAtIndex:j] completeBrief]) {
                        completeCount ++;
                        
                    }
                }
                // NSLog(@"completeCount:%d [step1_Texts count]:%d",completeCount,[step1_Texts count]);
                if (completeCount == [step8_Texts count]) {
                    briefing = NO;
                    s8Et += d;
                    
                    //최종브리핑이 끝났으니 튜토리얼 제거가 명령을 받도록 플래그 온
                    [GameCondition sharedGameCondition].hasLearnTutorial = YES;
                    [self onGestures:NO Out:NO TutoC:YES Touch:NO];
                    
                    
                    if (doneTutoCloseGesture) {
                        //doneTutoCloseGesture = NO; //사용자의 제스쳐를 튜토리얼루프에서 감지한후에 플래그 끔
                        //if (s8Et > 1) {
                            for(TextLineBriefer * o in step8_Texts){
                                [o close];
                            }
                        //}
                    }
                    
                }
                
                int closedCount = 0;
                for(TextLineBriefer * o in step8_Texts){
                    [o update:d];
                    if ([o completeClose]) {
                        closedCount ++;
                        if (closedCount == [step8_Texts count]) {
                            step++;
                            briefing = YES;
                            
                            //제스춰 성공후 튜토리얼 글자 지운후에 창 닫고 게임 재개
                            [self closingWindow];
                            [self offGestures];
                        }
                    }
                }
                
            }
        }else if(lang == Language_en){
       //////////////////////////////// English //////////////////////////////////////     
            
            ///* Step1 *///
            if (step == 1) {
                for (int i = 0 ; i < [step1_Texts count] ; i++){
                    TextLineBriefer * o = [step1_Texts objectAtIndex:i];
                    
                    //브리핑 애니메이션 완료시에
                    if ([o running]) {
                        if ([o completeBrief]) {
                            
                            //마지막 브리핑 라인이 아니라면
                            if (i < [step1_Texts count] - 1) {
                                TextLineBriefer * nexto = [step1_Texts objectAtIndex:i+1];
                                
                                NSLog(@"next");
                                //다음 브리핑 라인을 작동
                                if ([nexto running] == NO) {
                                    [o stop];
                                    [nexto run];
                                }
                                
                            }
                        }
                    }
                }
                
                int completeCount = 0;
                for (int j = 0 ; j < [step1_Texts count]; j++) {
                    if ([[step1_Texts objectAtIndex:j] completeBrief]) {
                        completeCount ++;
                        if (completeCount == 3) {
                            for (int s1i = 0; s1i < 3; s1i++) {
                                [[step1_Texts objectAtIndex:s1i] close];
                            }
                            
                            [self onGestures:YES Out:YES TutoC:NO Touch:NO];
                        }
                    }
                }
                // NSLog(@"completeCount:%d [step1_Texts count]:%d",completeCount,[step1_Texts count]);
                if (completeCount == [step1_Texts count]) {
                    briefing = NO;
                    s1Et += d;
                    if (s1Et > 2) {
                        for(TextLineBriefer * o in step1_Texts){
                            [o close];
                        }
                    }
                }
                
                                
                int closedCount = 0;
                for(TextLineBriefer * o in step1_Texts){
                    [o update:d];
                    if ([o completeClose]) {
                        closedCount ++;
                        if (closedCount == [step1_Texts count]) {
                            step++;
                            briefing = YES;
                            [self offGestures];
                            
                        }
                    }
                }
                ///* Step2 *///
            }else if(step == 2){
                for (int i = 0 ; i < [step2_Texts count] ; i++){
                    TextLineBriefer * o = [step2_Texts objectAtIndex:i];
                    
                    //브리핑 애니메이션 완료시에
                    if ([o running]) {
                        if ([o completeBrief]) {
                            
                            //마지막 브리핑 라인이 아니라면
                            if (i < [step2_Texts count] - 1) {
                                TextLineBriefer * nexto = [step2_Texts objectAtIndex:i+1];
                                
                                NSLog(@"next");
                                //다음 브리핑 라인을 작동
                                if ([nexto running] == NO) {
                                    [o stop];
                                    [nexto run];
                                }
                                
                            }
                        }
                    }
                }
                
                int completeCount = 0;
                for (int j = 0 ; j < [step2_Texts count]; j++) {
                    if ([[step2_Texts objectAtIndex:j] completeBrief]) {
                        completeCount ++;
                    }
                }
                
                if (s1_completeCount <= 1) {
                    s1_completeCount = MAX(completeCount, s1_completeCount);
                }
                
                // NSLog(@"completeCount:%d [step1_Texts count]:%d",completeCount,[step1_Texts count]);
                if (completeCount == [step2_Texts count]) {
                    s2Et += d;
                    if (s2Et > 1) {
                        for(TextLineBriefer * o in step2_Texts){
                            [o close];
                        }
                    }
                }
                
                int closedCount = 0;
                for(TextLineBriefer * o in step2_Texts){
                    [o update:d];
                    if ([o completeClose]) {
                        closedCount ++;
                        if (closedCount == [step2_Texts count]) {
                            step++;
                            briefing = YES;
                            
                        }
                    }
                }
                
                ///* Step3 *///
            }else if(step == 3){ 
                for (int i = 0 ; i < [step3_Texts count] ; i++){
                    TextLineBriefer * o = [step3_Texts objectAtIndex:i];
                    
                    //브리핑 애니메이션 완료시에
                    if ([o running]) {
                        if ([o completeBrief]) {
                            
                            //마지막 브리핑 라인이 아니라면
                            if (i < [step3_Texts count] - 1) {
                                TextLineBriefer * nexto = [step3_Texts objectAtIndex:i+1];
                                
                                NSLog(@"next");
                                //다음 브리핑 라인을 작동
                                if ([nexto running] == NO) {
                                    [o stop];
                                    [nexto run];
                                }
                                
                            }
                        }
                    }
                }
                
                int completeCount = 0;
                for (int j = 0 ; j < [step3_Texts count]; j++) {
                    if ([[step3_Texts objectAtIndex:j] completeBrief]) {
                        completeCount ++;
                        if (completeCount == 3) {
                            [self onGestures:NO Out:YES TutoC:NO Touch:NO];
                            
                        }
                    }
                }
                // NSLog(@"completeCount:%d [step1_Texts count]:%d",completeCount,[step1_Texts count]);
                if (completeCount == [step3_Texts count]) {
                    briefing = NO;
                    s3Et += d;
                    if (doneGesture) {
                        doneGesture = NO; //사용자의 제스쳐를 튜토리얼루프에서 감지한후에 플래그 끔
                        //if (s3Et > 1) {
                        for(TextLineBriefer * o in step3_Texts){
                            [o close];
                        }
                        //}
                    }
                    
                }
                
                int closedCount = 0;
                for(TextLineBriefer * o in step3_Texts){
                    [o update:d];
                    if ([o completeClose]) {
                        closedCount ++;
                        if (closedCount == [step3_Texts count]) {
                            step++;
                            briefing = YES;
                            
                            //제스춰 성공후 튜토리얼 글자 지운후에 창 닫고 게임 재개
                            [self closingWindow];
                            [self offGestures];
                        }
                    }
                }
                
                ///* Step4444444444 *///
            }else if(step == 4){   
                for (int i = 0 ; i < [step4_Texts count] ; i++){
                    TextLineBriefer * o = [step4_Texts objectAtIndex:i];
                    
                    //브리핑 애니메이션 완료시에
                    if ([o running]) {
                        if ([o completeBrief]) {
                            
                            //마지막 브리핑 라인이 아니라면
                            if (i < [step4_Texts count] - 1) {
                                TextLineBriefer * nexto = [step4_Texts objectAtIndex:i+1];
                                
                                NSLog(@"next");
                                //다음 브리핑 라인을 작동
                                if ([nexto running] == NO) {
                                    [o stop];
                                    [nexto run];
                                }
                                
                            }
                        }
                    }
                }
                
                int completeCount = 0;
                for (int j = 0 ; j < [step4_Texts count]; j++) {
                    if ([[step4_Texts objectAtIndex:j] completeBrief]) {
                        completeCount ++;
                        if (completeCount == 3) {
                            [self onGestures:NO Out:YES TutoC:NO Touch:NO];
                            
                        }
                    }
                }
                // NSLog(@"completeCount:%d [step1_Texts count]:%d",completeCount,[step1_Texts count]);
                if (completeCount == [step4_Texts count]) {
                    briefing = NO;
                    s4Et += d;
                    if (doneGesture) {
                        doneGesture = NO; //사용자의 제스쳐를 튜토리얼루프에서 감지한후에 플래그 끔
                        //if (s4Et > 1) {
                        for(TextLineBriefer * o in step4_Texts){
                            [o close];
                        }
                        //}
                    }
                    
                }
                
                int closedCount = 0;
                for(TextLineBriefer * o in step4_Texts){
                    [o update:d];
                    if ([o completeClose]) {
                        closedCount ++;
                        if (closedCount == [step4_Texts count]) {
                            step++;
                            briefing = YES;
                            
                            //제스춰 성공후 튜토리얼 글자 지운후에 창 닫고 게임 재개
                            [self closingWindow];
                            [self offGestures];
                        }
                    }
                }
                
                ///* Step5555555 *///
            }else if(step == 5){ 
                for (int i = 0 ; i < [step5_Texts count] ; i++){
                    TextLineBriefer * o = [step5_Texts objectAtIndex:i];
                    
                    //브리핑 애니메이션 완료시에
                    if ([o running]) {
                        if ([o completeBrief]) {
                            
                            //마지막 브리핑 라인이 아니라면
                            if (i < [step5_Texts count] - 1) {
                                TextLineBriefer * nexto = [step5_Texts objectAtIndex:i+1];
                                
                                NSLog(@"next");
                                //다음 브리핑 라인을 작동
                                if ([nexto running] == NO) {
                                    if (touchStandbyState) {
                                        if (onTouch) {
                                            //[self onTouchOk];
                                            [o stop];
                                            [nexto run];
                                        }
                                    }else{
                                        if (i == 2) {
                                            if (s5_completeCount == 3) {
                                                [o stop];
                                                [nexto run];
                                            }
                                        }else{
                                            [o stop];
                                            [nexto run];  
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                }
                
                int completeCount = 0;
                for (int j = 0 ; j < [step5_Texts count]; j++) {
                    if ([[step5_Texts objectAtIndex:j] completeBrief]) {
                        completeCount ++;
                        if (completeCount == 3) {
                            if (s5_midCheck == NO) {
                                s5_midCheck = YES;
                                [self onTouchStandbyState];
                            }
                            if (touchStandbyState) {
                                if (onTouch) {
                                    for (int s5i = 0; s5i < 3; s5i++) {
                                        [[step5_Texts objectAtIndex:s5i] close];
                                        
                                    }
                                    
                                    [self onTouchOk];
                                    [self offGestures];
                                    
                                    
                                }
                            }
                            
                            
                        }
                        
                        if (completeCount == 4) {
                            [self onGestures:YES Out:NO TutoC:NO Touch:NO];
                            
                        }
                    }
                }
                
                //스탭 브리핑 완료
                if (s5_completeCount <= 4) {
                    s5_completeCount = MAX(completeCount, s5_completeCount);
                }
                
                
                // NSLog(@"completeCount:%d [step1_Texts count]:%d",completeCount,[step1_Texts count]);
                if (completeCount == [step5_Texts count]) {
                    briefing = NO;
                    s5Et += d;
                    if (doneGesture) {
                        doneGesture = NO; //사용자의 제스쳐를 튜토리얼루프에서 감지한후에 플래그 끔
                        //if (s5Et > 1) {
                        for(TextLineBriefer * o in step5_Texts){
                            [o close];
                        }
                        //}
                    }
                    
                }
                
                int closedCount = 0;
                for(TextLineBriefer * o in step5_Texts){
                    [o update:d];
                    if ([o completeClose]) {
                        closedCount ++;
                        if (closedCount == [step5_Texts count]) {
                            step++;
                            briefing = YES;
                            
                            //제스춰 성공후 튜토리얼 글자 지운후에 창 닫고 게임 재개
                            [self closingWindow];
                            [self offGestures];
                        }
                    }
                }
                
                ///* Step666666 *///
            }else if(step == 6){
                for (int i = 0 ; i < [step6_Texts count] ; i++){
                    TextLineBriefer * o = [step6_Texts objectAtIndex:i];
                    
                    //브리핑 애니메이션 완료시에
                    if ([o running]) {
                        if ([o completeBrief]) {
                            
                            //마지막 브리핑 라인이 아니라면
                            if (i < [step6_Texts count] - 1) {
                                TextLineBriefer * nexto = [step6_Texts objectAtIndex:i+1];
                                
                                NSLog(@"next");
                                //다음 브리핑 라인을 작동
                                if ([nexto running] == NO) {
                                    [o stop];
                                    [nexto run];
                                }
                                
                            }
                        }
                    }
                }
                
                int completeCount = 0;
                for (int j = 0 ; j < [step6_Texts count]; j++) {
                    if ([[step6_Texts objectAtIndex:j] completeBrief]) {
                        completeCount ++;
                        if (completeCount == 3) {
                            [self onGestures:YES Out:NO TutoC:NO Touch:NO];
                            
                        }
                    }
                }
                // NSLog(@"completeCount:%d [step1_Texts count]:%d",completeCount,[step1_Texts count]);
                if (completeCount == [step6_Texts count]) {
                    briefing = NO;
                    s6Et += d;
                    if (doneGesture) {
                        doneGesture = NO; //사용자의 제스쳐를 튜토리얼루프에서 감지한후에 플래그 끔
                        //if (s6Et > 1) {
                        for(TextLineBriefer * o in step6_Texts){
                            [o close];
                        }
                        //}
                    }
                    
                }
                
                int closedCount = 0;
                for(TextLineBriefer * o in step6_Texts){
                    [o update:d];
                    if ([o completeClose]) {
                        closedCount ++;
                        if (closedCount == [step6_Texts count]) {
                            step++;
                            briefing = YES;
                            
                            //제스춰 성공후 튜토리얼 글자 지운후에 창 닫고 게임 재개
                            //[self closingWindow];
                            [self offGestures];
                        }
                    }
                }
                
                ///* Step7777777 *///
            }else if(step == 7){
                for (int i = 0 ; i < [step7_Texts count] ; i++){
                    TextLineBriefer * o = [step7_Texts objectAtIndex:i];
                    
                    //브리핑 애니메이션 완료시에
                    if ([o running]) {
                        if ([o completeBrief]) {
                            
                            //마지막 브리핑 라인이 아니라면
                            if (i < [step7_Texts count] - 1) {
                                TextLineBriefer * nexto = [step7_Texts objectAtIndex:i+1];
                                
                                NSLog(@"next");
                                //다음 브리핑 라인을 작동
                                if ([nexto running] == NO) {
                                    [o stop];
                                    [nexto run];
                                }
                                
                            }
                        }
                    }
                }
                
                int completeCount = 0;
                for (int j = 0 ; j < [step7_Texts count]; j++) {
                    if ([[step7_Texts objectAtIndex:j] completeBrief]) {
                        completeCount ++;
                        if (completeCount == 3) {
                            for (int s7i = 0; s7i < 3; s7i++) {
                                [[step7_Texts objectAtIndex:s7i] close];
                            }
                            
                        }
                    }
                }
                // NSLog(@"completeCount:%d [step1_Texts count]:%d",completeCount,[step1_Texts count]);
                if (completeCount == [step7_Texts count]) {
                    briefing = NO;
                    s7Et += d;
                    if (s7Et > 2) {
                        for(TextLineBriefer * o in step7_Texts){
                            [o close];
                        }
                    }
                    
                }
                
                int closedCount = 0;
                for(TextLineBriefer * o in step7_Texts){
                    [o update:d];
                    if ([o completeClose]) {
                        closedCount ++;
                        if (closedCount == [step7_Texts count]) {
                            step++;
                            briefing = YES;
                            
                            //제스춰 성공후 튜토리얼 글자 지운후에 창 닫고 게임 재개
                            //[self closingWindow];
                            [self offGestures];
                        }
                    }
                }
                
                
                
            }else if(step == 8){
                
                for (int i = 0 ; i < [step8_Texts count] ; i++){
                    TextLineBriefer * o = [step8_Texts objectAtIndex:i];
                    
                    //브리핑 애니메이션 완료시에
                    if ([o running]) {
                        if ([o completeBrief]) {
                            
                            //마지막 브리핑 라인이 아니라면
                            if (i < [step8_Texts count] - 1) {
                                TextLineBriefer * nexto = [step8_Texts objectAtIndex:i+1];
                                
                                NSLog(@"next");
                                //다음 브리핑 라인을 작동
                                if ([nexto running] == NO) {
                                    [o stop];
                                    [nexto run];
                                }
                                
                            }
                        }
                    }
                }
                
                int completeCount = 0;
                for (int j = 0 ; j < [step8_Texts count]; j++) {
                    if ([[step8_Texts objectAtIndex:j] completeBrief]) {
                        completeCount ++;
                        
                    }
                }
                // NSLog(@"completeCount:%d [step1_Texts count]:%d",completeCount,[step1_Texts count]);
                if (completeCount == [step8_Texts count]) {
                    briefing = NO;
                    s8Et += d;
                    
                    //최종브리핑이 끝났으니 튜토리얼 제거가 명령을 받도록 플래그 온
                    [GameCondition sharedGameCondition].hasLearnTutorial = YES;
                    [self onGestures:NO Out:NO TutoC:YES Touch:NO];
                    
                    
                    if (doneTutoCloseGesture) {
                        //doneTutoCloseGesture = NO; //사용자의 제스쳐를 튜토리얼루프에서 감지한후에 플래그 끔
                        //if (s8Et > 1) {
                        for(TextLineBriefer * o in step8_Texts){
                            [o close];
                        }
                        //}
                    }
                    
                }
                
                int closedCount = 0;
                for(TextLineBriefer * o in step8_Texts){
                    [o update:d];
                    if ([o completeClose]) {
                        closedCount ++;
                        if (closedCount == [step8_Texts count]) {
                            step++;
                            briefing = YES;
                            
                            //제스춰 성공후 튜토리얼 글자 지운후에 창 닫고 게임 재개
                            [self closingWindow];
                            [self offGestures];
                        }
                    }
                }
                
            }
            
            
            
            
        }
    }
        
        
    
    
    //8스텝을 마친후 
    //[GameCondition sharedGameCondition].hasLearnTutorial = YES;
}



#pragma mark -
#pragma mark === Controll from Outside ===
-(void)begin {
	
	if (run == NO) {
		run = YES;
		animation.visible = YES;
	}
    
}

-(void)stop {
	run = NO;
}

-(void)endTutorial {
    //이미 튜토리얼을 완료한 후 다시 진행하는것 이거나 스텝이 8이상일경우 자유로운 종료가 가능함
    if ([GameCondition sharedGameCondition].hasLearnTutorial == YES) {
        for(BaseCharacter * o in refMeObjects){
            [o deleteRefTM];
        }
        
        [refMeObjects removeAllObjects];
        run = NO;
        extinction = YES;
        PM.game_state = GAME_PLAYING;
        [CoverLayer removeChild:self cleanup:YES];
        
        self = nil;
        NSLog(@"EndTM");
        
        //[PM tutorialInformDelete];
    }
    
}

#pragma mark -
#pragma mark === Controll from Inside ===
-(void)showingWindow{
    windowAniRun = YES;
    openedWindow = YES;
    briefing = YES;
    runBriefing = YES;
}
-(void)closingWindow{
    windowAniRun = YES;
    openedWindow = NO;
    runBriefing = NO;
    PM.game_state = GAME_PLAYING;
    [targetSelector1 stopRepeat];
    [targetSelector2 stopRepeat];
    blinderTXscale = 0;
    
    
}

-(void)stopGameRun{
    PM.game_state = GAME_FROM_TUTORIAL_PUASE;
    [targetSelector1 runningControll:SE_Running];
    [targetSelector1 playRepeat];
    [targetSelector2 runningControll:SE_Running];
    [targetSelector2 playRepeat];
    blinderTXscale = 480;
    [self showingWindow];
}

-(void)inputStatefromShape:(id)shapeID PrevState:(State)prevState_ CurrentState:(State)currentState_{
    //(COMIN,GOOUT),ARRIVED,DIED,DISAPPEAR,STANDBY
    
    if (currentState_ == STANDBY & prevState_ != STANDBY) {
        if (Ar == nil) {
            if (Ap == shapeID) {
                Ar = Ap;
                Ap = nil;
                
                
                NSLog(@"> Standby");
                //비주얼부분
                cAr = cAp;
                cAp = nil;
                
                [self stopGameRun];
                
                //cAr.position = ccp(45,250);
            }
            
            
        }
    }else if(prevState_ == STANDBY && currentState_ != STANDBY){
        if (P == nil) {
            if (Ar == shapeID) {
                P = Ar;
                Ar = nil;
                
                
                
                //NSLog(@"Standby > ");
                cP = cAr;
                cAr = nil;
                //cP.position = ccp(90,250);
            }
            
            
        }else{
            if (Ar == shapeID) {
                P2 = P;
                P = Ar;
                Ar = nil;
                
                
                NSLog(@"Standby >> ");
                
                if (cP2 != nil) {
                    [self removeChild:cOut cleanup:YES];
                    cOut = cP2;
                    cOutSubOpacity = 255;
                }
                
                cP2 = cP;
                cP  = cAr;
                cAr = nil;
                //cP.position = ccp(90,250);
                //cP2.position = ccp(135,250);
            }
            
        }
    }
    
    if ([PMsShapeObject count] > 0) { //Ap에 캐릭터 넣는과정
        if (Ap == nil) {
            
            Ap = [PMsShapeObject objectAtIndex:0];
            
            
            if (Ap == Ar) {
                NSLog(@"같다고 씌발");
            }
            [Ap setTutorialManager:self];
            [refMeObjects addObject:Ap];
            
            //비주얼부분
            cAp = [[[BaseCharacter alloc] initWithShape:[Ap characterCode]] autorelease];
            cAp.position = ccp(0,250);
            cAp.anchorPoint = ccp(0.5f,0);
            
            cApSubOpacity = 0;
            cAp.opacity = cApSubOpacity;
            //캐릭터 크기별 스케일 고정 코드 넣기
            cAp.scale = 0.3f;
            
            [self addChild:cAp];
            NSLog(@"add");
        }
    }
}

-(void)onGestures:(BOOL)In_ Out:(BOOL)Out_ TutoC:(BOOL)TutoC_ Touch:(BOOL)Touch_{
    if (!gestureGuideInit) {
        gestureGuideInit = YES;
        if (In_) {
            [gestureGuideIn runningControll:SE_Restart];
            [gestureGuideIn playRepeat];
        }
        if (Out_) {
            [gestureGuideOut runningControll:SE_Restart];
            [gestureGuideOut playRepeat];
        }
        if (TutoC_) {
            [gestureGuideTutoClose runningControll:SE_Restart];
            [gestureGuideTutoClose playRepeat];
        }
        if (Touch_) {
            [gestureGuideTouch runningControll:SE_Restart];
            [gestureGuideTouch playRepeat];
        }
        

    }
}

-(void)offGestures{
    [gestureGuideIn stopRepeat];
    [gestureGuideOut stopRepeat];
    [gestureGuideTutoClose stopRepeat];
    [gestureGuideTouch stopRepeat];
    gestureGuideInit = NO;
}

//터치 대기상태 돌입
-(void)onTouchStandbyState{
    touchStandbyState = YES;
    [self onGestures:NO Out:NO TutoC:NO Touch:YES];
}
//터치감지자로부터 확인이 되면
-(void)onTouchOk{
    touchStandbyState = NO;
    onTouch = NO;
}

#pragma mark -
#pragma mark === Dealloc ===
-(void)dealloc {
    
    [refMeObjects release];
    
    [aniFrames release];
    
    [step1_Texts removeAllObjects];
    [step1_Texts release];
    [step2_Texts removeAllObjects];
    [step2_Texts release];
    [step3_Texts removeAllObjects];
    [step3_Texts release];
    [step4_Texts removeAllObjects];
    [step4_Texts release];
    [step5_Texts removeAllObjects];
    [step5_Texts release];
    [step6_Texts removeAllObjects];
    [step6_Texts release];
    [step7_Texts removeAllObjects];
    [step7_Texts release];
    [step8_Texts removeAllObjects];
    [step8_Texts release];
    
    
	[super dealloc];
	NSLog(@"TutorialAndHintManager Dealloc");
}

@end
