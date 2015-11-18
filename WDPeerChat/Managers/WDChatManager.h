//
//  WDChatManager.h
//  WDPeerChat
//
//  Created by Waruna de Silva on 11/10/15.
//  Copyright © 2015 Waruna de Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface WDChatManager : NSObject <MCSessionDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;

@property (nonatomic, strong) NSMutableArray *messages;

+ (id)sharedWDChatManager;
- (void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
- (void)setupMCBrowser;
- (void)advertiseSelf:(BOOL)shouldAdvertise;
- (void)sendTextMessageToPeer:(NSString *)textMsg;

@end
