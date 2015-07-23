//
//  User.m
//  ShareBarrierFree
//
//  Created by cisl on 15-6-29.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import "User.h"
#import "ProgressHUD.h"
#import "ShareBarrierFreeAPIS.h"
#import "GVUserDefaults+Properties.h"
#import "MJExtension.h"
@implementation User

-(BOOL) verifyInfo:(NSString*)verifyPassword{
    if ([_username isEqualToString:@""]) {
        [ProgressHUD showError:@"用户名不能为空！"];
        return FALSE;
    }
    if ([_password isEqualToString:@""]) {
        [ProgressHUD showError:@"密码不能为空！"];
        return FALSE;
    }
    if ([verifyPassword isEqualToString:@""]) {
        [ProgressHUD showError:@"再次输入密码不能为空！"];
        return FALSE;
    }
//    if ([_address isEqualToString:@""]) {
//        [ProgressHUD showError:@"地址不能为空！"];
//        return FALSE;
//    }
//    if ([_email isEqualToString:@""]) {
//        [ProgressHUD showError:@"邮箱不能为空！"];
//        return FALSE;
//    }
//    if ([_phone isEqualToString:@""]) {
//        [ProgressHUD showError:@"手机号不能为空！"];
//        return FALSE;
//    }
    if(![_password isEqualToString:verifyPassword]){
        [ProgressHUD showError:@"两次输入密码不一致，请重新输入！"];
        return FALSE;
    }
    

    return TRUE;
}

-(void) saveUserInfo:(NSInteger)userId{
    [GVUserDefaults standardUserDefaults].userId = userId;
    [GVUserDefaults standardUserDefaults].username = _username;
    [GVUserDefaults standardUserDefaults].password = _password;
    [GVUserDefaults standardUserDefaults].address = _address;
    [GVUserDefaults standardUserDefaults].email = _email;
    [GVUserDefaults standardUserDefaults].phone = _phone;
}

+ (User*) initUser:(NSDictionary*)dic{
//    User *user = [[User alloc] init];
    return [User objectWithKeyValues:dic];
}

@end
