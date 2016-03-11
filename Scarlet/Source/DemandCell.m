//
//  MyEventCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "DemandCell.h"
#import "Event.h"
#import "UIImageView+AFNetworking.h"
#import "Profile.h"
#import "Picture.h"
#import "ShareAppContext.h"
#import "Demand.h"
#import "ProfileCollectionCell.h"
#import "Address.h"

@implementation DemandCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void) configure:(Demand*) demand
{
    self.mDemand = demand;
    _mTitle.text = demand.leader.firstName;
    for(Profile * lPartner in demand.partners)
    {
        _mTitle.text = [_mTitle.text stringByAppendingString:[NSString stringWithFormat:@", %@",lPartner.firstName]];
    }
    


    _mStatusLabel.text = @"";
    
    
    NSMutableArray * listProfile = [NSMutableArray array];
    [listProfile addObject:demand.leader];
    [listProfile addObjectsFromArray:[demand.partners allObjects]];
    self.mData = listProfile;
    [self.mCollectionView reloadData];
    _mStatusLabel.hidden = false;
    
    switch ([demand.status integerValue])
    {
        case 1:
            _mBackgroundLabel.backgroundColor = [UIColor colorWithRed:116/255. green:196/255. blue:29/255. alpha:1];
            _mStatusLabel.text = NSLocalizedString2(@"request_accepted", nil);
            break;
        case 2:
            _mBackgroundLabel.backgroundColor = [UIColor colorWithRed:1 green:29/255. blue:76/255. alpha:1];
            _mStatusLabel.text =  NSLocalizedString2(@"request_rejected", nil);
            break;
        case 3:
            _mBackgroundLabel.backgroundColor = [UIColor colorWithRed:245/255. green:166/255. blue:35/255. alpha:1];
            _mStatusLabel.text =  NSLocalizedString2(@"request_pending", nil);
            break;
        default:
            break;
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  [self.mData count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"ProfileCollectionCell";
    ProfileCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell configure:[self.mData objectAtIndex:indexPath.row]];
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch ([self.mData count]) {
            
        case 1:
            return  CGSizeMake( collectionView.frame.size.width, collectionView.frame.size.height);
        case 2:
            return  CGSizeMake(  collectionView.frame.size.width/2., collectionView.frame.size.height);
        default:
            return  CGSizeMake(  collectionView.frame.size.width/2.2, collectionView.frame.size.height);
    }
    
    
}
- (IBAction)selectDemand:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"demandSelected" object:self.mDemand];
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
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
