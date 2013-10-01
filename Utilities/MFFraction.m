//
//  MFFraction.m
//  MathFractions
//
/*
 Author: Janusz Chudzynski
 The MIT License (MIT)
 
 Copyright 2010 University of West Florida. All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "MFFraction.h"

@implementation MFFraction

-(instancetype)initWithNumerator:(int)n andDenominatro:(int)d{
    if(self = [super init]){
        self.numerator = n;
        self.denominator = d;
    }
    return self;
}

-(float)value{
    return self.numerator*1.0/self.denominator*1.0;
}
- (NSComparisonResult)compare:(MFFraction *)otherObject {
    float a =  self.numerator/self.denominator;
    float b = otherObject.numerator/otherObject.denominator;
   if(a==b)
   {
       return NSOrderedSame;
   }
    if(a<b){
        return NSOrderedAscending;
    }
    return NSOrderedDescending;
}
- (BOOL)isEqual:(id)object
{
    // MONInteger allows a comparison to NSNumber
    if ([object isKindOfClass:[MFFraction class]]) {
        MFFraction * other = (MFFraction *)object;
        return self.numerator == other.numerator && self.denominator == other.denominator;
    }
        return NO;
}


@end
