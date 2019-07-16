//
//  GameCenterManager.m
//  KEEPINGSHAPE
//
//  Created by JinWoong Han on 11. 8. 24..
//  Copyright 2011 -. All rights reserved.
//

#import "GameCenterManager.h"
#import "GameCondition.h"

@implementation GameCenterManager

//GameCenter 사용 가능 단말인지 확인

+ (BOOL) isGameCenterAvailable { 
    
    // check for presence of GKLocalPlayer API
    
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    
    NSString *reqSysVer = @"4.1";
    
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] !=NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
    
}


//GameCenter 로그인

+ (void) connectGameCenter{
    
    NSLog(@"connect... to gamecenter");
    
    if([GKLocalPlayer localPlayer].authenticated == NO) { //게임센터 로그인이 아직일때
        
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError* error){
            
            if(error == NULL){
                
                NSLog(@"게임센터 로그인 성공~");
                //로그인후에 처리할 메세지를 실행
                [[GameCondition sharedGameCondition] GameCenterLoginSuccess:[[GKLocalPlayer localPlayer] playerID]];
                
            } else {
                
                NSLog(@"게임센터 로그인 에러. 별다른 처리는 하지 않는다.");
                
            }
            
        }];
        
    }
    
}

// 게임센터 서버로 점수를 보낸다.

+(void) sendScoreToGameCenter:(long long)_score StageCode:(StageCode)_stageCode{
    GKScore* sendTargetBoard;
    GKLeaderboard *board = [[[GKLeaderboard alloc] init] autorelease];
    if (board != nil)
    {
        board.range = NSMakeRange(1, 10);
        //board.timeScope = GKLeaderboardTimeScopeAllTime;
        board.playerScope = GKLeaderboardPlayerScopeGlobal;
        
        switch (_stageCode) {
            case STAGE_1 :
                sendTargetBoard = [[[GKScore alloc] initWithCategory:@"rb_stage1"]autorelease];
                board.category = [NSString stringWithFormat:@"rb_stage1"];
                break;
            case STAGE_2 :
                sendTargetBoard = [[[GKScore alloc] initWithCategory:@"rb_stage2"]autorelease];
                board.category = [NSString stringWithFormat:@"rb_stage2"];
                break;
            case STAGE_3 :
                sendTargetBoard = [[[GKScore alloc] initWithCategory:@"rb_stage3"]autorelease];
                board.category = [NSString stringWithFormat:@"rb_stage3"];
                break;
            case STAGE_4 :
                sendTargetBoard = [[[GKScore alloc] initWithCategory:@"rb_stage4"]autorelease];
                board.category = [NSString stringWithFormat:@"rb_stage4"];
                break;
            case STAGE_5 :
                sendTargetBoard = [[[GKScore alloc] initWithCategory:@"rb_stage5"]autorelease];
                board.category = [NSString stringWithFormat:@"rb_stage5"];
                break;
            case STAGE_6 :
                sendTargetBoard = [[[GKScore alloc] initWithCategory:@"rb_stage6"]autorelease];
                board.category = [NSString stringWithFormat:@"rb_stage6"];
                break;
            default:
                sendTargetBoard = [[[GKScore alloc] initWithCategory:@"rb_stage1"]autorelease];
                board.category = [NSString stringWithFormat:@"rb_stage1"];
                break;
        }
        
        [board loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
            if (error == nil)
            {
                if ([board localPlayerScore]==nil){
                    NSLog(@"localplayer nil!");
                    
                    sendTargetBoard.value = _score;
                    
                    
                    // 아래는 겜센터 스타일의 노티를 보여준다. 첫번째가 타이틀, 두번째가 표시할 메세지
                    if ([GameCondition sharedGameCondition].lang == Language_ko ) {
                        [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"이게 내 신기록이야"andMessage:[NSString stringWithFormat:@"축하합니다 %llu점을 기록하셨습니다.",_score]];
                    }else if([GameCondition sharedGameCondition].lang == Language_en){
                        [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"ScoreNewRecord"andMessage:[NSString stringWithFormat:@"Congratulation record %llu Score.",_score]];
                    }else{
                        [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"ScoreNewRecord"andMessage:[NSString stringWithFormat:@"Congratulation record %llu Score.",_score]];
                    }
                    
                    
                    
                    
                    // 실지로 게임센터 서버에 점수를 보낸다.
                    
                    [sendTargetBoard reportScoreWithCompletionHandler:^(NSError* error){
                        
                        if(error != NULL){
                            
                            // Retain the score object and try again later (not shown).
                            
                            
                            
                        }
                        
                    }];
                    
                        
                    
                }else {
                    NSLog(@"%@",[[board localPlayerScore] description]);
                    NSLog(@"%@",[scores description]);
                    
                    
                    //이미 기록된 점수보다 높으면 새 점수 기록
                    if ([[board localPlayerScore] value] < _score) {
                        // 위에서 kPoint 가 게임센터에서 설정한 Leaderboard ID
                        
                        sendTargetBoard.value = _score;
                        
                        
                        // 아래는 겜센터 스타일의 노티를 보여준다. 첫번째가 타이틀, 두번째가 표시할 메세지
                        if ([GameCondition sharedGameCondition].lang == Language_ko ) {
                            [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"이게 내 신기록이야"andMessage:[NSString stringWithFormat:@"축하합니다 %llu점을 기록하셨습니다.",_score]];
                        }else if([GameCondition sharedGameCondition].lang == Language_en){
                            [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"ScoreNewRecord"andMessage:[NSString stringWithFormat:@"Congratulation record %llu Score.",_score]];
                        }else{
                            [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"ScoreNewRecord"andMessage:[NSString stringWithFormat:@"Congratulation record %llu Score.",_score]];
                        }
                        
                        
                        
                        
                        // 실지로 게임센터 서버에 점수를 보낸다.
                        
                        [sendTargetBoard reportScoreWithCompletionHandler:^(NSError* error){
                            
                            if(error != NULL){
                                
                                // Retain the score object and try again later (not shown).
                                
                                
                                
                            }
                            
                        }];
                    }
                    
                    
                }
            } else {
                NSLog(@"error 1st fetch");
            }
        }];
        
    }
    
    
    
     
    
    
    
}

+(void)sendLevelToGameCenter:(int)level_ ShowLevelMode:(BOOL)showLevelMode_{
    GKScore* sendTargetBoard= [[[GKScore alloc] initWithCategory:@"rb_level"] autorelease];


    sendTargetBoard.value = level_;
    
    if (!showLevelMode_) {
        // 아래는 겜센터 스타일의 노티를 보여준다. 첫번째가 타이틀, 두번째가 표시할 메세지
        if ([GameCondition sharedGameCondition].lang == Language_ko ) {
            [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"레벨상승!신분상승!"andMessage:[NSString stringWithFormat:@"레벨 %d 달성!",level_]];
        }else if([GameCondition sharedGameCondition].lang == Language_en){
            [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"LevelUp!"andMessage:[NSString stringWithFormat:@"Achievement %d Level!",level_]];
        }else{
            [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"LevelUp!"andMessage:[NSString stringWithFormat:@"Achievement %d Level!",level_]];
        }
    }else{
        // 아래는 겜센터 스타일의 노티를 보여준다. 첫번째가 타이틀, 두번째가 표시할 메세지
        if ([GameCondition sharedGameCondition].lang == Language_ko ) {
            [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"나의 레벨은"andMessage:[NSString stringWithFormat:@" %d Lv",level_]];
        }else if([GameCondition sharedGameCondition].lang == Language_en){
            [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"MyLevel is"andMessage:[NSString stringWithFormat:@" %d Lv",level_]];
        }else{
            [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"MyLevel is"andMessage:[NSString stringWithFormat:@"%d Lv",level_]];
        }
    }
    
    
    
    
    // 실지로 게임센터 서버에 점수를 보낸다.
    
    [sendTargetBoard reportScoreWithCompletionHandler:^(NSError* error){
        
        if(error != NULL){
            
            // Retain the score object and try again later (not shown).
            
            
            
        }
        NSLog(@"Rank:%d",[sendTargetBoard rank]);
    }];
}



// 게임센터 서버로 목표달성도를 보낸다. 첫번째가 목표ID, 두번째가 달성도. 100%면 목표달성임

+ (void) sendAchievementWithIdentifier: (NSString*) identifier percentComplete: (float) percent{
    
    NSLog(@"--겜센터 : sendAchievementWithIdentifier %@ , %f",identifier,percent);
    
    GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier: identifier]autorelease];
    
    if (achievement)
        
    {
        
        achievement.percentComplete = percent;
        
        
        
        [achievement reportAchievementWithCompletionHandler:^(NSError *error)
         
         {
             
             if (error != nil)
                 
             {
                 
                 
                 
             }
             
         }];
        
        
        
        // 이 아래는 게임센터로부터 목표달성이 등록되면 실행되는 리스너(?)
        
        [GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:
         
         ^(NSArray *descriptions, NSError *error) {
             
             if (error != nil){}
             
             // process the errors
             
             if (descriptions != nil){
                 
                 
                 
                 //목표달성이 등록되면 노티로 알려준다.
                 
                 for (GKAchievementDescription *achievementDescription in descriptions){
                     
                     if ([[achievementDescription identifier] isEqualToString:identifier]){
                         
                         // 보낸 ID와 일치하면 달성도에 따라 노티를 보여준다.
                         //NSLog(@"percent:%.0f",percent);
                         if (percent >= 100.0f) { // 100%면 달성완료 노티를...
                             
                             [[GKAchievementHandler defaultHandler]notifyAchievement:achievementDescription];   
                             
                         } else { // 100%가 안되면 진행도를 노티.
                             if ([GameCondition sharedGameCondition].lang == Language_ko) {
                                 [[GKAchievementHandler defaultHandler]notifyAchievementTitle:achievementDescription.title andMessage:[NSString stringWithFormat:@"%.0f%% 완료하셨습니다.",percent]];
                             }else if ([GameCondition sharedGameCondition].lang == Language_en) {
                                 [[GKAchievementHandler defaultHandler]notifyAchievementTitle:achievementDescription.title andMessage:[NSString stringWithFormat:@"%.0f%% Succeed.",percent]];
                             }else {
                                 [[GKAchievementHandler defaultHandler]notifyAchievementTitle:achievementDescription.title andMessage:[NSString stringWithFormat:@"%.0f%% Succeed.",percent]];
                             }
                             
                             
                         }
                         
                     }
                     
                 }                           
                 
             }                     
             
         }];    
        
    }
    
} 

// 테스트할때 현재까지 모든 진행도를 리셋하는 메소드.

+ (void) resetAchievements

{
    
    // Clear all progress saved on Game Center
    
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
     
     {
         
         if (error != nil){}
         
         // handle errors
         
     }];
    
}


//+(GKScore*)getGKScoreObj:(StageCode)stageCode_{
//    GKScore* gkScore;
//    switch (stageCode_) {
//        case STAGE_1 :
//            gkScore = [[[GKScore alloc] initWithCategory:@"rb_stage1"]autorelease];
//            NSLog(@"STAGE_1");
//            break;
//        case STAGE_2 :
//            gkScore = [[[GKScore alloc] initWithCategory:@"rb_stage2"]autorelease];
//            break;
//        case STAGE_3 :
//            gkScore = [[[GKScore alloc] initWithCategory:@"rb_stage3"]autorelease];
//            break;
//        case STAGE_4 :
//            gkScore = [[[GKScore alloc] initWithCategory:@"rb_stage4"]autorelease];
//            break;
//        case STAGE_5 :
//            gkScore = [[[GKScore alloc] initWithCategory:@"rb_stage5"]autorelease];
//            break;
//        case STAGE_6 :
//            gkScore = [[[GKScore alloc] initWithCategory:@"rb_stage6"]autorelease];
//            break;
//        default:
//            break;
//    }
//    return gkScore;
//}


@end
