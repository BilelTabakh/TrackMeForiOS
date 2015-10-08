//
//  MathController.m
//  TrackMe
//
//  Created by Trabelsi Achraf on 3/20/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import "MathController.h"


static bool const isMetric = YES;
static float const metersInKM = 1000;
static float const metersInMile = 1609.344;

@implementation MathController


+ (NSString *) stringifyDistance:(float)meters
{
    float unitDivider;
    NSString *unitName;
    
    //metric
    if(isMetric){
        unitName = @"";
        //to get from meters to kilometers divide by this
        unitDivider = metersInKM;
        //U.S
    }else{
        unitName = @"mi";
        //to get from meters to miles divide by this
        unitDivider = metersInMile;
    }
    return [NSString stringWithFormat:@"%.2f %@",(meters/unitDivider),unitName];
}


+ (NSString *) stringifySecondCount:(int)seconds usingLongFormat:(BOOL)longFormat{

    int remainingSeconds = seconds;
    //Get Hours
    int hours = remainingSeconds / 3600;
    remainingSeconds = remainingSeconds - hours * 3600;
    //Get Minutes
    int minutes  = remainingSeconds / 60;
    remainingSeconds = remainingSeconds - minutes * 60;

    if(longFormat){
        if(hours > 0){
            return [NSString stringWithFormat:@"%i %i %i",hours,minutes,remainingSeconds];
        }else if(minutes > 0){
            return  [NSString stringWithFormat:@"%i %i",minutes,remainingSeconds];
        }else {
            return  [NSString stringWithFormat:@"%i",remainingSeconds];
        }
    }else {
        if(hours > 0){
            return [NSString stringWithFormat:@"%02i:%02i:%02i",hours,minutes,remainingSeconds];
        }else if(minutes > 0){
            return [NSString stringWithFormat:@"%02i:%02i",minutes,remainingSeconds];
        }else {
            return [NSString stringWithFormat:@"00:%02i",remainingSeconds];
        }
    
    }
}


+ (NSString *)stringifyAvgPaceFromDist:(float)meters overTime:(int)seconds
{
    if(seconds == 0 || meters ==0){
        return @"0";
    }

    float avgPaceSecMeters = seconds / meters;

    float unitMultiplier;
    NSString *unitName;
    
    //metric
    if(isMetric){
        unitName = @"min/km";
        unitMultiplier  = metersInKM;
    //U.S
    }else {
        unitName = @"min/mi";
        unitMultiplier = metersInMile;
    }
    
    
    int paceMin = (int) ((avgPaceSecMeters * unitMultiplier)/60);
    int paceSec = (int) (avgPaceSecMeters * unitMultiplier - (paceMin*60));
    
    
    //return [NSString stringWithFormat:@"%i:%02i",paceMin,paceSec];
    return [NSString stringWithFormat:@"%i:%02i",paceMin,paceSec];
}

@end
