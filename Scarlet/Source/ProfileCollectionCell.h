//
//  ProfileCollectionCell.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 03/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Profile;
@interface ProfileCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mImage;
@property (weak, nonatomic) IBOutlet UILabel *mTitle;
@property (strong, nonatomic) id mData;
@property (nonatomic) int mType;
-(void) configure:(Profile*) profile;
@end
