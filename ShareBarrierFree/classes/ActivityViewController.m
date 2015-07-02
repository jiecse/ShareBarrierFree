//
//  ActivityViewController.m
//  ShareBarrierFree
//
//  Created by cisl on 15-6-29.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import "ActivityViewController.h"
#import "NavigationViewController.h"
#import "TagDetailViewController.h"
#import "LJCommonGroup.h"
#import "LJCommonItem.h"
#import "ShareBarrierFreeAPIS.h"
#import "MJExtension.h"
#import "LocationInfo.h"
#import "ProgressHUD.h"
@interface ActivityViewController ()

@end

@implementation ActivityViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    [self.navigationItem setTitle:@"历史记录"];
    
    // Here self.navigationController is an instance of NavigationViewController (which is a root controller for the main window)
    //
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(toggleMenu)];
    [self setupGroups];
}

-(void) getHistoryInfoArray{
    dispatch_async(serverQueue, ^{
        NSDictionary *resultDic = [ShareBarrierFreeAPIS GetUserReleaseList];
        if ([[resultDic objectForKey:@"result"] isEqualToString:@"success"]) {
            _historyInfoArray = [LocationInfo getLocationInfos:[resultDic objectForKey:@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setGroup0];
                [self.tableView reloadData];

            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"获取记录失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            });
            return;
        }
    });
}

-(void)setupGroups
{
    //[self setGroup0];
    [self getHistoryInfoArray];

}

-(void)setGroup0
{
    LJCommonGroup *group=[[LJCommonGroup alloc]init];
    group.groupheader = @"记录列表";
    [self.groups addObject:group];

    LocationInfo *locInfo;
    for (locInfo in _historyInfoArray) {
        LJCommonItem *item = [LJCommonItem itemWithTitle:locInfo.title];
        item.subtitle = [NSString stringWithString:locInfo.time];
        [group.items addObject:item];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    NavigationViewController *navigationController = (NavigationViewController *)self.navigationController;
    [navigationController.menu setNeedsLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        [self switchToTagDetailVC:[_historyInfoArray objectAtIndex:indexPath.row]];
    }
    NSLog(@"item = %ld",(long)indexPath.item);
    
    //self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark - 联系TagDetailVC
-(void) switchToTagDetailVC:(LocationInfo*)locInfo{
    [ProgressHUD show:@"正在获取详细信息"];
    self.view.userInteractionEnabled = false;
    
    dispatch_async(serverQueue, ^{
        NSDictionary *resultDic = [ShareBarrierFreeAPIS GetDetailDescription:locInfo.infoId];
        
        if ([[resultDic objectForKey:@"result"] isEqualToString:@"success"]) {
            [locInfo setDetailDescription:[[resultDic objectForKey:@"infomation"] objectForKey:@"description"]];
            [locInfo setPictureUrl:[[resultDic objectForKey:@"infomation"] objectForKey:@"picture_url"]];
            [locInfo setUserId:[[[resultDic objectForKey:@"infomation"] objectForKey:@"user_id"] intValue]];
            [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"获取成功" waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(switchNextViewController:) withObject:locInfo waitUntilDone:YES];
            return ;
        }
        else//登录出错
        {
            [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"获取失败！" waitUntilDone:YES];
            return ;
        }
    });
}

- (void) successWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showSuccess:message];
}

- (void) errorWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showError:message];
}

- (void)switchNextViewController:(LocationInfo*)info
{
    TagDetailViewController *tagDetailViewController = [[TagDetailViewController alloc] initWithNibName:@"TagDetailViewController" bundle:nil];
    tagDetailViewController.locationInfo = info;
    [self.navigationController pushViewController:tagDetailViewController animated:YES];
}

@end
