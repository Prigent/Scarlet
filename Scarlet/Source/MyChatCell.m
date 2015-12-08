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
    if([[chat.messages allObjects] count]>0)
    {
        Message* lMessage = [[chat.messages allObjects] firstObject];
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
        _mLastMessageText.text  = @"No message";
        _mDateMessage.text = [formatDate stringFromDate:chat.event.date];
        _mHoursMessage.text = @"";
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
