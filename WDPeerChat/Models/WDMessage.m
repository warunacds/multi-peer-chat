//
//  WDMessage.m
//  WDPeerChat
//
//  Created by Waruna de Silva on 11/17/15.
//  Copyright © 2015 Waruna de Silva. All rights reserved.
//

#import "WDMessage.h"

@implementation WDMessage

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.text = [aDecoder decodeObjectForKey:@"text"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.senderName = [aDecoder decodeObjectForKey:@"senderName"];
        self.senderId = [aDecoder decodeObjectForKey:@"senderId"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"text"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.senderName forKey:@"senderName"];
    [aCoder encodeObject:self.senderId forKey:@"senderId"];

}



@end
