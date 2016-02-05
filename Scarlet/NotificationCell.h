//
//  NotificationCell.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 12/01/2016.
//  Copyright © 2016 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mTitle;
@property (weak, nonatomic) IBOutlet UISwitch *mSwitch;

@property (strong, nonatomic)NSString* mKey;
@property (strong, nonatomic)NSNumber* mEnabled;


@end
