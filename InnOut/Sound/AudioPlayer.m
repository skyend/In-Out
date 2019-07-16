//
//  AudioPlayee.m
//  KEEPINGSHAPE
//
//  Created by JinWoong Han on 11. 9. 10..
//  Copyright 2011 -. All rights reserved.
//

#import "AudioPlayer.h"
#import "GameCondition.h"
@interface AudioPlayer (privateMethods)
-(AVAudioPlayer*)createAudioPlayer:(NSString*)audioSource_ volumn:(CGFloat)volumn_;
@end

@implementation AudioPlayer
@synthesize backGroundAudioPlayer;

static AudioPlayer * _sharedAudioPlayer = nil;

+(AudioPlayer*)sharedAudioPlayer{
    //@synchronized([AudioPlayer class]){
        if (!_sharedAudioPlayer)
            [[self alloc] init];
            
        return _sharedAudioPlayer;
    //}
    
    return nil;
}

+(id)alloc {
    //@synchronized([AudioPlayer class]){
        
        _sharedAudioPlayer = [super alloc];
        
        return _sharedAudioPlayer;
        
    //}
    
    return nil;
}

-(id)init{
    if ( ( self = [super init] ) ) {
        
        registeredBGMs = [[NSMutableDictionary alloc] init];
        effectSounds = [[NSMutableArray alloc] init];
        
        //audioKiller = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(delete_EffectSound_Interval:) userInfo:nil repeats:YES];
        
        return self;
    }
    
    return nil;
}

-(AVAudioPlayer*)createAudioPlayer:(NSString*)audioSource_ volumn:(CGFloat)volumn_{
    
    NSArray * separationFileName = [audioSource_ componentsSeparatedByString:@"."];
    
    NSString * audioPath = [[NSBundle mainBundle] pathForResource:[separationFileName objectAtIndex:0] ofType:[separationFileName objectAtIndex:1]];
    
    AVAudioPlayer * tmpAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:audioPath] error:NULL];
    
    tmpAudioPlayer.numberOfLoops = 0;
    tmpAudioPlayer.volume = volumn_;
    
    [tmpAudioPlayer prepareToPlay];
    [tmpAudioPlayer autorelease];
    
    return tmpAudioPlayer;
}

-(void)playEffectSound:(NSString*)soundSource_{
    if (![[GameCondition sharedGameCondition] onSound])
        return;
    
    //if ([effectSounds count] < 10) {
        AVAudioPlayer * audioPlayer = [self createAudioPlayer:soundSource_ volumn:0.7f];
        
        audioPlayer.numberOfLoops = 1;
        
        [audioPlayer play];
        
        [effectSounds addObject:audioPlayer];
    //}
    
    
}

-(void)playAudio:(NSString*)audioSource_{
    if (![[GameCondition sharedGameCondition] onBGM])
        return;
    
    AVAudioPlayer * audioPlayer = [self createAudioPlayer:audioSource_ volumn:0.7f];
    
    [registeredBGMs setValue:audioPlayer forKey:audioSource_];
    
    audioPlayer.numberOfLoops = -1;
    
    [audioPlayer play];
}

-(void)playAudio:(NSString*)audioSource_ volumn:(float)volumn_{
    if (![[GameCondition sharedGameCondition] onBGM])
        return;
    
    AVAudioPlayer * audioPlayer = [self createAudioPlayer:audioSource_ volumn:volumn_];
    
    [registeredBGMs setValue:audioPlayer forKey:audioSource_];
    
    audioPlayer.numberOfLoops = -1;
    
    [audioPlayer play];
}

-(void)stopAudio:(NSString*)audioSource_{
    
    AVAudioPlayer * audioPlayer = [registeredBGMs valueForKey:audioSource_];
    
    if (audioPlayer != nil) {
        
        [audioPlayer stop];
        audioPlayer.currentTime = 0;
        
    }
}

-(void)delete_EffectSound_Interval:(id)sender {
    NSMutableArray * killedAudioPlayers = [[[NSMutableArray alloc] init] autorelease];
    //NSLog(@"Effect Sound Count:%d",[effectSounds count]);
    
    for (int i = 0; i < [effectSounds count]; i++) {
        AVAudioPlayer * av = [effectSounds objectAtIndex:i];
        
        if (av.playing == NO) {
            
            [killedAudioPlayers addObject:av];
            
            //NSLog(@"remove register effectSound");
        }
    }
    
    while ([killedAudioPlayers count] != 0) {
        [effectSounds removeObject:[killedAudioPlayers objectAtIndex:0]];
        [killedAudioPlayers removeObject:[killedAudioPlayers objectAtIndex:0]];
        
        //NSLog(@"remove effectSound");
    }
    
    //NSLog(@"killer action");
    
}

-(void)stageBGMSetting:(StageCode)stageCode_{
    switch (stageCode_) {
        case STAGE_1 :
            [[AudioPlayer sharedAudioPlayer] playAudio:@"Jungle Day.mp3" volumn:0.5f];
            [[AudioPlayer sharedAudioPlayer] playAudio:@"Wind 4.mp3" volumn:0.4f];
            [[AudioPlayer sharedAudioPlayer] playAudio:@"st1_hill.mp3" volumn:0.9f];
            break;
        case STAGE_2 :
            
            [[AudioPlayer sharedAudioPlayer] playAudio:@"Wind 4.mp3" volumn:0.4f];
            break;
        case STAGE_3 :
            [[AudioPlayer sharedAudioPlayer] playAudio:@"Underwater.mp3" volumn:0.4f];
            [[AudioPlayer sharedAudioPlayer] playAudio:@"Water Bubbles.mp3" volumn:0.4f];
            [[AudioPlayer sharedAudioPlayer] playAudio:@"st3_water.mp3" volumn:0.9f];
            break;
        case STAGE_4 :
            [[AudioPlayer sharedAudioPlayer] playAudio:@"Birds FX 02.mp3" volumn:0.4f];
            [[AudioPlayer sharedAudioPlayer] playAudio:@"Forest Stream River Water 01.mp3" volumn:0.4f];
            [[AudioPlayer sharedAudioPlayer] playAudio:@"st4_Jungle.mp3" volumn:0.9f];
            break;
        case STAGE_5 :
            [[AudioPlayer sharedAudioPlayer] playAudio:@"Volcano Lava 02.mp3" volumn:0.4f];
            [[AudioPlayer sharedAudioPlayer] playAudio:@"Wind 4.mp3" volumn:0.4f];
            [[AudioPlayer sharedAudioPlayer] playAudio:@"Thunder and Lightning 3.caf" volumn:0.6f];
            [[AudioPlayer sharedAudioPlayer] playAudio:@"st5_volcano.mp3" volumn:0.9f];
            //[[AudioPlayer sharedAudioPlayer] playAudio:@"Thunder and Lightning 2.caf"];
            break;
            
        default:
            break;
    }
}

-(void)allStopAudio{
    if (registeredBGMs != nil) {
        NSArray * bgmKeys = [registeredBGMs allKeys];
        
        for (int i = 0; i < [bgmKeys count]; i++) {
            
            AVAudioPlayer * audioPlayer = [registeredBGMs valueForKey:[bgmKeys objectAtIndex:i]];
            
            [audioPlayer stop];
            audioPlayer.currentTime = 0;
            
        }
        [registeredBGMs release];
        
        registeredBGMs = [[NSMutableDictionary alloc] init];
    }
}



-(void)dealloc {
    
    NSArray * bgmKeys = [registeredBGMs allKeys];
    
    for (int i = 0; i < [bgmKeys count]; i++) {
        
        AVAudioPlayer * audioPlayer = [registeredBGMs valueForKey:[bgmKeys objectAtIndex:i]];
        
        [audioPlayer stop];
        audioPlayer.currentTime = 0;
        
    }
    
    [effectSounds release];
    [registeredBGMs release];
    [super dealloc];
}

@end
