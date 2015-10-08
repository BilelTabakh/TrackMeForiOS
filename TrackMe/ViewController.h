//
//  ViewController.h
//  TrackMe
//
//  Created by Trabelsi Achraf on 2/19/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"


@interface ViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;


@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dureeLabel;
@property (weak, nonatomic) IBOutlet UILabel *vitesseLabel;
@property (weak, nonatomic) IBOutlet UILabel *caloriesLabel;

@property (strong, nonatomic) NSArray *mydata;

@property (strong, nonatomic) DBManager *DB;




@end

