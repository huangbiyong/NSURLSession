//
//  AppDelegate.h
//  session 后台下载
//
//  Created by chhu02 on 2018/6/13.
//  Copyright © 2018年 chhu02. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DownloadCompletionHandler)(void);


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// 后台下载的
@property (strong, nonatomic) NSString *identifier;
@property (copy,   nonatomic) DownloadCompletionHandler completionHandler;

@end

