//
//  MFFractalAttempt.h
//  MathFractions
//
//  Created by Janusz Chudzynski on 10/10/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MFFractalFraction ;

@interface MFFrAttempt : NSObject
@property (nonatomic, retain) NSNumber * activity;
@property (nonatomic, retain) NSDate * attempt_date;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSArray *fractions;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * mfclassId;
@property (nonatomic, retain) MFFractalFraction * answer;


@end
