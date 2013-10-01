//
//  MFAttempt.m
//  MathFractions
//
//  Created by Janusz Chudzynski on 9/23/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import "MFAttempt.h"

@implementation MFAttempt

- (void)encodeWithCoder:(NSCoder *)encoder {
   
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.attempt_date forKey:@"date"];
    [encoder encodeObject:self.fractions forKey:@"fractions"];

    [encoder encodeObject:[NSNumber numberWithInt:self.score] forKey:@"score"];
    [encoder encodeObject:[NSNumber numberWithInt:self.activity] forKey:@"activity"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.attempt_date = [decoder decodeObjectForKey:@"date"];
        self.fractions= [decoder decodeObjectForKey:@"completed"];
        
        self.score = [[decoder decodeObjectForKey:@"score"]integerValue];
        self.activity = [[decoder decodeObjectForKey:@"activity"]integerValue];
        
    }
    return self;
}


@end
