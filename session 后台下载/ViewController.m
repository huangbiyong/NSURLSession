//
//  ViewController.m
//  session 后台下载
//
//  Created by chhu02 on 2018/6/13.
//  Copyright © 2018年 chhu02. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()<NSURLSessionDownloadDelegate, NSURLSessionDelegate>
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *resumData;
@property (nonatomic, strong) NSURLSession *session;

//@property (strong, nonatomic) NSString *path;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self download];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)download {
    
    NSString *path = @"http://royole-appmarket-1255704470.cos.ap-beijing.myqcloud.com/apkmarket/resource/language/myscript-iink-recognition-text-de_DE.zip?sign=q-sign-algorithm%3Dsha1%26q-ak%3DAKIDazA8sN8mdFckdI8tpWyB8sMcdOvDRIyO%26q-sign-time%3D1528881654%3B1528882854%26q-key-time%3D1528881654%3B1528882854%26q-header-list%3Dhost%26q-url-param-list%3D%26q-signature%3D6dcdbc0fc2623fdf7dbd979471c522569822ea45";  //下载的文件url
    
    //1.url
    NSURL *url = [NSURL URLWithString:path];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.创建session
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"download_file_language"];
    //config.sessionSendsLaunchEvents = YES;
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // 如果还没下载完成，就关闭app，可以使用以下来kill掉
    // [self.session invalidateAndCancel];
    
    //4.创建Task
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithRequest:request];
    
    //5.执行Task
    [downloadTask resume];
    
    self.downloadTask = downloadTask;
    
}


#pragma mark ----------------------
#pragma mark NSURLSessionDownloadDelegate
/**
 *  写数据
 *
 *  @param session                   会话对象
 *  @param downloadTask              下载任务
 *  @param bytesWritten              本次写入的数据大小
 *  @param totalBytesWritten         下载的数据总大小
 *  @param totalBytesExpectedToWrite  文件的总大小
 */
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    CGFloat progress = 1.0 * totalBytesWritten/totalBytesExpectedToWrite;
    
    NSLog(@"%lf", progress);
    
    self.progressLabel.text = [NSString stringWithFormat:@"%lf",progress];
}

/**
 *  当恢复下载的时候调用该方法
 *
 *  @param fileOffset         从什么地方下载
 *  @param expectedTotalBytes 文件的总大小
 */
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"%s",__func__);
}

/**
 *  当下载完成的时候调用
 *
 *  @param location     文件的临时存储路径
 */
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    //DLog(@"%@",location);
    
    //1 拼接文件全路径
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    //2 剪切文件
    [[NSFileManager defaultManager]moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
    //NSLog(@"%@",fullPath);
}

/**
 *  请求结束
 */
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    //DLog(@"didCompleteWithError");
    
    // 关闭后台下载
    [self.session finishTasksAndInvalidate];

    
}


#pragma mark - NSURLSessionDelegate
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
   
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.completionHandler) {
        void (^completionHandle)() = appDelegate.completionHandler;
        appDelegate.completionHandler = nil;
        completionHandle();
    }
}


@end










































