//
//  HTDelegateLabel.m
//  Hitster
//
//  Created by Christophe Boivin on 06/03/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "DelegateLabel.h"

@implementation DelegateLabel
@synthesize delegate;

- (void)setText:(NSString*)_text
{
	[super setText:_text];
	
	[delegate textWasSet];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
	[super setAttributedText:attributedText];
	
	[delegate textWasSet];
}

- (void)setTextColor:(UIColor *)textColor
{
	[super setTextColor:textColor];
	
	[delegate textColorWasSet];
}

- (void)dealloc
{
	[delegate labelDeallocated];
	
	delegate = nil;
}

@end
