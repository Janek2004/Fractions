//
//  MFUser.h
//  MathFractions
//
//  Created by Janusz Chudzynski on 10/1/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MFAttempt, MFCompleted;

@interface MFUser : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic) int16_t pin;
@property (nonatomic, retain) NSSet *attempts;
@property (nonatomic, retain) NSSet *completed;
@end

@interface MFUser (CoreDataGeneratedAccessors)

- (void)addAttemptsObject:(MFAttempt *)value;
- (void)removeAttemptsObject:(MFAttempt *)value;
- (void)addAttempts:(NSSet *)values;
- (void)removeAttempts:(NSSet *)values;

- (void)addCompletedObject:(MFCompleted *)value;
- (void)removeCompletedObject:(MFCompleted *)value;
- (void)addCompleted:(NSSet *)values;
- (void)removeCompleted:(NSSet *)values;

@end
