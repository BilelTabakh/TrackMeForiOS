//
//  StatistiqueHomeViewController.m
//  TrackMe
//
//  Created by Trabelsi Achraf on 3/26/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import "StatistiqueHomeViewController.h"
#import "SWRevealViewController.h"


@interface StatistiqueHomeViewController ()

@end

@implementation StatistiqueHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Statistics";
    
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

@end
