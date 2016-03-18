//
//  SexCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 20/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "SexCell.h"

@implementation SexCell

- (void)awakeFromNib {
    // Initialization code
    if(self.sexSegment.tag == 0)
    {
        [self.sexSegment setTitle:NSLocalizedString2(@"male", nil) forSegmentAtIndex:0];
        [self.sexSegment setTitle:NSLocalizedString2(@"female", nil) forSegmentAtIndex:1];
    }
    else
    {
        [self.sexSegment setTitle:NSLocalizedString2(@"man", nil) forSegmentAtIndex:0];
        [self.sexSegment setTitle:NSLocalizedString2(@"woman", nil) forSegmentAtIndex:1];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
