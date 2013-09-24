//
//  DataManager.m
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

#import "DataManager.h"
#import "MFActivityModel.h"
#import "MFFraction.h"
#import "MFUser.h"
#import "MFAttempt.h"

@implementation DataManager

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}


-(NSMutableArray *)randomize:(NSMutableArray *) array fromSet:(NSMutableArray *)defaultSet andDesiredCount:(int)count
{
    if(!array){
        array = [NSMutableArray new];
    }
    //desired count
    if(array.count == count){
        return array;
    }
    else{
        int index = arc4random()%defaultSet.count;
        id obj = defaultSet[index];
        [defaultSet removeObjectAtIndex:index];
        [array addObject:obj];
        
        [self randomize:array fromSet:defaultSet andDesiredCount:count];
    
    }
    
    return array;
    
}




-(MFActivityModel *)getActivity:(int)activityId{
    
    //get all data
   NSDictionary *dict = [self getLocalJSON];
   NSArray * a = [dict objectForKey:@"activities"];
   __block MFActivityModel * activity;
    [a enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
       if([[obj objectForKey:@"id"]integerValue]== activityId)
       {
           activity = [[MFActivityModel alloc]initWithDictionary:obj];
           //get sets
           int set = [[obj objectForKey:@"set"]integerValue];
           NSMutableArray * a = [self randomize:Nil fromSet:[[self getSet: set   fromDict:dict]mutableCopy] andDesiredCount:activity.maxQuestions];
           
           activity.questionsSet = a;
           
           *stop = YES;
       }
   }];
    
    
    return activity;
    
}

-(NSArray *)getSet:(int)setId fromDict:(NSDictionary *)dict {
    NSMutableArray * fractions = [NSMutableArray new];
    NSArray * a = [dict objectForKey:@"sets"];
    [a enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
        if([[obj objectForKey:@"id"]integerValue] == setId)
        {
            NSArray * numerators = [obj objectForKey:@"numerator"];
            NSArray * denominators = [obj objectForKey:@"denominator"];
            if(numerators.count !=denominators.count){
                *stop = YES;
            }
            
            for(int i=0; i<numerators.count;i ++){
                
                MFFraction * fraction =[[MFFraction alloc]initWithNumerator:[numerators[i] integerValue] andDenominatro:[ denominators[i] integerValue]];
                [fractions addObject: fraction];
            
            }
            *stop = YES;
        }

    }];
    
    
     return fractions;
}



-(NSDictionary *)getLocalJSON{
    NSError * err;
    NSString * path = [[NSBundle mainBundle]pathForResource:@"data" ofType:@"json"];

    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&err];
    if(err){
        NSLog(@"Error %@", err.debugDescription);
        return nil;
    }
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
    if(err){
        NSLog(@"Error %@", err.debugDescription);
    }
    

    
    return json;
}


-(MFUser *)findUserWithPin:(NSString *)pin andName:(NSString *)name{
    NSDictionary * dict = [self getLocalJSON];
    NSArray * users = [dict objectForKey:@"users"];
    __block MFUser * mf;
    

    [users enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
        
        MFUser * mf1 = [[MFUser alloc]initWithDictionary:obj];
        //get completed
        NSMutableArray * completed = [obj objectForKey:@"completed"];
        mf1.completed = completed;
        
        if([mf1.name isEqualToString: name] &&  pin.integerValue == mf1.userPin){
               mf= mf1;
            *stop = YES;
        }
    }];
    
     return mf;
    
}

-(MFUser *)getCurrentUser{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];

    NSString *userName= [ud objectForKey:@"current_user"];
    NSString *userPin= [ud objectForKey:@"current_pin"];

    if(!userName) return nil;
    
    NSDictionary * dict = [self getLocalJSON];
    NSArray * users = [dict objectForKey:@"users"];
    __block MFUser * mf;
    
    [users enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
     
       MFUser * mf1 = [[MFUser alloc]initWithDictionary:obj];
        if([mf1.name isEqualToString: userName] && mf1.userPin== userPin.integerValue){
            
            NSMutableArray * completed = [obj objectForKey:@"completed"];
            mf1.completed = completed;

            mf= mf1;
            *stop = YES;
        }
    }];
    return mf;
    
}




-(void)saveAttempt:(MFAttempt *)attempt forUser:(MFUser *)user{
    
   
}


-(void)loginUser:(MFUser *)user{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];

    [ud setObject: [NSNumber numberWithInt:user.userPin] forKey:@"current_pin"];
    [ud setObject:user.name    forKey:@"current_user"];
    [ud synchronize];
}


@end
