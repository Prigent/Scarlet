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
    self.mKey = [data objectAtIndex:0];
    self.mEnabled = [data objectAtIndex:1];
    
    
    self.mTitle.text = NSLocalizedString2(self.mKey,self.mKey);
    [self.mSwitch setOn:[self.mEnabled boolValue] animated:true];
}
- (IBAction)onSwitch:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onSwitch" object:@[self.mKey,self.mEnabled ]];
}
@end
