//
//  MFAttempt.h
//  MathFractions
//
//  Created by Janusz Chudzynski on 10/1/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MFUser;

@interface MFAttempt : NSManagedObject

@property (nonatomic) int16_t activity;
@property (nonatomic) NSTimeInterval attempt_date;
@property (nonatomic) int16_t score;
@property (nonatomic, retain) MFUser *user;

@end
