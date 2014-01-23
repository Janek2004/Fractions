//
//  MFActivity.h
//  Fractio
//
//  Created by Janusz Chudzynski on 1/23/14.
//  Copyright (c) 2014 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MFFraction;

@interface MFActivity : NSManagedObject

@property (nonatomic, retain) NSNumber * activityid;
@property (nonatomic, retain) NSString * class_name;
@property (nonatomic, retain) NSNumber * fractionCount;
@property (nonatomic, retain) NSNumber * maxQuestions;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * standard;
@property (nonatomic, retain) NSSet *set;
@end

@interface MFActivity (CoreDataGeneratedAccessors)

- (void)addSetObject:(MFFraction *)value;
- (void)removeSetObject:(MFFraction *)value;
- (void)addSet:(NSSet *)values;
- (void)removeSet:(NSSet *)values;

@end
