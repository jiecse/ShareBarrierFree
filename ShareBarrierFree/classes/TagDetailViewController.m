//
//  TagDetailViewController.m
//  ShareBarrierFree
//
//  Created by cisl on 15-6-12.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import "TagDetailViewController.h"
#import "ShareBarrierFreeAPIS.h"
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
@end
