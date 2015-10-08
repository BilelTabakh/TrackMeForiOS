//
//  StatistiquesViewController.h
//  TrackMe
//
//  Created by Trabelsi Achraf on 2/19/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface ListeStatistiquesViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButton;

@property (strong, nonatomic) NSArray *mydata;

@property (strong, nonatomic) DBManager *DB;

@property (weak, nonatomic) IBOutlet UITableView *tab;

-(void)loaddata;




@end
