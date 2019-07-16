//
//  GameCenterViewController.h
//  KEEPINGSHAPE
//
//  Created by JinWoong Han on 11. 8. 29..
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

#import "cocos2d.h"
@class GameMain;

@interface GameCenterViewController : UIViewController <GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate>{
    
    GameMain * Main;
}
/////////////////Geunwon,Mo : GameCenter 추가 start 
@property (assign) GameMain * Main; 

- (IBAction)openLeaderBD:(id)sender; //점수판을 띄운다

- (IBAction)openArchivementBD:(id)sender; //목표달성판을 띄운다


- (void) showLeaderboard; //실제로 점수판을 띄우는 부분 구현 메소드

- (void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController;//점수판이 닫힐때 호출되는 메소드

- (void) showArchboard; //목표달성판을 띄우는 부분 구현 메소드

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;//목표달성판이 닫힐때 호출되는 메소드


/////////////////Geunwon,Mo : GameCenter 추가 end 


@end
