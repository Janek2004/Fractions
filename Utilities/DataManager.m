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
#import "MFActivity.h"
#import "MFFraction.h"
#import "MFUser.h"
#import "MFAttempt.h"
#import "MFAppDelegate.h"


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


-(MFActivity *)getActivity:(int)activityId{
    
    NSManagedObjectContext *context = [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MFActivity" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:  @"(activityid == %d)",activityId];
    
    [request setPredicate:predicate];
    
    
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"Error %@",error.debugDescription);
    }


    MFActivity *act;
    if(array.count==1){
    
        act= array[0];
        if(!self.appData){
            [self getLocalJSON];
        }
        
//           NSLog(@"Before");
//        NSSet *set = [self getSet:activityId fromDict:self.appData];
//        //randomize it
//        
//           NSLog(@"Before");
//        

        NSMutableArray * a=[self randomize:nil fromSet:act.set.allObjects.mutableCopy  andDesiredCount:act.maxQuestions];
      
        act.set = [NSSet setWithArray:a];
 

        return act;
    }
    return nil;
    
}




-(NSMutableSet *)getSet:(int)setId fromDict:(NSDictionary *)dict {
   NSMutableSet * fractions = [NSMutableSet new];
   NSArray * a = [dict objectForKey:@"sets"];
   NSManagedObjectContext *context =   [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
 
    [a enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
        if([[obj objectForKey:@"id"]integerValue] == setId)
        {
            NSArray * numerators = [obj objectForKey:@"numerator"];
            NSArray * denominators = [obj objectForKey:@"denominator"];
            if(numerators.count !=denominators.count){
                *stop = YES;
                NSLog(@"Incosistent data error");
            }

            for(int i=0; i<numerators.count;i ++){
                
              MFFraction * fraction = [NSEntityDescription insertNewObjectForEntityForName:@"MFFraction" inManagedObjectContext:context];
               fraction.numerator =[numerators[i] integerValue] ;
               fraction.denominator =[denominators[i] integerValue] ;
                
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
    NSManagedObjectContext *context = [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MFUser" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
   
    NSPredicate *predicate = [NSPredicate predicateWithFormat:  @"(name LIKE[c] %@)",name];
    
    [request setPredicate:predicate];
   
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"name" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"Error %@",error.debugDescription);
    }
      MFUser *mf;
    if(array.count==1)
    {
        mf = array[0];
  
    }

    
    
     return mf;
    
}

-(MFUser *)getCurrentUser{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];

    NSString *userName= [ud objectForKey:@"current_user"];
    NSString *userPin= [ud objectForKey:@"current_pin"];
    if(!userName||!userPin) return nil;

    MFUser * user=   [self findUserWithPin:userPin andName:userName];
    return user;
}

-(void)saveAttemptWithScore:(int)score andActivity:(MFActivity *)activity{
    
    NSManagedObjectContext *context =   [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
    
    MFAttempt *at = [NSEntityDescription insertNewObjectForEntityForName:@"MFAttempt" inManagedObjectContext:context];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    at.score = score;
    at.attempt_date =time;
    at.user = self.getCurrentUser;
    
    NSError * error;
    [context save:&error];

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

-(void)import{
    [self getLocalJSON];

    NSArray * a = [self.appData objectForKey:@"activities"];
  
    [a enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {

        NSManagedObjectContext *context =   [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];

        MFActivity *act = [NSEntityDescription insertNewObjectForEntityForName:@"MFActivity" inManagedObjectContext:context];
        act.activityid = [obj[@"id"]integerValue];
        act.name =obj[@"name"];
        act.class_name = obj[@"classname"];
        act.standard = obj[@"standard"];
        act.maxQuestions = [obj[@"questioncount"]integerValue];
        act.fractionCount =[obj[@"nr_fraction_inquestion"]integerValue];
        
        //get raw set
        NSSet *set = [self getSet:[obj[@"set"]integerValue] fromDict:self.appData];
        //randomize it
      //  NSMutableArray * a=[self randomize:nil fromSet:set.allObjects.mutableCopy  andDesiredCount:act.maxQuestions];
        
        act.set = set; //[NSSet setWithArray:a.a];
        
        //save it
        NSError * error;
        [context save:&error];
        if(error){
            NSLog(@"Error %@",error.debugDescription);
        
        }
    }];
}


-(MFUser *)addNewUserWithPin:(NSString *)pin andName:(NSString *)name;{
    
    if([self findUserWithPin:pin andName:name]){
        UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Message" message:@"User already exists" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [a show];

        return nil;
    }
    
    NSManagedObjectContext *context = [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];

    MFUser * user = [NSEntityDescription insertNewObjectForEntityForName:@"MFUser" inManagedObjectContext:context];
    user.pin = pin.integerValue;
    user.name = name;
    
    NSError *error;
    [context save:&error];
    if(error){
        NSLog(@"Error %@",error.debugDescription);
        return nil;
    }
    else{
        
        [self loginUser:user];
         return user;
    }
    
}


@end
