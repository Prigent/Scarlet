//
//  InterestListCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 19/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "InterestListCell.h"
#import "InterestCollectionCell.h"
#import "Interest.h"

@implementation InterestListCell
-(void) configure:(NSArray*) listProfile
{
    self.mData = listProfile;
    
    self.mEmptyLabel.hidden = ([self.mData count]>0);
    [_mCollectionView reloadData];
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


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Interest * lInterest = [self.mData objectAtIndex:indexPath.row];
    
    
    CGSize constraint = CGSizeMake(20000, 30.0f);
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [lInterest.name boundingRectWithSize:constraint
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                           context:context].size;


    
    return  CGSizeMake( ceil(boundingBox.width) + 16 , 30);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0, 8.0, 0.0, 0.0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 00.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 00.0;
}
@end
