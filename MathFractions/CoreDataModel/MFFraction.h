//
//  MFFraction.h
//  MathFractions
//
//  Created by Janusz Chudzynski on 10/1/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MFActivity;

@interface MFFraction : NSManagedObject

@property (nonatomic) int16_t denominator;
@property (nonatomic) int16_t numerator;
@property (nonatomic, retain) MFActivity *activity;

@end
