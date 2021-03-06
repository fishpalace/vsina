//
//  LoginViewController.m
//  PushBox
//
//  Created by Xie Hasky on 11-7-25.
//  Copyright 2011年 同济大学. All rights reserved.
//

#import "LoginViewController.h"
#import "WeiboClient.h"

#define kUserDefaultKeyAutoSave @"kUserDefaultKeyAutoSave"
#define kUserDefaultName @"kUserDefaultName"

@implementation LoginViewController

@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize autoSaveButton = _autoSaveButton;
@synthesize confirmButton = _confirmButton;
@synthesize providerLabel = _providerLabel;
@synthesize delegate = _delegate;
@synthesize loadingIndicator = _loadingIndicator;

#pragma mark - View lifecycle

+ (void)initialize
{
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:[NSNumber numberWithBool:YES] forKey:kUserDefaultKeyAutoSave];
	[userDefault registerDefaults:dict];
}

- (void)dealloc
{
    NSLog(@"LoginViewController dealloc");
    [_usernameTextField release];
    [_passwordTextField release];
	[_autoSaveButton release];
    [_providerLabel release];
	[_loadingIndicator release];
    [_confirmButton release];
    _delegate = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.providerLabel.text = NSLocalizedString(@"新浪微博", nil);
	BOOL autoSave = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultKeyAutoSave];
    self.confirmButton.hidden = NO;
	self.autoSaveButton.selected = autoSave;
	self.usernameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultName];
    [self.usernameTextField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.usernameTextField = nil;
    self.passwordTextField = nil;
    self.autoSaveButton = nil;
    self.confirmButton = nil;
	self.providerLabel = nil;
	self.loadingIndicator = nil;
}

- (IBAction)login:(id)sender {
    self.confirmButton.hidden = YES;
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
	[[NSUserDefaults standardUserDefaults] setObject:username forKey:kUserDefaultName];
    
    [self.passwordTextField resignFirstResponder];
    [self.usernameTextField resignFirstResponder];
	
    WeiboClient *client = [WeiboClient client];
    
	self.loadingIndicator.hidden = NO;
	[self.loadingIndicator startAnimating];
	
    [client setCompletionBlock:^(WeiboClient *client) {
        
		self.loadingIndicator.hidden = YES;
		[self.loadingIndicator stopAnimating];
        if (client.hasError || ![WeiboClient authorized]) {
			self.confirmButton.hidden = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"验证失败", nil)
                                                            message:NSLocalizedString(@"请检查用户名或网络设置", nil)
                                                            delegate:nil 
                                                  cancelButtonTitle:NSLocalizedString(@"关闭", nil)
                                                   otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            
            [self.passwordTextField becomeFirstResponder];
        }
        else {
            
            NSString *preName = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultKeyUserName"];
            BOOL differentUser = ![username isEqualToString:preName];
            if (differentUser) {
                [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"kUserDefaultKeyUserName"];
            }
            
            [self.delegate loginViewControllerDidLogin:self shouldClearData:differentUser];
        }
    }];
	[client authWithUsername:username password:password autosave:self.autoSaveButton.selected];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == self.usernameTextField) {
		[self.passwordTextField becomeFirstResponder];
	}
	else {
		[self login:nil];
	}
	return YES;
}


- (IBAction)openRegisterURL:(id)sender {
    NSString *urlString = @"http://weibo.com/signup/signup.php";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (IBAction)autoSaveSwitchChanged:(id)sender {
	BOOL on = !self.autoSaveButton.selected;
	self.autoSaveButton.selected = on;
	[[NSUserDefaults standardUserDefaults] setBool:on forKey:kUserDefaultKeyAutoSave];
}


@end
