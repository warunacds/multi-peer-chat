//
//  WDChatManager.m
//  WDPeerChat
//
//  Created by Waruna de Silva on 11/10/15.
//  Copyright © 2015 Waruna de Silva. All rights reserved.
//

#import "WDChatManager.h"
#import "WDMessage.h"

#define SERVICE_NAME "wdchat-service"

@implementation WDChatManager

-(id)init{
    self = [super init];
    
    if (self) {
        
        _peerID = nil;
        _session = nil;
        _browser = nil;
        _advertiser = nil;
        _messages = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (id)sharedWDChatManager
{
    static dispatch_once_t onceQueue;
    static WDChatManager *wDChatManager = nil;
    
    dispatch_once(&onceQueue, ^{ wDChatManager = [[self alloc] init]; });
    return wDChatManager;
}


#pragma mark - Public method implementation

-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName
{
    _peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    _session = [[MCSession alloc] initWithPeer:_peerID];
    _session.delegate = self;
}


-(void)setupMCBrowser
{
    _browser = [[MCBrowserViewController alloc] initWithServiceType:@SERVICE_NAME session:_session];
    _browser.maximumNumberOfPeers = 1;
}




-(void)advertiseSelf:(BOOL)shouldAdvertise{
    
    if (shouldAdvertise) {
        _advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@SERVICE_NAME
                                                           discoveryInfo:nil
                                                                 session:_session];
        [_advertiser start];
    }
    else{
        [_advertiser stop];
        _advertiser = nil;
    }
}

- (void)sendTextMessageToPeer:(NSString *)textMsg
{
        
    WDMessage *message = [[WDMessage alloc] init];
    message.senderId = [UIDevice currentDevice].identifierForVendor.UUIDString;
    message.text = textMsg;
    message.senderName = _peerID.displayName;
    message.date = [NSDate date];
    
    [self.messages addObject:message];
    
    NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject:message];
    NSError *error;
    
    [self.session sendData:dataToSend toPeers:self.session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession * _Nonnull))invitationHandler
{
    

}

#pragma mark - MCSession Delegate method implementation


-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    
    NSDictionary *dict = @{@"peerID": peerID,
                           @"state" : [NSNumber numberWithInt:state]
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeStateNotification"
                                                        object:nil
                                                      userInfo:dict];
}


-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
    WDMessage *message = (WDMessage *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self.messages addObject:message];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceiveDataNotification"
                                                        object:nil
                                                      userInfo:nil];
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
    // not implemented
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    // not implemented
}


-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    //not implemented
}



@end
