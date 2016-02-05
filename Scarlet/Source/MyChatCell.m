//
//  MyChatCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "MyChatCell.h"
#import "Chat.h"
#import "Event.h"
#import "Profile.h"
#import "Picture.h"
#import "Message.h"
#import "UIImageView+AFNetworking.h"
#import "Address.h"
#import "NSData+Base64.h"


@implementation MyChatCell
-(BOOL)isBase64Data:(NSString *)input
{
    
    input=[[input componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    if ([input length] % 4 == 0) {
        static NSCharacterSet *invertedBase64CharacterSet = nil;
        if (invertedBase64CharacterSet == nil) {
            invertedBase64CharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="]invertedSet];
        }
        return [input rangeOfCharacterFromSet:invertedBase64CharacterSet options:NSLiteralSearch].location == NSNotFound;
    }
    return NO;
}
-(void) configure:(Chat*) chat
{
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    [formatDate setDateFormat:@"dd/MM/yyyy"];
    _mLastMessageText.text = @"";
    if([chat.messages count]>0)
    {
        Message* lMessage = [chat.messages lastObject];
        
        if([self isBase64Data:lMessage.text])
        {
            NSData *data = [NSData dataFromBase64String:lMessage.text];
            NSString *valueUnicode = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData *dataa = [valueUnicode dataUsingEncoding:NSUTF8StringEncoding];
            NSString *valueEmoj = [[NSString alloc] initWithData:dataa encoding:NSNonLossyASCIIStringEncoding];
            _mLastMessageText.text = valueEmoj;
        }
        else
        {
            _mLastMessageText.text = _mLastMessageText.text;
        }

        
        _mLastMessageOwner.text = lMessage.owner.firstName;
        Picture * picture = [lMessage.owner.pictures firstObject];
        self.mLastMessageImage.image = nil;
        [self.mLastMessageImage setImageWithURL:[NSURL URLWithString:picture.filename]];
        
        NSString* datePart = [NSDateFormatter localizedStringFromDate:lMessage.date dateStyle: kCFDateFormatterMediumStyle timeStyle: NSDateFormatterShortStyle];
        self.mDateMessage.text = [lMessage getDateString];

        
        _mReadStatus.hidden = [lMessage.readStatus boolValue];
    }
    else
    {
        Picture * picture = [chat.event.leader.pictures firstObject];
         self.mLastMessageImage.image = nil;
        [self.mLastMessageImage setImageWithURL:[NSURL URLWithString:picture.filename]];
        _mLastMessageOwner.text = chat.event.leader.firstName;
        _mLastMessageText.text  = @"";
        _mDateMessage.text = @"";
        _mHoursMessage.text = @"";
    }
    
    self.mProfileListText.text = chat.event.leader.firstName;
    for(int i=0 ; i< [chat.event.partners count] ; i++)
    {
        Profile* lProfile = [[chat.event.partners allObjects]objectAtIndex:i];
        if( i == [chat.event.partners count]-1)
        {
            self.mProfileListText.text = [NSString stringWithFormat:@"%@ %@ %@",self.mProfileListText.text , NSLocalizedString2(@"and", @"and"), lProfile.firstName ];
            NSLog(@"%@", self.mProfileListText.text);
        }
        else
        {
            self.mProfileListText.text = [NSString stringWithFormat:@"%@, %@",self.mProfileListText.text, lProfile.firstName ];
            NSLog(@"%@", self.mProfileListText.text);
        }
    }
    
    
    
    _mAdressLabel.text  = [NSString stringWithFormat:@"%@",chat.event.address.street];
    _mSheduleLabel.text = [chat.event getDateString];
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
