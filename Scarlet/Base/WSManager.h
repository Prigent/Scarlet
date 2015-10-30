//
//  WSManager.h
//  Ricard Strat
//
//  Created by Damien PRACA on 26/08/14.
//  Copyright (c) 2014 Ricard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReverseGeocoding.h"


@class Chat;
@interface WSManager : NSObject



+ (WSManager *)sharedInstance;
+ (CLGeocoder*) sharedGeocoder;



- (void)getUserCompletion:(void (^)(NSError* error)) onCompletion;
- (void)getEventsCompletion:(void (^)(NSError* error)) onCompletion;
- (void)getProfilsCompletion:(void (^)(NSError* error)) onCompletion;
- (void)getMessagesForChat:(Chat*) chat completion:(void (^)(NSError* error)) onCompletion;
- (void)getMyEventsCompletion:(void (^)(NSError* error)) onCompletion;


@end

