//
//  GNWGS84Point.m
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
