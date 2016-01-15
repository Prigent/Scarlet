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
@implementation MyChatCell

-(void) configure:(Chat*) chat
{
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    [formatDate setDateFormat:@"dd/MM/yyyy"];
    if([chat.messages count]>0)
    {
        Message* lMessage = [chat.messages lastObject];
        _mLastMessageText.text  = lMessage.text;
        _mLastMessageOwner.text = lMessage.owner.firstName;
        Picture * picture = [lMessage.owner.pictures firstObject];
        self.mLastMessageImage.image = nil;
        [self.mLastMessageImage setImageWithURL:[NSURL URLWithString:picture.filename]];
        
        NSString* datePart = [NSDateFormatter localizedStringFromDate:lMessage.date dateStyle: kCFDateFormatterMediumStyle timeStyle: NSDateFormatterShortStyle];
        self.mDateMessage.text = [datePart uppercaseString];

        
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
        i++;
        if( i == [chat.event.partners count])
        {
            self.mProfileListText.text = [NSString stringWithFormat:@"%@ %@ %@",self.mProfileListText.text , NSLocalizedString(@"and", @"and"), lProfile.firstName ];
        }
        else
        {
            self.mProfileListText.text = [NSString stringWithFormat:@"%@, %@",self.mProfileListText.text, lProfile.firstName ];
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
