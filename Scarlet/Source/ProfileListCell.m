//
//  ProfileListCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 26/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "ProfileListCell.h"
#import "Profile.h"
#import "Picture.h"
#import "UIImageView+AFNetworking.h"
#import "ProfileCollectionCell.h"

@implementation ProfileListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) configure:(NSArray*) listProfile
{
    self.mData = listProfile;
    [_mCollectionView reloadData];
    self.mEmptyLabel.hidden = ([self.mData count]>0);
    [self.mCollectionView reloadData];
}

-(void) configure:(NSArray*) listProfile andSelectedList:(NSMutableArray*) selectedList
{
    [self configure:listProfile];
    self.mSelectedList = selectedList;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  [self.mData count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"ProfileCollectionCell";
    ProfileCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell configure:[self.mData objectAtIndex:indexPath.row]];
    
    if( self.mSelectedList != nil)
    {
        Profile* lProfile = [self.mData objectAtIndex:indexPath.row];
        if( [self.mSelectedList containsObject:lProfile.identifier])
        {
            cell.mImage.alpha = 1;
        }
        else
        {
            cell.mImage.alpha = 0.3;
        }
    }
    
    return cell;
}




@end
