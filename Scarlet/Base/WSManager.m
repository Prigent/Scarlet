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

- (id)getJSONObject:(id)_responseObject error:(NSError**)_error
{
    NSDictionary* responseDic = nil;
    if ([_responseObject isKindOfClass:[NSData class]])
    {
        responseDic = [NSJSONSerialization JSONObjectWithData:_responseObject options:kNilOptions error:_error];
    }
    else if ([_responseObject isKindOfClass:[NSDictionary class]])
    {
        responseDic = [NSDictionary dictionaryWithDictionary:_responseObject];
    }
    else if ([_responseObject isKindOfClass:[NSString class]])
    {
        responseDic = [NSJSONSerialization JSONObjectWithData:[_responseObject dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:_error];
    }
    
    return responseDic;
}

-( NSDictionary *)createJsonParameterWithParameters:(NSDictionary *) specifiqParameters
{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]initWithDictionary: REQUEST_CREDENTIALS];
    [parameters setValue:[NSString stringWithFormat:@"%d",(int)([[NSDate date] timeIntervalSince1970])] forKey:@"ttp"];
    if(specifiqParameters!=nil){
        [parameters addEntriesFromDictionary:specifiqParameters];
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:0
                                                         error:&error];
    if (!jsonData) {
        return nil;
    }
    NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    return [[NSDictionary alloc] initWithObjectsAndKeys:JSONString, @"json", nil];
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

- (void)addMessageCompletion:(void (^)(NSError* error)) onCompletion
{
    
}
- (void)createEventCompletion:(void (^)(NSError* error)) onCompletion
{
    
}


#pragma mark - POST REQUEST




- (void)authentification:(NSString*) token completion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= @"http://scarlet.aouka.org/rest/services/v1/auth/authenticate" ;
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:token forKey:@"FBSDKAccessToken"];
    
    [manager POST:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"authentification %@", responseObject);
        
        [ShareAppContext sharedInstance].userIdentifier = [responseObject valueForKey:@"profile_id"];
        [ShareAppContext sharedInstance].accessToken = [responseObject valueForKey:@"access_token"];
        
        [[WSManager sharedInstance] getProfilsCompletion:^(NSError *error) {
            [self getUserCompletion:^(NSError *error) {
                
                onCompletion(nil);
            }];
        }];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", error);
         onCompletion(error);
     }];
}

- (void)sendPicture:(UIImage*) picture position:(NSNumber*) position completion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= @"http://scarlet.aouka.org/rest/services/v1/picture" ;
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[self encodeToBase64String:picture] forKey:@"picture_data"];
    [param setObject:position forKey:@"position"];
    
    
    [manager POST:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        onCompletion(nil);

     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         onCompletion(error);
     }];
}

- (void)addDemand:(NSString*) identifier partner:(NSArray*) partnerIdentifier completion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= @"http://scarlet.aouka.org/rest/services/v1/friend" ;
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:identifier forKey:@"event_identifier"];
    [param setObject:partnerIdentifier forKey:@"partner"];
    
    [manager POST:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         onCompletion(nil);
         
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         onCompletion(error);
     }];
}
- (void)respondDemand:(NSString*) identifier status:(NSNumber*) status completion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= @"http://scarlet.aouka.org/rest/services/v1/friend" ;
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:identifier forKey:@"demand_identifier"];
    [param setObject:status forKey:@"status"];
    
    [manager PUT:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         onCompletion(nil);
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         onCompletion(error);
     }];
}


- (void)addFriend:(NSString*) identifier completion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= @"http://scarlet.aouka.org/rest/services/v1/friend" ;
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:identifier forKey:@"profile_identifier"];
    
    
    [manager POST:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         onCompletion(nil);
         
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         onCompletion(error);
     }];
}

- (void)respondFriend:(NSString*) identifier status:(NSNumber*) status completion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= @"http://scarlet.aouka.org/rest/services/v1/friend" ;
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:identifier forKey:@"friend_request_identifier"];
    [param setObject:status forKey:@"status"];
    
    [manager PUT:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         onCompletion(nil);
         
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         onCompletion(error);
     }];
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
}


- (void)editUserCompletion:(NSDictionary*) property :(void (^)(NSError* error)) onCompletion
{
    NSString* base= @"http://scarlet.aouka.org/rest/services/v1/user";
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    NSMutableDictionary * param = [NSMutableDictionary dictionaryWithDictionary:property];
    
    [manager PUT:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [WSParser addUser:[responseObject valueForKey:@"user"]];
         onCompletion(nil);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         onCompletion(error);
     }];
}


#pragma mark - GET REQUEST

- (void)getUserCompletion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= @"http://scarlet.aouka.org/rest/services/v1/user";
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];
    
    [manager GET:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"getUserCompletion %@", responseObject);
        [WSParser addUser:[responseObject valueForKey:@"user"]];
        onCompletion(nil);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
         NSLog(@"%@", error);
        onCompletion(error);
    }];
}

- (void)getEventsCompletion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= @"http://scarlet.aouka.org/rest/services/v1/event";
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    [manager GET:base parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSArray* lAllEvents= [responseObject valueForKey:@"event"];
        for(NSDictionary * lDicEvent in lAllEvents)
        {
            [WSParser addEvent:lDicEvent];
        }
        onCompletion(nil);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     onCompletion(error);
     }];
}

- (void)getProfilsCompletion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= @"http://scarlet.aouka.org/rest/services/v1/profile";
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param setObject:[ShareAppContext sharedInstance].accessToken forKey:@"access_token"];
    
    
    [manager GET:base parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"getProfilsCompletion %@", responseObject);
        NSArray* lAllProfiles= [responseObject valueForKey:@"profile"];
        for(NSDictionary * lDicProfile in lAllProfiles)
        {
            [WSParser addProfile:lDicProfile];
        }
        onCompletion(nil);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     onCompletion(error);
     }];
}


- (void)getMessagesForChat:(Chat*) chat completion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= @"http://scarlet.aouka.org/rest/services/v1/message";
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    [manager GET:base parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSArray* lAllMessage= [responseObject valueForKey:@"message"];
        [chat removeMessages:chat.messages];
        
        for(NSDictionary * lDicMessage in lAllMessage)
        {
            [chat addMessagesObject:[WSParser addMessage:lDicMessage]];
        }
        onCompletion(nil);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     onCompletion(error);
     }];
}




- (void)getMyEventsCompletion:(void (^)(NSError* error)) onCompletion
{
    NSString* base= @"http://scarlet.aouka.org/rest/services/v1/myevent";
    AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    [manager GET:base parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSArray* lAllEvents= [responseObject valueForKey:@"event"];
        for(NSDictionary * lDicEvent in lAllEvents)
        {
            [WSParser addEvent:lDicEvent];
        }
        onCompletion(nil);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     onCompletion(error);
     }];
}

- (void)getChatsCompletion:(void (^)(NSError* error)) onCompletion
{
    //NSString* base= nil;
    //AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    //[manager GET:base parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary* reponseObject = [self getDataFromFile:@"chats.json"];
        
        NSArray* lAllEvents= [reponseObject valueForKey:@"event"];
        for(NSDictionary * lDicEvent in lAllEvents)
        {
            [WSParser addEvent:lDicEvent];
        }
        onCompletion(nil);
    }
    /*failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     onCompletion(nil);
     }];*/
}





@end

