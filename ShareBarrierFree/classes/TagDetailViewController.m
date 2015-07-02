//
//  TagDetailViewController.m
//  ShareBarrierFree
//
//  Created by cisl on 15-6-12.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import "TagDetailViewController.h"

@interface TagDetailViewController ()

@end

@implementation TagDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [titleInfo setText:self.locationInfo.title];
    [timeInfo setText:[NSString stringWithFormat:@"发布时间：%@",self.locationInfo.time]];
    [usernameInfo setText:[NSString stringWithFormat:@"发布者ID：%d",self.locationInfo.userId]];
    [detailDescription setText:[NSString stringWithFormat:@"详细描述：%@",self.locationInfo.detailDescription]];
    //[currentImageView setImage:[UIImage imageNamed:@"Icon_Home"]];
    NSLog(@"pictureURL=%@",self.locationInfo.pictureUrl);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
