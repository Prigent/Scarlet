//
//  Event.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "Event.h"
#import "Address.h"
#import "Chat.h"
#import "Demand.h"
#import "Profile.h"

#import "NSDate+Utilities.h"
#import "ShareAppContext.h"

@implementation Event

// Insert code here to add functionality to your managed object subclass
-(NSInteger) getMyStatus
{
    
    if([self.leader.identifier isEqualToString:[ShareAppContext sharedInstance].userIdentifier])
    {
        // IS LEADER
        return 1;
    }
    

    NSPredicate *predPart = [NSPredicate predicateWithFormat:@"identifier == %@",[ShareAppContext sharedInstance].userIdentifier];
    NSArray *matchesPart = [[self.partners allObjects] filteredArrayUsingPredicate:predPart];
    if([matchesPart count]>0)
    {
        // IS PARTNER
        return 2;
    }

    
    for(Demand * lDemand in self.demands)
    {
        if([lDemand.leader.identifier isEqualToString:[ShareAppContext sharedInstance].userIdentifier])
        {
            switch ([lDemand.status integerValue]) {
                case 1: return 3;  // DEMAND ACCEPTED
                case 2: return 7;  // DEMAND REJECTED
                case 3: return 5;  // DEMAND WAITING
            }
        }
        
        for(Profile* lProfile in lDemand.partners)
        {
            if([lProfile.identifier isEqualToString:[ShareAppContext sharedInstance].userIdentifier])
            {
                switch ([lDemand.status integerValue]) {
                    case 1: return 4;  // DEMAND ACCEPTED
                    case 2: return 8;  // DEMAND REJECTED
                    case 3: return 6;  // DEMAND WAITING
                }
            }
        }
    }
    return 0;
}

-(NSString*) getDateString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"EEEE"];
    NSString* dayPart = [format stringFromDate:self.date];
    if([self.date isToday])
    {
        dayPart = NSLocalizedString(@"today", nil);
    }
    else if([self.date isTomorrow])
    {
        dayPart = NSLocalizedString(@"tomorrow", nil);
    }
    
    NSString* datePart = [NSDateFormatter localizedStringFromDate: self.date
                                                        dateStyle: NSDateFormatterShortStyle
                                                        timeStyle: NSDateFormatterNoStyle];
    NSString* timePart = [NSDateFormatter localizedStringFromDate: self.date
                                                        dateStyle: NSDateFormatterNoStyle
                                                        timeStyle: NSDateFormatterShortStyle];
    return [NSString stringWithFormat:@"%@, %@ %@ %@",[dayPart capitalizedString],datePart, NSLocalizedString(@"at", nil),timePart];
    
    
}

-(NSInteger) getCountMember
{
    NSInteger countMember = 1;
    countMember += [self.partners count];
    
    for(Demand * lDemand in self.demands)
    {
        switch ([lDemand.status integerValue])
        {
            case 1: countMember += ([lDemand.partners count] +1);
        }
    }
    return countMember;
}

-(NSInteger) getWaitingDemand
{
    NSArray * lDemand = [self.demands allObjects];
    NSPredicate * lPredicate = [NSPredicate predicateWithFormat:@"status == 3"];
    return [[lDemand filteredArrayUsingPredicate:lPredicate] count];
}




@end
