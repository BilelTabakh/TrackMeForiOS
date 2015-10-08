//
//  MesInfosViewController.h
//  TrackMe
//
//  Created by Trabelsi Achraf on 2/24/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MesInfosViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButton;

- (IBAction)tapBackgroundMesinfos:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *tailleInfoTextField;

@property (weak, nonatomic) IBOutlet UITextField *poidsInfoTextField;

- (IBAction)modifierButton:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *txtInterpretation;


@property (weak, nonatomic) IBOutlet UILabel *imcInfoTextField;

@end
