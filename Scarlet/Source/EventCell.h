//
//  EventCell.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mLeaderImage;
@property (weak, nonatomic) IBOutlet UIImageView *mPartnerImage1;
@property (weak, nonatomic) IBOutlet UIImageView *mPartnerImage2;
@property (weak, nonatomic) IBOutlet UIImageView *mPartnerImage;
@property (weak, nonatomic) IBOutlet UILabel *mTitle;
@property (weak, nonatomic) IBOutlet UILabel *mSubtitle;

@end
