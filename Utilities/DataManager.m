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
#import "MFLocalStudent.h"
#import "MyFractal.h"

#import "MFAttempt.h"
#import "MFAppDelegate.h"
#import "MFCompleted.h"
#import "MFManager.h"
#import "UIBAlertView.h"
#import "MFFrAttempt.h"
#import "MFFractalFraction.h"
#import "MFMessage.h"


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
//        
//        NSString * query = [NSString stringWithFormat:@"/MFFractalAttempt/"];
//        
//        [_manager.ff getArrayFromUri:query onComplete:^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse) {
//            for (int i=0;i<[theObj count]; i++){
//                [_manager.ff deleteObj:[theObj objectAtIndex:i]];
//            }
//        }];

        
       
    }
    return self;
}

-(void)teacherFeedbackForUser:(NSString *)userId completionBlock: (void(^)(NSArray *a)) block{
    
    NSString * query = [NSString stringWithFormat:@"/MFFeedbackMessage/(studentid eq '%@')",userId];
    
    [_manager.ff getArrayFromUri:query onComplete:^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse) {
        if(theErr){
            UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Message" message:@"We couldn't complete your request." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [a show];
            NSLog(@"Error %@",theErr.debugDescription);
            block(nil);
        }
        else{
            block(theObj);
        }}];
    
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


-(MFLocalStudent *)findUserWithId: (NSString *)userId{
    NSManagedObjectContext *context = [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MFLocalStudent" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
   
    NSPredicate *predicate = [NSPredicate predicateWithFormat:  @"(userid LIKE[c] %@)",userId];
    
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"Error %@",error.debugDescription);
    }
    MFLocalStudent *mf;
    if(array.count==1)
    {
        mf = array[0];
  
    }

     return mf;
    
}

-(MFLocalStudent *)getCurrentUser{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];

    NSString *userName= [ud objectForKey:USER_NAME_KEY];
    NSString *userPin= [ud objectForKey:USER_PASS_KEY];
    NSString *userId= [ud objectForKey:USER_ID_KEY];

    if(!userName||!userPin||!userId) return nil;
    MFLocalStudent * user=   [self findUserWithId:userId];
    user.userid = userId;
    
    return user;
}

-(MFFrAttempt *)createFractalAttemptWithAttempt:(MFAttempt *)attempt{
    MFFrAttempt * mf = [[MFFrAttempt alloc]init];
    mf.score = attempt.score;
    mf.attempt_date = attempt.attempt_date;
        
    
    if(_manager.mfuser){
        NSLog(@"%@ %@ ", _manager.mfuser.userid ,attempt.user.userid );
        assert([_manager.mfuser.userid isEqualToString:attempt.user.userid]);

        mf.mfclassId = _manager.mfuser.classId;
        mf.userId=attempt.user.userid;
    }

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

-(void)saveAttemptWithScore:(int)score andActivity:(MFActivity *)activity andFractions:(NSSet *)fractions andAnswer:(MFFraction *)answer;{
    
    NSManagedObjectContext *context =   [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
    MFAttempt *at = [NSEntityDescription insertNewObjectForEntityForName:@"MFAttempt" inManagedObjectContext:context];
    MFLocalStudent * st = [self getCurrentUser];

    if(st){
        at.score = [NSNumber numberWithInt:score];
        at.attempt_date = [NSDate new];
        at.user = self.getCurrentUser;
        at.userid = st.userid;
        at.activity = activity.activityid;
        at.fractions = fractions;
        at.uid = [NSString stringWithFormat:@"%@",[at objectID]];
        #warning store answer as well
        
        MFFrAttempt * a = [self createFractalAttemptWithAttempt:at];
        MFFractalFraction * fr = [[MFFractalFraction alloc]init];
        fr.denominator = answer.denominator;
        fr.numerator = answer.numerator;
        a.answer = fr;
        
        
        
        
        NSError * error;
        [_manager.ff createObj:a atUri:@"/MFFrAttempt" error:&error];
        
        if(error) {
            NSLog(@"Saving Attempt %@",error.debugDescription);
        }
        error = nil;
        [context save:&error];
        if(error){
            NSLog(@"Core Data Saving Attempt %@",error.debugDescription);
        }
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


-(void)loginUser:(MFLocalStudent *)user{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];

    [ud setObject: user.password forKey:USER_PASS_KEY];
    [ud setObject:user.username  forKey:USER_NAME_KEY];
    [ud setObject:user.userid    forKey:USER_ID_KEY];
    [ud synchronize];
    _manager.mfuser = user;
    _manager.guestMode = NO;
}

-(void)logout;{
    _manager.mfuser = nil;
    _manager.guestMode = NO;
    
}



-(void)loginUser:(NSString *)username andPassword:(NSString *)password block:(void (^)())block{
    NSString * query = [NSString stringWithFormat:@"/MFStudent/((username eq '%@') and (password eq = '%@'))",username, password];
  
    [_manager.ff getArrayFromUri:query onComplete:^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse) {
        if(theErr){
            UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Message" message:@"We couldn't complete your request." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [a show];
        }
        else{
            if([(NSArray *)theObj count]== 0)
            { UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Wrong username and password combination." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [a show];
                //user doesn't exist
            }
            if([(NSArray *)theObj count]== 1){
                

                MFStudent * student = [(NSArray *)theObj objectAtIndex:0];
                FFMetaData * meta = [_manager.ff metaDataForObj:student];
                student.userId = meta.guid;
                
                MFLocalStudent * localStudent = [self findUserWithId:student.userId];
                
                if(!localStudent){
                    //create a local student
                   localStudent = [self createLocalStudentfromFractalStudent:student];
                    
                    NSManagedObjectContext *context =   [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
                    [context insertObject:localStudent];
                    
                    NSError *e;
                     [context save:&e];
                    if(e){
                        NSLog(@"%@",e.debugDescription);
                    }
                }
                NSLog(@" here %@ %@ %@",student.username, student.userId, student.classId);
                NSLog(@" here %@ %@ %@",localStudent.username, localStudent.userid, localStudent.classId);
                [self loginUser:localStudent];
                
                block();
            
            }

        }}];
}


-(void)import{
    [self getLocalJSON];

    NSArray * a = [self.appData objectForKey:@"activities"];
    NSManagedObjectContext *context =   [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
    [a enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {

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
        
           }];
    //save it
    NSError * error;
    [context save:&error];
    if(error){
        NSLog(@"Error %@",error.debugDescription);
        
    }

}


-(MFLocalStudent *)createLocalStudentfromFractalStudent:(MFStudent *)student{
    NSManagedObjectModel *model =   [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectModel];
    
    NSEntityDescription *entity = [[model entitiesByName]objectForKey:@"MFLocalStudent"];
    MFLocalStudent *localStudent = (MFLocalStudent *)[[NSManagedObject alloc] initWithEntity:entity
                      insertIntoManagedObjectContext:nil];
    
    localStudent.userid = student.userId;
    localStudent.username = student.username;
    localStudent.lastname = student.lastname;
    localStudent.password = student.password;
    localStudent.classId = student.classId;
    localStudent.firstname = student.firstname;
    
    return localStudent;
}

-(MFStudent *)createFractalStudentfromLocalStudent:(MFLocalStudent *)student{
    MFStudent * fractalStudent = [[MFStudent alloc]init];
    
    fractalStudent.userId = student.userid;
    fractalStudent.username = student.username;
    fractalStudent.lastname = student.lastname;
    fractalStudent.password = student.password;
    fractalStudent.classId = student.classId;
    fractalStudent.firstname = student.firstname;
    
    return fractalStudent;
}


-(void)addNewUserWithPassword:(NSString *)pin andName:(NSString *)name classId:(NSString *)classId first:(NSString *)firstName last:(NSString *)lastName successBlock:(void (^)(id obj))block responseBlock:(void (^)(NSError * error))errorBlock{
  
    NSString * query = [NSString stringWithFormat:@"/MFStudent/((username eq '%@') and (password eq = '%@'))",name,pin];
    
    [_manager.ff getArrayFromUri:query onComplete:^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse) {
        
        if(theErr){
            UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Message" message:@"We couldn't complete your request." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [a show];
            errorBlock(theErr);
        }
        else{
            if([(NSArray *)theObj count]== 0)
            {
                NSManagedObjectContext *context =   [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
                NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MFLocalStudent"  inManagedObjectContext:context];
                MFLocalStudent *student =  [[MFLocalStudent alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:context];
                student.username = name;
                student.password = pin;
                student.lastname = lastName;
                student.firstname = firstName;
                student.classId = classId;

                //Create a mfstudent object
                MFStudent *fractalStudent =[self createFractalStudentfromLocalStudent:student];
                NSError * error;
                fractalStudent =  [_manager.ff createObj:fractalStudent atUri:@"/MFStudent" error:&error];
                ///get metadata
                FFMetaData * meta = [_manager.ff metaDataForObj:fractalStudent];
                student.userid = meta.guid;
                
                if(error) {
                   NSLog(@"Registration Error %@",error.debugDescription);
                    UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Message" message:@"We couldn't register user. Please try again or continue as a guest." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [a show];
                    
                }
                else{
                    UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Message" message:@"User Created. Use username and password to log in." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [a show];
                    //save the user
                    MFLocalStudent * localStudent = [self findUserWithId:student.userid];
                    if(!localStudent){
                        NSError *e;
                        [context save:&e];
                        if(e){
                            errorBlock(e);
                        }
                    }
                    else{
                        NSLog(@"Local User exists. Data Integrity Problem Detected.");
                    }
                }
            }
            else{
                UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Message" message:@"User already exists." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [a show];
            }
           block(theObj);
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
//    }
}

-(MFStudent *)findUserWith:(NSString *)username andPassword:(NSString *)password;{
    NSManagedObjectContext *context = [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
   

    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MFLocalStudent"  inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:  @"(userid LIKE[c] %@ and password = %@)",username,password];
    
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"Error %@",error.debugDescription);
    }
    MFStudent *mf;
    if(array.count==1)
    {
        mf  = [[MFStudent alloc]init];
        MFLocalStudent * ls = array[0];
        mf.firstname = ls.firstname;
        mf.lastname = ls.lastname;
        mf.password = ls.password;
        mf.userId = ls.userid;
        mf.classId = ls.classId;
        
        
              
    }
    return mf;

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
