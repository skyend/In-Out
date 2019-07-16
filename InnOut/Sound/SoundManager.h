//
//  SoundManager.h
//  KEEPINGSHAPE
//
//  Created by JinWoong Han on 11. 9. 9..
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SoundManager : NSObject {
    NSMutableDictionary * soundDic;
}

@property (nonatomic,retain) NSMutableDictionary * soundDic;

+(SoundManager*)sharedSM;
-(void)playSound:(NSString*)soundSource_;
-(SystemSoundID)registerSoundID:(NSString*)soundSource_;
-(void)playButtonTouchBegin; //ccMenu.m에서 부르는 메소드
-(void)playJumpingSoundEffect; //CCActionInterval.m CCJumpBy update:에서 부름
-(void)playButtonTouch; //CCMenuItem.m 에서 부르는 메소드
-(void)playMissionClearSE;
-(void)dragCardSE;
@end
