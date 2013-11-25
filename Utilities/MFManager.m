//
//  MFManager.m
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

#import "MFManager.h"

@implementation MFManager


#pragma mark Singleton Methods

+ (id)sharedManager {
    static MFManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
           });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        NSString *baseUrl = @"https://research.fatfractal.com/Fractions/";
        if(!_ff){
            _ff = [[FatFractal alloc] initWithBaseUrl:baseUrl];
            [_ff loginWithUserName:@"Test" andPassword:@"Test1234"];
        }


    }
    return self;
}


@end
