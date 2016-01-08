//
//  MapEventCollectionCell.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 21/12/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Event;
@interface MapEventCollectionCell : UICollectionViewCell

@property (strong, nonatomic) NSArray *mData;
@property (strong, nonatomic) Event * mEvent;
@property (weak, nonatomic) IBOutlet UICollectionView *mCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mSubTitleLabel;

-(void) configure:(Event*) event;
@end
