//
//  FirstViewController.h
//  WDPeerChat
//
//  Created by Waruna de Silva on 11/10/15.
//  Copyright © 2015 Waruna de Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <JSQMessagesViewController/JSQMessages.h>    // import all the things


@interface WDChatViewController : JSQMessagesViewController <MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, JSQMessagesCollectionViewDataSource, JSQMessagesCollectionViewDelegateFlowLayout>


@end

