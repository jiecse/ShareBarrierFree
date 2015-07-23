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
#import "GVUserDefaults+Properties.h"
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
    [self getCountAndRate];
    [self downLoadPicture];
    NSLog(@"pictureURL=%@",self.locationInfo.pictureUrl);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getCountAndRate{
    dispatch_async(serverQueue, ^{
        NSDictionary *resultDic = [ShareBarrierFreeAPIS GetHighPraiseRate:self.locationInfo.infoId];
        if ([[resultDic objectForKey:@"result"] isEqualToString:@"success"]) {
            self.locationInfo.commentNumber = [[resultDic objectForKey:@"count"] intValue];
            self.locationInfo.highPraiseRate = [[resultDic objectForKey:@"rate"] floatValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [countAndRate setText:[NSString stringWithFormat:@"评论数:%d  好评率:%.2f",self.locationInfo.commentNumber,self.locationInfo.highPraiseRate]];
            });
            return;
        }else
        {
            return ;
        }
    });
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
    [self commentInfo:true];
}

- (IBAction)uselessClicked:(UIBarButtonItem *)sender {
    [self commentInfo:false];
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

-(void)commentInfo:(BOOL)isUseful{
    //获取当前时间
    NSDate *  sendDate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:MM:SS"];
    NSString *  dateString=[dateformatter stringFromDate:sendDate];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys: [NSNumber numberWithInteger:self.locationInfo.infoId], @"info_id",[NSNumber numberWithInteger:[GVUserDefaults standardUserDefaults].userId],@"user_id", dateString,@"time",@"",@"content", [NSNumber numberWithInteger:isUseful], @"isUsable",nil];
    
    dispatch_async(serverQueue, ^{
        NSDictionary *resultDic = [ShareBarrierFreeAPIS AddComment:dic];

        if ([[resultDic objectForKey:@"result"] isEqualToString:@"success"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [usefulBarBtn setEnabled:FALSE];
                [uselessBarBtn setEnabled:FALSE];
            });
            return;
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"评论失败，请检查您的网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            });
            return ;
        }
    });
}
@end
