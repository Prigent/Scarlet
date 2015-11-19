//
//  WSManager.h
//  Ricard Strat
//
//  Created by Damien PRACA on 26/08/14.
//  Copyright (c) 2014 Ricard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReverseGeocoding.h"

typedef enum {
    kaccept = 1,
    kreject,
    kwaiting
} StatusType;


@class Chat,Profile;
@interface WSManager : NSObject


@property (nonatomic, retain) NSString* mBaseURL;

+ (WSManager *)sharedInstance;
+ (CLGeocoder*) sharedGeocoder;


- (void)authentification:(NSString*) token completion:(void (^)(NSError* error)) onCompletion;

- (void)getProfilsCompletion:(void (^)(NSError* error)) onCompletion;
- (void)getEventsCompletion:(void (^)(NSError* error)) onCompletion;
- (void)getMyEventsCompletion:(void (^)(NSError* error)) onCompletion;
- (void)getMessagesForChat:(Chat*) chat completion:(void (^)(NSError* error)) onCompletion;
- (void)getChatsCompletion:(void (^)(NSError* error)) onCompletion;
- (void)getUserCompletion:(void (^)(NSError* error)) onCompletion;

- (void)saveUserCompletion:(void (^)(NSError* error)) onCompletion;
- (void)addDemand:(NSString*) identifier partner:(NSArray*) partnerIdentifier completion:(void (^)(NSError* error)) onCompletion;
- (void)respondDemand:(NSString*) identifier status:(NSNumber*) status completion:(void (^)(NSError* error)) onCompletion;
- (void)addFriend:(NSString*) identifier completion:(void (^)(NSError* error)) onCompletion;
- (void)respondFriend:(NSString*) identifier status:(NSNumber*) status completion:(void (^)(NSError* error)) onCompletion;

- (void)sendPicture:(UIImage*) picture position:(NSNumber*) position completion:(void (^)(NSError* error)) onCompletion;
- (void)removePicture:(NSNumber*) position completion:(void (^)(NSError* error)) onCompletion;

- (void)addMessageCompletion:(void (^)(NSError* error)) onCompletion;
- (void)createEventCompletion:(void (^)(NSError* error)) onCompletion;
- (void)getMutualfriend:(Profile*) profile completion:(void (^)(NSError* error)) onCompletion;

//add message
//create event



@end

