//
//  MyEventViewController.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoListViewController.h"
#import "EventExpendView.h"

@class Event;
@interface MyEventViewController : AutoListViewController

@property (strong, nonatomic) Event* mEvent;
@property (strong, nonatomic) NSString* mEventId;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mHeighEditButton;
@property (weak, nonatomic) IBOutlet EventExpendView *mEventExpendView;
@property (weak, nonatomic) IBOutlet UIButton *mButtonCancel;

@end
