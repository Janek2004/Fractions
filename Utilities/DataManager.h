//
//  DataManager.h
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
#import <UIKit/UIKit.h>
@class MFActivity;
@class MFAttempt;
@class MFLocalStudent;
@class MFFraction;

@interface DataManager : NSObject
-(MFActivity *)getActivity:(int)activityId;
-(void)saveAttemptWithScore:(int)score andActivity:(MFActivity *)activity andFractions:(NSSet *)fractions andAnswer:(MFFraction *)answer;
-(void)markActivity:(int )activity asCompletedForUser:(MFLocalStudent *)user;
-(MFLocalStudent *)getCurrentUser;
-(MFLocalStudent *)findUserWithId: (NSString *)userId;
-(MFLocalStudent *)findUserWith:(NSString *)username andPassword:(NSString *)password;

-(void)loginUser:(MFLocalStudent *)user;
-(void)loginUser:(NSString *)username andPassword:(NSString *)password block:(void (^)())block;

-(NSDictionary *)getLocalJSON;
-(void)import;
-(void)addNewUserWithPassword:(NSString *)pin andName:(NSString *)name classId:(NSString *)classId first:(NSString *)firstName last:(NSString *)lastName successBlock:(void (^)(id obj))block responseBlock:(void (^)(NSError * error))errorBlock;

-(void)updateData:(NSManagedObject *)object;
-(MFFraction *)getFractionInContext:(NSManagedObjectContext *)context;

-(void)logout;

@end
