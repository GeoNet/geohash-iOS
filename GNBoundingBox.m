//
//  GNBoundingBox.m
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

#import "GNBoundingBox.h"


@implementation GNBoundingBox

@synthesize serialVersionUID,maxLat,maxLon,minLat,minLon;

/**
 * create a bounding box defined by two coordinates
 */
- (id) initWithP1:(GNWGS84Point*) p1 andP2:(GNWGS84Point*) p2 
{
    //Initialization of an area based on two points
    return [self initWithY1:p1.latitude andY2:p2.latitude andX1:p1.longitude andX2:p2.longitude];
}

- (id) initWithY1:(double)y1 andY2:(double)y2 andX1:(double)x1 andX2:(double)x2
{
    //Initialization of an area based on x/y coordinates
    if (self = [super init])
    {
        self.minLon = fmin(x1, x2);
        self.maxLon = fmax(x1, x2);
        self.minLat = fmin(y1, y2);
        self.maxLat = fmax(y1, y2);
    }
    return self;
}

- (NSString*) description 
{
    //Definition of string output for object
    return [NSString stringWithFormat:@"%@ -> %@",[self getUpperLeft],[self getLowerRight]];
}

- (GNWGS84Point*) getUpperLeft
{
    //Returns the upper left point of the area
    return [[GNWGS84Point alloc] initWithLatitude:self.maxLat andLongitude:self.minLon];
}

- (GNWGS84Point*) getLowerRight
{
    //Returns the lower right point of the area
    return [[GNWGS84Point alloc] initWithLatitude:self.minLat andLongitude:self.maxLon];
}
@end
