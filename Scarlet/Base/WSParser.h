//
//  WSParser.h
//  osis
//
//  Created by Damien PRACA on 08/04/14.
//  Copyright (c) 2014 Damien PRACA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User,Profile,Event, Message, FacebookProfile,Demand,Chat;
@interface WSParser : NSObject

+(Message*) addMyMessageTmp:(NSString*) messagetxt;
+(User*) getUser:(NSString*) idUser;
+(Chat*) addChatObject:(NSString*) chatId;
+(User*) addUser:(NSDictionary*) dicUser;
+(Profile*) addProfile:(NSDictionary*) dicProfile;
+(Event*) addEvent:(NSDictionary*) dicEvent;
+(Event*) editEvent:(NSDictionary*) dicEvent;
+(Event*) getEvent:(NSString*) idEvent;


+(Message*) addMessage:(NSDictionary*) dicMessage;
+(NSArray*) getProfiles;
+(FacebookProfile* ) addFacebookProfile:(NSDictionary*) dicFacebookProfile;
+(Demand*) addDemand:(NSDictionary*) dicDemand;
+(Chat*) addChat:(NSDictionary*) chatDic;
+(NSArray*) getChats;
+(NSArray*) getEvents;
+(NSArray*) getEventsNotOwn;
+(void) removeEventNotOwn;
+(void) removeEventOwn;

+(void) resetProfileUpdate;
+(void) removeProfileNotUpdate;
@end

