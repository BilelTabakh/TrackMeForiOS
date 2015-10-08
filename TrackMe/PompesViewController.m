//
//  PompesViewController.m
//  TrackMe
//
//  Created by Trabelsi Achraf on 2/19/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import "PompesViewController.h"
#import "SWRevealViewController.h"

@interface PompesViewController ()

@end

@implementation PompesViewController

bool pushUp = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Title Of ViewController
    self.navigationItem.title = @"Push-up Counter";
    
    //Drawer Configuration
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sensorStateChange:(NSNotificationCenter *)notification
{
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        pushUp = true;
        _push++;
    }
    else
    {
        pushUp = false;
    }
    if (pushUp) {
        _scorePompeLabel.text = [NSString stringWithFormat:@"%ld",_push];
        if(_push>=_best)
        {
            _txtBestPush.text = [NSString stringWithFormat:@"%ld", _push];
        }
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger) buttonIndex{
    
    if (buttonIndex == 1) {
        _push = 0;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (buttonIndex == 1) {
            [defaults setInteger:_push forKey:@"saveScorePush"];
            [defaults synchronize];
            _best = [[NSUserDefaults standardUserDefaults]integerForKey:@"saveScorePush"];
            _txtBestPush.text = [NSString stringWithFormat:@"%d", _best];
            _scorePompeLabel.text = @"0";
    }
    }
}
- (IBAction)btnReset:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Reset?"
                          message:@"Do you want to reset the counter?"
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"OK", nil];
    [alert show];

}
-(void)viewWillDisappear:(BOOL)animated{
[[UIDevice currentDevice] setProximityMonitoringEnabled:NO];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(_push>_best){
        [defaults setInteger:_push forKey:@"saveScorePush"];
        [defaults synchronize];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    // Enabled monitoring of the sensor
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    _scorePompeLabel.text = @"0";
    
    // Set up an observer for proximity changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:)
                                                 name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    //get best score
    _best = [[NSUserDefaults standardUserDefaults]integerForKey:@"saveScorePush"];
    
    _txtBestPush.text = [NSString stringWithFormat:@"%d", _best];


}

@end
