//
//  SeanceViewController.h
//  TrackMe
//
//  Created by Trabelsi Achraf on 2/19/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DBManager.h"
#import <Social/Social.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"


@interface SeanceViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, MKOverlay,UIActionSheetDelegate> {
    
    CLLocationManager *lm; //core lcoation manager instance
    
    NSMutableArray *trackPointArray; //Array to store location points
    
    //instaces from mapkit to draw trail on map
    MKMapRect routeRect;
    MKPolylineView* routeLineView;
    MKPolyline* routeLine;

}
//Declaration DataBase
@property(strong,nonatomic) DBManager *DB;

@property (weak, nonatomic) IBOutlet MKMapView *mapview;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

- (IBAction)musicBarBtn:(id)sender;



- (IBAction)btnStart:(id)sender;
- (IBAction)btnStop:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnStop2;
@property (strong, nonatomic) IBOutlet UIButton *btnStart2;


@property int seconds;
@property float distance;
@property float vitesseAffect;
@property float caloriesAffect;


@property float di;

@property (nonatomic,strong) NSTimer *timer;


@property (weak, nonatomic) IBOutlet UILabel *dureeLabel;

@property (weak, nonatomic) IBOutlet UILabel *vitesseLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;


@property (weak, nonatomic) IBOutlet UILabel *caloriesLabel;

-(void)CustomAlertMethod;

-(void)ShareOnFacebook;
-(void)ShareOnTwitter;

-(BOOL)checkNetwork;



@property (weak, nonatomic) NSData *data;

@end
