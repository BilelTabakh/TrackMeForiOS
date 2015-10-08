//
//  DistanceStatistiqueViewController.m
//  TrackMe
//
//  Created by Trabelsi Achraf on 3/26/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import "DistanceStatistiqueViewController.h"
#import "Reachability.h"

@interface DistanceStatistiqueViewController ()

@end

@implementation DistanceStatistiqueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Title Of ViewController
    self.navigationItem.title = @"Statistiques Distances";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    
    //Load  DataBase
    _DB=[[DBManager alloc]initWithDatabaseFilename:@"trackmedatabase.sqlite"];
    
    //Select All Seances
    NSString *requete=@"Select * from Seance;";
    _mydata=[[NSArray alloc] initWithArray:[_DB loadDataFromDB:requete]];
    
    //Declare NSMutableDistancesLabels
    NSMutableArray *distancesLabelsNSMutable = [NSMutableArray array];
    //Declare NSMutableDatesSeances
    NSMutableArray *datesSeancesNSMutable = [NSMutableArray array];
    //Declare NSMutableDistancesValues
    NSMutableArray *distancesNSMutable = [NSMutableArray array];

    
    
    if([_mydata count] == 0){
        
    }else{
        
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
        self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 200.0, SCREEN_WIDTH, 200.0)];
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
        dataDistance.dataTitle = @"Distance en Km";
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
        [self.view addSubview:legend];
        
        
    }

 
}

-(void)viewWillDisappear:(BOOL)animated{
    //Remove LineChart From The View
    [self.lineChart removeFromSuperview];
}

- (void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex{
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
}

- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UIImage *)capture{
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.lineChart.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *imageView = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(imageView, nil, nil, nil);
    return imageView;
}

-(BOOL)checkNetwork{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return  networkStatus != NotReachable;
}

- (IBAction)btnSocialShare:(id)sender {
    
    if([_mydata count] == 0){
        //Show Alert No Stats
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Pas de statistiques" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }else{
        if(![self checkNetwork]){
            //Show Alert No Stats
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Pas de connexion Internet" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }else{
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Partage statistiques distnaces" delegate:self cancelButtonTitle:@"Fermer" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter", nil ];
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
        [facebookPost setInitialText:@"Statistiques Calories "];
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
        [twitterPost setInitialText:@"Statistiques Calories  "];
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
