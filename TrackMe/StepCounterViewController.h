//
//  StepCounterViewController.h
//  TrackMe
//
//  Created by Trabelsi Achraf on 5/21/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepCounterViewController : UIViewController<UIAccelerometerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *txtSteps;

@property(nonatomic)NSInteger steps;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButton;

@property (strong, nonatomic) IBOutlet UILabel *txtBest;
@property(nonatomic) int best;
@property(nonatomic)BOOL ok;
@end
