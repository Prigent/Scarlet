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


@class Chat,Profile, Event;
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
- (void)getNotificationConfiguration:(void (^)(NSError* error)) onCompletion;
- (void)deleteFriend:(Profile*) friend completion:(void (^)(NSError* error)) onCompletion;
- (void)geoLocate:(double) longi andLat:(double) lat;
- (void)geoBackgroundLocate:(double) longi andLat:(double) lat;

- (void)flagging:(NSString*) type identifier:(NSString*) identifier completion:(void (^)(NSError* error)) onCompletion;
- (void)chatOut:(NSString*) identifier completion:(void (^)(NSError* error)) onCompletion;


- (void)getTextCompletion:(void (^)(NSError* error)) onCompletion;
- (void)setNotificationConfiguration:(NSString*) key andValue:(NSNumber*) value completion:(void (^)(NSError* error)) onCompletion;
- (void)saveUserCompletion:(void (^)(NSError* error)) onCompletion;
- (void)addDemand:(Event*) event partner:(NSArray*) partnerIdentifier completion:(void (^)(NSError* error)) onCompletion;
- (void)removeDemand:(NSString*) demandID completion:(void (^)(NSError* error)) onCompletion;
- (void)respondDemand:(NSString*) identifier status:(NSNumber*) status completion:(void (^)(NSError* error)) onCompletion;
- (void)addFriend:(NSString*) identifier completion:(void (^)(NSError* error)) onCompletion;
- (void)respondFriend:(NSString*) identifier status:(NSNumber*) status completion:(void (^)(NSError* error)) onCompletion;

- (void)sendPicture:(UIImage*) picture position:(NSNumber*) position completion:(void (^)(NSError* error)) onCompletion;
- (void)removePicture:(NSNumber*) position completion:(void (^)(NSError* error)) onCompletion;
- (void)addMessage:(Chat*) chat message:(NSString*) message completion:(void (^)(NSError* error)) onCompletion;
- (void)createEvent:(NSDictionary*) eventDic completion:(void (^)(NSError* error)) onCompletion;

- (void)getMutualfriend:(Profile*) profile completion:(void (^)(NSError* error)) onCompletion;
- (void)editEvent:(NSDictionary*) eventDic completion:(void (^)(NSError* error)) onCompletion;
- (void)hideEvent:(Event*) event status:(NSNumber*) status completion:(void (^)(NSError* error)) onCompletion;
//add message
//create event
-(void) updateCountRead;
- (void)syncgeoLocate:(double) longi andLat:(double) lat;

@end

