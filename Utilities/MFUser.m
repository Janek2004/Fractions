//
//  MFUser.m
//  MathFractions
//
//  Created by Janusz Chudzynski on 9/23/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import "MFUser.h"

@implementation MFUser

-(instancetype)init{
    self = [super init];
    if(self){
        _progress = [NSMutableArray new];
        _completed = [NSMutableArray new];
    }
    return self;
}


-(instancetype)initWithDictionary:(NSDictionary *)dict;{
    self = [super init];
    self.name = dict[@"name"];
    self.userPin = [dict[@"pin"]integerValue];

    return self;
}

@end
