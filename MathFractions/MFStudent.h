//
//  MFUser.h
//  Fractio
//
//  Created by Janusz Chudzynski on 1/23/14.
//  Copyright (c) 2014 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MFAttempt, MFCompleted;

@interface MFStudent : NSObject

@property (nonatomic, retain) NSString * classId;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * lastname;
@end


