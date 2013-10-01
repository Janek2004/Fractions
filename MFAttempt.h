//
//  MFAttempt.h
//  MathFractions
//
//  Created by Janusz Chudzynski on 9/23/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFAttempt : NSObject <NSCoding>
    @property int score;
    @property int activity;
    @property (nonatomic,strong) NSDate * attempt_date;
    @property (nonatomic,strong) NSArray * fractions;
    
@end
