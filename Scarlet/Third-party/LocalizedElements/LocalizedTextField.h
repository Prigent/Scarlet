//
//  HTLocalizedTextField.h
//

#import <Foundation/Foundation.h>

@interface LocalizedTextField : UITextField

@end

@interface LocalizedTextFieldForm : UITextField

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds;

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds;

@end

@interface LocalizedTextView : UITextView

@end
