//
//  PompesViewController.h
//  TrackMe
//
//  Created by Trabelsi Achraf on 2/19/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PompesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;


@property (weak, nonatomic) IBOutlet UILabel *scorePompeLabel;

@property (strong, nonatomic) IBOutlet UILabel *txtBestPush;

@property(nonatomic) int best;
@property(nonatomic)NSInteger push;
- (IBAction)btnReset:(id)sender;


@end
