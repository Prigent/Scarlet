//
//  InterestCollectionCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 19/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "InterestCollectionCell.h"
#import "Interest.h"

@implementation InterestCollectionCell

-(void) configure:(Interest*) interest
{
    self.mTitle.text = interest.name;
}


@end
