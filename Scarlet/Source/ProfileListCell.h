//
//  ProfileListCell.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 26/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileListCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSArray *mData;
@property (nonatomic) int mType;
@property (weak, nonatomic) IBOutlet UICollectionView *mCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *mEmptyLabel;
-(void) configure:(NSArray*) listProfile type:(int) type;
@end
