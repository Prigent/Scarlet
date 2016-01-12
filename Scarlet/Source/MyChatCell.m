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
        
        NSDateFormatter *formatHours = [[NSDateFormatter alloc] init];
        [formatHours setDateFormat:@"HH:mm"];
     
        
        _mDateMessage.text = [formatDate stringFromDate:lMessage.date];
        _mHoursMessage.text = [formatHours stringFromDate:lMessage.date];
    }
    else
    {
        Picture * picture = [chat.event.leader.pictures firstObject];
         self.mLastMessageImage.image = nil;
        [self.mLastMessageImage setImageWithURL:[NSURL URLWithString:picture.filename]];
        _mLastMessageOwner.text = chat.event.leader.firstName;
        _mLastMessageText.text  = @"";
        _mDateMessage.text = [formatDate stringFromDate:chat.event.date];
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
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
