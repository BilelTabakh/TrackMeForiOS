//
//  ViewController.m
//  TrackMe
//
//  Created by Trabelsi Achraf on 2/19/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"
#import "MathController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Title Of ViewController
    self.navigationItem.title = @"Home";
    

    //Load  DataBase
    _DB=[[DBManager alloc]initWithDatabaseFilename:@"trackmedatabase.sqlite"];
    
    //Last parcours
    NSString *requete=@"Select * from Seance;";
        _mydata=[[NSArray alloc] initWithArray:[_DB loadDataFromDB:requete]];
        

    //Show Alert : No Seance In DataBase
    if ([_mydata count] == 0) {
        
        _distanceLabel.text = @"No Data";
        _dureeLabel.text =@"No Data";
        _vitesseLabel.text = @"No Data";
        _caloriesLabel.text =@"No Data";
    }
    else{
        
        NSString *nDuree = [NSString stringWithFormat:@"%@",[_mydata[_mydata.count-1]objectAtIndex:1]];
        double dureeDouble = [nDuree doubleValue];
        
        NSString *nDistance = [NSString stringWithFormat:@"%@",[_mydata[_mydata.count-1]objectAtIndex:2]];
        double distanceDouble = [nDistance doubleValue]*1000;
        
        
        _dureeLabel.text =[NSString stringWithFormat:@"%@ sec",[MathController stringifySecondCount:dureeDouble usingLongFormat:YES]];
        
        _distanceLabel.text = [NSString stringWithFormat:@"%@km",[MathController stringifyDistance:distanceDouble]];
        
        _vitesseLabel.text = [NSString stringWithFormat:@"%@ km/h",[_mydata[_mydata.count-1]objectAtIndex:3]];
        
        _caloriesLabel.text =[NSString stringWithFormat:@"%@ kcal",[_mydata[_mydata.count-1]objectAtIndex:4]];
    }
        
   
    
   //Drawer Configuration
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
