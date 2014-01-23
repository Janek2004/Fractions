//
//  MFAttempt.h
//  Fractio
//
//  Created by Janusz Chudzynski on 1/23/14.
//  Copyright (c) 2014 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MFFraction, MFStudent;

@interface MFAttempt : NSManagedObject

@property (nonatomic, retain) NSNumber * activity;
@property (nonatomic, retain) NSDate * attempt_date;
@property (nonatomic, retain) NSNumber * saved;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * userid;
@property (nonatomic, retain) NSSet *fractions;
@property (nonatomic, retain) MFStudent *user;
@end

@interface MFAttempt (CoreDataGeneratedAccessors)

- (void)addFractionsObject:(MFFraction *)value;
- (void)removeFractionsObject:(MFFraction *)value;
- (void)addFractions:(NSSet *)values;
- (void)removeFractions:(NSSet *)values;

@end
