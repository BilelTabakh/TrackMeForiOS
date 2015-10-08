//
//  MesInfosViewController.m
//  TrackMe
//
//  Created by Trabelsi Achraf on 2/24/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import "MesInfosViewController.h"
#import "SWRevealViewController.h"

@interface MesInfosViewController ()

@end

@implementation MesInfosViewController

bool imcOk = NO;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Title Of ViewController
    self.navigationItem.title = @"My Infos";
   
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    //Load Data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *loadTaille = [defaults objectForKey:@"saveTaille"];
    NSString *loadPoids = [defaults objectForKey:@"savePoids"];
    
    [_tailleInfoTextField setText:loadTaille];
    [_poidsInfoTextField setText:loadPoids];
    
    
    //Calcule IMC
    int taille = [loadTaille intValue];
    int poids =  [loadPoids intValue];
    
    double tailleCalc1 = (double)taille/100;
    double tailleCalc2 = tailleCalc1*tailleCalc1;
    double imc = poids/tailleCalc2;
    imc = (double)((int)(imc*100))/100;
    
    //Interpretations IMC
    if(imc<10 || imc >50){
        //Show Alert
        UIAlertView *alertSuivant = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong input, please check your values" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertSuivant show];
    }
    else if(imc<=15)
    {
        _txtInterpretation.text = @"Famine";
    
    }else if(imc<=18.5 && imc>15){
        _txtInterpretation.text = @"UnderWeight";
            }else if(imc<=25 && imc>18.5){
        _txtInterpretation.text = @"Ideal Weight";
      
    }else if(imc<=30 && imc>25){
        _txtInterpretation.text = @"Overweight";
        
    }else if(imc<=35 && imc>30){
        _txtInterpretation.text = @"Moderate Obesity";
      
    }else if(imc<=40 && imc>35){
        _txtInterpretation.text = @"Severe Obesity";
        
    }else{_txtInterpretation.text = @"Morbid Obesity";
        
    }
    _imcInfoTextField.text = [NSString stringWithFormat:@"%.2 f", imc];
    
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

- (IBAction)tapBackgroundMesinfos:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)modifierButton:(id)sender {
    
    int tailleTextfieldNumber = [[_tailleInfoTextField text] intValue];
    int poidsTextfieldNumber = [[_poidsInfoTextField text] intValue];
    
    if((tailleTextfieldNumber == 0) || (poidsTextfieldNumber ==0)){
        //Show Alert
        UIAlertView *alertSuivant = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Empty value detected !" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertSuivant show];
    }
    else{
      
        //Save Data : Taille et Poids
        NSString *saveTailleInfo = _tailleInfoTextField.text;
        NSString *savePoidsInfo = _poidsInfoTextField.text;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        
        //Calcule IMC
        int taille = [saveTailleInfo intValue];
        int poids =  [savePoidsInfo intValue];
        
        double tailleCalc1 = (double)taille/100;
        double tailleCalc2 = tailleCalc1*tailleCalc1;
        double imc = poids/tailleCalc2;
        imc = (double)((int)(imc*100))/100;
        
        
        //Interpretations IMC
        if(imc<10 || imc >50){
            //Show Alert
            UIAlertView *alertSuivant = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong input, please check your values" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertSuivant show];
        }
        else if(imc<=15)
        {
        _txtInterpretation.text = @"Famine";
            imcOk = YES;
        }else if(imc<=18.5 && imc>15){
        _txtInterpretation.text = @"UnderWeight";
            imcOk = YES;
        }else if(imc<=25 && imc>18.5){
            _txtInterpretation.text = @"Ideal Weight";
            imcOk = YES;
        }else if(imc<=30 && imc>25){
            _txtInterpretation.text = @"Overweight";
            imcOk = YES;
        }else if(imc<=35 && imc>30){
            _txtInterpretation.text = @"Moderate Obesity";
            imcOk = YES;
        }else if(imc<=40 && imc>35){
            _txtInterpretation.text = @"Severe Obesity";
            imcOk = YES;
        }else{_txtInterpretation.text = @"Morbid Obesity";
        imcOk = YES;}
        
        if(imcOk){
        //Affichage IMC
        //NSLog(@"imc:%.2lf",imc);
        [_imcInfoTextField setText:[NSString stringWithFormat:@"%.2lf",imc]];
        
            //Save values
            [defaults setObject:saveTailleInfo forKey:@"saveTaille"];
            [defaults setObject:savePoidsInfo forKey:@"savePoids"];
            [defaults synchronize];
            
            //Show Alert
            UIAlertView *alertModifier = [[UIAlertView alloc] initWithTitle:@"Modified" message:@"Your new data will be applied in the next run" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertModifier show];
            imcOk = NO;
        }
    }
    
}
@end
