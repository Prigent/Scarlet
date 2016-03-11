//
//  MyEventCell.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Event;
@interface MyEventCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mTitle;
@property (weak, nonatomic) IBOutlet UILabel *mSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *mDate;
@property (weak, nonatomic) IBOutlet UICollectionView *mCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *mButtonEdit;

@property (weak, nonatomic) IBOutlet UILabel *mStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *mCount;
@property (weak, nonatomic) IBOutlet UIView *mBackgroundLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mIconLabel;


@property (strong, nonatomic) NSArray *mData;
@property (strong, nonatomic) Event* mEvent;

@end
