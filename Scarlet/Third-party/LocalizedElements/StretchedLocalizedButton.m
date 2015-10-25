//
//  HTStretchedLocalizedButton.m
//
//  Created by Christophe Boivin.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StretchedLocalizedButton.h"

@implementation StretchedLocalizedButton

- (void)setup
{
	// Background image
	
	UIImage* image = [self backgroundImageForState:UIControlStateNormal];
	
	image = [image stretchableImageWithLeftCapWidth:image.size.width/2. topCapHeight:image.size.height/2.];
	
	[self setBackgroundImage:image forState:UIControlStateNormal];
	
	UIImage* imageHighlighted = [self backgroundImageForState:UIControlStateHighlighted];
	if (imageHighlighted && imageHighlighted != image)
	{
		imageHighlighted = [imageHighlighted stretchableImageWithLeftCapWidth:imageHighlighted.size.width/2. topCapHeight:imageHighlighted.size.height/2.];
		
		[self setBackgroundImage:imageHighlighted forState:UIControlStateHighlighted];
	}
	UIImage* imageSelected = [self backgroundImageForState:UIControlStateSelected];
	if (imageSelected && imageSelected != image)
	{
		imageSelected = [imageSelected stretchableImageWithLeftCapWidth:imageSelected.size.width/2. topCapHeight:imageSelected.size.height/2.];
		
		[self setBackgroundImage:imageSelected forState:UIControlStateSelected];
	}
	UIImage* imageDisabled = [self backgroundImageForState:UIControlStateDisabled];
	if (imageDisabled && imageDisabled != image)
	{
		imageDisabled = [imageDisabled stretchableImageWithLeftCapWidth:imageDisabled.size.width/2. topCapHeight:imageDisabled.size.height/2.];
		
		[self setBackgroundImage:imageDisabled forState:UIControlStateDisabled];
	}
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		[self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self)
	{
		[self setup];
	}
	return self;
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
	//image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
	
	[super setBackgroundImage:image forState:state];
}

@end
