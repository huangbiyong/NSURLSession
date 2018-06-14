# NSURLSession

### NSURLSession background download
#### 1.环境
* xcode 版本：xcode9.3
* ios 版本： iOS11.0
#### 2.集成步骤
* NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"download_file_language"]; 创建一个后台配置；
* self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
* NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithRequest:request]; 创建下载DownloadTask，不能创建NSURLSessionDataTask，因为进入后台会被kill掉；
* 只想task   [downloadTask resume];


