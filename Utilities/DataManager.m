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
#import "MFStudent.h"
#import "MFStudent.h"
#import "MyFractal.h"

#import "MFAttempt.h"
#import "MFAppDelegate.h"
#import "MFCompleted.h"
#import "MFManager.h"
#import "UIBAlertView.h"
#import "MFFrAttempt.h"
#import  "MFFractalFraction.h"


#define USER_NAME_KEY @"current_username"
#define USER_PASS_KEY  @"current_password"
#define USER_ID_KEY  @"current_id"


@interface DataManager()
@property (nonatomic,strong) NSMutableDictionary * appData;
@property (nonatomic,strong) MFManager * manager;
@end

@implementation DataManager

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        _manager = [MFManager sharedManager];
    }
    return self;
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
        
       // NSLog(@"Act %hd %@ %hd",act.maxQuestions, act.set,act.fractionCount);
        
        NSMutableArray * a=[self randomize:nil fromSet:act.set.allObjects.mutableCopy  andDesiredCount:act.maxQuestions.intValue];
       
        
        
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
               fraction.numerator =numerators[i];
               fraction.denominator =denominators[i] ;
                
                [fractions addObject: fraction];

               
            
            }
              *stop = YES;
            }
        }];

    
    
     return fractions;
}


-(MFFraction *)getFractionInContext:(NSManagedObjectContext *)context{
   // NSManagedObjectContext *context =   [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
    NSManagedObjectModel *model =   [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectModel];

    NSEntityDescription *entity = [[model entitiesByName]objectForKey:@"MFFraction"];
    id obj = [[NSManagedObject alloc] initWithEntity:entity
                      insertIntoManagedObjectContext:context];
    return obj;

//     return [NSEntityDescription insertNewObjectForEntityForName:@"MFFraction" inManagedObjectContext:context];
    
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


-(MFStudent *)findUserWithPin:(NSString *)pin andName:(NSString *)name{
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
    MFStudent *mf;
    if(array.count==1)
    {
        mf = array[0];
  
    }

    
    
     return mf;
    
}

-(MFStudent *)getCurrentUser{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];

    NSString *userName= [ud objectForKey:USER_NAME_KEY];
    NSString *userPin= [ud objectForKey:USER_PASS_KEY];
    NSString *userId= [ud objectForKey:USER_ID_KEY];

    if(!userName||!userPin||!userId) return nil;
    MFStudent * user=   [self findUserWithPin:userPin andName:userName];

    user.userid = userId;
    
    return user;
}

-(MFFrAttempt *)createFractalAttemptWithAttempt:(MFAttempt *)attempt{
    MFFrAttempt * mf = [[MFFrAttempt alloc]init];
    mf.score = attempt.score;
    mf.attempt_date = attempt.attempt_date;
    mf.userId=attempt.user.userid;
    assert(mf.userId);
    
    mf.mfclassId = _manager.mfuser.classId;
    mf.mfuid = [NSString stringWithFormat:@"%@",[attempt objectID]];
    mf.activity = attempt.activity;

    NSMutableArray * a =[NSMutableArray new];
    for(MFFraction *fra in attempt.fractions){
        MFFractalFraction *fr = [[MFFractalFraction alloc]init];
        fr.numerator = fra.numerator;
        fr.denominator = fra.denominator;
        
        [a addObject:fr];
        
    }
    NSLog(@"Fractions %@",a);
    mf.fractions =a;
    
    
    
    return mf;
}

-(void)saveAttemptWithScore:(int)score andActivity:(MFActivity *)activity andFractions:(NSSet *)fractions{
    
    NSManagedObjectContext *context =   [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
    
    MFAttempt *at = [NSEntityDescription insertNewObjectForEntityForName:@"MFAttempt" inManagedObjectContext:context];
    at.score = [NSNumber numberWithInt:score];
    at.attempt_date = [NSDate new];
    at.user = self.getCurrentUser;
    at.activity = activity.activityid;
    at.fractions = fractions;
    at.uid = [NSString stringWithFormat:@"%@",[at objectID]];

    
    MFFrAttempt * a = [self createFractalAttemptWithAttempt:at];
    
    NSError * error;
   [_manager.ff createObj:a atUri:@"/MFAttempt" error:&error];
    
    if(error) {
        NSLog(@"Saving Attempt %@",error.debugDescription);
  
    }
    
 }


+ (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

-(void)markActivity:(int )activity asCompletedForUser:(MFStudent *)user{
    [self getActivity:activity];
    NSManagedObjectContext *context =   [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
    
    MFCompleted *at = [NSEntityDescription insertNewObjectForEntityForName:@"MFCompleted" inManagedObjectContext:context];
    at.completed_date = [NSDate new];
    at.activity =[NSNumber numberWithInt:activity];
    at.user = [self getCurrentUser];

    NSError * e;
    [context save:&e];
    if(e){
        NSLog(@"Error: debug desription %@",e.debugDescription);
    }
}


-(void)loginUser:(MFStudent *)user{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];

    [ud setObject: user.password forKey:USER_PASS_KEY];
    [ud setObject:user.username  forKey:USER_NAME_KEY];
    [ud setObject:user.userid forKey:USER_ID_KEY];
    
    [ud synchronize];
}


-(void)loginUser:(NSString *)username andPassword:(NSString *)password block:(void (^)())block{
    NSString * query = [NSString stringWithFormat:@"/MFStudent/((username eq '%@') and (password eq = '%@'))",username, password];
        [_manager.ff getArrayFromUri:query onComplete:^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse) {
            if(theErr){
            
            }
        }];

    
//    [_manager.ff getArrayFromUri:query onComplete:^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse) {
//        if(theErr){
//            UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Message" message:@"We couldn't complete your request." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//            [a show];
//        }
//        else{
//            if([(NSArray *)theObj count]== 0)
//            { UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Wrong username and password combination." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//                [a show];
//                //user doesn't exist
//            }
//            if([(NSArray *)theObj count]== 1){
//                
//                NSLog(@" here");
//                
//                MFStudent * student = [(NSArray *)theObj objectAtIndex:0];
//                
//                 NSManagedObjectContext *context =   [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
//                
//                NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MFStudent"  inManagedObjectContext:context];
//                
//              MFStudent *user =  [[MFStudent alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
//                
//                user.password =student.password;
//                user.username = student.username;
//                FFMetaData * meta = [_manager.ff metaDataForObj:student];
//                if(meta){
//                    user.userid = meta.guid;
//                }
//                
//                [self loginUser:user];
//                
//                block();
//            
//            }
//
//        }}];
}


-(void)import{
    [self getLocalJSON];

    NSArray * a = [self.appData objectForKey:@"activities"];
  
    [a enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {

        NSManagedObjectContext *context =   [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];

        MFActivity *act = [NSEntityDescription insertNewObjectForEntityForName:@"MFActivity" inManagedObjectContext:context];
        act.activityid = obj[@"id"];
        act.name =obj[@"name"];
        act.class_name = obj[@"classname"];
        act.standard = obj[@"standard"];
        act.maxQuestions = obj[@"questioncount"];
        act.fractionCount =obj[@"nr_fraction_inquestion"];
        
        //get raw set
        NSSet *set = [self getSet:[obj[@"set"]integerValue] fromDict:self.appData];

        act.set = set;
        
        //save it
        NSError * error;
        [context save:&error];
        if(error){
            NSLog(@"Error %@",error.debugDescription);
        
        }
    }];
}


-(void)addNewUserWithPin:(NSString *)pin andName:(NSString *)name classId:(NSString *)classId first:(NSString *)firstName last:(NSString *)lastName successBlock:(void (^)())block{
  
    NSString * query = [NSString stringWithFormat:@"/MFStudent/((username eq '%@') and (password eq = '%@'))",name,pin];
    
    [_manager.ff getArrayFromUri:query onComplete:^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse) {
        if(theErr){
            UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Message" message:@"We couldn't complete your request." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [a show];
        }
        else{
            if([(NSArray *)theObj count]== 0)
            {
                //create an instance of MFStudent
//                MFStudent * student = [[MFStudent alloc]init];
                
                NSManagedObjectContext *context =   [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
                NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MFUser"  inManagedObjectContext:context];
                MFStudent *student =  [[MFStudent alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:context];
                
                
                student.username = name;
                student.password = pin;
                student.lastname = lastName;
                student.firstname = firstName;
#warning change it eventually to classId
                student.classId = classId;
                               
                NSError * error;
                [_manager.ff createObj:student atUri:@"/MFStudent" error:&error];
                
                if(error) {
                   NSLog(@"Registration Error %@",error.debugDescription);
                    UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Message" message:@"We couldn't register user. Please try again or continue as a guest." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [a show];
                    
                }
                else{
                   
                    UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Message" message:@"User Created. Use username and password to log in." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [a show];
                    block();

                }
            }
            else{
                UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Message" message:@"User already exists." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [a show];
            }
        }
    }];
    
#warning local user

    //
//    if([self findUserWithPin:pin andName:name]){
//        UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Message" message:@"User already exists" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//        [a show];
//
//        return nil;
//    }
//    
//    NSManagedObjectContext *context = [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
//
//    MFUser * user = [NSEntityDescription insertNewObjectForEntityForName:@"MFUser" inManagedObjectContext:context];
//    user.pin = [NSNumber numberWithInt:pin.integerValue];
//    user.name = name;
//    
//    NSError *error;
//    [context save:&error];
//    if(error){
//        NSLog(@"Error %@",error.debugDescription);
//        return nil;
//    }
//    else{
//        
//        [self loginUser:user];
//         return user;
//    }
}

-(void)updateData:(NSManagedObject *)object;{
     NSManagedObjectContext *context = [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
     NSError *error;
     [context save:&error];
     if(error){
        NSLog(@"Update Data Error %@",error.debugDescription);
    }
}

-(NSMutableArray *)randomize:(NSMutableArray *) array fromSet:(NSMutableArray *)defaultSet andDesiredCount:(int)count
{
    
    if(!array){
        array = [NSMutableArray new];
    }
    
    while(array.count<count){
        int index = arc4random()%defaultSet.count;
        id obj = defaultSet[index];
        [defaultSet removeObjectAtIndex:index];
        [array addObject:obj];
    }
    
    return array;
}




@end
