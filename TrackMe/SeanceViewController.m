//
//  SeanceViewController.m
//  TrackMe
//
//  Created by Trabelsi Achraf on 2/19/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import "SeanceViewController.h"
#import "SWRevealViewController.h"
#import "Seance.h"
#import "MathController.h"
#import "MusicViewController.h"
//Import Of CustomAlert
#import "SampleSheetViewController.h"
#import "NAModalSheet.h"
#import "UIImage+BoxBlur.h"
#import "Reachability.h"


@interface SeanceViewController ()<NAModalSheetDelegate>

@property (strong,nonatomic) UIImage *fcbImage;
@property (strong,nonatomic) UIImage *twitterImage;


@end

@implementation SeanceViewController

@synthesize mapview;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Clear MapView
    [self.mapview removeOverlays: self.mapview.overlays];
    
    //Hide btnStop
    self.btnStop2.hidden = YES;
    
    
    // Title Of ViewController
    self.navigationItem.title = @"Run";
    
    //Map
     mapview.mapType = MKMapTypeStandard;
    
    //Drawer Configuration
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //Load DataBase
    _DB = [[DBManager alloc]initWithDatabaseFilename:@"trackmedatabase.sqlite"];
    
    
    self.distance = 0;
    self.caloriesAffect = 0;
    self.vitesseAffect = 0;
    
    lm = [[CLLocationManager alloc] init];
    lm.delegate = self;
    lm.desiredAccuracy = kCLLocationAccuracyBest;
    lm.distanceFilter = kCLDistanceFilterNone;
    //New Code
    lm.activityType = CLActivityTypeFitness;
    
    
    mapview.delegate = self;
    mapview.showsUserLocation = YES;
    
    
    
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    
    if (IS_OS_8_OR_LATER)
    {
        //Stop NSTimer
        [self.timer invalidate];
        self.timer = nil;
        
        [lm requestWhenInUseAuthorization];
        
        [lm requestAlwaysAuthorization];
    }
    

    [lm startUpdatingLocation];
    
}

- (void)viewWillAppear:(BOOL)animated {
    trackPointArray = [[NSMutableArray alloc] init];
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

//With This Method , The Timer Is Stopped When The User Navigates Away From The View
/*- (void) viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}
*/
//This Is Method That Will Be Called Every Second By Using An NSTimer
- (void) eachSecond
{
    self.seconds++;
    self.dureeLabel.text = [NSString stringWithFormat:@"%@",[MathController stringifySecondCount:self.seconds usingLongFormat:NO]];
    self.distanceLabel.text = [MathController stringifyDistance:self.distance];
    
    //self.vitesseLabel.text = [NSString stringWithFormat:@"%@", [MathController stringifyAvgPaceFromDist:self.distance overTime:self.seconds]];
   
    
    self.caloriesLabel.text = [NSString stringWithFormat:@"%.0f",self.caloriesAffect];
    self.vitesseLabel.text = [NSString stringWithFormat:@"%.0f",self.vitesseAffect];
 

}



- (IBAction)musicBarBtn:(id)sender {
    
    
    MusicViewController * svcMusic =[self.storyboard instantiateViewControllerWithIdentifier:@"music"];
    
    
    [self.navigationController pushViewController:svcMusic animated:YES];
    
}

- (IBAction)btnStart:(id)sender {
   
    
    self.btnStop2.hidden = NO;
    self.btnStart2.hidden = YES;
   
    //Update Fields
    self.seconds = 0;
    self.distance = 0;
    self.caloriesAffect = 0;
    self.vitesseAffect = 0;
    
 /*
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    
    if (IS_OS_8_OR_LATER)
    {
        //Stop NSTimer
        [self.timer invalidate];
        self.timer = nil;
        
        [lm requestWhenInUseAuthorization];
        
        [lm requestAlwaysAuthorization];
    }
    */

    //Update Fields
    trackPointArray = [NSMutableArray array];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(eachSecond) userInfo:nil repeats:YES];
    
    //Clear MapView
    [self.mapview removeOverlays: self.mapview.overlays];
    
    
    //Again
    lm = [[CLLocationManager alloc] init];
    lm.delegate = self;
    lm.desiredAccuracy = kCLLocationAccuracyBest;
    lm.distanceFilter = kCLDistanceFilterNone;
    //New Code
    lm.activityType = CLActivityTypeFitness;
    
    
    mapview.delegate = self;
    mapview.showsUserLocation = YES;
    
    [lm startUpdatingLocation];
    
    
}

- (IBAction)btnStop:(id)sender {
    
    
    //Stop NSTimer
    [self.timer invalidate];
    self.timer = nil;
    
    //reset location manager and turn off GPS
    lm = [[CLLocationManager alloc] init];
    [lm stopUpdatingLocation];
    lm = nil;
    
    //stop shwing user location
    mapview.showsUserLocation = NO;
    
    //reset array fo tracks
    trackPointArray = nil;
    trackPointArray = [[NSMutableArray alloc] init];
    
    /*Save Seance*/
    NSString *alertStore = @"Seance sauvegardée";
    
    //Declaration Infos Seance
    int dureeSeanceToSave = self.seconds;
    double distanceSeanceToSave = self.distance/1000;
    
    double caloriesSeanceToSave =self.caloriesAffect;
    //double vitesseSeanceToSave = self.vitesseAffect;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *dateSeanceSysteme = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString * dateSeanceToSave = [NSString stringWithFormat:@"%@",dateSeanceSysteme];
    
    
    //Save Infos Of Seance
    NSString * duree = [NSString stringWithFormat:@"%d",dureeSeanceToSave];
    NSString * distance = [NSString stringWithFormat:@"%.2f",distanceSeanceToSave];
    NSString * vitesse = [NSString stringWithFormat:@"%.0f",[self.vitesseLabel.text floatValue]];
    NSString * calories = [NSString stringWithFormat:@"%.1f",caloriesSeanceToSave];
    NSString * dateSeance = dateSeanceToSave;
    
    //Execute Request
    NSString *requete=[NSString stringWithFormat:@"insert into Seance values (null,'%@','%@','%@','%@','%@')",duree,distance,vitesse,calories,dateSeance];
    [_DB executeQuery:requete];
    
    //Show Alert After Saving Infos Of Seance
    /*UIAlertView *alert = [[UIAlertView alloc]initWithTitle:alertStore message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];*/
    
    //Call Method CustomAlertMethod To Share On Facebook
    //[self CustomAlertMethod];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Run saved" delegate:self cancelButtonTitle:@"Close" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter", nil ];
    [actionSheet showInView:self.view];
    

}

-(BOOL)checkNetwork{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return  networkStatus != NotReachable;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        if(![self checkNetwork]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No internet connection" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }else{
            [self ShareOnFacebook];
        }
    }
    else if(buttonIndex == 1){
        if(![self checkNetwork]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No internet connection" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }else{
            [self ShareOnTwitter];
        }
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    //get the latest location
    CLLocation *currentLocation = [locations lastObject];

    
    //store latest location in stored track array;
    [trackPointArray addObject:currentLocation];
    
    //get latest location coordinates
    CLLocationDegrees Latitude = currentLocation.coordinate.latitude;
    CLLocationDegrees Longitude = currentLocation.coordinate.longitude;
    
    CLLocationCoordinate2D locationCoordinates = CLLocationCoordinate2DMake(Latitude, Longitude);
    
    //zoom map to show users location
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(locationCoordinates, 500, 500);
    MKCoordinateRegion adjustedRegion = [mapview regionThatFits:viewRegion]; [mapview setRegion:adjustedRegion animated:YES];
    
    NSInteger numberOfSteps = trackPointArray.count;
    
    CLLocationCoordinate2D coordinates[numberOfSteps];
    for (NSInteger index = 0; index < numberOfSteps; index++) {
        //LLocation *firstLocation = [trackPointArray objectAtIndex:(index-1)];
        CLLocation *location = [trackPointArray objectAtIndex:index];
        CLLocationCoordinate2D coordinate2 = location.coordinate;
        
        coordinates[index] = coordinate2;
        
       self.distance += [location distanceFromLocation:trackPointArray.lastObject]/1000;
       NSLog(@"dist: %f",self.distance);
        
     
    }
    
    //Load Data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loadPoids = [defaults objectForKey:@"savePoids"];
    int poids =  [loadPoids intValue];
    
    self.caloriesAffect =+ (poids*self.distance)/1000;
    NSLog(@"caloriesAffect %f", self.caloriesAffect);
    
    
    self.vitesseAffect = (((self.distance/self.seconds)*3.6)*100)/100;
    //self.vitesseAffect  = (double)((int)( self.vitesseAffect *100))/100;
    
    
    // NSLog(@"duree : %@",self.dureeLabel.text);
     NSLog(@"vitesse : %.2f",self.vitesseAffect);
    
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
    [mapview addOverlay:polyLine];
    
   // NSLog(@"%@", trackPointArray);
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor blueColor];
    polylineView.lineWidth = 4.0;
    
    return polylineView;
}


//Method Of Custom Alert
-(void)CustomAlertMethod{
    SampleSheetViewController *svc = [[SampleSheetViewController alloc] init];
    //svc.opaque = disableBlurSwitch.on;
    NAModalSheet *sheet = [[NAModalSheet alloc] initWithViewController:svc presentationStyle:NAModalSheetPresentationStyleSlideInFromBottom];
    //sheet.disableBlurredBackground = (!disableBlurSwitch.on);
    sheet.delegate = self;
    svc.modalSheet = sheet;
    [sheet presentWithCompletion:^{
    }];
}

/*
- (UIImage *)drawRoute:(MKPolyline *)polyline onSnapshot:(MKMapSnapshot *)snapShot withColor:(UIColor *)lineColor {
    
    UIGraphicsBeginImageContext(snapShot.image.size);
    CGRect rectForImage = CGRectMake(0, 0, snapShot.image.size.width, snapShot.image.size.height);
    
    // Draw map
    [snapShot.image drawInRect:rectForImage];
    
    // Get points in the snapshot from the snapshot
    int lastPointIndex;
    int firstPointIndex = 0;
    BOOL isfirstPoint = NO;
    NSMutableArray *pointsToDraw = [NSMutableArray array];
    for (int i = 0; i < polyline.pointCount; i++){
        MKMapPoint point = polyline.points[i];
        CLLocationCoordinate2D pointCoord = MKCoordinateForMapPoint(point);
        CGPoint pointInSnapshot = [snapShot pointForCoordinate:pointCoord];
        if (CGRectContainsPoint(rectForImage, pointInSnapshot)) {
            [pointsToDraw addObject:[NSValue valueWithCGPoint:pointInSnapshot]];
            lastPointIndex = i;
            if (i == 0)
                firstPointIndex = YES;
            if (!isfirstPoint) {
                isfirstPoint = YES;
                firstPointIndex = i;
            }
        }
    }
    
    // Adding the first point on the outside too so we have a nice path
    if (lastPointIndex+1 <= polyline.pointCount) {
        MKMapPoint point = polyline.points[lastPointIndex+1];
        CLLocationCoordinate2D pointCoord = MKCoordinateForMapPoint(point);
        CGPoint pointInSnapshot = [snapShot pointForCoordinate:pointCoord];
        [pointsToDraw addObject:[NSValue valueWithCGPoint:pointInSnapshot]];
    }
        // Adding the point before the first point in the map as well (if needed) to have nice path
        
        if (firstPointIndex != 0) {
            MKMapPoint point = polyline.points[firstPointIndex-1];
            CLLocationCoordinate2D pointCoord = MKCoordinateForMapPoint(point);
            CGPoint pointInSnapshot = [snapShot pointForCoordinate:pointCoord];
            [pointsToDraw insertObject:[NSValue valueWithCGPoint:pointInSnapshot] atIndex:0];
        }
        
        // Draw that points
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 3.0);
        
        for (NSValue *point in pointsToDraw){
            CGPoint pointToDraw = [point CGPointValue];
            if ([pointsToDraw indexOfObject:point] == 0){
                CGContextMoveToPoint(context, pointToDraw.x, pointToDraw.y);
            } else {
                CGContextAddLineToPoint(context, pointToDraw.x, pointToDraw.y);
            }
        }
        CGContextSetStrokeColorWithColor(context, [lineColor CGColor]);
        CGContextStrokePath(context);
        
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resultingImage;
        }
*/

-(UIImage *)capture{
   
    UIGraphicsBeginImageContext(self.mapview.bounds.size);
    [self.mapview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *imageView = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(imageView, nil, nil, nil);
    return imageView;
}

//Share On Facebook
-(void)ShareOnFacebook{

        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
            
            SLComposeViewController *facebookPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            //Information To Share On Facebook
            [facebookPost setInitialText:@"My new run:"];
            [facebookPost addImage:[self capture]];
            
            [self presentViewController:facebookPost animated:YES completion:Nil];
            
            SLComposeViewControllerCompletionHandler compeletion = ^(SLComposeViewControllerResult result){
                
                switch (result) {
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Posted to Facebook");
                        break;
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"User cancelled the operation");
                        break;
                    default:
                        break;
                }
                [facebookPost dismissViewControllerAnimated:YES completion:nil];
                
            };
            
            facebookPost.completionHandler = compeletion;
            
        }

}


//Share On Twitter
-(void)ShareOnTwitter{
    
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
            
            SLComposeViewController *twitterPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            //Information To Share On Facebook
            [twitterPost setInitialText:@"My new run : "];
            [twitterPost addImage:[self capture]];
            
            [self presentViewController:twitterPost animated:YES completion:Nil];
            
            SLComposeViewControllerCompletionHandler compeletion = ^(SLComposeViewControllerResult result){
                
                switch (result) {
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Posted to Twitter");
                        break;
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"User cancelled the operation");
                        break;
                    default:
                        break;
                }
                [twitterPost dismissViewControllerAnimated:YES completion:nil];
                
            };
            
            twitterPost.completionHandler = compeletion;
            
        }
    }


@end
