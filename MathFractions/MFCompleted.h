//
//  MFCompleted.h
//  MathFractions
//
//  Created by Janusz Chudzynski on 10/1/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MFUser;

@interface MFCompleted : NSManagedObject

@property (nonatomic) NSTimeInterval completed_date;
@property (nonatomic, retain) MFUser *activity;

@end
