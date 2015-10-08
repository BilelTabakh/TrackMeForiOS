//
//  AboutViewController.m
//  TrackMe
//
//  Created by Trabelsi Achraf on 4/15/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import "AboutViewController.h"
#import "SWRevealViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Title Of ViewController
    self.navigationItem.title = @"About";
   
    //Drawer Configuration
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)shareBilel:(id)sender {
    //Go To Bilel Facebook
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://www.facebook.com/bilel.tabakh"]];
}

- (IBAction)shareAchraf:(id)sender {
    //Go To Achraf Facebook
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://www.facebook.com/Trabelsi.Achraf.Mentalite.psychologie?fref=ts"]];
}
@end
