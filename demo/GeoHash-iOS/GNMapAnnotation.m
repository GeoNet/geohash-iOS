//
//  GNMapAnnotation.m
//  GeoHashes
//
//  Created by AppTastic Technologies (www.apptastic.com.au) for GNS Science
//  Copyright (c) 2012 GNS Science. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
//

#import "GNMapAnnotation.h"
#import "GNGeoHash.h"

@implementation GNMapAnnotation

@synthesize theTitle,theSubTitle,theCoordinate,pointPrecision,areaPrecision,url,mapView,poly;

-(id) initWithPointPrecision:(int)pointPrec andAreaPrecision:(int)areaPrec andMapView:(MKMapView*) theMapView
{
    //Initialization
    if (self = [super init])
    {
        self.pointPrecision = pointPrec;
        self.areaPrecision = areaPrec;
        self.mapView = theMapView;
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
    GNGeoHash *pointGH = [GNGeoHash withCharacterPrecision:newCoordinate.latitude andLongitude:newCoordinate.longitude andNumberOfCharacters:self.pointPrecision];
    
    //Set annotation properties
    self.theTitle = [NSString stringWithFormat:@"%@",pointGH.point];
    self.theSubTitle = [NSString stringWithFormat:@"GeoHash: %@",[pointGH toBase32]];
    self.theCoordinate = newCoordinate;
    
    //Set new URL
    NSString* hashString = [pointGH toBase32];
    self.url = [NSString stringWithFormat:@"http://geohash.org/%@",hashString];
    NSLog(@"%@ -> %@",pointGH.point, hashString);
    
    //Update area
    if ([[mapView overlays] count] > 0 ) {
        [mapView removeOverlay:poly];
    }
    
    GNGeoHash *areaGH = [GNGeoHash withCharacterPrecision:newCoordinate.latitude andLongitude:newCoordinate.longitude andNumberOfCharacters:areaPrecision];
    
    CLLocationCoordinate2D  points[4];
    
    points[0] = CLLocationCoordinate2DMake(areaGH.boundingBox.minLat, areaGH.boundingBox.minLon);
    points[1] = CLLocationCoordinate2DMake(areaGH.boundingBox.minLat, areaGH.boundingBox.maxLon);
    points[2] = CLLocationCoordinate2DMake(areaGH.boundingBox.maxLat, areaGH.boundingBox.maxLon);
    points[3] = CLLocationCoordinate2DMake(areaGH.boundingBox.maxLat, areaGH.boundingBox.minLon);
    
    poly = [MKPolygon polygonWithCoordinates:points count:4];
    poly.title = @"Area";
    
    [mapView addOverlay:poly];
}

@end
