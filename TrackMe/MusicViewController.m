//
//  MusicViewController.m
//  TrackMe
//
//  Created by Trabelsi Achraf on 4/9/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import "MusicViewController.h"

@interface MusicViewController ()

@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pause = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(playPausePressed:)];
    self.play = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playPausePressed:)];
    
    [self.pause setStyle:UIBarButtonItemStyleBordered];
    self.player = [MPMusicPlayerController iPodMusicPlayer];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(nowPlayingItemChanged:)
                               name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self.player];
    
    [self.player beginGeneratingPlaybackNotifications];
    [self.player beginGeneratingPlaybackNotifications];
    MPMusicPlaybackState playbackState = [self.player playbackState];
    if (playbackState == MPMusicPlaybackStatePlaying) {
        [self.pause setTintColor:[UIColor blackColor]];
        NSMutableArray *items = [NSMutableArray arrayWithArray:[self.toolbar items]];
        
        [items replaceObjectAtIndex:3 withObject:self.pause];
        [self.toolbar setItems:items animated:YES];
        
    }
    
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

- (IBAction)rewindPressed:(id)sender {
    if ([self.player indexOfNowPlayingItem] == 0) {
        [self.player skipToBeginning];
    } else {
        [self.player endSeeking];
        [self.player skipToPreviousItem];
    }
}

- (IBAction)playPausePressed:(id)sender {
    
    [self.pause setTintColor:[UIColor blackColor]];
    [self.play setTintColor:[UIColor blackColor]];
    MPMusicPlaybackState playbackState = [self.player playbackState];
    NSMutableArray *items = [NSMutableArray arrayWithArray:[self.toolbar items]];
    NSLog(@"%@",items);
    if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
        [self.player play];
        [items replaceObjectAtIndex:3 withObject:self.pause];
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        [self.player pause];
        [items replaceObjectAtIndex:3 withObject:self.play];
    }
    [self.toolbar setItems:items animated:NO];
}

- (IBAction)fastForwardPressed:(id)sender {
    
    NSUInteger nowPlayingIndex = [self.player indexOfNowPlayingItem];
    [self.player endSeeking];
    [self.player skipToNextItem];
    if ([self.player nowPlayingItem] == nil) {
        if ([self.collection count] > nowPlayingIndex+1) {
            // added more songs while playing
            [self.player setQueueWithItemCollection:self.collection];
            MPMediaItem *item = [[self.collection items] objectAtIndex:nowPlayingIndex+1];
            [self.player setNowPlayingItem:item];
            [self.player play];
        }
        else {
            // no more songs
            [self.player stop];
            NSMutableArray *items = [NSMutableArray arrayWithArray:[self.toolbar items]];
            [items replaceObjectAtIndex:3 withObject:self.play];
            [self.toolbar setItems:items];
        }
    }
    
}

- (IBAction)addPressed:(id)sender {
    MPMediaType mediaType = MPMediaTypeMusic;
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:mediaType];
    picker.delegate = self;
    [picker setAllowsPickingMultipleItems:YES];
    picker.prompt = NSLocalizedString(@"Select items to play", @"Select items to play");
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Media Picker Delegate Methods

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.collection == nil) {
        self.collection = mediaItemCollection;
        [self.player setQueueWithItemCollection:self.collection];
        MPMediaItem *item = [[self.collection items] objectAtIndex:0];
        [self.player setNowPlayingItem:item];
        [self playPausePressed:self];
    } else {
        NSArray *oldItems = [self.collection items];
        NSArray *newItems = [oldItems arrayByAddingObjectsFromArray:[mediaItemCollection items]];
        self.collection = [[MPMediaItemCollection alloc] initWithItems:newItems];
    }
}


- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Notification Methods

- (void)nowPlayingItemChanged:(NSNotification *)notification
{
    MPMediaItem *currentItem = [self.player nowPlayingItem];
    if (nil == currentItem) {
        [self.imageView setImage:nil];
        [self.imageView setHidden:YES];
        [self.artist setText:nil];
        [self.song setText:nil];
    }
    else {
        MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
        if (artwork) {
            UIImage *artworkImage = [artwork imageWithSize:CGSizeMake(320, 320)];
            [self.imageView setImage:artworkImage];
            [self.imageView setHidden:NO];
        }
        
        // Display the artist and song name for the now-playing media item
        NSString *artistStr = [currentItem valueForProperty:MPMediaItemPropertyArtist];
        NSString *albumStr = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        [self.artist setText:[NSString stringWithFormat:@"%@ — %@", artistStr,albumStr]];
        [self.song setText:[currentItem valueForProperty:MPMediaItemPropertyTitle]];
    }
}


@end
