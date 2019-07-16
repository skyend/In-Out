//
//  GameCenterManager.h
//  KEEPINGSHAPE
//
//  Created by JinWoong Han on 11. 8. 24..
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "GKAchievementHandler.h" //이건 노티를 위해서 임포트
#import "GameConfig.h"
@interface GameCenterManager : NSObject {
    
}
/////////////////Geunwon,Mo : GameCenter 추가 start /////////////

+ (BOOL) isGameCenterAvailable ; //게임센터가 사용가능하지 알아보는 메소드

+ (void) connectGameCenter; //게임센터에 접속하는 메소드

+(void) sendScoreToGameCenter:(long long)_score StageCode:(StageCode)_stageCode; //게임센터서버에 점수 보내는 메소드

+ (void) sendAchievementWithIdentifier: (NSString*) identifier percentComplete: (float) percent;//게임센터서버에 목표달성 보내는 메소드

+ (void) resetAchievements; //테스트용으로 목표달성도를 리셋하는 메소드

//+(GKScore*)getGKScoreObj:(StageCode)stageCode_; //스테이지에 해당하는 GKScore반환
/////////////////Geunwon,Mo : GameCenter 추가 end   /////////////
+(void)sendLevelToGameCenter:(int)level_ ShowLevelMode:(BOOL)showLevelMode_;

@end
