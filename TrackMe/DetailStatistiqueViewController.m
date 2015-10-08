//
//  DetailStatistiqueViewController.m
//  TrackMe
//
//  Created by Trabelsi Achraf on 3/26/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import "DetailStatistiqueViewController.h"


@interface DetailStatistiqueViewController ()

@end

@implementation DetailStatistiqueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Title Of ViewController
    //self.navigationItem.title = [NSString stringWithFormat:@"Seance e %@",_strDateDetailsStats];
    
    //Load Details Statistiques
    [_dureeLabel setText:_strDureeDetailsStats];
    [_distanceLabel setText:_strDistanceDetailsStats];
    [_vitesseLabel setText:_strVitesseDetailsStats];
    [_caloriesLabel setText:_strCaloriesDetailsStats];
    [_dateLabel setText:_strDateDetailsStats];
    
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



-(void)viewWillAppear:(BOOL)animated{
    
    //Load  DataBase
    _DB=[[DBManager alloc]initWithDatabaseFilename:@"trackmedatabase.sqlite"];
    
    //Select All Seances
    NSString *requete=@"Select * from Seance;";
    _mydata=[[NSArray alloc] initWithArray:[_DB loadDataFromDB:requete]];
    
    //Declare NSMutableCalories
    NSMutableArray *caloriesNSMutable = [NSMutableArray array];
    //Declare NSMutableDatesSeances
    NSMutableArray *datesSeancesNSMutable = [NSMutableArray array];
    
    
    //Declare NSMutableDistancesLabels
    NSMutableArray *distancesLabelsNSMutable = [NSMutableArray array];

    //Declare NSMutableDistancesValues
    NSMutableArray *distancesNSMutable = [NSMutableArray array];
    
    
    if([_mydata count] == 0){
        
    }else{
        
        
        //BarChart
        for (int i=0; i < _mydata.count; i++) {
            //Add Calories To NSMutable : caloriesNSMutable
            [caloriesNSMutable addObject:[NSDecimalNumber numberWithInt:[[_mydata[i]objectAtIndex:4]intValue]]];
            //Add DatesSeances To NSMutable : datesSeancesNSMutable
            [datesSeancesNSMutable addObject:[_mydata[i]objectAtIndex:5]];
        }
        
        
        //Affectation NSMutable(caloriesNSMutable) To NSArray(mydataCalories)
        self.mydataCalories = [NSArray arrayWithArray:caloriesNSMutable];
        //Affectation NSMutable(datesSeancesNSMutable) To NSArray(mydataDatesSeances)
        self.mydataDatesSeances = [NSArray arrayWithArray:datesSeancesNSMutable];
        
        
        //BarChart
        self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 120.0, SCREEN_WIDTH, 150.0)];
        self.barChart.backgroundColor = [UIColor clearColor];
        self.barChart.yLabelFormatter = ^(CGFloat yValue){
            CGFloat yValueParsed = yValue;
            NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
            return labelText;
        };
        self.barChart.labelMarginTop = 5.0;
        
        //Abcisse DateSeances
        [self.barChart setXLabels:self.mydataDatesSeances];
        
        self.barChart.rotateForXAxisText = true ;
        //Ordonnee Calories
        [self.barChart setYValues:self.mydataCalories];
        
        [self.barChart setStrokeColors:@[PNGreen,PNGreen,PNRed,PNGreen,PNGreen,PNYellow,PNGreen]];
        // Adding gradient
        self.barChart.barColorGradientStart = [UIColor blueColor];
        
        
        [self.barChart strokeChart];
        
        self.barChart.delegate = self;
        
        [self.view addSubview:self.barChart];
        
        
        //LineChart
        for (int i=0; i < _mydata.count; i++) {
            //Add Distances Values To NSMutable : distancesNSMutable
            [distancesNSMutable addObject:[NSDecimalNumber numberWithInt:[[_mydata[i]objectAtIndex:2]floatValue]]];
            //Add DatesSeances To NSMutable : datesSeancesNSMutable
            [datesSeancesNSMutable addObject:[_mydata[i]objectAtIndex:5]];
            //Add Distances Labels To NSMutable : distancesLabelsNSMutable
            [distancesLabelsNSMutable addObject:[_mydata[i]objectAtIndex:2]];
        }
        
        
        //Affectation NSMutable(distancesNSMutable) To NSArray(mydataDistance)
        self.mydataDistance = [NSArray arrayWithArray:distancesNSMutable];
        //Affectation NSMutable(datesSeancesNSMutable) To NSArray(mydataDatesSeances)
        self.mydataDatesSeances = [NSArray arrayWithArray:datesSeancesNSMutable];
        //Affectation NSMutable(distancesLabelsNSMutable) To NSArray(mydataDistancesLabels)
        //self.mydataDistancesLabels = [NSArray arrayWithArray:distancesLabelsNSMutable];
        self.mydataDistancesLabels = @[@"0.5km",@"1km",@"1.5km",@"2km",@"2.5km",@"3km",@"3.5km",@"4km",@"4.5km",@"5km"];
        
        
        
        //LineChart
        self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 290.0, SCREEN_WIDTH, 150.0)];
        self.lineChart.yLabelFormat = @"%1.1f";
        self.lineChart.backgroundColor = [UIColor clearColor];
        
        //Abcisse DateSeances
        [self.lineChart setXLabels:self.mydataDatesSeances];
        self.lineChart.showCoordinateAxis = YES;
        
        //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
        //Only if you needed
        self.lineChart.yFixedValueMax =5.0;
        self.lineChart.yFixedValueMin = 0.0;
        
        //Ordonnee DistanceLabel
        [self.lineChart setYLabels:self.mydataDistancesLabels];
        
        /* Line Chart Created */
        //Affectations Distances To dataDistancesArray from mydataDistance
        NSArray * dataDistanceArray = self.mydataDistance;
        PNLineChartData *dataDistance = [PNLineChartData new];
        dataDistance.dataTitle = @"Distance in Km";
        dataDistance.color = PNTwitterColor;
        dataDistance.alpha = 0.5f;
        dataDistance.itemCount = dataDistanceArray.count;
        dataDistance.inflexionPointStyle = PNLineChartPointStyleCircle;
        dataDistance.getData = ^(NSUInteger index) {
            CGFloat yValue = [dataDistanceArray[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        self.lineChart.chartData = @[dataDistance];
        [self.lineChart strokeChart];
        self.lineChart.delegate = self;
        
        [self.view addSubview:self.lineChart];
        
        self.lineChart.legendStyle = PNLegendItemStyleStacked;
        self.lineChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
        self.lineChart.legendFontColor = [UIColor redColor];
        
        
        UIView *legend = [self.lineChart getLegendWithMaxWidth:320];
        [legend setFrame:CGRectMake(30, 430, legend.frame.size.width, legend.frame.size.width)];
        //[self.view addSubview:legend];
        
    }
    
}

-(UIImage *)capture{
    
    UIGraphicsBeginImageContext(self.barChart.bounds.size);
    [self.barChart.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *imageView = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(imageView, nil, nil, nil);
    return imageView;
}

- (void)userClickedOnBarAtIndex:(NSInteger)barIndex
{
    
    NSLog(@"Click on bar %@", @(barIndex));
    
    PNBar * bar = [self.barChart.bars objectAtIndex:barIndex];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.fromValue = @1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.toValue = @1.1;
    animation.duration = 0.2;
    animation.repeatCount = 0;
    animation.autoreverses = YES;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    [bar.layer addAnimation:animation forKey:@"Float"];
}

-(void)viewWillDisappear:(BOOL)animated{
    //Remove BarChart From The View
    [self.barChart removeFromSuperview];
    [self.lineChart removeFromSuperview];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(BOOL)checkNetwork{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return  networkStatus != NotReachable;
}

- (IBAction)btnSocialShare:(id)sender {
    
    if([_mydata count] == 0){
        //Show Alert No Stats
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No statistics" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }else{
        if(![self checkNetwork]){
            //Show Alert No Stats
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No internet connection" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }else{
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"No statistics" delegate:self cancelButtonTitle:@"Fermer" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter", nil ];
            [actionSheet showInView:self.view];
        }
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0)
        [self ShareOnFacebook];
    else if(buttonIndex == 1)
        [self ShareOnTwitter];
    
}


//Share On Facebook
-(void)ShareOnFacebook{
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        
        SLComposeViewController *facebookPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        //Information To Share On Facebook
        [facebookPost setInitialText:@"Statistics "];
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
        [twitterPost setInitialText:@"Statistics"];
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

- (void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex{
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
}

- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
}



@end
