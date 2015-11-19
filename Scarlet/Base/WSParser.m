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
#import "FriendRequest.h"
#import "FacebookProfile.h"
#import "Interest.h"

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

+(FriendRequest*) addFriendRequest:(NSDictionary*) dicFriendRequest
{
    FriendRequest* friendRequest = [WSParser getFriendRequest:[dicFriendRequest valueForKey:@"identifier"]];
    if(friendRequest == nil)
    {
        friendRequest = [NSEntityDescription insertNewObjectForEntityForName:@"FriendRequest" inManagedObjectContext:[ShareAppContext sharedInstance].managedObjectContext];
    }
    friendRequest.identifier = [dicFriendRequest valueForKey:@"identifier"];
    friendRequest.date = [NSDate dateWithTimeIntervalSince1970:[[dicFriendRequest valueForKey:@"date"] integerValue]];
    friendRequest.status = [self getValue:[dicFriendRequest valueForKey:@"status"]];
    friendRequest.profile = [self getProfile: [dicFriendRequest valueForKey:@"profile_id"]];
    friendRequest.type = [self getValue:[dicFriendRequest valueForKey:@"type"]];
    return friendRequest;
}


+(FriendRequest*) getFriendRequest:(NSString*) idFriendRequest
{
    return [WSParser searchIdentifier:idFriendRequest andName:@"FriendRequest"];
}

+(FacebookProfile*) addFacebookProfile:(NSDictionary*) dicFacebookProfile
{
    FacebookProfile* facebookProfile = [NSEntityDescription insertNewObjectForEntityForName:@"FacebookProfile" inManagedObjectContext:[ShareAppContext sharedInstance].managedObjectContext];
    
    facebookProfile.identifier = [dicFacebookProfile valueForKey:@"id"];
    facebookProfile.name = [dicFacebookProfile valueForKey:@"name"];
    facebookProfile.picture = [dicFacebookProfile valueForKey:@"picture"];
    
    return facebookProfile;
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
    
    
    NSArray* lArrayFriendsRequest = [dicUser valueForKey:@"friendRequest"];
    
    NSArray* listOfFriendRequest = [user.friendRequest allObjects];
    [user removeFriendRequest:user.friendRequest];
    for (NSManagedObject *managedObject in listOfFriendRequest) {
        [[ShareAppContext sharedInstance].managedObjectContext deleteObject:managedObject];
    }
    
    [user removeFriendRequest:user.friendRequest];
    
    if([lArrayFriendsRequest isKindOfClass:[NSArray class]])
    {
        for(NSDictionary* lFriendRequest in lArrayFriendsRequest)
        {
            [user addFriendRequestObject:[self addFriendRequest:lFriendRequest]];
        }
    }

    NSArray* lArraySuggest = [dicUser valueForKey:@"suggestProfile"];
    

    
    [user removeSuggestProfile:user.suggestProfile];
    if([lArraySuggest isKindOfClass:[NSArray class]])
    {
        for(NSString* lIdentifier in lArraySuggest)
        {
            Profile* lProfile = [self getProfile:lIdentifier];
            if(lProfile)
            {
                [user addSuggestProfileObject:lProfile];
            }
        }
    }

    
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
    
    NSArray* lArrayPicture = [dicProfile valueForKey:@"picture"];
    if([lArrayPicture isKindOfClass:[NSArray class]])
    {
        for(NSString* lFileName in lArrayPicture)
        {
            [profile addPicturesObject:[self addPicture:lFileName]];
        }
    }
    NSArray* lArrayFriends = [dicProfile valueForKey:@"friends"];
    if([lArrayFriends isKindOfClass:[NSArray class]])
    {
        for(NSString* lIdentifier in lArrayFriends)
        {
            Profile* lProfile = [self getProfile:lIdentifier];
            if(lProfile)
            {
                [profile addFriendsObject:lProfile];
            }
        }
    }
    
    [profile removeInterests:profile.interests];
    NSArray* lArrayInterest = [dicProfile valueForKey:@"interests"];
    if([lArrayInterest isKindOfClass:[NSArray class]])
    {
        for(NSString* lTitle in lArrayInterest)
        {
            Interest* lInterest =  [NSEntityDescription insertNewObjectForEntityForName:@"Interest" inManagedObjectContext:[ShareAppContext sharedInstance].managedObjectContext];
            lInterest.name = lTitle;
                [profile addInterestsObject:lInterest];
            
        }
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
        Profile* lProfile = [self getProfile:lProfileIdentifier];
        if(lProfile)
        {
            [event addPartnersObject:[self getProfile:lProfileIdentifier]];
        }
    }
    for(NSDictionary* lDemandDic in [dicEvent valueForKey:@"demands"])
    {
        Demand * lDemand = [self addDemand:lDemandDic];
        if(lDemand)
        {
            [event addDemandsObject:lDemand];
        }
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
        Profile* lProfile = [self getProfile:lProfileIdentifier];
        if(lProfile)
        {
            [demand addPartnersObject:lProfile];
        }
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier != %@", [ShareAppContext sharedInstance].userIdentifier];
    [fetchRequest setPredicate:predicate];
    
    NSArray * anArray = [[ShareAppContext sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return anArray;
}


+(id) searchIdentifier:(id) identifier andName:(NSString*) name
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:[ShareAppContext sharedInstance].managedObjectContext];
    [fetchRequest setEntity:entity];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identifier];
    [fetchRequest setPredicate:predicate];
    
    NSArray * anArray = [[ShareAppContext sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return [anArray firstObject];
}


+(NSNumber*) getValue:(id) data
{
    if([data isKindOfClass:[NSArray class]])
    {
        for (NSDictionary* lDic in data)
        {
            if([lDic isKindOfClass:[NSDictionary class]])
            {
                id value = [lDic valueForKey:@"value"];
                if([value isKindOfClass:[NSString class]]  || [value isKindOfClass:[NSNumber class]])
                {
                    return [NSNumber numberWithInt:[value intValue]];
                }
            }
        }
    }
    else if ([data isKindOfClass:[NSDictionary class]])
    {
        id value = [data valueForKey:@"value"];
        if([value isKindOfClass:[NSString class]]  || [value isKindOfClass:[NSNumber class]])
        {
            return [NSNumber numberWithInt:[value intValue]];
        }
    }
    else if([data isKindOfClass:[NSString class]]  || [data isKindOfClass:[NSNumber class]])
    {
        return [NSNumber numberWithInt:[data intValue]];
    }
    return nil;
}


@end
