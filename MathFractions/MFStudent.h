//
//  MFUser.h
//  Fractio
//
//  Created by Janusz Chudzynski on 1/23/14.
//  Copyright (c) 2014 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MFAttempt, MFCompleted;

@interface MFStudent : NSManagedObject

@property (nonatomic, retain) NSString * classId;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * userid;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSSet *attempts;
@property (nonatomic, retain) NSSet *completed;
@end

@interface MFStudent (CoreDataGeneratedAccessors)

- (void)addAttemptsObject:(MFAttempt *)value;
- (void)removeAttemptsObject:(MFAttempt *)value;
- (void)addAttempts:(NSSet *)values;
- (void)removeAttempts:(NSSet *)values;

- (void)addCompletedObject:(MFCompleted *)value;
- (void)removeCompletedObject:(MFCompleted *)value;
- (void)addCompleted:(NSSet *)values;
- (void)removeCompleted:(NSSet *)values;

@end
