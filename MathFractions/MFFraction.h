//
//  MFFraction.h
//  Fractio
//
//  Created by Janusz Chudzynski on 1/23/14.
//  Copyright (c) 2014 UWF. All rights reserved.
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
