//
//  MessageCell.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 25/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Message;
@interface MessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mTitle;
@property (weak, nonatomic) IBOutlet UILabel *mMessage;
@property (weak, nonatomic) IBOutlet UILabel *mDate;
@property (weak, nonatomic) IBOutlet UITextView *mMessageView;
@property (weak, nonatomic) IBOutlet UIImageView *mUserImage;
@property (weak, nonatomic) IBOutlet UIView *mMessageContainer;

@property (strong, nonatomic) Message * mMessageObject;

@end
