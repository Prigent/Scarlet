//
//  InterestListCell.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 19/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterestListCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSArray *mData;
@property (weak, nonatomic) IBOutlet UICollectionView *mCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *mEmptyLabel;

-(void) configure:(NSArray*) listProfile;
@end
