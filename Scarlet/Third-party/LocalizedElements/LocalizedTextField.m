//
//  HTLocalizedTextField.m
//

#import "LocalizedTextField.h"

@implementation LocalizedTextField

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		self.placeholder	= NSLocalizedString2(self.placeholder, @"");
        self.layer.cornerRadius = 2;
        self.clipsToBounds = YES;
	}
	return self;
}

@end

@implementation LocalizedTextFieldForm

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		self.placeholder	= NSLocalizedString2(self.placeholder, @"");
        self.layer.cornerRadius = 1;
        self.clipsToBounds = YES;
	}
	return self;
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

@end



@implementation LocalizedTextView


- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		self.text	= NSLocalizedString2(self.text, @"");
	}
	return self;
}

@end