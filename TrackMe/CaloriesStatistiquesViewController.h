//
//  StatistiquesViewController.h
//  TrackMe
//
//  Created by Trabelsi Achraf on 3/26/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"
#import "DBManager.h"
#import <Social/Social.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"

@interface CaloriesStatistiquesViewController : UIViewController

@property (nonatomic) PNBarChart * barChart;
- (IBAction)btnSocialShare:(id)sender;


@property (strong, nonatomic) NSArray *mydata;

@property (strong, nonatomic) NSArray *mydataCalories;
@property (strong, nonatomic) NSArray *mydataDatesSeances;


@property (strong, nonatomic) DBManager *DB;

-(void)ShareOnFacebook;
-(void)ShareOnTwitter;

-(BOOL)checkNetwork;

@end
