//
//  MFActivity.h
//  MathFractions
//
//  Created by Janusz Chudzynski on 10/1/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MFFraction;

@interface MFActivity : NSManagedObject

@property (nonatomic) int16_t activityid;
@property (nonatomic, retain) NSString * class_name;
@property (nonatomic) int16_t maxQuestions;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * standard;
@property (nonatomic) int16_t fractionCount;
@property (nonatomic, retain) NSSet *set;
@end

@interface MFActivity (CoreDataGeneratedAccessors)

- (void)addSetObject:(MFFraction *)value;
- (void)removeSetObject:(MFFraction *)value;
- (void)addSet:(NSSet *)values;
- (void)removeSet:(NSSet *)values;

@end
