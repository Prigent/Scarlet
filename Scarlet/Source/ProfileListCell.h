//
//  ProfileListCell.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 26/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileListCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *mProfileListImage;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *mProfileListLabel;

@end
