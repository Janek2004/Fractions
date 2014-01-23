//
//  MFUser.h
//  Fractio
//
//  Created by sadmin on 1/22/14.
//  Copyright (c) 2014 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MFAttempt, MFCompleted;

@interface MFUser : NSManagedObject

@property (nonatomic, retain) NSString * classId;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * userid;
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
