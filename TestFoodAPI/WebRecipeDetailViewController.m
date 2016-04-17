//
//  WebRecipeDetailViewController.m
//  TestFoodAPI
//
//  Created by Bahram Haddadi on 2016-03-08.
//  Copyright © 2016 Bahram Haddadi. All rights reserved.
//

#import "WebRecipeDetailViewController.h"

@interface WebRecipeDetailViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *vwSpinnerBG;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation WebRecipeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]];
    [self.webView loadRequest:request];
    [self showSpinner:YES];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
//    [self showSpinner:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self showSpinner:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [self showSpinner:NO];
    NSLog(@"Error : %@",error.localizedDescription);
}

#pragma mark - Helper Methods
-(void)showSpinner:(BOOL)show{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.vwSpinnerBG.hidden = !show;
        self.spinner.hidden = !show;
        if (show) [self.spinner startAnimating];
        else [self.spinner stopAnimating];
    });
}

@end
