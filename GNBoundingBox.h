//
//  GNBoundingBox.h
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

/**
 * GNBoundingBox encapsulates areas on the earths surface represented by two point that are maximum Latitude/Longitude and minimum Latitude/Longitude.<br>
 * Coordinate projections might end up using this class...
 */

#import <Foundation/Foundation.h>
#import "GNWGS84Point.h"

@interface GNBoundingBox : NSObject

@property(assign)long serialVersionUID;
@property(assign)double maxLat;
@property(assign)double maxLon;
@property(assign)double minLat;
@property(assign)double minLon;

- (id) initWithY1:(double)y1 andY2:(double)y2 andX1:(double)x1 andX2:(double)x2;
- (id) initWithP1:(GNWGS84Point*) p1 andP2:(GNWGS84Point*) p2;

- (GNWGS84Point*) getUpperLeft;
- (GNWGS84Point*) getLowerRight;
@end
