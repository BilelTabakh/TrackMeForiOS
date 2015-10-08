//
//  StepCounterViewController.m
//  TrackMe
//
//  Created by Trabelsi Achraf on 5/21/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import "StepCounterViewController.h"

#import "SWRevealViewController.h"

@interface StepCounterViewController ()

@end

@implementation StepCounterViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Title Of ViewController
    self.navigationItem.title = @"Step Counter";
    
    //Drawer Configuration
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];


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
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:
(UIAcceleration *)acceleration{
    
    float accelerometerZ = acceleration.z;
    if(accelerometerZ <= -0.2 && _ok == NO){
        _steps++;
        _ok = YES;
        _txtSteps.text =[NSString stringWithFormat:@"%ld",_steps];
        if(_steps>=_best)
        {
            _txtBest.text = [NSString stringWithFormat:@"%ld", _steps];
        }
    }
    if(accelerometerZ >= 0.2 && _ok == YES){
        _steps++;
        _ok = NO;
        _txtSteps.text =[NSString stringWithFormat:@"%ld",_steps];
        if(_steps>=_best)
        {
        _txtBest.text = [NSString stringWithFormat:@"%ld", _steps];
        }
    }
}

- (IBAction)btnResetStep:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Reset?"
                          message:@"Do you want to reset the counter?"
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"OK", nil];
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger) buttonIndex{
    _steps = 0;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (buttonIndex == 1) {
        [defaults setInteger:_steps forKey:@"saveScoreStep"];
        [defaults synchronize];
        _best = [[NSUserDefaults standardUserDefaults]integerForKey:@"saveScoreStep"];
        _txtBest.text = [NSString stringWithFormat:@"%d", _best];;
        _txtSteps.text = @"0";
        
    }
}

-(void)viewWillDisappear:(BOOL)animated{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(_steps>_best){
    [defaults setInteger:_steps forKey:@"saveScoreStep"];
    [defaults synchronize];
    }
    [[UIAccelerometer sharedAccelerometer]setDelegate:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    //get best score
    _best = [[NSUserDefaults standardUserDefaults]integerForKey:@"saveScoreStep"];
    
    _txtBest.text = [NSString stringWithFormat:@"%d", _best];
    [[UIAccelerometer sharedAccelerometer]setDelegate:self];
    
    _ok = NO;

}
@end
