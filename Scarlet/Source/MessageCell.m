//
//  MessageCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 25/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "MessageCell.h"
#import "Message.h"
#import "Profile.h"
#import "Picture.h"
#import "UIImageView+AFNetworking.h"
#import "ShareAppContext.h"

@implementation MessageCell

-(void) configure:(Message*) message
{
    _mTitle.text = [NSString stringWithFormat:@"%@", message.owner.firstName];
    _mMessage.text = message.text;
    
    
    Picture * picture = [message.owner.pictures firstObject];
    
    if([message.owner.identifier isEqualToString:[ShareAppContext sharedInstance].userIdentifier])
    {
        [self.mUserImage setImageWithURL:[NSURL URLWithString:picture.filename]];
        
    }
    else
    {
        [self.mProfileImage setImageWithURL:[NSURL URLWithString:picture.filename]];
        
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
