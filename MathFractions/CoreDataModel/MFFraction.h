//
//  MFFraction.h
//  MathFractions
//
//  Created by Janusz Chudzynski on 10/7/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MFActivity, MFAttempt;

@interface MFFraction : NSManagedObject

@property (nonatomic, retain) NSNumber * denominator;
@property (nonatomic, retain) NSNumber * numerator;
@property (nonatomic, retain) MFActivity *activity;
@property (nonatomic, retain) NSSet *attempt;
@end

@interface MFFraction (CoreDataGeneratedAccessors)

- (void)addAttemptObject:(MFAttempt *)value;
- (void)removeAttemptObject:(MFAttempt *)value;
- (void)addAttempt:(NSSet *)values;
- (void)removeAttempt:(NSSet *)values;

@end
