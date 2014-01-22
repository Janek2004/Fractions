//
//  MFFractalUser.h
//  MathFractions
//
//  Created by Janusz Chudzynski on 10/10/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFStudent : NSObject
    @property(nonatomic,strong) NSString * username;
    @property(nonatomic,strong) NSString * firstname;
    @property(nonatomic,strong) NSString * lastname;
    @property(nonatomic,strong) NSString * password;
    @property(nonatomic,strong) NSString * classId;
    @property(nonatomic,strong) NSString * email;

@end
