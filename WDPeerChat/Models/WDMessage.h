//
//  WDMessage.h
//  WDPeerChat
//
//  Created by Waruna de Silva on 11/17/15.
//  Copyright © 2015 Waruna de Silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDMessage : NSObject

@property (strong) NSString *senderId;
@property (strong) NSString *senderName;
@property (strong) NSString *text;
@property (strong) NSDate *date;

@end
