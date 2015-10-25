//
//  MyEventCell.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyEventCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mLeaderImage;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *mPartnerImages;
@property (weak, nonatomic) IBOutlet UILabel *mStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTitle;
@property (weak, nonatomic) IBOutlet UILabel *mDate;

@end
