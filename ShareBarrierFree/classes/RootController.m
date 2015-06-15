//
//  RootController.m
//  ShareBarrierFree
//
//  Created by cisl on 15-6-15.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import "RootController.h"
#import "LoginViewController.h"
#import "NavigationViewController.h"
#import "HomeViewController.h"
#import "ShareBarrierFreeAPIS.h"

@interface RootController ()

@property(nonatomic, strong) LoginViewController *loginViewController;
@property(nonatomic, strong) NavigationViewController *navigationViewController;

@end

@implementation RootController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //获取setting中设置的URL
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *ipAddr = [defaults stringForKey:@"ipAddr"];
    if (ipAddr==nil || [ipAddr isEqualToString:@""])
    {
        ipAddr =  @"10.131.200.97:8080";
    }
    NSLog(@"IP : %@", ipAddr);
    [ShareBarrierFreeAPIS setIpAddr:ipAddr];

}

-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults stringForKey:@"username"];
    NSString *password = [userDefaults stringForKey:@"password"];
    //[userDefaults setObject:password forKey:@"password"];
    if (!(userName == nil) && !(password == nil)) {
        self.navigationViewController = [[NavigationViewController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
        [self.view addSubview:self.navigationViewController.view];
    } else {
        self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.view addSubview:self.loginViewController.view];
    }
    NSLog(@"%@%@",userName,password);

}

- (void)switchToMainTabBarView
{
    [self.loginViewController.view removeFromSuperview];
    self.loginViewController = nil;
    
    self.navigationViewController = [[NavigationViewController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    [self.view addSubview:self.navigationViewController.view];
}

- (void)switchToLoginView
{
    [self.navigationViewController.view removeFromSuperview];
    self.navigationViewController = nil;
    
    self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.view addSubview:self.loginViewController.view];
}


@end
