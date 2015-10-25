//
//  ChatViewController.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoListViewController.h"

@class Chat;
@interface ChatViewController : AutoListViewController
@property (nonatomic, retain) Chat* mChat;
@end
