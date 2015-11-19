//
//  CALayer+UIColor.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 18/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer(UIColor)

// This assigns a CGColor to borderColor.
@property(nonatomic, assign) UIColor* borderUIColor;

@end
