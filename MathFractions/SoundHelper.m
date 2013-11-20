//
//  SoundHelper.m
//  MathFractions
//
//  Created by Janusz Chudzynski on 11/20/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import "SoundHelper.h"
@import AVFoundation;

@interface SoundHelper()
 @property(nonatomic) SystemSoundID correctSound;
 @property(nonatomic) SystemSoundID wrongSound;
 @property(nonatomic,strong) AVAudioPlayer *theAudio;
@end


@implementation SoundHelper
-(instancetype)init{
    if(self=[super init]){
        //initialize sound
        NSURL *correctAudioPath = [[NSBundle mainBundle] URLForResource:@"CorrectBellDing" withExtension:@"aiff"];
        NSURL *wrongAudioPath = [[NSBundle mainBundle] URLForResource:@"WrongBuzzer" withExtension:@"aiff"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)correctAudioPath, &_correctSound);
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)wrongAudioPath, &_wrongSound);
        
      
        
    }
    return self;
}

-(void)playSound:(BOOL) correct{
    if(correct){
       AudioServicesPlaySystemSound (_correctSound);
    }
    else{
       AudioServicesPlaySystemSound (_wrongSound);
    }
}

-(void)playBackgroundMusic{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Simon Says (Theme)" ofType:@"mp3"];
    _theAudio=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    
    _theAudio.numberOfLoops = -1;
     [_theAudio play];
}
-(void)stopBackgroundMusic{
    [_theAudio stop];
}

@end
