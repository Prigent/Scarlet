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


- (void)getUserCompletion:(void (^)(NSError* error)) onCompletion
{
    //NSString* base= nil;
    //AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    //[manager GET:base parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary* reponseObject = [self getDataFromFile:@"user.json"];
        [WSParser addUser:[reponseObject valueForKey:@"user"]];
        onCompletion(nil);
    }
    /*failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        onCompletion(nil);
    }];*/
}

- (void)getEventsCompletion:(void (^)(NSError* error)) onCompletion
{
    //NSString* base= nil;
    //AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    //[manager GET:base parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary* reponseObject = [self getDataFromFile:@"events.json"];
        
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


- (void)getProfilsCompletion:(void (^)(NSError* error)) onCompletion
{
    //NSString* base= nil;
    //AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    //[manager GET:base parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary* reponseObject = [self getDataFromFile:@"profiles.json"];
        
        NSArray* lAllProfiles= [reponseObject valueForKey:@"profile"];
        for(NSDictionary * lDicProfile in lAllProfiles)
        {
            [WSParser addProfile:lDicProfile];
        }
        onCompletion(nil);
    }
    /*failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     onCompletion(nil);
     }];*/
}


- (void)getMessagesForChat:(Chat*) chat completion:(void (^)(NSError* error)) onCompletion
{
    //NSString* base= nil;
    //AFHTTPRequestOperationManager *manager = [self createConfiguredManager];
    //[manager GET:base parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary* reponseObject = [self getDataFromFile:@"messages.json"];
        
        NSArray* lAllMessage= [reponseObject valueForKey:@"message"];
        [chat removeMessages:chat.messages];
        
        for(NSDictionary * lDicMessage in lAllMessage)
        {
            [chat addMessagesObject:[WSParser addMessage:lDicMessage]];
        }
        onCompletion(nil);
    }
    /*failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     onCompletion(nil);
     }];*/
}
@end

