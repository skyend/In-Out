//
//  AudioPlayee.h
//  KEEPINGSHAPE
//
//  Created by JinWoong Han on 11. 9. 10..
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "GameConfig.h"

typedef enum{
    kAudio_Background

}AudioPlayerType;

@interface AudioPlayer : NSObject {
    AVAudioPlayer * backGroundAudioPlayer;
    
    NSMutableDictionary * registeredBGMs;
    
    NSMutableArray * effectSounds;
    
    NSTimer * audioKiller;
}
@property (nonatomic ,retain) AVAudioPlayer * backGroundAudioPlayer;

+(AudioPlayer*)sharedAudioPlayer;



-(void)playAudio:(NSString*)audioSource_;
-(void)playAudio:(NSString*)audioSource_ volumn:(float)volumn_;
-(void)stopAudio:(NSString*)audioSource_;
-(void)playEffectSound:(NSString*)soundSource_;
-(void)stageBGMSetting:(StageCode)stageCode_;
-(void)delete_EffectSound_Interval:(id)sender;
-(void)allStopAudio;

@end
