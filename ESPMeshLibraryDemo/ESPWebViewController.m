//
//  ESPWebViewController.m
//  ESPMeshLibraryDemo
//
//  Created by zhaobing on 2018/7/2.
//  Copyright © 2018年 zhaobing. All rights reserved.
//

#import "ESPWebViewController.h"

@interface ESPWebViewController ()<WKNavigationDelegate,WKScriptMessageHandler>

@end

@implementation ESPWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webview = [[WKWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.webview setNavigationDelegate:self];
    [self.view addSubview:_webview];
    
    // Do any additional setup after loading the view from its nib.
    [self initApiForWebView];
    [self loadHtml];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidFinishLoad");
}


- (void)loadHtml {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [_webview loadHTMLString:appHtml baseURL:baseURL];
}

WKScriptMessage* MessHandler=nil;
- (void)initApiForWebView {
    
    [_webview.configuration.userContentController addScriptMessageHandler:self name:@"log"];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"log"]) {
        
        [self log:message.body];
    }
}

- (void)log:(id)message {
    NSLog(@"%@", message);
    [_webview evaluateJavaScript:@"save1(\'zb\')" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
       
    }];
}
@end
