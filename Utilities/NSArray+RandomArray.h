//
//  NSArray+RandomArray.h
//  MathFractions
//
//  Created by Janusz Chudzynski on 9/23/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (RandomArray)
-(NSArray *) getRandomSetOf:(int)numberOfQuestions fromArray:(NSMutableArray *)defaultSet;


@end
