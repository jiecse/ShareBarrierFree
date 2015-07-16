//
//  TagDetailViewController.m
//  ShareBarrierFree
//
//  Created by cisl on 15-6-12.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import "TagDetailViewController.h"
#import "ShareBarrierFreeAPIS.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
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
    [self downLoadPicture];
    NSLog(@"pictureURL=%@",self.locationInfo.pictureUrl);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) downLoadPicture{
    dispatch_async(serverQueue, ^{
        NSData *imageData = [ShareBarrierFreeAPIS DownloadPicture:self.locationInfo.pictureUrl];

        [self performSelectorOnMainThread:@selector(changePicture:) withObject:imageData waitUntilDone:YES];
        return ;
       
    });
}
-(void) changePicture:(NSData*) imageData{
    if(imageData != nil){
        currentImageView.image = [UIImage imageWithData:imageData];
    }else {
        currentImageView.image = [UIImage imageNamed:@"DownloadFail"];
    }

}
- (IBAction)usefulCilicked:(UIBarButtonItem *)sender {
    [usefulBarBtn setEnabled:FALSE];
    [uselessBarBtn setEnabled:FALSE];
}

- (IBAction)uselessClicked:(UIBarButtonItem *)sender {
    [usefulBarBtn setEnabled:FALSE];
    [uselessBarBtn setEnabled:FALSE];
}

- (IBAction)shareClicked:(UIBarButtonItem *)sender {
    
    NSLog(@"点击了分享");
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wxc5d237d2bc663e47" appSecret:@"2c074b90798bb134994d4908624c528d" url:@"http://cscw.fudan.edu.cn/"];
    
    //利用友盟平台分享
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"55a70eea67e58e08db006827"
                                      shareText:titleInfo.text
                                     shareImage:currentImageView.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,nil]
     //[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:nil];
}
@end
