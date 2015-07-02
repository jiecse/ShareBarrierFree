//
//  User.h
//  ShareBarrierFree
//
//  Created by cisl on 15-6-29.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property(strong,nonatomic)NSString *username;
@property(strong,nonatomic)NSString *password;
@property(strong,nonatomic)NSString *address;
@property(strong,nonatomic)NSString *email;
@property(strong,nonatomic)NSString *phone;
@property(nonatomic)int user_id;

-(BOOL) verifyInfo:(NSString*)verifyPassword;
-(void) saveUserInfo:(NSInteger)userId;
+ (User*) initUser:(NSDictionary*)dic;
@end
