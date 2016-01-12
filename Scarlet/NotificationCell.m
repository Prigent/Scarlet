//
//  NotificationCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 12/01/2016.
//  Copyright © 2016 Prigent ROUDAUT. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell


-(void) configure:(NSArray*) data
{
    NSString* lKey = [data objectAtIndex:0];
    NSNumber* lEnabled = [data objectAtIndex:1];
    
    
    self.mTitle.text = NSLocalizedString(lKey,lKey);
    [self.mSwitch setOn:[lEnabled boolValue] animated:true];
}
@end
