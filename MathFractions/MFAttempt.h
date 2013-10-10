//
//  MFAttempt.h
//  MathFractions
//
//  Created by Janusz Chudzynski on 10/10/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MFFraction, MFUser;

@interface MFAttempt : NSManagedObject

@property (nonatomic, retain) NSNumber * activity;
@property (nonatomic, retain) NSDate * attempt_date;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSNumber * saved;
@property (nonatomic, retain) NSSet *fractions;
@property (nonatomic, retain) MFUser *user;
@end

@interface MFAttempt (CoreDataGeneratedAccessors)

- (void)addFractionsObject:(MFFraction *)value;
- (void)removeFractionsObject:(MFFraction *)value;
- (void)addFractions:(NSSet *)values;
- (void)removeFractions:(NSSet *)values;

@end
