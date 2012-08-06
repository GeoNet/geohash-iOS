//
//  GNMapAnnotation.m
//  GeoHashes
//
//  Created by AppTastic Technologies (www.apptastic.com.au) for GNS Science
//  Copyright (c) 2012 GNS Science. All rights reserved.
//

#import "GNMapAnnotation.h"
#import "GNGeoHash.h"

@implementation GNMapAnnotation

@synthesize theTitle,theSubTitle,theCoordinate,precision,url;

-(id) initWithPrecision:(int)prec
{
    //Initialization
    if (self = [super init])
    {
        self.precision = prec;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate;
{
    return self.theCoordinate;
}

- (NSString *)title
{
    return self.theTitle;
}

- (NSString *)subtitle
{
    return self.theSubTitle;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    double lat = newCoordinate.latitude;
    double lon = newCoordinate.longitude;
    
    //Round to geohash.org precision for comparison
    lat = (round(lat * 1000000))/1000000;
    lon = (round(lon * 1000000))/1000000;

    newCoordinate.latitude = lat;
    newCoordinate.longitude = lon;
    
    //Initialize GeoHash
    GNGeoHash *gh = [GNGeoHash withCharacterPrecision:newCoordinate.latitude andLongitude:newCoordinate.longitude andNumberOfCharacters:self.precision];
    
    //Set annotation properties
    self.theTitle = [NSString stringWithFormat:@"%@",gh.point];
    self.theSubTitle = [NSString stringWithFormat:@"GeoHash: %@",[gh toBase32]];
    self.theCoordinate = newCoordinate;
    
    NSString* hashString = [gh toBase32];
    self.url = [NSString stringWithFormat:@"http://geohash.org/%@",hashString];
    NSLog(@"%@ -> %@",gh.point, hashString);
}

@end
