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
@interface ChatViewController : AutoListViewController<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mBottomLayout;
@property (nonatomic, retain) Chat* mChat;
@property (weak, nonatomic) IBOutlet UITextField *mTextField;
@end
