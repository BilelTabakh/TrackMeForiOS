//
//  MathController.h
//  TrackMe
//
//  Created by Trabelsi Achraf on 3/20/15.
//  Copyright (c) 2015 ESPRIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathController : NSObject


+ (NSString *) stringifyDistance:(float)meters;
+ (NSString *) stringifySecondCount:(int)seconds usingLongFormat:(BOOL)longFormat;
+ (NSString *) stringifyAvgPaceFromDist:(float)meters overTime:(int)seconds;


@end
