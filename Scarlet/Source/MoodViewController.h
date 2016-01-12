//
//  MoodViewController.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 25/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "BaseViewController.h"

@interface MoodViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray * mData;
@property (nonatomic, strong) NSString * mMood;
@property ( nonatomic) BOOL filter;
@end
