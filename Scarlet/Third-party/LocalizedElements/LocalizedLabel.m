//
//  HTLocalizedLabel.m
//

#import "LocalizedLabel.h"
#import "objc/runtime.h"

@implementation LocalizedLabel

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		self.text	= NSLocalizedString2(self.text, @"");
        
	}
	return self;
}

+ (NSArray *)classPropsFor:(Class)klass
{    
    if (klass == NULL) {
        return nil;
    }
	
    NSMutableArray *results = [[NSMutableArray alloc] init];
	
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(klass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName)
		{
            //const char *propType = getPropertyType(property);
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            //NSString *propertyType = [NSString stringWithUTF8String:propType];
			[results addObject:propertyName];
            //[results setObject:propertyType forKey:propertyName];
        }
    }
    free(properties);
	
    // returning a copy here to make sure the dictionary is immutable
    return [NSArray arrayWithArray:results];//[NSDictionary dictionaryWithDictionary:results];
}

- (LocalizedLabel*)copy
{
	LocalizedLabel* label = [[[self class] alloc] init];
	
	// Get all properties
	NSArray* properties = [LocalizedLabel classPropsFor:[UILabel class]];
	// Copy each properties
	for (NSString* prop in properties)
	{
		[label setValue:[self valueForKey:prop] forKey:prop];
	}
	
	return label;
}

- (void)setPersistentBackgroundColor:(UIColor*)color {
    super.backgroundColor = color;
}

- (void)setBackgroundColor:(UIColor *)color {
    // do nothing - background color never changes
}

@end
