
#import <UIKit/UIKit.h>

@protocol UILabelDelegate <NSObject>

- (void)textWasSet;
- (void)textColorWasSet;
- (void)labelDeallocated;

@end

@interface DelegateLabel : UILabel

@property (nonatomic, assign) IBOutlet id<UILabelDelegate> delegate;

@end
