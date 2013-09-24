//
//  MFAttempt.h
//  MathFractions
//
//  Created by Janusz Chudzynski on 9/23/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFAttempt : NSObject
    @property int score;
    @property int activity;
    @property (nonatomic,strong) NSDate * attempt_date;
    @property (nonatomic,strong) NSArray * fractions;
    
@end



/*
{
 "name": "Janek",
 "lastname": "Chudzynski",
 "user_progress":[{"activity_id":"1", 
 "fraction":{"numerator":"1","denominator":"2"}, 
 "score": "0",
 "attempt_date":"2012/01/01 23:45:10"}],
 "login":["2012/01/01 23:45:10"]
 
}
 
*/