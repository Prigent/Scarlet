//
//  EventCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "EventCell.h"
#import "Event.h"
#import "UIImageView+AFNetworking.h"
#import "Profile.h"
#import "Picture.h"
#import "Address.h"

@implementation EventCell

-(void) configure:(Event*) event
{
    Picture * picture = [event.leader.pictures firstObject];
    [self.mLeaderImage setImageWithURL:[NSURL URLWithString:picture.filename]];
    
    if([event.partners count] == 1)
    {
        Profile * partner = [[event.partners allObjects] firstObject];
        Picture* picture = [partner.pictures firstObject];
        [self.mPartnerImage setImageWithURL:[NSURL URLWithString:picture.filename]];
        
    }
    else if([event.partners count] >= 2)
    {
        Profile * partner1 = [[event.partners allObjects] firstObject];
        Picture* picture1 = [partner1.pictures firstObject];
        [self.mPartnerImage1 setImageWithURL:[NSURL URLWithString:picture1.filename]];
        
        Profile * partner2 = [[event.partners allObjects] objectAtIndex:1];
        Picture* picture2 = [partner2.pictures firstObject];
        [self.mPartnerImage2 setImageWithURL:[NSURL URLWithString:picture2.filename]];
    }
    
    _mTitle.text = event.leader.firstName;
    for(Profile * lPartner in event.partners)
    {
        _mTitle.text = [_mTitle.text stringByAppendingString:[NSString stringWithFormat:@", %@",lPartner.firstName]];
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"EEEE, dd/MM/yyyy à HH:mm"];
    _mSubtitle.text  = [NSString stringWithFormat:@"%@, %@",event.address.street ,[format stringFromDate:event.date] ];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
