//
//  GNProximity.m
//  GeoNetQuakeIB
//
//  Created by Patrick Dockhorn on 17/04/12.
//  Copyright (c) 2012 KJEW Investments Pty Ltd t/as AppTastic. All rights reserved.
//

// ported from Proximity.java and LocalityUtil.java

#import "GNProximity.h"
#import "GNLocation.h"

@implementation GNProximity

@synthesize distance,bearing,localityName;

-(id)init
{
    return [self initWithDistance:0.0 andBearing:0.0 andLocalityName:nil];
}

-(id)initWithDistance:(float)dist andBearing:(float)bear andLocalityName:(NSString*)locName
{
    if (self = [super init])
    {
        self.distance = dist;
        self.bearing = bear;
        self.localityName = locName;
    }
    return self;
}

/**
 * Convert distance in m to integer 5 km.
 *
 * @param distance distance in m
 * @return distance in km to the nearest 5 km.
 */

+(int) metersToIntFiveKm:(float)distance
{
    return round(distance / 5000) * 5;
}

/**
 * The compass bearing.
 *
 * @param bearing bearing in degrees east of north.  Negative values west of north as acceptable,
 * @return a string describing the compass direction e.g., 'north'.
 */

+(NSString*)compassAzimuthForBearing:(float)inbearing
{
    float bearing = inbearing;
    
    if (bearing < 0.0) 
    {
        bearing = bearing + 360.0;
    }
    
    NSString *compassBearing = nil;
    
    if ((bearing >= 337.5) && (bearing <= 360)) {
        compassBearing = @"north";
    } else if ((bearing >= 0) && (bearing <= 22.5)) {
        compassBearing = @"north";
    } else if ((bearing > 22.5) && (bearing < 67.5)) {
        compassBearing = @"north-east";
    } else if ((bearing >= 67.5) && (bearing <= 112.5)) {
        compassBearing = @"east";
    } else if ((bearing > 112.5) && (bearing < 157.5)) {
        compassBearing = @"south-east";
    } else if ((bearing >= 157.5) && (bearing <= 202.5)) {
        compassBearing = @"south";
    } else if ((bearing > 202.5) && (bearing < 247.5)) {
        compassBearing = @"south-west";
    } else if ((bearing >= 247.5) && (bearing <= 292.5)) {
        compassBearing = @"west";
    } else if ((bearing > 292.5) && (bearing < 337.5)) {
        compassBearing = @"north-west";
    } else {
        compassBearing = @"";
    }
    
    return compassBearing;
}

/**
 * Locality string suitable for display.
 *
 * @param distance in m
 * @param bearing  in degrees east of north.  Negative values for west of north are acceptable.
 * @param locality the name of the locality.
 * @return locality string for display.
 */

-(NSString*) localityString
{
    NSString *locs = nil;
    
    int distKm = [GNProximity metersToIntFiveKm:self.distance];
    
    NSString *compassBearing = [GNProximity compassAzimuthForBearing:self.bearing];
    
    if (distKm == 0) {
        locs = [NSString stringWithFormat:@"Within 5 km of %@",self.localityName];
    } else {
        locs = [NSString stringWithFormat:@"%d km %@ of %@",distKm,compassBearing,self.localityName];
    }
    
    return locs;
}


@end
