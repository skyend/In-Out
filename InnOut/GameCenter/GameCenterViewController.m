//
//  GameCenterViewController.m
//  KEEPINGSHAPE
//
//  Created by JinWoong Han on 11. 8. 29..
//  Copyright 2011 -. All rights reserved.
//

#import "GameCenterViewController.h"
#import "GameMainScene.h"

@implementation GameCenterViewController
@synthesize Main;
/////////////////Geunwon,Mo : GameCenter 추가 start /////////////


///////////////// 점수판

// 점수판 버튼이 눌리면 호출된다.

- (IBAction)openLeaderBD:(id)sender{ 
    
    NSLog(@"open leader board");
    
    [self showLeaderboard]; // 실행~
    
}


- (void) showLeaderboard {
    
    GKLeaderboardViewController *leaderboardController = [[[GKLeaderboardViewController alloc] init]autorelease];
    if (leaderboardController != nil) {
        
        // 레더보드 델리게이트는 나임
        
        leaderboardController.leaderboardDelegate = self;
        
        
        // 레더보드를 현재 뷰에 모달로 띄운다.
        
        [self presentModalViewController:leaderboardController animated: YES];
        
    }
    
}


// 레더보드 델리게이트를 구현한 부분. 닫힐때 호출된다.

- (void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
    
    [self dismissModalViewControllerAnimated:YES]; //점수판 모달뷰를 내림
    [Main closeGameCenterView];
    // 추가적으로 자신의 어플에 맞게 구현해야할것이 있으면 한다.
    
}


///////////////// 목표달성. (점수판 구현과 방법은 똑같음)

// 목표달성판 버튼이 눌리면 호출된다.

- (IBAction)openArchivementBD:(id)sender {
    
    NSLog(@"open archivement board");
    
    [self showArchboard];
    
}


- (void) showArchboard {
    
    GKAchievementViewController *archiveController = [[[GKAchievementViewController alloc]init] autorelease];
    
    
    
    if (archiveController != nil) {
        
        
        
        archiveController.achievementDelegate = self;
        
        
        [self presentModalViewController:archiveController animated: YES];

    }
    
}


- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController{
    
    [self dismissModalViewControllerAnimated:YES];
    [Main closeGameCenterView];
}

@end
