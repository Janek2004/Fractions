//
//  MFCompleted.h
//  MathFractions
//
//  Created by Janusz Chudzynski on 10/3/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MFUser;

@interface MFCompleted : NSManagedObject

@property (nonatomic, retain) NSDate * completed_date;
@property (nonatomic, retain) NSNumber * activity;
@property (nonatomic, retain) MFUser *user;

@end
