//
//  SoundManager.m
//  KEEPINGSHAPE
//
//  Created by JinWoong Han on 11. 9. 9..
//  Copyright 2011 -. All rights reserved.
//

#import "SoundManager.h"
#import "GameCondition.h"
#import "AudioPlayer.h"


@implementation SoundManager

static SoundManager * _sharedSoundManager = nil;

@synthesize soundDic;

// @synchronized(Object&class){} 괄호 안에 있는 객체의 수행이 끝나기전까지 다른쓰레드의 침입을 차단한다

+(SoundManager*)sharedSM{
    @synchronized([SoundManager class]){
        
        if (!_sharedSoundManager)
            [[SoundManager alloc] init];
        
        return _sharedSoundManager;
    }
    return nil;
}

+(id)alloc {
    @synchronized([SoundManager class]){
        _sharedSoundManager = [super alloc];
        return _sharedSoundManager;
    }
    return nil;
}

-(id)init {
    if ( (self = [super init] )) {
        NSMutableDictionary * tempDic = [[NSMutableDictionary alloc] init];
        self.soundDic = tempDic;
        [tempDic release];
        return self;
    }
    return nil;
    
}

-(SystemSoundID)registerSoundID:(NSString*)soundSource_{
    
    if ([[GameCondition sharedGameCondition] onSound]) {
        
        @try {
            NSNumber *num = (NSNumber*)[self.soundDic objectForKey:soundSource_];
            SystemSoundID soundID;
            NSArray * separationNameNType = [soundSource_ componentsSeparatedByString:@"."];
            
            if (num == nil) {
                NSBundle * mainBundle = [NSBundle mainBundle];
                
                NSString *path = [mainBundle pathForResource:[separationNameNType objectAtIndex:0] ofType:[separationNameNType objectAtIndex:1]];
                
                //path를 통해 만들어진 음악리소스의 경로로 사운드 아이디를 만들어 직접 변수에 넣어줌
                AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID);
                
                num = [[NSNumber alloc] initWithUnsignedLong:soundID];
                [self.soundDic setObject:num forKey:soundSource_];
                
            }else{
                soundID = [num unsignedLongValue];
            }
            
            return soundID;
            
        }@catch (NSException * e) {
            
            NSLog(@"Exception from playSystemSound:%@ for '%@'",e,soundSource_);
            return -1;
        }
        
    }else{
        return -1;
    }
}

-(void)playSound:(NSString *)soundSource_{
    if ([[GameCondition sharedGameCondition] onSound]) {
        SystemSoundID soundID = [self registerSoundID:soundSource_];
        if (soundID != -1) {
            AudioServicesPlaySystemSound(soundID);
        }
    }
    
}

-(void)playButtonTouchBegin{
    [self playSound:@"Cartoon Accent 17.caf"];
}

-(void)playButtonTouch{
    [self playSound:@"Button Down Up.wav"]; //테일즈위버 사운드 376.wav
}

-(void)playJumpingSoundEffect{
    //[self playSound:@"jumping.wav"];
    [self playSound:@"jumping.wav"];
}

-(void)playMissionClearSE{
    [self playSound:@"0121.wav"];
}

-(void)dragCardSE{
    [self playSound:@"dragCard.wav"];
}

-(void)dealloc {
    if (self.soundDic != nil && [self.soundDic count] > 0) {
        NSArray * IDs = [self.soundDic allKeys];
        for (int i = 0;  i < [IDs count]; i++) {
            
            NSNumber * num = (NSNumber*)[self.soundDic objectForKey:[IDs objectAtIndex:i]];
            
            if (num == nil) 
                continue; //continue 는 반복문의 한번의 반복을 건너뜀 break는 반복문 수행 중지
            
            SystemSoundID soundID = [num unsignedLongValue];
            AudioServicesDisposeSystemSoundID(soundID);
            
        }
    }
    
    [soundDic release];
    [super dealloc];
}

@end
