//
//  CALayer+UIColor.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 18/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "CALayer+UIColor.h"

@implementation CALayer(UIColor)

- (void)setBorderUIColor:(UIColor*)color {
    self.borderColor = color.CGColor;
}

- (UIColor*)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

@end