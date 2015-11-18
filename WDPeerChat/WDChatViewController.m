//
//  FirstViewController.m
//  WDPeerChat
//
//  Created by Waruna de Silva on 11/10/15.
//  Copyright © 2015 Waruna de Silva. All rights reserved.
//

#import "WDChatViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "WDChatManager.h"
#import "WDLoginViewController.h"
#import "WDMessage.h"

@interface WDChatViewController ()

@property (nonatomic, strong) NSMutableArray *arrConnectedDevices;
//@property (strong) NSMutableArray *messagesArray;

@end

@implementation WDChatViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    self.senderId = [UIDevice currentDevice].identifierForVendor.UUIDString;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"ChangeStateNotification"
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"ReceiveDataNotification"
                                               object:nil];
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    

}

- (void)didReceiveDataWithNotification:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self finishReceivingMessageAnimated:NO];

    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSString *)senderDisplayName
{
    return [[[WDChatManager sharedWDChatManager] peerID] displayName];
    
}



-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession * _Nonnull))invitationHandler
{
    WDChatManager *chatManager = [WDChatManager sharedWDChatManager];
    invitationHandler(YES, chatManager.session);
}

-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    NSLog(@"lostPeer: %@", peerID.displayName);

}

-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary<NSString *,NSString *> *)info
{
    NSLog(@"foundPeer: %@ || DiscoveryInfor %@", peerID.displayName, info);

}


-(void)didPressAccessoryButton:(UIButton *)sender
{
    
}

-(void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    
    [[WDChatManager sharedWDChatManager] sendTextMessageToPeer:text];
    [self finishSendingMessageAnimated:YES];

}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    WDMessage *message = [[[WDChatManager sharedWDChatManager] messages] objectAtIndex:indexPath.item];
    JSQMessage *msgData = [[JSQMessage alloc] initWithSenderId:message.senderId senderDisplayName:message.senderName date:message.date text:message.text];

    
    if ([msgData.senderId isEqualToString:self.senderId]) {
        
        return [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:[msgData.senderDisplayName substringToIndex:1].capitalizedString  backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] diameter:60];
    } else {
        
        return [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:[msgData.senderDisplayName substringToIndex:1].capitalizedString backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] diameter:60];
    }
    
    
    return nil;
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    WDMessage *message = [[[WDChatManager sharedWDChatManager] messages] objectAtIndex:indexPath.item];
    JSQMessage *msgData = [[JSQMessage alloc] initWithSenderId:message.senderId senderDisplayName:message.senderName date:message.date text:message.text];

    
    if (!msgData.isMediaMessage) {
        
        if ([msgData.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[WDChatManager sharedWDChatManager] messages] count];
}

-(id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    WDMessage *message = [[[WDChatManager sharedWDChatManager] messages] objectAtIndex:indexPath.item];
    JSQMessage *msgData = [[JSQMessage alloc] initWithSenderId:message.senderId senderDisplayName:message.senderName date:message.date text:message.text];
    
    return msgData;
}

-(id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    WDMessage *message = [[[WDChatManager sharedWDChatManager] messages] objectAtIndex:indexPath.item];
    
    
    JSQMessage *msgData = [[JSQMessage alloc] initWithSenderId:message.senderId senderDisplayName:message.senderName date:message.date text:message.text];
    
    if ([msgData.senderId isEqualToString:self.senderId]) {
        return [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    }
    
    return [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
}

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            [_arrConnectedDevices addObject:peerDisplayName];
        }
        else if (state == MCSessionStateNotConnected){
            if (![_arrConnectedDevices count] > 0) {
                [self showAlertForPeerlost];
            }
        }
    }
}

- (void)showAlertForPeerlost
{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:NSLocalizedString(@"Lost Connection", @"Lost Connection")
                                message:NSLocalizedString(@"We lost the connection to peer", @"We lost the connection to peer")
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK") style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:alertAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
