//
//  MyFractal.m
//  Fractio
//
//  Created by Janusz Chudzynski on 1/23/14.
//  Copyright (c) 2014 UWF. All rights reserved.
//

#import "MyFractal.h"
#import "MFStudent.h"
#import "MFAppDelegate.h"

@interface FatFractal()
- (void) setValuesOnObject:(id)obj fromDict:(NSDictionary *)dict loadFromCacheOnly:(BOOL)loadFromCacheOnly
            doAutoLoadRefs:(BOOL)doAutoLoadRefs doAutoLoadBlobs:(BOOL)doAutoLoadBlobs;
-(id)objectFromDictionary:(NSDictionary *)dict;
-(id)getClassFromClazz:(id)clazz;

@end

@implementation MyFractal
//
//
//-(instancetype)initWithBaseUrl:(NSString *)url{
//    
//    self = [super initWithBaseUrl:url];
//    if(self)
//    {
//        NSLog(@"Custom Init");
//    }
//    return self;
//}
//
//+(id)setValuesOnObject:(id)obj fromDict:(NSDictionary *)dict
//{
//
//    return nil;
//}
//
//
//
//- (BOOL) shouldSerialize:(NSString *)propertyName;{
//    NSLog(@"%@",propertyName);
//    
//    return YES;
//}
//
//- (id) createInstanceOfClass:(Class) class {
//    BOOL special = NO;
//    
////    if (Some code to figure out whether this class needs special initialisation or not)
////        special = YES;
////    
//    if([class isSubclassOfClass:[MFStudent class]])
//    {
//        NSManagedObjectContext *context =   [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
//        //
//        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MFStudent"  inManagedObjectContext:context];
//        MFStudent *user =  [[MFLocalStudent alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
//        return user;
//        
//    }
//    if (special) {
//        // Do special stuff
//        return [[class alloc] init]; 
//    } else {
//        return [[class alloc] init]; // This is essential, otherwise bad bad stuff will happen
//    }
//}
//
//- (void) setValuesOnObject:(id)obj fromDict:(NSDictionary *)dict loadFromCacheOnly:(BOOL)loadFromCacheOnly
//            doAutoLoadRefs:(BOOL)doAutoLoadRefs doAutoLoadBlobs:(BOOL)doAutoLoadBlobs
//{
//    NSLog(@" %@",dict);
//    BOOL k = NO;
//    if (k) {
//        // set the values on the object from the dictionary
//        } else {
//            [super setValuesOnObject:obj fromDict:dict loadFromCacheOnly:loadFromCacheOnly doAutoLoadRefs:doAutoLoadRefs doAutoLoadBlobs:doAutoLoadBlobs];
//        }
//}
//
//-(id)getClassFromClazz:(id)clazz{
//    [super getClassFromClazz:clazz];
//   // NSLog(@"Class Is:  %@ ",clazz);
//
//    
//    return nil;
//}
//
//-(id)objectFromDictionary:(NSDictionary *)dict{
//    
//    if([[dict objectForKey:@"clazz"] isEqualToString:@"MFStudent"]){
//        NSManagedObjectContext *context =   [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
//        //
//        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MFStudent"  inManagedObjectContext:context];
//        MFStudent *user =  [[MFStudent alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
//         user.userid = [dict objectForKey:@"guid"];
//         user.firstname =[dict objectForKey:@"firstname"];
//         user.classId =[dict objectForKey:@"classid"];
//         user.password=[dict objectForKey:@"password"];
//         user.username =[dict objectForKey:@"username"];
//        user.lastname = [dict objectForKey:@"lastname"];
//        
//        return user;
//    }
//    else{
//        return    [super objectFromDictionary:dict];
//    }
//    
//    NSLog(@"Object From Dictionary %@",dict);
//
//}




@end
