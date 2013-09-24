//
//  NSArray+RandomArray.m
//  MathFractions
//
//  Created by Janusz Chudzynski on 9/23/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import "NSArray+RandomArray.h"

@implementation NSArray (RandomArray)
-(NSArray *) getRandomSetOf:(int)numberOfQuestions fromArray:(NSMutableArray *)defaultSet{
    
    NSMutableArray * randomSet = [NSMutableArray new];
    
    while(randomSet.count<numberOfQuestions)
    {
        int randomIndex= arc4random()%randomSet.count;
        id object = defaultSet[randomIndex];
        [defaultSet removeObjectAtIndex:randomIndex];
        [randomSet addObject:object];
        
	}//End of while loop
    
    return randomSet;
}//End of the -(void) calculate

@end
