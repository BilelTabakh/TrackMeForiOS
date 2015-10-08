//
//  DistanceStatistiqueViewController.h
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

@interface DistanceStatistiqueViewController : UIViewController

@property (nonatomic) PNLineChart * lineChart;

@property (strong, nonatomic) NSArray *mydata;

@property (strong, nonatomic) NSArray *mydataDistance;
@property (strong, nonatomic) NSArray *mydataDatesSeances;
@property (strong, nonatomic) NSArray *mydataDistancesLabels;

@property (strong, nonatomic) DBManager *DB;

- (IBAction)btnSocialShare:(id)sender;


-(void)ShareOnFacebook;
-(void)ShareOnTwitter;

-(BOOL)checkNetwork;

@end
