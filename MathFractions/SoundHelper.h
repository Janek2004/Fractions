//
//  SoundHelper.h
//  MathFractions
//
//  Created by Janusz Chudzynski on 11/20/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//
@import AudioToolbox;
#import <Foundation/Foundation.h>

@interface SoundHelper : NSObject
-(void)playSound:(BOOL) correct;
-(void)playBackgroundMusic;
-(void)stopBackgroundMusic;

@end
