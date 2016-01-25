//
//  MessageCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 25/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "MessageCell.h"
#import "Message.h"
#import "Profile.h"
#import "Picture.h"
#import "UIImageView+AFNetworking.h"
#import "ShareAppContext.h"
#import "NSData+Base64.h"

@implementation MessageCell

-(BOOL)isBase64Data:(NSString *)input
{
    
    input=[[input componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    if ([input length] % 4 == 0) {
        static NSCharacterSet *invertedBase64CharacterSet = nil;
        if (invertedBase64CharacterSet == nil) {
            invertedBase64CharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="]invertedSet];
        }
        return [input rangeOfCharacterFromSet:invertedBase64CharacterSet options:NSLiteralSearch].location == NSNotFound;
    }
    return NO;
}


-(void) configure:(Message*) message
{
    self.mMessageObject =  message;
    
    _mTitle.text = [NSString stringWithFormat:@"%@", message.owner.firstName];
    _mMessage.text = message.text;
    

    if([self isBase64Data:message.text])
    {
        NSData *data = [NSData dataFromBase64String:message.text];
        NSString *valueUnicode = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData *dataa = [valueUnicode dataUsingEncoding:NSUTF8StringEncoding];
        NSString *valueEmoj = [[NSString alloc] initWithData:dataa encoding:NSNonLossyASCIIStringEncoding];
        _mMessageView.text = valueEmoj;
    }
    else
    {
        _mMessageView.text = message.text;
    }

    

    Picture * picture = [message.owner.pictures firstObject];
    
    _mUserImage.image= nil;
    [self.mUserImage setImageWithURL:[NSURL URLWithString:picture.filename]];
    
    self.mDate.text = [message getDateString];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)selectProfile:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectProfile" object:self.mMessageObject];
    
}

@end
