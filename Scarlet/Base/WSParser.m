//
//  WSParser.m
//  osis
//
//  Created by Damien PRACA on 08/04/14.
//  Copyright (c) 2014 Damien PRACA. All rights reserved.
//

#import "WSParser.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "ShareAppContext.h"
#import "User.h"
#import "Event.h"
#import "Picture.h"
#import "Chat.h"
#import "Address.h"
#import "Demand.h"
#import "Message.h"

@implementation WSParser

#pragma mark - Items

+(Message*) addMessage:(NSDictionary*) dicMessage
{
    Message* message  = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:[ShareAppContext sharedInstance].managedObjectContext];
    message.date = [NSDate dateWithTimeIntervalSince1970:[[dicMessage valueForKey:@"date"] integerValue]];
    message.identifier = [dicMessage valueForKey:@"identifier"];
    message.text = [dicMessage valueForKey:@"message"];
    message.owner = [self getProfile:[dicMessage valueForKey:@"profile_id"]];
    return message;
}


+(User*) addUser:(NSDictionary*) dicUser
{
    User* user = [WSParser getUser:[dicUser valueForKey:@"identifier"]];
    if(user == nil)
    {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[ShareAppContext sharedInstance].managedObjectContext];
    }
    [self parseProfile:dicUser profile:user];
    user.lookingFor = [dicUser valueForKey:@"lookingFor"];
    user.ageMax = [dicUser valueForKey:@"age_max"];
    user.ageMin = [dicUser valueForKey:@"age_min"];
    
    return user;
}

+(User*) getUser:(NSString*) idUser
{
    return [WSParser searchIdentifier:idUser andName:@"User"];
}


+(Profile*) addProfile:(NSDictionary*) dicProfile
{
    Profile* profile = [WSParser getProfile:[dicProfile valueForKey:@"identifier"]];
    if(profile == nil)
    {
        profile = [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:[ShareAppContext sharedInstance].managedObjectContext];
    }
    return [self parseProfile:dicProfile profile:profile];
}


+(Profile*) parseProfile:(NSDictionary*) dicProfile profile:(Profile*) profile
{
    profile.identifier = [dicProfile valueForKey:@"identifier"];
    profile.name = [dicProfile valueForKey:@"name"];
    profile.firstName = [dicProfile valueForKey:@"firstname"];
    profile.pictures = [NSOrderedSet orderedSet];
    profile.occupation = [dicProfile valueForKey:@"occupation"];
    profile.about = [dicProfile valueForKey:@"about"];
    
    profile.birthdate = [NSDate dateWithTimeIntervalSince1970:[[dicProfile valueForKey:@"birthdate"] integerValue]];
    
    
    for(NSString* lFileName in [dicProfile valueForKey:@"picture"])
    {
        [profile addPicturesObject:[self addPicture:lFileName]];
    }
    return profile;
}

+(Profile*) getProfile:(NSString*) idProfile
{
    return [WSParser searchIdentifier:idProfile andName:@"Profile"];
}

+(Event*) addEvent:(NSDictionary*) dicEvent
{
    Event* event = [WSParser getEvent:[dicEvent valueForKey:@"identifier"]];
    if(event == nil)
    {
        event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:[ShareAppContext sharedInstance].managedObjectContext];
    }
    event.identifier = [dicEvent valueForKey:@"identifier"];
    event.date = [NSDate dateWithTimeIntervalSince1970:[[dicEvent valueForKey:@"date"] integerValue]];
    event.leader = [self getProfile:[dicEvent valueForKey:@"leader_id"]];
    event.chat = [self addChat:[dicEvent valueForKey:@"chat_id"]];
    event.mood = [dicEvent valueForKey:@"mood"];
    event.address = [self addAddress:dicEvent];
    for(NSString* lProfileIdentifier in [dicEvent valueForKey:@"partners"])
    {
        [event addPartnersObject:[self getProfile:lProfileIdentifier]];
    }
    for(NSDictionary* lDemandDic in [dicEvent valueForKey:@"demands"])
    {
        [event addDemandsObject:[self addDemand:lDemandDic]];
    }
    return event;
}

+(Event*) getEvent:(NSString*) idEvent
{
    return [WSParser searchIdentifier:idEvent andName:@"Event"];
}


+(Demand*) addDemand:(NSDictionary*) dicDemand
{
    Demand* demand = [WSParser getDemand:[dicDemand valueForKey:@"identifier"]];
    if(demand == nil)
    {
        demand = [NSEntityDescription insertNewObjectForEntityForName:@"Demand" inManagedObjectContext:[ShareAppContext sharedInstance].managedObjectContext];
    }
    demand.identifier = [dicDemand valueForKey:@"identifier"];
    demand.date = [NSDate dateWithTimeIntervalSince1970:[[dicDemand valueForKey:@"date"] integerValue]];
    demand.leader = [self getProfile:[dicDemand valueForKey:@"leader_id"]];
    demand.status =[dicDemand valueForKey:@"status"];
    for(NSString* lProfileIdentifier in [dicDemand valueForKey:@"partners"])
    {
        [demand addPartnersObject:[self getProfile:lProfileIdentifier]];
    }
    return demand;
}

+(Demand*) getDemand:(NSString*) idDemand
{
    return [WSParser searchIdentifier:idDemand andName:@"Demand"];
}


+(Address*) addAddress:(NSDictionary*) dicAddress
{
    Address* address = [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:[ShareAppContext sharedInstance].managedObjectContext];

    
    address.longi = [dicAddress  valueForKey:@"long"];
    address.lat = [dicAddress valueForKey:@"lat"];
    address.street =  [dicAddress valueForKey:@"address"];
    return address;
}

+(Chat*) addChat:(NSString*) chatId
{
    Chat* chat = [WSParser getChat:chatId];
    if(chat == nil)
    {
        chat = [NSEntityDescription insertNewObjectForEntityForName:@"Chat" inManagedObjectContext:[ShareAppContext sharedInstance].managedObjectContext];
    }
    chat.identifier = chatId;
    return chat;
}

+(Chat*) getChat:(NSString*) idChat
{
    return [WSParser searchIdentifier:idChat andName:@"Chat"];
}

+(Picture*) addPicture:(NSString*) filename
{
    Picture* picture = [NSEntityDescription insertNewObjectForEntityForName:@"Picture" inManagedObjectContext:[ShareAppContext sharedInstance].managedObjectContext];
    picture.filename = filename;
    return picture;
}

+(NSArray*) getProfiles
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Profile" inManagedObjectContext:[ShareAppContext sharedInstance].managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray * anArray = [[ShareAppContext sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return anArray;
}


+(id) searchIdentifier:(id) identifier andName:(NSString*) name
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:[ShareAppContext sharedInstance].managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSLog(@"identifier ==  %@", identifier);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identifier];
    [fetchRequest setPredicate:predicate];
    
    NSArray * anArray = [[ShareAppContext sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return [anArray firstObject];
}

@end
