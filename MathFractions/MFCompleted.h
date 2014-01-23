//
//  MFCompleted.h
//  Fractio
//
//  Created by Janusz Chudzynski on 1/23/14.
//  Copyright (c) 2014 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MFStudent;

@interface MFCompleted : NSManagedObject

@property (nonatomic, retain) NSNumber * activity;
@property (nonatomic, retain) NSDate * completed_date;
@property (nonatomic, retain) MFStudent *user;

@end
