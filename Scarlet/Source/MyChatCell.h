//
//  MyChatCell.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mHoursMessage;
@property (weak, nonatomic) IBOutlet UIImageView *mLastMessageImage;
@property (weak, nonatomic) IBOutlet UILabel *mLastMessageText;
@property (weak, nonatomic) IBOutlet UILabel *mLastMessageOwner;
@property (weak, nonatomic) IBOutlet UILabel *mDateMessage;

@end