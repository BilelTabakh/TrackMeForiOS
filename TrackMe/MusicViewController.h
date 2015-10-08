//
//  MusicViewController.h
//  TrackMe
//
//  Created by Trabelsi Achraf on 4/9/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MusicViewController : UIViewController<MPMediaPickerControllerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *song;
@property (weak, nonatomic) IBOutlet UILabel *artist;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) MPMusicPlayerController *player;
@property (strong, nonatomic) MPMediaItemCollection *collection;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic)          UIBarButtonItem *pause;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *play;
- (IBAction)rewindPressed:(id)sender;
- (IBAction)playPausePressed:(id)sender;
- (IBAction)fastForwardPressed:(id)sender;
- (IBAction)addPressed:(id)sender;


- (void)nowPlayingItemChanged:(NSNotification *)notification;

@end
