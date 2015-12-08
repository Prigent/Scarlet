//
//  EventExpendCell.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Event;
@interface EventExpendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mMood;
@property (weak, nonatomic) IBOutlet UILabel *mCountPeople;
@property (weak, nonatomic) IBOutlet UILabel *mAddress;
@property (weak, nonatomic) IBOutlet UILabel *mDate;
@property (weak, nonatomic) IBOutlet UICollectionView *mCollectionView;

@property (strong, nonatomic) NSArray *mData;
@property (strong, nonatomic) Event *mEvent;
@property (weak, nonatomic) IBOutlet UIImageView *mMapImageView;

-(void) configure:(Event*) event;


@end
