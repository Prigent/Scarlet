//
//  Chat.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "Chat.h"
#import "Event.h"
#import "Message.h"

@implementation Chat

// Insert code here to add functionality to your managed object subclass
- (void)addMessagesObject:(Message *)value  {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.messages];
    [tempSet addObject:value];
    self.messages = tempSet;
}

- (void)removeMessages:(NSOrderedSet<Message *> *)values
{
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.messages];
    for(id obj in values)
    {
        [tempSet removeObject:obj];
    }
    self.messages = tempSet;
}

- (void)removeMessagesObject:(Message *)value
{
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.messages];
    [tempSet removeObject:value];
    
    self.messages = tempSet;
}



@end
