//
//  URL.h
//  PurangFinance
//
//  Created by liumingkui on 15/5/6.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#ifndef PurangFinance_URL_h
#define PurangFinance_URL_h

#define URL_HEAD(url) [NSString stringWithFormat:@"https://m3.purang.com:8050%@",url]
//#define URL_HEAD(url) [NSString stringWithFormat:@"http://10.10.96.144:8088%@",url]//测试环境
//#define URL_HEAD(url) [NSString stringWithFormat:@"http://10.10.96.139:8087%@",url]
//#define URL_HEAD(url) [NSString stringWithFormat:@"http://10.10.29.6:8080%@",url]//
//#define URL_HEAD(url) [NSString stringWithFormat:@"http://10.1.110.22:8088%@",url]//开发环境
//#define URL_HEAD(url) [NSString stringWithFormat:@"http://10.10.29.7:8080%@",url]//c
#define URL_DISCOUNTSUBMIT @"/mobile/discount/submit.htm"//贴现提交
#define URL_LOGIN @"/mobile/login.htm"//登录
#define URL_REGIST @"/mobile/regist.htm"//注册
#define URL_GETREGISTCODE @"/mobile/regValidateCode.htm"//注册获取验证码
#define URL_RESET @"/mobile/resetPassword.htm"//找回密码
#define URL_GETRESETCODE @"/mobile/findPasswordValidateCode.htm"//找回密码获取验证码
#define URL_LOGOUT @"/mobile/logout.htm"//注销
#define URL_QUERY @"/mobile/queryPublicSummon.htm"//公告票据查询
#define URL_COMFIRM @"/mobile/company/comfirm.htm"//企业认证
#define URL_SEARCH @"/mobile/discount/search.htm"//贴现查询
#define URL_PERSONALCENTER @"/mobile/company/personcenter.htm"//个人中心
#define URL_CHANGEINFORMATION @"/mobile/updateUser.htm"//个人中心，修改用户信息
#define URL_CHANGECODE @"/mobile/modifyUserValidateCode.htm"//个人中心,修改用户信息，获取验证码
//https://m3.purang.com:8050/mobile/agreementPrivacy.htm 隐私政策
#define URL_REACHABILITY @"www.baidu.com"

#endif
