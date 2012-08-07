//
//  GNGeoHash.h
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

#import <Foundation/Foundation.h>
#import "GNWGS84Point.h"
#import "GNBoundingBox.h"

#define BASE32_BITS 5

@interface GNGeoHash : NSObject

@property(strong)NSMutableArray *BITS; 
@property(assign)long long FIRST_BIT_FLAGGED;
@property(strong)NSString *base32;
@property(strong)NSDictionary *decodeMap;
@property(assign)long long bits;
@property(assign)Byte significantBits;
@property(strong)GNWGS84Point *point;
@property(strong)GNBoundingBox *boundingBox;

-(id) initWithLatitude:(double)lat andLongitude:(double)lon andPrecision:(int)precision;
- (NSString*) toBase32;
+ (long long) unsignedRightShiftWith:(long long) number andDigits:(int) digits;

- (NSString*) toBinaryString;
+ (NSString*) toBinaryString:(long long)theNumber;
+ (GNGeoHash*) withCharacterPrecision:(double)latitude andLongitude:(double)longitude andNumberOfCharacters:(int) numberOfCharacters;

- (void) divideRangeEncode:(double)value andRange:(NSMutableArray*) range;
- (void) addOnBitToEnd;
- (void) addOffBitToEnd;


- (NSArray*) getAdjacent;
- (GNGeoHash*) getNorthernNeighbour;
- (GNGeoHash*) getSouthernNeighbour;
- (GNGeoHash*) getEasternNeighbour;
- (GNGeoHash*) getWesternNeighbour;

- (NSMutableArray*) getRightAlignedLatitudeBits;
- (NSMutableArray*) getRightAlignedLongitudeBits;
- (long long) extractEverySecondBit:(long long) copyOfBits andNumberOfBits:(int)numberOfBits;
- (NSArray*) getNumberOfLatLonBits;

- (GNGeoHash*) recombineLatLonBitsToHash:(NSMutableArray*)latBits andLongBits:(NSMutableArray*)lonBits;
+ (void) divideRangeDecode:(GNGeoHash*) hash andRange:(NSMutableArray*)range andBool:(BOOL) b ;

+ (void) setBoundingBox:(GNGeoHash*)hash andLatitudeRange:(NSMutableArray*) latitudeRange andLongitudeRange:(NSMutableArray*) longitudeRange;
@end
