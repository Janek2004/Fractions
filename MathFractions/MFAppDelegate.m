//
//  iTenAppDelegate.m
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
#import "MFAppDelegate.h"

#import "MFViewController.h"
#import "MFUtilities.h"
#import "DataManager.h"
#import "MFActivity.h"
#import "MFFraction.h"
#import "PDDebugger.h"
#import "SoundHelper.h"
#import <FFEF/FatFractal.h>


@interface MFAppDelegate()
@property (nonatomic,strong)  DataManager *dm;
@property (nonatomic,strong)  SoundHelper * soundHelper;
@end
@implementation MFAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[MFViewController alloc] initWithNibName:@"MFViewController" bundle:nil];
    //test core data
    NSManagedObjectContext *context = [self managedObjectContext];
    
    PDDebugger *debugger = [PDDebugger defaultInstance];
    [debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
    [debugger enableCoreDataDebugging];
    [debugger addManagedObjectContext:context withName:@"My MOC"];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"MFActivity" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
   [request setEntity:entityDescription];
    NSError *error;
  
    
   [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    NSArray *array = [context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"Error %@",error.debugDescription);
    }
    _dm = [[DataManager alloc]init];
    //if array is empty
    if(array.count ==0){
       
        [_dm import];
        
    }
    
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    _soundHelper = [[SoundHelper alloc]init];
   
   // [self testMe];
    return YES;
}

-(void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    [[FatFractal main] registerNotificationID:[devToken description]];
        NSString *str = [NSString stringWithFormat:@"Device Token=%@",devToken];
        NSLog(@"This is device token%@", str);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // handle notification as you wish

}


//importing data to core data model
//mail

-(void)testMe{
    [self runLoginTests];
    [self runRegistrationTest];
}

-(void)runLoginTests{
    //
    NSLog(@"Test 1 ");
    [_dm loginUser:@"Janek2004" andPassword:@"stany17" block:^{
            NSLog(@"Login successful  ");
    }];
}

-(void)runRegistrationTest{
    //

    NSLog(@"Test 2 Adding new user ");
    __weak DataManager *dm1 =_dm;
    
    [_dm addNewUserWithPassword: @"stany17" andName:@"Janek2004" classId:@"2013" first:@"Janusz" last:@"Chudzynski" successBlock:^(id obj) {
        NSLog(@"Success obj %@",obj);
        NSLog(@"Test 3 Adding new user again - it should fail! Number of objects should be the same as in the previous call ");
        
        [dm1 addNewUserWithPassword: @"stany17" andName:@"Janek2004" classId:@"2013" first:@"Janusz" last:@"Chudzynski" successBlock:^(id obj) {
            NSLog(@"Success obj %@",obj);
            
        } responseBlock:^(NSError *error) {
            NSLog(@"Error obj %@",error);
        }];
        
        
    } responseBlock:^(NSError *error) {
        NSLog(@"Error obj %@",error);
    }];
    
  
    
    
//    
//    
//    [_dm addNewUserWithPin:@"stany17" andName:@"Janek2004" classId:@"2013" first:@"Janusz" last:@"Chudzynski" successBlock:^(NSArray * a){
//            NSLog(@"Registration successful ");
//    ];
//
//    NSLog(@"Test 3 Add it again ");
//    [_dm addNewUserWithPin:@"stany17" andName:@"Janek2004" classId:@"2013" first:@"Janusz" last:@"Chudzynski" successBlock:^{
//        NSLog(@"Registration shouldn't be successful ");
//    }];
    
    
    
    
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
