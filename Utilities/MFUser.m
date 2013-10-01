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
-(NSDictionary *)dictionaryRepresentation;{
    /*
     "id":"1",
     "name": "Janek",
     "pin":"1111",
     "completed":[1,3,5],
     "progress":[
     {"activity_id":"1",
     "fraction":{"numerator":"1","denominator":"2"},
     "score": "0",
     "attempt_date":"2012/01/01 23:45:10"
     }
     ]
     }
     */
    
   NSNumber * pin = [NSNumber numberWithInt:self.pin];
    
    return @{@"name":self.name,@"pin":pin,@"completed":self.completed,@"progress":self.progress};

}

-(instancetype)initWithDictionary:(NSDictionary *)dict;{
    self = [super init];
    self.name = dict[@"name"];
    self.pin = [dict[@"pin"]integerValue];
    self.completed = [dict[@"completed"]mutableCopy];
    self.progress = [dict[@"progress"]mutableCopy];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.progress forKey:@"progress"];
    [encoder encodeObject:self.completed forKey:@"completed"];
    [encoder encodeObject:[NSNumber numberWithInt:self.pin] forKey:@"pin"];
    [encoder encodeObject:self.name forKey:@"name"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.name = [decoder decodeObjectForKey:@"name"];
        self.completed= [decoder decodeObjectForKey:@"completed"];
        self.progress = [decoder decodeObjectForKey:@"progress"];
        self.pin = [[decoder decodeObjectForKey:@"pin"]integerValue];
        
    }
    return self;
}




@end
