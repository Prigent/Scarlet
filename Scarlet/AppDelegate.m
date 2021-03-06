//
//  AppDelegate.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 13/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "ShareAppContext.h"
#import "WSManager.h"
#import "Toast+UIView.h"
#import "ChatViewController.h"
#import "FriendViewController.h"
#import "Chat.h"
#import "WSParser.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/******* Set your tracking ID here *******/

static NSString *const kAllowTracking = @"allowTracking";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Fabric with:@[[Crashlytics class]]];
    [ShareAppContext sharedInstance].managedObjectContext = [self managedObjectContext];
    
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"icnSearch"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    
    NSDictionary *appDefaults = @{kAllowTracking: @(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    [GAI sharedInstance].optOut = ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    [GAI sharedInstance].dispatchInterval = 20;
    [[GAI sharedInstance] trackerWithTrackingId:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"tracking"]];
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    UIImage *barBackBtnImg = [[UIImage imageNamed:@"btnBack"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 0)];

    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:barBackBtnImg forState:UIControlStateNormal  barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:1 green:29/255. blue:76/255. alpha:1]];
    

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application  openURL:url  sourceApplication:sourceApplication annotation:annotation];
}



- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *tokenString = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    

    if([[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"] == nil) {
        
        NSLog(@"PUSH TOKEN : %@",tokenString);
        [[NSUserDefaults standardUserDefaults] setValue:tokenString forKey:@"DeviceToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        if([ShareAppContext sharedInstance].user != nil)
        {
            [[WSManager sharedInstance] saveUserCompletion:^(NSError *error) {
                
            }];
        }
    }
}


- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    NSNumber * lNumber = [userInfo valueForKey:@"redirection"];
    if([application applicationState] == UIApplicationStateInactive)
    {
        [self redirection:userInfo];
    }
    else
    {
        UIViewController *vc = [AppDelegate topMostController];
        if([lNumber intValue] == 2 && [vc  isKindOfClass:[ChatViewController class]])
        {
            return;
        }
        [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] makeToast:[[userInfo valueForKey:@"aps"] valueForKey:@"alert"]];
    }
}


-(void) redirection:(NSDictionary*) dictionary
{
    NSNumber * number = [dictionary valueForKey:@"redirection"];
    NSString * chatId = [[dictionary valueForKey:@"code_chat"] description];
    NSString * eventId = [[dictionary valueForKey:@"code_event"] description];
    NSString * eventIdSearch = [[dictionary valueForKey:@"code_event_search"] description];
    
    
    if([number intValue] < 4)
    {
        [[AppDelegate topMostController].tabBarController setSelectedIndex:[number intValue]];
        UINavigationController * lnav = (UINavigationController *)[[AppDelegate topMostController].tabBarController.viewControllers objectAtIndex:[number intValue]];
        if( [lnav isKindOfClass:[UINavigationController class]])
        {
            [lnav popToRootViewControllerAnimated:false];
        }
        
        if([chatId length]>0)
        {
            Chat * lChat = [WSParser addChatObject:chatId];
            [self performSelector:@selector(showChat:) withObject:lChat afterDelay:1];
        }
        else if([eventId length]>0)
        {
            [self performSelector:@selector(showEvent:) withObject:eventId afterDelay:1];
        }
        else if([eventIdSearch length]>0)
        {
            [self performSelector:@selector(showEventSearch:) withObject:eventIdSearch afterDelay:1];
        }
    }
    else if([number intValue] == 4)
    {
        [[AppDelegate topMostController].navigationController popToRootViewControllerAnimated:false];
        [self performSelector:@selector(showFriendController) withObject:nil afterDelay:1];
    }
}

-(void) showEventSearch:(id) eventId
{
    BaseViewController *viewController = nil;
    viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchEventDetailViewController"];
    [viewController configure:eventId];
    
    [[AppDelegate topMostController].navigationController pushViewController:viewController animated:true];
}

-(void) showEvent:(id) eventId
{
    BaseViewController *viewController = nil;
    viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyEventViewController"];
    [viewController configure:eventId];
    [[AppDelegate topMostController].navigationController pushViewController:viewController animated:true];
}

-(void) showChat:(id) chat
{
    BaseViewController *viewController = nil;
    viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatViewController"];
    [viewController configure:chat];
    [[AppDelegate topMostController].navigationController pushViewController:viewController animated:true];
}

-(void) showFriendController
{
    FriendViewController *viewController = nil;
    viewController = [[UIStoryboard storyboardWithName:@"Friend" bundle:nil] instantiateInitialViewController];
    viewController.type = 2;
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [[AppDelegate topMostController].navigationController.view.layer addAnimation:transition forKey:nil];
    
    [[AppDelegate topMostController].navigationController pushViewController:viewController animated:false];
}









+ (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    if([topController isKindOfClass:[UINavigationController class]])
    {
        topController = ((UINavigationController*)topController).topViewController;
    }
    if([topController isKindOfClass:[UITabBarController class]])
    {
        topController = ((UITabBarController*)topController).selectedViewController;
    }
    if([topController isKindOfClass:[UINavigationController class]])
    {
        topController = ((UINavigationController*)topController).topViewController;
    }
    
    
    
    
    return topController;
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@" , error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[WSManager sharedInstance] getTextCompletion:^(NSError *error) {
        
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.

}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.scarlet.Scarlet" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Scarlet" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Scarlet.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
