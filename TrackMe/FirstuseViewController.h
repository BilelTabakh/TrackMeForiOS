//
//  FirstuseViewController.h
//  TrackMe
//
//  Created by Trabelsi Achraf on 2/23/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstuseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *tailleTextField;
@property (weak, nonatomic) IBOutlet UITextField *poidsTextField;
- (IBAction)backgroundTapFirstUse:(id)sender;


- (IBAction)suivantButton:(id)sender;

@end
