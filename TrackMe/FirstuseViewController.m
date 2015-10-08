//
//  FirstuseViewController.m
//  TrackMe
//
//  Created by Trabelsi Achraf on 2/23/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import "FirstuseViewController.h"
#import "ViewController.h"
#import "SWRevealViewController.h"

@interface FirstuseViewController ()

@end

@implementation FirstuseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Title Of ViewController
    self.navigationItem.title = @"Welcome";
    
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

- (IBAction)backgroundTapFirstUse:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)suivantButton:(id)sender {
    
    int tailleTextfieldNumber = [[_tailleTextField text] intValue];
    int poidsTextfieldNumber = [[_poidsTextField text] intValue];
    
    if((tailleTextfieldNumber == 0) || (poidsTextfieldNumber ==0)){
        //Show Alert
        UIAlertView *alertSuivant = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Empty value detected !" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertSuivant show];
    
    }
    else{
        //Calcule IMC
        
        double tailleCalc1 = (double)tailleTextfieldNumber/100;
        double tailleCalc2 = tailleCalc1*tailleCalc1;
        double imc = poidsTextfieldNumber/tailleCalc2;
        imc = (double)((int)(imc*100))/100;
        
        //Interpretations IMC
        if(imc<10 || imc >50){
            //Show Alert
            UIAlertView *alertSuivant = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong input, please check your values" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertSuivant show];
        }
        else{
        
        //Save Data : Taille et Poids
        //Récuperation
        NSString *saveTaille = _tailleTextField.text;
        NSString *savePoids = _poidsTextField.text;
        //Déclaration NSUserDefaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //Sauvegarde des données : taille et poids
        [defaults setObject:saveTaille forKey:@"saveTaille"];
        [defaults setObject:savePoids forKey:@"savePoids"];
        [defaults synchronize];
        //Navigation vers HomeViewController
         SWRevealViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeview"];
        [self presentViewController:homeViewController animated:NO completion:nil];
        }
    
    }
    

    
}
@end
