//
//  SampleSheetViewController.m
//  NAModalSheet
//
//  Created by Ken Worley on 11/22/13.
//  Copyright (c) 2013 Ken Worley. All rights reserved.
//

#import "SampleSheetViewController.h"
#import "NAModalSheet.h"


@interface SampleSheetViewController ()
{
  __weak IBOutlet UISwitch *sizeSwitch;
  __weak IBOutlet UILabel *sizeLabel;
}
@end

@implementation SampleSheetViewController

- (instancetype)init
{
  self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
  if (self)
  {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  if (self.opaque)
  {
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
  }
   
}

- (void)viewDidLayoutSubviews
{
  CGRect f = sizeLabel.frame;
  f.origin.x = CGRectGetMaxX(sizeSwitch.frame) + 8.0;
  sizeLabel.frame = f;
}

- (IBAction)dismissButtonTouched:(id)sender
{
  [self.modalSheet dismissWithCompletion:^{
    
  }];
}


- (IBAction)facebookShareBtn:(id)sender {
    //Call Method ShareOnFacebook From SeanceViewController
    SeanceViewController *seanceViewController = [[SeanceViewController alloc] init];
    [seanceViewController ShareOnFacebook];
  
}


- (IBAction)twitterShareBtn:(id)sender {
    //Call Method ShareOnTwitter From SeanceViewController
    SeanceViewController *seanceViewController = [[SeanceViewController alloc] init];
    [seanceViewController ShareOnTwitter];
}















@end
