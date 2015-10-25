//
//  ShareAppContext.m
//  OM
//
//  Created by Prigent ROUDAUT on 14/01/2015.
//  Copyright (c) 2015 HighConnexion. All rights reserved.
//

#import "ShareAppContext.h"

@implementation ShareAppContext


- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.queue = [[NSOperationQueue alloc] init];
    }
    return self;
}


+ (ShareAppContext *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}



+ (BOOL)isConnected
{
    bool connected = ([[NSUserDefaults standardUserDefaults] valueForKey:@"user"]!= nil);
    return connected;
}

+ (BOOL)isOnline
{
    NSDictionary * lUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"user"];
    NSString * lDateString = [lUser valueForKey:@"end_date_om_tv_online"];
    NSDateFormatter * lDateFormater =  [[NSDateFormatter alloc] init];
    [lDateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *lDateAbonnement = [lDateFormater dateFromString:lDateString];

    bool online = ([lDateAbonnement compare:[NSDate date]] == NSOrderedDescending);
    return online;
}



@end
