//
//  PlanningViewController.h
//  TrackMe
//
//  Created by Trabelsi Achraf on 2/19/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditEventViewController.h"


@interface PlanningViewController : UIViewController <EditEventViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tblEvents;


- (IBAction)showCalendars:(id)sender;

- (IBAction)createEvent:(id)sender;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButton;


@end
