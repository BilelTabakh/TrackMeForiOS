//
//  DetailStatistiqueViewController.h
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

@interface DetailStatistiqueViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *dureeLabel;

@property (weak, nonatomic) IBOutlet UILabel *vitesseLabel;


@property (weak, nonatomic) IBOutlet UILabel *caloriesLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@property(strong,nonatomic) NSString* strDureeDetailsStats;
@property(strong,nonatomic) NSString* strDistanceDetailsStats;
@property(strong,nonatomic) NSString* strVitesseDetailsStats;
@property(strong,nonatomic) NSString* strCaloriesDetailsStats;
@property(strong,nonatomic) NSString* strDateDetailsStats;





//Distance stats
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


//Calories stats
@property (nonatomic) PNBarChart * barChart;
- (IBAction)btnSocialShare:(id)sender;


@property (strong, nonatomic) NSArray *mydataCalories;



@end
