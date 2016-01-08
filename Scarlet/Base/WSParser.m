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
    Message* message = [WSParser getMessage:[dicMessage valueForKey:@"identifier"]];
    if(message == nil)
    {
        message  = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:[ShareAppContext sharedInstance].managedObjectContext];
    }

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
    friendRequest.status = [self parseNumberValue:[dicFriendRequest valueForKey:@"status"]];
    friendRequest.profile = [self getProfile: [dicFriendRequest valueForKey:@"profile_id"]];
    friendRequest.type = [self parseNumberValue:[dicFriendRequest valueForKey:@"type"]];
    return friendRequest;
}


+(FriendRequest*) getFriendRequest:(NSString*) idFriendRequest
{
    return [WSParser searchIdentifier:idFriendRequest andName:@"FriendRequest"];
}

+(Message*) getMessage:(NSString*) idMessage
{
    return [WSParser searchIdentifier:idMessage andName:@"Message"];
}


+(FacebookProfile* ) addFacebookProfile:(NSDictionary*) dicFacebookProfile
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
    user.lookingFor = [dicUser valueForKey:@"lookingfor"];
    user.ageMax = [dicUser valueForKey:@"age_max"];
    user.ageMin = [dicUser valueForKey:@"age_min"];
    
    
    NSDictionary * gps =  [dicUser valueForKey:@"gps"];

    
    user.lat = [self parseNumberValue:[gps valueForKey:@"lat"]];
    user.longi =  [self parseNumberValue:[gps valueForKey:@"long"]];
    

    
    
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
    
    
    
    [profile removePictures:profile.pictures];
    NSArray* lArrayPicture = [dicProfile valueForKey:@"picture"];
    if([lArrayPicture isKindOfClass:[NSArray class]])
    {
        for(NSString* lFileName in lArrayPicture)
        {
            [profile addPicturesObject:[self addPicture:lFileName]];
        }
    }
    
    
    [profile removeFriends:profile.friends];
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
    event.identifier = [self parseStringValue:[dicEvent valueForKey:@"identifier"]];
    event.date = [NSDate dateWithTimeIntervalSince1970:[[dicEvent valueForKey:@"date"] integerValue]];
   
    
    Profile* lLeader = [self getProfile:[self parseStringValue:[dicEvent valueForKey:@"leader_id"]]];
    event.leader = lLeader;
    
    event.chat = [self addChatObject:[self parseStringValue:[dicEvent valueForKey:@"chat_id"]]];
    event.mood = [dicEvent valueForKey:@"mood"];
    event.address = [self addAddress:dicEvent];
    event.status = [self parseNumberValue:[dicEvent valueForKey:@"status"]];
    
    if([dicEvent valueForKey:@"sort"])
    {
        event.sort = [self parseNumberValue:[dicEvent valueForKey:@"sort"]];
    }

    [event removePartners:event.partners];
    for(NSString* lProfileIdentifier in [dicEvent valueForKey:@"partners"])
    {
        Profile* lProfile = [self getProfile:lProfileIdentifier];
        if(lProfile)
        {
            [event addPartnersObject:[self getProfile:lProfileIdentifier]];
        }
    }
    
    [event removeDemands:event.demands];
    for(NSDictionary* lDemandDic in [dicEvent valueForKey:@"demands"])
    {
        Demand * lDemand = [self addDemand:lDemandDic];
        if(lDemand)
        {
            [event addDemandsObject:lDemand];
        }
    }
    
    NSInteger mystatus = [event getMyStatus];
    if(mystatus>0)
    {
       event.mystatus = [NSNumber numberWithInteger:mystatus];
    }

    CLLocation * lCLLocationA = [ShareAppContext sharedInstance].placemark.location;
    
    NSLog(@"lCLLocationA %@", lCLLocationA);
    
    CLLocation * lCLLocationB = [[CLLocation alloc] initWithLatitude:[event.address.lat doubleValue] longitude:[event.address.longi doubleValue]];
    CLLocationDistance distance = [lCLLocationA distanceFromLocation:lCLLocationB];
    
    
    event.distance = [NSNumber numberWithDouble:distance];
    
    
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
    demand.status = [self parseNumberValue:[dicDemand valueForKey:@"status"]];
    
    
    [demand removePartners:demand.partners];
    for(NSString* lProfileIdentifier in [dicDemand valueForKey:@"partners_id"])
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
    address.longi = [dicAddress valueForKey:@"long"];
    address.lat = [dicAddress valueForKey:@"lat"];
    address.street =  [dicAddress valueForKey:@"address"];
    return address;
}

+(Chat*) addChatObject:(NSString*) chatId
{
    Chat* chat = [WSParser getChat:chatId];
    if(chat == nil)
    {
        chat = [NSEntityDescription insertNewObjectForEntityForName:@"Chat" inManagedObjectContext:[ShareAppContext sharedInstance].managedObjectContext];
    }
    chat.identifier = chatId;
    return chat;
}


+(Chat*) addChat:(NSDictionary*) chatDic
{
    Chat* chat = [WSParser getChat:[chatDic valueForKey:@"identifier"]];
    if(chat == nil)
    {
        chat = [NSEntityDescription insertNewObjectForEntityForName:@"Chat" inManagedObjectContext:[ShareAppContext sharedInstance].managedObjectContext];
    }
    chat.identifier = [chatDic valueForKey:@"identifier"];
    chat.isMine = [NSNumber numberWithBool:true];
    NSDictionary* lLastMessage = [chatDic valueForKey:@"lastMessage"];
    if([lLastMessage isKindOfClass:[NSDictionary class]])
    {
        [chat removeMessages:chat.messages];
        [chat addMessagesObject:[WSParser addMessage:lLastMessage]];
    }
    
    
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


+(NSArray*) getEvents
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:[ShareAppContext sharedInstance].managedObjectContext];
    [fetchRequest setEntity:entity];
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


+(NSNumber*) parseNumberValue:(id) valueArray
{
    if([valueArray isKindOfClass:[NSArray class]])
    {
        for(NSDictionary* lDicValue in valueArray)
        {
            id value = [lDicValue valueForKey:kValue];
            if([value isKindOfClass:[NSNumber class]])
            {
                return value;
            }
            else if([value isKindOfClass:[NSString class]])
            {
                return [NSNumber numberWithInteger:[[lDicValue valueForKey:kValue] integerValue]];
            }
        }
    }
    else if([valueArray isKindOfClass:[NSDictionary class]])
    {
        id value = [valueArray valueForKey:kValue];
        if([value isKindOfClass:[NSNumber class]])
        {
            return value;
        }
        else if([value isKindOfClass:[NSString class]])
        {
            return [NSNumber numberWithInteger:[[valueArray valueForKey:kValue] integerValue]];
        }
    }
    else if([valueArray isKindOfClass:[NSString class]])
    {
        id value = valueArray;
        return [NSNumber numberWithInteger:[value integerValue]];
    }
    else if([valueArray isKindOfClass:[NSNumber class]])
    {
        id value = valueArray;
        return value;
    }
    return nil;
}


+(NSNumber*) parseDoubleNumberValue:(id) valueArray
{
    if([valueArray isKindOfClass:[NSArray class]])
    {
        for(NSDictionary* lDicValue in valueArray)
        {
            id value = [lDicValue valueForKey:kValue];
            if([value isKindOfClass:[NSNumber class]])
            {
                return value;
            }
            else if([value isKindOfClass:[NSString class]])
            {
                return [NSNumber numberWithDouble:[[lDicValue valueForKey:kValue] doubleValue]];
            }
        }
    }
    else if([valueArray isKindOfClass:[NSDictionary class]])
    {
        id value = [valueArray valueForKey:kValue];
        if([value isKindOfClass:[NSNumber class]])
        {
            return value;
        }
        else if([value isKindOfClass:[NSString class]])
        {
            return [NSNumber numberWithDouble:[[valueArray valueForKey:kValue] doubleValue]];
        }
    }
    else if([valueArray isKindOfClass:[NSString class]])
    {
        id value = valueArray;
        return [NSNumber numberWithDouble:[value doubleValue]];
    }
    else if([valueArray isKindOfClass:[NSNumber class]])
    {
        id value = valueArray;
        return value;
    }
    return nil;
}




+(NSString*) parseStringValue:(id) valueArray
{
    if([valueArray isKindOfClass:[NSArray class]])
    {
        for(NSDictionary* lDicValue in valueArray)
        {
            id value = [lDicValue valueForKey:kValue];
            if([value isKindOfClass:[NSString class]])
            {
                return value;
            }
            
        }
    }
    else if([valueArray isKindOfClass:[NSDictionary class]])
    {
        id value = [valueArray valueForKey:kValue];
        if([value isKindOfClass:[NSString class]])
        {
            return value;
        }
    }
    else if([valueArray isKindOfClass:[NSString class]])
    {
        id value = valueArray;
        return value;
    }
    else if([valueArray isKindOfClass:[NSNumber class]])
    {
        NSNumber* numberValue = (NSNumber*)valueArray;
        return [numberValue stringValue];
    }
    return nil;
}

@end
