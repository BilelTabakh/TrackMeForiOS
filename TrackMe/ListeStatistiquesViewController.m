//
//  StatistiquesViewController.m
//  TrackMe
//
//  Created by Trabelsi Achraf on 2/19/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import "ListeStatistiquesViewController.h"
#import "SWRevealViewController.h"
#import "DetailStatistiqueViewController.h"
#import "MathController.h"

@interface ListeStatistiquesViewController ()

@end

@implementation ListeStatistiquesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Title Of ViewController
    self.navigationItem.title = @"Statistics";
   
    
    //Load  DataBase
    _DB=[[DBManager alloc]initWithDatabaseFilename:@"trackmedatabase.sqlite"];
    _tab.delegate=self;
    _tab.dataSource=self;
    [self loaddata];
    
    //Drawer Configuration
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{return _mydata.count;}


-(void)loaddata
{NSString *requete=@"Select * from Seance;";
    _mydata=[[NSArray alloc] initWithArray:[_DB loadDataFromDB:requete]];
    [_tab reloadData];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
    //Duree
    NSInteger indiceduree=[_DB.arrColumnNames indexOfObject:@"duree"];
    NSString *duree=[[_mydata objectAtIndex:indexPath.row] objectAtIndex:indiceduree];
    //Distance
    NSInteger indicedistance=[_DB.arrColumnNames indexOfObject:@"distance"];
    NSString *distance=[[_mydata objectAtIndex:indexPath.row] objectAtIndex:indicedistance];
    //Calories
    NSInteger indicecalories=[_DB.arrColumnNames indexOfObject:@"calories"];
    NSString *calories=[[_mydata objectAtIndex:indexPath.row] objectAtIndex:indicecalories];
    //Vitesse
    NSInteger indicevitesse=[_DB.arrColumnNames indexOfObject:@"vitesse"];
    NSString *vitesse=[[_mydata objectAtIndex:indexPath.row] objectAtIndex:indicevitesse];
    //DateSeance
    NSInteger indicedateSeance=[_DB.arrColumnNames indexOfObject:@"date_seance"];
    NSString *dateSeance=[[_mydata objectAtIndex:indexPath.row] objectAtIndex:indicedateSeance];
    
    
    //Load TabView
    Cell.textLabel.text=[NSString stringWithFormat:@"Seance of : %@",dateSeance];
    //Cell.detailTextLabel.text=calories;
    
    return Cell;
}

//Swipe To Delete Seance From TabView
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete The Selected Seance.
        NSString *requete=[NSString stringWithFormat:@"delete from Seance where id='%@'",[_mydata objectAtIndex:indexPath.row][0]];
        [_DB executeQuery:requete];
        // Reload All Seances And The Table View.
        [self loaddata];
    }
}

/*
-(UITableViewCellEditingStyle *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    return  UITableViewCellEditingStyleDelete;

}*/


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    DetailStatistiqueViewController * svcDetailStats =[self.storyboard instantiateViewControllerWithIdentifier:@"sceneDeatils"];
    
    svcDetailStats.strDureeDetailsStats = [NSString stringWithFormat:@"%@ sec",[_mydata objectAtIndex:indexPath.row][1]];

    svcDetailStats.strDistanceDetailsStats = [NSString stringWithFormat:@"%@ km",[_mydata objectAtIndex:indexPath.row][2]];

    svcDetailStats.strVitesseDetailsStats = [NSString stringWithFormat:@"%@ km/h",[_mydata objectAtIndex:indexPath.row][3]];

    svcDetailStats.strCaloriesDetailsStats = [NSString stringWithFormat:@"%@ kcal",[_mydata objectAtIndex:indexPath.row][4]];
    
    svcDetailStats.strDateDetailsStats = [_mydata objectAtIndex:indexPath.row][5];

    
    
    [self.navigationController pushViewController:svcDetailStats animated:YES];
    
    
}

-(NSString*) getDateFromPicker:(NSString*) dateSeance
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *formatedDateSeance = [dateFormatter dateFromString:dateSeance];
    NSLog(@"Seance de : %@",formatedDateSeance);
    NSString *formatedStringDateSeance = [dateFormatter stringFromDate:formatedDateSeance];
    
    return formatedStringDateSeance;
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

@end
