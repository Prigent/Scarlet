//
//  WSManager.m
//  Ricard Strat
//
//  Created by Damien PRACA on 26/08/14.
//  Copyright (c) 2014 Ricard. All rights reserved.
//
#import "NSString+HTML.h"
#import "Constants.h"
#import "WSManager.h"
#import "AFNetworking.h"
#import "GTMNSString+HTML.h"
#import "AFHTTPRequestOperation.h"
#import "AppDelegate.h"
#import "WSParser.h"
#import "Chat.h"
#import "ShareAppContext.h"
#import "User.h"
#import "Event.h"
#import "Message.h"

#import "NSData+Base64.h"

#import <sys/utsname.h>
#import "Toast+UIView.h"
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/ASIdentifierManager.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation WSManager

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.mBaseURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"urlBase"];   
    }
    return self;
}

+ (WSManager *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

+ (CLGeocoder *)sharedGeocoder
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedGeocoder = nil;
    dispatch_once(&pred, ^{
        _sharedGeocoder = [[CLGeocoder alloc] init];
    });
    return _sharedGeocoder;
}

-(AFHTTPRequestOperationManager*) createConfiguredManager
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"scarletiOSapp" password:@"5lj6c6SK4CexS7RgFiK"];
    return manager;
}

-(id) getDataFromFile:(NSString*) fileLocation
{
    NSString *filePathLocal = [[NSBundle mainBundle] pathForResource:[fileLocation stringByDeletingPathExtension] ofType:[fileLocation pathExtension]];
    NSData* data = [NSData dataWithContentsOfFile:filePathLocal];
    NSError* error = nil;
    NSDictionary * responseObject = [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:&error];
    return responseObject;
}


- (void)createEvent:(NSDictionary*) eventDic completion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/event"];
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    NSMutableDictionary * param = [NSMutableDictionary dictionaryWithDictionary:eventDic];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];
    [manager POST:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError * error  =  [self checkResponse:responseObject];
         if(error == nil)
         {
            Event * lEvent = [WSParser addEvent:[responseObject valueForKey:@"event"]];
            lEvent.isMine = [NSNumber numberWithBool:true];
         }
         [self manageError:error];
         onCompletion(error);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self manageError:error];
         onCompletion(error);
     }];
}

- (void)editEvent:(NSDictionary*) eventDic completion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/event"];
    
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    NSMutableDictionary * param = [NSMutableDictionary dictionaryWithDictionary:eventDic];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];
    [manager PUT:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError * error  =  [self checkResponse:responseObject];
         if(error == nil)
         {
             [WSParser editEvent:[responseObject valueForKey:@"event"]];
         }
         [self manageError:error];
         onCompletion(error);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self manageError:error];
         onCompletion(error);
     }];
}

- (void)hideEvent:(Event*) event status:(NSNumber*) status completion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/event"];
    
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];
    [param setValue:event.identifier forKey:@"event_identifier"];
    [param setValue:status forKey:@"status"];
    
    
    [manager PUT:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError * error  =  [self checkResponse:responseObject];
         if(error == nil)
         {
             [WSParser editEvent:[responseObject valueForKey:@"event"]];
         }
         [self manageError:error];
         onCompletion(error);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self manageError:error];
         onCompletion(error);
     }];
}




#pragma mark - POST REQUEST

-(NSError*) checkResponse:(NSDictionary*) responseObject
{
    if([responseObject isKindOfClass:[NSDictionary class]])
    {
        NSString* code = [responseObject valueForKey:@"response_code"];
        if([code intValue] != 0)
        {
            return [NSError errorWithDomain:self.mBaseURL code:[code intValue] userInfo:nil];
        }
        else
        {
            return nil;
        }
    }
    return [NSError errorWithDomain:self.mBaseURL code:-2 userInfo:nil];
}



- (void)authentification:(NSString*) token completion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/auth/authenticate"];
    
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    [param setObject:token forKey:@"FBSDKAccessToken"];

    [manager POST:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSError * error  =  [self checkResponse:responseObject];
        if(error == nil)
        {
            [[ShareAppContext sharedInstance] setUserIdentifier:[responseObject valueForKey:@"profile_id"]];
            [[ShareAppContext sharedInstance] setAccessToken:[responseObject valueForKey:@"access_token"]];
            [[ShareAppContext sharedInstance] setFirstStarted:[[responseObject valueForKey:@"is_new"] boolValue]];
                [self getUserCompletion:^(NSError *error) {
                    
                    if([[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"] != nil) {
                        if([ShareAppContext sharedInstance].user != nil)
                        {
                            [[WSManager sharedInstance] saveUserCompletion:^(NSError *error) {
                                [[ShareAppContext sharedInstance].managedObjectContext save:nil];
                                onCompletion(nil);
                            }];
                        }
                    }
                    else
                    {
                        [[ShareAppContext sharedInstance].managedObjectContext save:nil];
                        onCompletion(nil);
                    }
                }];
        }
        else
        {
            onCompletion(error);
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         onCompletion(error);
     }];
}

- (void)removePicture:(NSNumber*) position completion:(void (^)(NSError* error)) onCompletion;
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/picture"];
    
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];
    [param setObject:position forKey:@"picture_id"];
    [manager DELETE:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError * error  =  [self checkResponse:responseObject];
         if(error == nil)
         {
             [WSParser addUser:[responseObject valueForKey:@"user"]];
         }
         [self manageError:error];
         onCompletion(error);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        [self manageError:error];
         onCompletion(error);
     }];
}

- (void)sendPicture:(UIImage*) picture position:(NSNumber*) position completion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/picture"];
    
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];
    NSString* stringImage =  [NSString stringWithFormat:@"%@%@",@"data:image/jpg;base64,/9j/",[self encodeToBase64String:picture]];
    [param setObject:stringImage forKey:@"picture_data"];
    [param setObject:position forKey:@"position"];
    

    [manager POST:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError * error  =  [self checkResponse:responseObject];
         if(error == nil)
         {
             [WSParser addUser:[responseObject valueForKey:@"user"]];
         }
         [self manageError:error];
         onCompletion(error);
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        [self manageError:error];
         onCompletion(error);
     }];
    
    

}

- (void)addDemand:(Event*) event partner:(NSArray*) partnerIdentifier completion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/demand"];
    
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:event.identifier forKey:@"event_identifier"];
    [param setObject:partnerIdentifier forKey:@"partner"];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];
    
    [manager POST:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError * error  =  [self checkResponse:responseObject];
         if(error == nil)
         {
             Demand * lDemand = [WSParser addDemand:[responseObject valueForKey:@"demand"]];
             [event addDemandsObject:lDemand];
             NSInteger mystatus = [event getMyStatus];
             event.mystatus = [NSNumber numberWithInteger:mystatus];
         }
         [self manageError:error];
         onCompletion(error);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        [self manageError:error];
         onCompletion(error);
     }];
}


- (void)addMessage:(Chat*) chat message:(NSString*) message completion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/message"];
    
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:chat.identifier forKey:@"chat_request_identifier"];
    
    NSData *msgData = [message dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    [param setObject:[msgData base64EncodedString] forKey:@"message"];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];
    

    
    
    [manager POST:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError * error  =  [self checkResponse:responseObject];
         if(error == nil)
         {
             NSLog(@"checkResponse %@",responseObject);
         }
         [self manageError:error];
         onCompletion(error);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self manageError:error];
         onCompletion(error);
     }];
}






- (void)removeDemand:(NSString*) demandID completion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/demand"];
    
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];
    [param setObject:demandID forKey:@"demand_id"];
    
    
    [manager DELETE:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError * error  =  [self checkResponse:responseObject];
         if(error == nil)
         {
             [WSParser editEvent:[responseObject valueForKey:@"event"]];
         }
         [self manageError:error];
         onCompletion(error);
     }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self manageError:error];
         onCompletion(error);
     }];
}

- (void)respondDemand:(NSString*) identifier status:(NSNumber*) status completion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/demand"];
    
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:identifier forKey:@"demand_identifier"];
    [param setObject:status forKey:@"status"];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];
    
    [manager PUT:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError * error  =  [self checkResponse:responseObject];
         if(error == nil)
         {
             [WSParser addDemand:[responseObject valueForKey:@"demand"]];
         }
         [self manageError:error];
         onCompletion(error);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        [self manageError:error];
         onCompletion(error);
     }];
}




- (void)addFriend:(NSString*) identifier completion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/friend"];
    
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:identifier forKey:@"profile_identifier"];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];
    
    [manager POST:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError * error  =  [self checkResponse:responseObject];
         if(error == nil)
         {
             [WSParser addUser:[responseObject valueForKey:@"user"]];
         }
         [self manageError:error];
         onCompletion(error);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self manageError:error];
         onCompletion(error);
     }];
}

- (void)respondFriend:(NSString*) identifier status:(NSNumber*) status completion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/friend"];
    
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:identifier forKey:@"friend_request_identifier"];
    [param setObject:status forKey:@"status"];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];
    
    [manager PUT:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError * error  =  [self checkResponse:responseObject];
         if(error == nil)
         {
            [WSParser addUser:[responseObject valueForKey:@"user"]];
         }
         [self manageError:error];
         onCompletion(error);
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        [self manageError:error];
         onCompletion(error);
     }];
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImageJPEGRepresentation(image, 0.9) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
}


- (void)saveUserCompletion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/user"];
    
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    
    
    NSMutableDictionary * param = [NSMutableDictionary dictionaryWithDictionary:[[ShareAppContext sharedInstance].user getDictionary]];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];

    [manager PUT:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError * error  =  [self checkResponse:responseObject];
         if(error == nil)
         {
             [WSParser addUser:[responseObject valueForKey:@"user"]];
         }
         [self manageError:error];
         onCompletion(error);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        [self manageError:error];
        onCompletion(error);
     }];
}


#pragma mark - GET REQUEST

- (void)getUserCompletion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/user"];
    
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];
    
    [manager GET:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSError * error  =  [self checkResponse:responseObject];
        if(error == nil)
        {
            NSArray* lAllProfiles= [responseObject valueForKey:@"profile"];
            for(NSDictionary * lDicProfile in lAllProfiles)
            {
                [WSParser addProfile:lDicProfile];
            }
            
            [ShareAppContext sharedInstance].user = [WSParser addUser:[responseObject valueForKey:@"user"]];
            [[ShareAppContext sharedInstance] updatePlacemark:^(NSError *error) {
                    onCompletion(error);
            }];
        }
        else
        {
            onCompletion(error);
        }
        [self manageError:error];

    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [self manageError:error];
        onCompletion(error);
    }];
}

- (void)getEventsCompletion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/event"];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];
    
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    [manager GET:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSError * error  =  [self checkResponse:responseObject];
        if(error == nil)
        {
            NSLog(@"%@", responseObject);
            
            NSArray* lAllProfiles= [responseObject valueForKey:@"profile"];
            for(NSDictionary * lDicProfile in lAllProfiles)
            {
                [WSParser addProfile:lDicProfile];
            }
            
            [WSParser removeEventNotOwn];
            
            NSArray* lAllEvents= [responseObject valueForKey:@"event"];
            for(NSDictionary * lDicEvent in lAllEvents)
            {
                [WSParser addEvent:lDicEvent];
            }
            NSLog(@"NB EVENT NOT OWN %ld", [lAllEvents count]);
        }
        [self manageError:error];
        onCompletion(error);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        [self manageError:error];
         onCompletion(error);
     }];
}

- (void)getProfilsCompletion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/profile"];
    
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];

    [manager GET:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSError * error  =  [self checkResponse:responseObject];
        if(error == nil)
        {
            [WSParser resetProfileUpdate];
            NSArray* lAllProfiles= [responseObject valueForKey:@"profile"];
            for(NSDictionary * lDicProfile in lAllProfiles)
            {
                [WSParser addProfile:lDicProfile];
            }
            [WSParser removeProfileNotUpdate];
        }
        [self manageError:error];
        onCompletion(error);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        [self manageError:error];
         onCompletion(error);
     }];
}


- (void)getMessagesForChat:(Chat*) chat completion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/message"];
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];
    [param setObject:chat.identifier forKey:@"chat_identifier"];

    
    
    
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    [manager GET:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSError * error  =  [self checkResponse:responseObject];
        if(error == nil)
        {
            NSArray* lAllMessage= [responseObject valueForKey:@"message"];
            [chat removeMessages:chat.messages];
            
            for(NSDictionary * lDicMessage in lAllMessage)
            {
                Message * lMessage = [WSParser addMessage:lDicMessage];
                [chat addMessagesObject:lMessage];
            }
        }
        [self manageError:error];
        onCompletion(error);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self manageError:error];
         onCompletion(error);
     }];
}




- (void)getMyEventsCompletion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/myevent"];
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];
    
    
    
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    [manager GET:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSError * error  =  [self checkResponse:responseObject];
        if(error == nil)
        {
            NSArray* lAllProfiles= [responseObject valueForKey:@"profile"];
            for(NSDictionary * lDicProfile in lAllProfiles)
            {
                [WSParser addProfile:lDicProfile];
            }
            
            [WSParser removeEventOwn];
            NSArray* lAllEvents= [responseObject valueForKey:@"event"];
            for(NSDictionary * lDicEvent in lAllEvents)
            {
                Event* lEvent = [WSParser addEvent:lDicEvent];
                lEvent.isMine = [NSNumber numberWithBool:true];
            }
        }
        [self manageError:error];
        onCompletion(error);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self manageError:error];
         onCompletion(error);
     }];
}

- (void)getChatsCompletion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/chat"];
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];
    
    
    
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    [manager GET:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError * error  =  [self checkResponse:responseObject];
         int countUnRead = 0;
         if(error == nil)
         {
             NSArray* lAllProfiles= [responseObject valueForKey:@"profile"];
             for(NSDictionary * lDicProfile in lAllProfiles)
             {
                 [WSParser addProfile:lDicProfile];
             }
             
             NSArray* lAllChats= [responseObject valueForKey:@"chat"];
             for(NSDictionary * lDicChat in lAllChats)
             {
                 Chat * lChat = [WSParser addChat:lDicChat];
                 Message * lMessage = [lChat.messages lastObject];
                 if(lMessage !=nil && [lMessage.readStatus boolValue] == false)
                 {
                     countUnRead++;
                 }
             }
         }
         
         
         [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUnread" object:[NSNumber numberWithInt:countUnRead]];
         
         
         [self manageError:error];
         onCompletion(error);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self manageError:error];
         onCompletion(error);
     }];
}


- (void)getNotificationConfiguration:(void (^)(NSError* error)) onCompletion
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/notification"];
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];
    
    
    
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    [manager GET:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError * error  =  [self checkResponse:responseObject];
         if(error == nil)
         {
             NSDictionary* lAllNotification= [responseObject valueForKey:@"notifications"];
             [ShareAppContext sharedInstance].notificationDic = lAllNotification;
         }
         [self manageError:error];
         onCompletion(error);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self manageError:error];
         onCompletion(error);
     }];
}

- (void)setNotificationConfiguration:(NSString*) key andValue:(NSNumber*) value completion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/notification"];
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];
    [param setObject:value forKey:key];
    
    
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    [manager PUT:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError * error  =  [self checkResponse:responseObject];
         if(error == nil)
         {
             NSDictionary* lAllNotification= [responseObject valueForKey:@"notifications"];
             [ShareAppContext sharedInstance].notificationDic = lAllNotification;
         }
         [self manageError:error];
         onCompletion(error);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self manageError:error];
         onCompletion(error);
     }];
}


- (void)getMutualfriend:(Profile*) profile completion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= [NSString stringWithFormat:@"%@/%@", self.mBaseURL, @"rest/services/v1/mutualfriend"];
    
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];
    [param setObject:profile.identifier forKey:@"profile_identifier"];
    
    
    [manager GET:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError * error  =  [self checkResponse:responseObject];
         if(error == nil)
         {
             NSArray* lAllProfiles= [responseObject valueForKey:@"mutual_friend"];
             [profile removeMutualFriends:profile.mutualFriends];
             
             for(NSDictionary * lDicProfile in lAllProfiles)
             {
                 [profile addMutualFriendsObject:[WSParser addFacebookProfile:lDicProfile]];
             }
         }
         [self manageError:error];
         onCompletion(error);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self manageError:error];
         onCompletion(error);
     }];
}


-(void) manageError:(NSError*) error
{
    [[ShareAppContext sharedInstance].managedObjectContext save:nil];
    if(error.code == -2)
    {
        [[ShareAppContext sharedInstance] setAccessToken:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"disconnect" object:nil];
    }
}


@end

