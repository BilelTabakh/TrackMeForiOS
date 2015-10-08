//
//  EditEventViewController.m
//  EventKitDemo
//
//  Created by Gabriel Theodoropoulos on 11/7/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "EditEventViewController.h"
#import "AppDelegate.h"

@interface EditEventViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, strong) NSString *eventTitle;

@property (nonatomic, strong) NSDate *eventStartDate;

@property (nonatomic, strong) NSDate *eventEndDate;

@property (nonatomic, strong) EKEvent *editedEvent;

@property (nonatomic, strong) NSMutableArray *arrAlarms;

@property (nonatomic, strong) NSArray *arrRepeatOptions;

@property (nonatomic) NSUInteger indexOfSelectedRepeatOption;

@property(nonatomic) int count;

@property(strong,nonatomic) EKCalendar *trackMeCalendar;

-(void)determineIndexOfRepeatOption;

@end


@implementation EditEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.count = 0;
    
    // Title Of ViewController
    self.navigationItem.title = @"Ajouter un planning";
    
    
    // Instantiate the appDelegate property, so we can access its eventManager property.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Make self the delegate and datasource of the table view.
    self.tblEvent.delegate = self;
    self.tblEvent.dataSource = self;
    
    
    // Set initial values.
    self.eventStartDate = nil;
    self.eventEndDate = nil;
    self.arrAlarms = [[NSMutableArray alloc] init];
    
    
    // Initialize the repeat options array.
    self.arrRepeatOptions = @[@"Jamais", @"Toujours", @"Chaque 3 jours", @"Chaque semaine", @"Chaque 2 semaines", @"Chaque mois", @"Chaque six mois", @"Chaque année"];
    
    self.indexOfSelectedRepeatOption = 0;
    
    
    // Check the value of the selectedEventIdentifier property, of the eventManager object.
    // If its length is 0, then a new event is going to be added.
    // If its length is other than 0, then an existing event is going to be edited. In that case, load the event.
    if (self.appDelegate.eventManager.selectedEventIdentifier.length > 0) {
        self.editedEvent = [self.appDelegate.eventManager.eventStore eventWithIdentifier:self.appDelegate.eventManager.selectedEventIdentifier];
        
        self.eventTitle = self.editedEvent.title;
        self.eventStartDate = self.editedEvent.startDate;
        self.eventEndDate = self.editedEvent.endDate;
        
        
        // Determine the index of the repeat option based on the recurrence rule of the edited event.
        [self determineIndexOfRepeatOption];
        
        
        // If there are alarms, then keep the absolute date of each one.
        if (self.editedEvent.hasAlarms) {
            NSArray *alarms = self.editedEvent.alarms;
            for (int i=0; i<alarms.count; i++) {
                [self.arrAlarms addObject:[(EKAlarm *)[alarms objectAtIndex:i] absoluteDate]];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"idSegueDatepicker"]) {
        DatePickerViewController *datePickerViewController = [segue destinationViewController];
        datePickerViewController.delegate = self;
    }
}


#pragma mark - UITableView Delegate and Datasource method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    else{
       return self.arrRepeatOptions.count;
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Informations Planning";
    }
    else{
        return @"Répétition";
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        // If the cell is nil, then dequeue it. Make sure to dequeue the proper cell based on the row.
        if (cell == nil) {
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"idCellTitle"];
            }
            else{
                cell = [tableView dequeueReusableCellWithIdentifier:@"idCellGeneral"];
            }
        }
        
        
        switch (indexPath.row) {
            case 0:
                // The title of the event.
            {
                UITextField *titleTextfield = (UITextField *)[cell.contentView viewWithTag:10];
                titleTextfield.delegate = self;
                titleTextfield.text = self.eventTitle;
            }
                break;
                
            case 1:
                // The event start date.
                if (self.eventStartDate == nil) {
                    cell.textLabel.text = @"Select begin date...";
                }
                else{
                    cell.textLabel.text = [self.appDelegate.eventManager getStringFromDate:self.eventStartDate];
                }
                break;
                
            case 2:
                // The event end date.
                if (self.eventEndDate == nil) {
                    cell.textLabel.text = @"Select end date...";
                }
                else{
                    cell.textLabel.text = [self.appDelegate.eventManager getStringFromDate:self.eventEndDate];
                }
                break;
                
            default:
                break;
        }
    }

    else{
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"idCellGeneral"];
        }
        
        // The section with the repeat options.
        cell.textLabel.text = [self.arrRepeatOptions objectAtIndex:indexPath.row];
        
        if (indexPath.row == self.indexOfSelectedRepeatOption) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 0 && (indexPath.row == 1 || indexPath.row == 2)) ||
        (indexPath.section == 1 && indexPath.row == 0)) {
        [self performSegueWithIdentifier:@"idSegueDatepicker" sender:self];
    }
    
    if (indexPath.section == 1) {
        self.indexOfSelectedRepeatOption = indexPath.row;
        
        [self.tblEvent reloadData];
    }
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row > 0) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // Remove the respective date from the arrAlarms array.
            [self.arrAlarms removeObjectAtIndex:indexPath.row - 1];
            
            // Reload the table view.
            [self.tblEvent reloadData];
        }
    }
}


#pragma mark - IBAction method implementation

- (IBAction)saveEvent:(id)sender {
    
    //Declaration Of Alert
    UIAlertView *alertDateVerification = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The begin date must be before the end date !" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    UIAlertView *alertDescriptionVerification = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The description field is empty !" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    UIAlertView *alerEmptyDateVerification = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The begin date or the end date is not selected!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    
    // Check if a title was typed in for the event.
    if (self.eventTitle.length == 0) {
        // In this case, just do nothing.
        [alertDescriptionVerification show];
        return;
    }
    
    // Check if a start and an end date was selected for the event.
    if (self.eventStartDate == nil || self.eventEndDate == nil) {
        // In this case, do nothing too.
        [alerEmptyDateVerification show];
        return;
    }
    
    if (self.appDelegate.eventManager.selectedEventIdentifier.length > 0) {
        [self.appDelegate.eventManager deleteEventWithIdentifier:self.appDelegate.eventManager.selectedEventIdentifier];
        self.appDelegate.eventManager.selectedEventIdentifier = @"";
    }
    
    // Create a new event object.
   // EKEvent *event = nil;
    
    // Set the event title.
    //self.event.title = self.eventTitle;
    
    //Set The Default Calendar
    EKEventStore *eventstore = [[EKEventStore alloc] init];
    if([eventstore respondsToSelector:@selector(requestAccessToEntityType:completion:)]){
        //iOS 6 and Later
        [eventstore requestAccessToEntityType:EKEntityMaskEvent completion:^(BOOL granted, NSError *error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(granted){
                    //Code here when the user allows your app to access the calendar
                    //EKEvent *event = [EKEvent eventWithEventStore:eventstore];
                    EKEvent *event = [EKEvent eventWithEventStore:self.appDelegate.eventManager.eventStore];
                    event.title = self.eventTitle;
                    
                    //Load Count
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSString *countNSStringReceive = [defaults objectForKey:@"count"];
                    self.count = [countNSStringReceive intValue];
                    
                    
                    if(self.count == 0){
                        
                    //Create Calendar
                    self.trackMeCalendar  = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:eventstore];
                    [self.trackMeCalendar setTitle:@"TrackMeCalendar"];
                    NSString *calendarIdentifier = [self.trackMeCalendar calendarIdentifier];
                    
                        
                    // Find the proper source type value.
                    for (int i=0; i<self.appDelegate.eventManager.eventStore.sources.count; i++) {
                        EKSource *source = (EKSource *)[self.appDelegate.eventManager.eventStore.sources objectAtIndex:i];
                        EKSourceType currentSourceType = source.sourceType;
                        
                        if (currentSourceType == EKSourceTypeLocal) {
                            self.trackMeCalendar.source = source;
                            break;
                        }
                    }
    
                    // Save and commit the calendar.
                    NSError *errorCalendar;
                    BOOL saved = [eventstore saveCalendar:self.trackMeCalendar commit:YES error:&errorCalendar];
                        if(saved){
                            [[NSUserDefaults standardUserDefaults] setObject:calendarIdentifier forKey:@"my_calendar_identifier"];
                        }
                        
                    if (error == nil) {
                        // Store the calendar identifier.
                        [self.appDelegate.eventManager saveCustomCalendarIdentifier:self.trackMeCalendar.calendarIdentifier];
                    }
                       //Increment Count and Save it
                        self.count ++ ;
                        NSString *countNSString = [NSString stringWithFormat:@"%d",self.count];
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:countNSString forKey:@"count"];
                        [defaults synchronize];
                    }
                    
                   
                    //Add Event To Calendar
                    //[event setCalendar:self.trackMeCalendar];//Code DefaultCalendar
                    event.calendar = [eventstore calendarWithIdentifier:[defaults objectForKey:@"my_calendar_identifier"]];
                    
                    // Set the start and end dates to the event
                    event.startDate = self.eventStartDate;
                    event.endDate = self.eventEndDate;
                    
                    //Verification If The start date must be before the end date.
                    if([self.eventStartDate compare:self.eventEndDate]== NSOrderedDescending){
                        [alertDateVerification show];
                    }
                    
                    // Add Alarm .
                    NSDate *alarmDate = event.startDate;
                    EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:alarmDate];
                    [event addAlarm:alarm];
                    
                    
                    // Specify the recurrence frequency and interval values based on the respective selected option.
                    EKRecurrenceFrequency frequency;
                    NSInteger interval;
                    switch (self.indexOfSelectedRepeatOption) {
                        case 1:
                            frequency = EKRecurrenceFrequencyDaily;
                            interval = 1;
                            break;
                        case 2:
                            frequency = EKRecurrenceFrequencyDaily;
                            interval = 3;
                        case 3:
                            frequency = EKRecurrenceFrequencyWeekly;
                            interval = 1;
                        case 4:
                            frequency = EKRecurrenceFrequencyWeekly;
                            interval = 2;
                        case 5:
                            frequency = EKRecurrenceFrequencyMonthly;
                            interval = 1;
                        case 6:
                            frequency = EKRecurrenceFrequencyMonthly;
                            interval = 6;
                        case 7:
                            frequency = EKRecurrenceFrequencyYearly;
                            interval = 1;
                            
                        default:
                            interval = 0;
                            frequency = EKRecurrenceFrequencyDaily;
                            break;
                            
                    }
                    
                    // Create a rule and assign it to the reminder object if the interval is greater than 0.
                    if (interval > 0) {
                        EKRecurrenceEnd *recurrenceEnd = [EKRecurrenceEnd recurrenceEndWithEndDate:event.endDate];
                        EKRecurrenceRule *rule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:frequency interval:interval end:recurrenceEnd];
                        event.recurrenceRules = @[rule];
                    }
                    else{
                        event.recurrenceRules = nil;
                    }
                    
                    // Save and commit the event.
                    NSError *error;
                    if ([self.appDelegate.eventManager.eventStore saveEvent:event span:EKSpanFutureEvents commit:YES error:&error]) {
                        // Call the delegate method to notify the caller class (the ViewController class) that the event was saved.
                        [self.delegate eventWasSuccessfullySaved];
                        
                        // Pop the current view controller from the navigation stack.
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else{
                        // An error occurred, so log the error description.
                        NSLog(@"%@", [error localizedDescription]);
                    }

                    
                }else{
                    //Code here for when the user does not allow your app to access the calendar
                    UIAlertView *alertDontAllowAccess = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please autorize the calendar access and try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alertDontAllowAccess show];
                }
            });
            
        }];
        
        
    }
    
    
}


#pragma mark - UITextFieldDelegate method implementation

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.eventTitle = textField.text;
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - DatePickerViewControllerDelegate method implementation

-(void)dateWasSelected:(NSDate *)selectedDate{
    // Based on the selected cell, specify what the selected date is purposed for.
    NSIndexPath *indexPath = [self.tblEvent indexPathForSelectedRow];
    
    if (indexPath.section == 0) {
        // In this case, it's either the event start or end date.
        if (indexPath.row == 1) {
            // The event start date.
            self.eventStartDate = selectedDate;
        }
        else{
            // The event end date.
            self.eventEndDate = selectedDate;
        }
    }
    else{
        // In this case, the selected date regards a new alarm.
        [self.arrAlarms addObject:selectedDate];
    }
    
    // Reload the table view.
    [self.tblEvent reloadData];
}


#pragma mark - Private method implementation

-(void)determineIndexOfRepeatOption{
    if (self.editedEvent.recurrenceRules != nil && self.editedEvent.recurrenceRules.count > 0) {
        // Get the frequency and interval values from the recurrence rule of the edited event.
        EKRecurrenceRule *rule = [self.editedEvent.recurrenceRules objectAtIndex:0];
        
        EKRecurrenceFrequency frequency = rule.frequency;
        NSInteger interval = rule.interval;
        
        if (interval == 1){
            if (frequency == EKRecurrenceFrequencyDaily) {
                self.indexOfSelectedRepeatOption = 1;
            }
            else if (frequency == EKRecurrenceFrequencyWeekly){
                self.indexOfSelectedRepeatOption = 3;
            }
            else if (frequency == EKRecurrenceFrequencyMonthly){
                self.indexOfSelectedRepeatOption = 5;
            }
            else{
                self.indexOfSelectedRepeatOption = 7;
            }
        }
        else{
            if (frequency == EKRecurrenceFrequencyDaily) {
                self.indexOfSelectedRepeatOption = 2;
            }
            else if (frequency == EKRecurrenceFrequencyWeekly){
                self.indexOfSelectedRepeatOption = 4;
            }
            else{
                self.indexOfSelectedRepeatOption = 6;
            }
        }
    }
}

@end
