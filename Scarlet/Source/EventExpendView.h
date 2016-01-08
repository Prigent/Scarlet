//
//  EventExpendCell.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Event;
@interface EventExpendView : UIView

@property (weak, nonatomic) IBOutlet UILabel *mMood;
@property (weak, nonatomic) IBOutlet UILabel *mCountPeople;
@property (weak, nonatomic) IBOutlet UILabel *mAddress;
@property (weak, nonatomic) IBOutlet UILabel *mDate;
@property (weak, nonatomic) IBOutlet UILabel *mStatusLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *mCollectionView;

@property (strong, nonatomic) NSArray *mData;
@property (strong, nonatomic) Event *mEvent;
@property (weak, nonatomic) IBOutlet UIImageView *mMapImageView;

@property (weak, nonatomic) IBOutlet UILabel *mHideLabel;
@property (weak, nonatomic) IBOutlet UISwitch *mHideSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mTopSwitch;
-(void) configure:(Event*) event;


@end
