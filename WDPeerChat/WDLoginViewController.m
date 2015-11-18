//
//  MainViewController.m
//  WDPeerChat
//
//  Created by Waruna de Silva on 11/10/15.
//  Copyright © 2015 Waruna de Silva. All rights reserved.
//

#import "WDLoginViewController.h"
#import "WDChatManager.h"


@interface WDLoginViewController()<UITextFieldDelegate>

@end

@implementation WDLoginViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textfieldUsername.delegate = self;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnView)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

-(void)tapOnView
{
    [self.textfieldUsername endEditing:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)tapSetUsername:(id)sender {
    
 
    if (self.textfieldUsername.text.length > 0) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.textfieldUsername.text forKey:@"Username"];
        [userDefaults synchronize];
        
        WDChatManager *chatManager = [WDChatManager sharedWDChatManager];
        [chatManager setupPeerAndSessionWithDisplayName:[userDefaults objectForKey:@"Username"]];
        [chatManager advertiseSelf:YES];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        

        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:NSLocalizedString(@"Set Username", @"Set Username")
                                    message:NSLocalizedString(@"Please set a username", @"Please set a username")
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK") style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:alertAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

@end
