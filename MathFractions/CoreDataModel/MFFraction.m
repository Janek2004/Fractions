//
//  MFFraction.m
//  MathFractions
//
//  Created by Janusz Chudzynski on 10/7/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import "MFFraction.h"
#import "MFActivity.h"
#import "MFAttempt.h"


@implementation MFFraction

@dynamic denominator;
@dynamic numerator;
@dynamic activity;
@dynamic attempt;

-(NSString *)description{
    return [NSString stringWithFormat:@"%@/%@",self.numerator, self.denominator];
}
@end
