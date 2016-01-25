//
//  Message.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "Message.h"
#import "Chat.h"
#import "Profile.h"

#import "NSDate+Utilities.h"

@implementation Message

// Insert code here to add functionality to your managed object subclass
-(NSString*) getDateString;
{
    if([self.date isToday])
    {
        NSString* datePart = [NSDateFormatter localizedStringFromDate:self.date dateStyle: kCFDateFormatterNoStyle timeStyle: NSDateFormatterShortStyle];
        return [datePart uppercaseString];
    }
    else
    {
        NSString* datePart = [NSDateFormatter localizedStringFromDate:self.date dateStyle: kCFDateFormatterMediumStyle timeStyle: NSDateFormatterShortStyle];
        return [datePart uppercaseString];
    }
}

@end
