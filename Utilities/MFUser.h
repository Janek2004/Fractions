//
//  MFUser.h
//  MathFractions
//
//  Created by Janusz Chudzynski on 9/23/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFUser : NSObject
-(instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic,strong) NSMutableArray * progress;
@property (nonatomic,strong) NSMutableArray * completed;
@property(nonatomic) int  userPin;
@property(nonatomic,strong)  NSString * name;


@end
