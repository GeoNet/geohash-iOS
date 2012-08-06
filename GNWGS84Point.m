//
//  GNWGS84Point.m
//  GeoHashes
//
//  Created by AppTastic Technologies (www.apptastic.com.au) for GNS Science
//  Copyright (c) 2012 GNS Science. All rights reserved.
//


#import "GNWGS84Point.h"

@implementation GNWGS84Point

@synthesize latitude,longitude;

-(id) initWithLatitude:(double)lat andLongitude:(double)lon
{
    //Initialization of a certain point
    if (self = [super init])
    {
        self.latitude = lat;
        self.longitude = lon;
        
        if ((fabs(self.latitude) > 90) || (fabs(self.longitude) > 180)) 
        {
            [NSException raise:@"Invalid coordinates" format:@"The supplied coordinates %f,%f are out of range.", self.latitude,self.longitude];
        }
    }
    return self;
}

- (NSString*) description
{
    //Definition of string output for object
    return [NSString stringWithFormat:@"%f,%f",self.latitude,self.longitude];
}
@end
