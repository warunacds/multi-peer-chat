//
//  WDChatListViewController.m
//  WDPeerChat
//
//  Created by Waruna de Silva on 11/13/15.
//  Copyright © 2015 Waruna de Silva. All rights reserved.
//

#import "WDChatListViewController.h"
#import "WDLoginViewController.h"
#import "WDChatViewController.h"
#import "WDChatManager.h"
#import "WDMessage.h"

@interface WDChatListViewController() <MCNearbyServiceBrowserDelegate, MCBrowserViewControllerDelegate>

@property (strong) NSArray *connectedPeers;

@end

@implementation WDChatListViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"ChangeStateNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"ReceiveDataNotification"
                                               object:nil];
    
    NSUserDefaults *userDeaults = [NSUserDefaults standardUserDefaults];
    if (![userDeaults objectForKey:@"Username"]) {
        
        
        
        WDLoginViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainView"];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        
        [self presentViewController:navigationController animated:YES completion:^{
            
        }];
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(browsePeers)];
    self.title = @"Chat List";
}

- (void)peerDidChangeStateWithNotification:(NSNotification *)notification
{
    WDChatManager *chatManager = [WDChatManager sharedWDChatManager];
    
    self.connectedPeers = chatManager.session.connectedPeers;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];

    });
    
}

- (void)didReceiveDataWithNotification:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        
    });
}

- (void)browsePeers
{
    WDChatManager *manager = [WDChatManager sharedWDChatManager];
    [manager setupMCBrowser];
    [manager.browser setDelegate:self];
    [self presentViewController:manager.browser animated:YES completion:nil];
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    WDChatManager *chatManager = [WDChatManager sharedWDChatManager];
    
    self.connectedPeers = chatManager.session.connectedPeers;

    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.connectedPeers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  
    MCPeerID *peerID = self.connectedPeers[indexPath.item];
    cell.textLabel.text = peerID.displayName;
    cell.textLabel.font = [cell.textLabel.font fontWithSize:20];
    
    WDMessage *message = [[[WDChatManager sharedWDChatManager] messages] lastObject];
    if (message) {
        cell.detailTextLabel.text = message.text;
    }
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDChatViewController *chatViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatView"];
    [self.navigationController pushViewController:chatViewController animated:YES];
}


-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    WDChatManager *manager = [WDChatManager sharedWDChatManager];
        [manager.browser dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    WDChatManager *manager = [WDChatManager sharedWDChatManager];
        [manager.browser dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary<NSString *,NSString *> *)info
{
    // not implemented
}

-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
        //not implemented
}

@end
