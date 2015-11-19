//
//  InterestListCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 19/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "InterestListCell.h"
#import "InterestCollectionCell.h"

@implementation InterestListCell
-(void) configure:(NSArray*) listProfile
{
    self.mData = listProfile;
    [_mCollectionView reloadData];
    self.mEmptyLabel.hidden = ([self.mData count]>0);
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  [self.mData count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"InterestCollectionCell";
    InterestCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell configure:[self.mData objectAtIndex:indexPath.row]];
    return cell;
}
@end
