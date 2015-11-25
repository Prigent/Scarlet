//
//  EventCell.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mTitle;
@property (weak, nonatomic) IBOutlet UILabel *mSubtitle;
@property (weak, nonatomic) IBOutlet UICollectionView *mCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *mCount;
@property (strong, nonatomic) NSArray *mData;
@end
