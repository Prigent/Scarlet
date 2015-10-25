//
//  MyEventCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "MyEventCell.h"
#import "Event.h"
#import "UIImageView+AFNetworking.h"
#import "Profile.h"
#import "Picture.h"
#import "ShareAppContext.h"
#import "Demand.h"

@implementation MyEventCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) configure:(Event*) event
{
    Picture * picture = [event.leader.pictures firstObject];
    [self.mLeaderImage setImageWithURL:[NSURL URLWithString:picture.filename]];
    
    for(UIImageView * imageView in _mPartnerImages)
    {
        imageView.image = nil;
    }
    
    int i=0;
    for(Profile * lPartner in event.partners)
    {
        if(i>= [_mPartnerImages count])
        {
            break;
        }
        UIImageView * imagePartnerView = [_mPartnerImages objectAtIndex:i];
        Picture * picture = [lPartner.pictures firstObject];
        [imagePartnerView setImageWithURL:[NSURL URLWithString:picture.filename]];
        i++;
    }
    
    _mTitle.text = [NSString stringWithFormat:@"%@ +%lu", event.leader.name, [event.partners count]];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"EEEE, dd/MM/yyyy\nHH:mm"];
    _mDate.text = [format stringFromDate:event.date];

    if([event.leader.identifier isEqualToString:[ShareAppContext sharedInstance].userIdentifier])
    {
        _mStatusLabel.text = @"Leader";
    }
    else
    {
        Demand* demand;
        switch ([demand.status integerValue]) {
            case 1: _mStatusLabel.text = @"accepted";break;
            case 2: _mStatusLabel.text = @"rejected";break;
            case 3: _mStatusLabel.text = @"waiting"; break;
            default:break;
        }
    }
        
        
    
    

}

@end
