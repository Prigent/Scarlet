//
//  DemandCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 23/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "DemandCell.h"
#import "Demand.h"
#import "UIImageView+AFNetworking.h"
#import "Profile.h"
#import "Picture.h"

@implementation DemandCell

- (void)awakeFromNib {
    // Initialization code
}

-(void) configure:(Demand*) demand
{
    Picture * picture = [demand.leader.pictures firstObject];
    [self.mLeaderImage setImageWithURL:[NSURL URLWithString:picture.filename]];
    
    switch ([demand.status integerValue]) {
        case 1:_mStatusLabel.text = @"accepted";break;
        case 2:_mStatusLabel.text = @"rejected";break;
        case 3: _mStatusLabel.text = @"waiting"; break;
        default:break;
    }
}

@end
