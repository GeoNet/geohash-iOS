//
//  GNWGS84Point.h
//  GeoHashes
//
//  Created by AppTastic Technologies (www.apptastic.com.au) for GNS Science
//  Copyright (c) 2012 GNS Science. All rights reserved.
//

/**
 * GNWGS84Point encapsulates coordinates on the earths surface.<br>
 * Coordinate projections might end up using this class...
 */

#import <Foundation/Foundation.h>

@interface GNWGS84Point : NSObject

@property(assign) double latitude;
@property(assign) double longitude;

-(id) initWithLatitude:(double)lat andLongitude:(double)lon;

@end
