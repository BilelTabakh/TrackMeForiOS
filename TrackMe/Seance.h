//
//  Seance.h
//  TrackMe
//
//  Created by Trabelsi Achraf on 3/17/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Seance : NSObject

@property NSString *duree;
@property NSString *distance;
@property NSString *vitesse;
@property NSString *calories;
@property NSString *dateSeance;

-(Seance *)initwithDuree:(NSString *)duree withDistance:(NSString *)distance andVitesse:(NSString *)vitesse andCalories:(NSString *)calories andDateseance:(NSString *)dateseance;


@end
