//
//  ViewController.m
//  NPPBrowser
//
//  Created by Nick Peters on 2/16/15.
//  Copyright (c) 2015 Nick Peters. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIWebView *pageWindow;
@property (nonatomic, weak) IBOutlet UITextField *url;
@property (nonatomic, weak) IBOutlet UIButton *goButton;

@end

@implementation ViewController

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *string = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    [self.pageWindow loadHTMLString:string baseURL:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid URL"
                                                    message:@"Please enter a valid URL."
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
    [alert show];
}

- (IBAction)goClicked:(id)sender
{
    if (![[self.url text] containsString:@"http://"]) {
        NSMutableString *validURL = [[NSMutableString alloc] init];
        [validURL setString:@"http://"];
        [validURL appendString:[self.url text]];
        [self.url setText:validURL];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.url text]]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Your request could not be completed."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
