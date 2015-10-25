//
//  DetailProfileCell.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 25/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mOccupationLabel;
@property (weak, nonatomic) IBOutlet UILabel *mAboutLabel;
@property (weak, nonatomic) IBOutlet UILabel *mCountFriendLabel;

@end
