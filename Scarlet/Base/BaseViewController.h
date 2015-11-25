//
//  BaseViewController.h
//  Voiturescom
//
//  Created by Damien PRACA on 08/10/14.
//  Copyright (c) 2014 HighConnexion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
@interface BaseViewController : GAITrackedViewController
{
    
}
-(void) configure:(id) dic;
-(void) close;


@property (nonatomic, strong) NSDictionary* mViewDictionnary;
@property (nonatomic, strong) UIView* mLoadingViewGeneric;
@property (nonatomic, strong) UIActivityIndicatorView * mIndicatorViewGeneric;
@property (nonatomic, strong) UILabel * mTextLoadingGeneric;
@property (nonatomic) BOOL customReturn;
@property (nonatomic) BOOL hideBottom;
@property (strong, nonatomic) NSObject* objectToPush;
@end
