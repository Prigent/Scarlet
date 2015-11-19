//
//  InterestCollectionCell.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 19/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Interest;
@interface InterestCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *mTitle;
-(void) configure:(Interest*) interest;
@end
