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


@interface DataManager()
@property (nonatomic,strong) NSMutableDictionary * appData;

@end

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
    
   
    if(!self.appData){
        [self getLocalJSON];
    }

   NSArray * a = [self.appData objectForKey:@"activities"];
   __block MFActivityModel * activity;
    [a enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
       if([[obj objectForKey:@"id"]integerValue]== activityId)
       {
           activity = [[MFActivityModel alloc]initWithDictionary:obj];
           //get sets
           int set = [[obj objectForKey:@"set"]integerValue];
           int nr_fraction_inquestion = [[obj objectForKey:@"nr_fraction_inquestion"]integerValue];
           
           NSMutableArray * a = [self randomize:Nil fromSet:[[self getSet: set   fromDict:self.appData]mutableCopy] andDesiredCount:activity.maxQuestions * nr_fraction_inquestion];
           if(nr_fraction_inquestion>1){
               //select pairs
               NSMutableArray * array = [NSMutableArray new];
               while(a.count>0) {
                int random =arc4random()%a.count;
                MFFraction  *a1 = a[random];
               [a removeObjectAtIndex:random];
                MFFraction  *a2 = a[arc4random()%a.count];
                random =arc4random()%a.count;
               [a removeObjectAtIndex:random];
                NSArray * k =@[a1,a2];
               [array addObject:k];
               }
               activity.questionsSet = array;

               
           }else{
               activity.questionsSet = a;

           }
           
           
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
   
    NSString *docFolder = [DataManager applicationDocumentsDirectory];
    NSString * docPath = [docFolder stringByAppendingPathComponent:@"data.json"];
    NSError * err;
  
    
    if([[NSFileManager defaultManager]fileExistsAtPath:docPath isDirectory:NO])
    {
        NSData *data = [NSData dataWithContentsOfFile:docPath options:NSDataReadingMappedIfSafe error:&err];
        if(err){
            NSLog(@"Docs Error %@", err.debugDescription);
            return nil;
        }
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        if(err){
            NSLog(@"Docs to JSON Error %@", err.debugDescription);
        }
        self.appData = [json mutableCopy];
        
        NSLog(@"App Data is: %@",self.appData);
        return self.appData;
    }
   
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
    self.appData = [json mutableCopy];
    return json;
}


-(MFUser *)findUserWithPin:(NSString *)pin andName:(NSString *)name{
    if(!self.appData){
     [self getLocalJSON];
    }
    
        NSArray * users = [self.appData objectForKey:@"users"];
    __block MFUser * mf;
    

    [users enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
        
        MFUser * mf1 = [[MFUser alloc]initWithDictionary:obj];
        //get completed
        NSMutableArray * completed = [obj objectForKey:@"completed"];
        mf1.completed = completed;
        
        if([mf1.name isEqualToString: name] &&  pin.integerValue == mf1.pin){
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
    
    if(!self.appData){
        [self getLocalJSON];
    }
    
    
    NSArray * users = [self.appData objectForKey:@"users"];
    __block MFUser * mf;
    
    [users enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
     
       MFUser * mf1 = [[MFUser alloc]initWithDictionary:obj];
        if([mf1.name isEqualToString: userName] && mf1.pin== userPin.integerValue){
            
            NSMutableArray * completed = [obj objectForKey:@"completed"];
            mf1.completed = completed;

            mf= mf1;
            *stop = YES;
        }
    }];
    return mf;    
}

-(void)saveAttempt:(MFAttempt *)attempt forUser:(MFUser *)user{
    // get current user
    NSMutableArray * array = user.progress;
    [array addObject:attempt];
    user.progress = array;

    //save to disk will be performed in  app delegate
    if(!self.appData){
        [self getLocalJSON];
    }
    
    NSMutableArray * users = [[self.appData objectForKey:@"users"]mutableCopy];
//    __block MFUser * mf = user;
    [users enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
        
        MFUser * mf1 = [[MFUser alloc]initWithDictionary:obj];
        
        if([mf1.name isEqualToString: user.name] &&  user.pin == mf1.pin){
            [users replaceObjectAtIndex:idx withObject:user];
     
            [self.appData setObject:users forKey:@"users"];
            *stop = YES;
        }
    }];

    NSError * err;
    
    NSString *docFolder = [DataManager applicationDocumentsDirectory];
    NSString * path = [docFolder stringByAppendingPathComponent:@"data.json"];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self.appData options:NSJSONWritingPrettyPrinted error:&err];
    [jsonData writeToFile:path atomically:YES];

}


+ (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}



-(void)markActivity:(int )activity asCompletedForUser:(MFUser *)user{
    
    

}


-(void)loginUser:(MFUser *)user{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];

    [ud setObject: [NSNumber numberWithInt:user.pin] forKey:@"current_pin"];
    [ud setObject:user.name    forKey:@"current_user"];
    [ud synchronize];
}


@end
