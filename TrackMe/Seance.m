//
//  Seance.m
//  TrackMe
//
//  Created by Trabelsi Achraf on 3/17/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import "Seance.h"

@implementation Seance

-(Seance *)initwithDuree:(NSString *)duree withDistance:(NSString *)distance andVitesse:(NSString *)vitesse andCalories:(NSString *)calories andDateseance:(NSString *)dateseance{

    self.duree = duree;
    self.distance = distance;
    self.vitesse = vitesse;
    self.calories = calories;
    self.dateSeance = dateseance;
    return self;
}

@end
