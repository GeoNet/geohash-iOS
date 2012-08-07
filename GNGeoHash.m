//
//  GNGeoHash.m
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

#import "GNGeoHash.h"

@interface GNGeoHash ()

@end

@implementation GNGeoHash 

@synthesize BITS,FIRST_BIT_FLAGGED,base32,decodeMap,bits,significantBits,point,boundingBox;

-(id)init
{
    //Initialize GeoHash standard values
    if (self = [super init])
    {
        self.BITS = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],nil];
        int val = 16;
        for (int i = 0 ; i < 5 ; i++)
        {
            [self.BITS replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:val]];
            val /= 2; 
            
        }
       
        self.FIRST_BIT_FLAGGED = 0x8000000000000000l;
        
        self.base32 = @"0123456789bcdefghjkmnpqrstuvwxyz";
        
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithCapacity:32];
        int sz = [base32 length];
        
        for (int i = 0; i < sz; i++)
        {
            [tmp setValue:[NSNumber numberWithInt:i] forKey:[NSString stringWithFormat:@"%c",[self.base32 characterAtIndex:i]]];
        }
             
        self.decodeMap = [NSDictionary dictionaryWithDictionary:tmp];
        
        self.bits = 0;
        self.significantBits = 0;
    }
    return self;
}


-(id) initWithLatitude:(double)lat andLongitude:(double)lon andPrecision:(int)precision
{
    //Initialize GeoHash with certain GNWGS84Point
    if ([self init])
    {
        self.point = [[GNWGS84Point alloc] initWithLatitude:lat andLongitude:lon];
        
        precision = fmin(precision, 64);
        
        BOOL isEvenBit = true;
        
        NSMutableArray *latitudeRange = [NSMutableArray arrayWithObjects: [NSNumber numberWithDouble:-90] ,[NSNumber numberWithDouble:90], nil];
        NSMutableArray *longitudeRange = [NSMutableArray arrayWithObjects: [NSNumber numberWithDouble:-180] ,[NSNumber numberWithDouble:180], nil];
        
        while (self.significantBits < precision)
        {
            if (isEvenBit) 
            {
                [self divideRangeEncode:lon andRange:longitudeRange];
            } 
            else 
            {
                [self divideRangeEncode:lat andRange:latitudeRange];
            }
            
            isEvenBit = !isEvenBit;
        }
        
        [GNGeoHash setBoundingBox:self andLatitudeRange:latitudeRange andLongitudeRange:longitudeRange];
        self.bits <<= (64 - precision);
    }
    return self;
}

- (NSString*) description
{
    if (significantBits % 5 == 0)
    {
        return [NSString stringWithFormat:@"%@ -> %@ -> %@", [GNGeoHash toBinaryString:self.bits], self.boundingBox, [self toBase32]];
    }
    else
    {
        return [NSString stringWithFormat:@"%@ -> %@, bits: %c", [GNGeoHash toBinaryString:self.bits], self.boundingBox, self.significantBits];
    }    
}

+ (GNGeoHash*) withCharacterPrecision:(double)latitude andLongitude:(double)longitude andNumberOfCharacters:(int) numberOfCharacters 
{
    int desiredPrecision = (numberOfCharacters * 5 <= 60) ? numberOfCharacters * 5: 60;
    
    return [[GNGeoHash alloc] initWithLatitude:latitude andLongitude:longitude andPrecision:desiredPrecision];
}

+ (NSString*) toBinaryString:(long long)theNumber
{
    //Returns a number as binary string representation
    NSMutableString* binaryString = [[NSMutableString alloc] initWithCapacity:1];
    long long numberCopy = theNumber;
    
    for(int i = 0; i < 64; i++)
    {
        // Prepend "0" or "1", depending on the bit
        // (Binary is read right to left)
        [binaryString insertString:((numberCopy & 1) ? @"1" : @"0") atIndex:0];
        numberCopy = [GNGeoHash unsignedRightShiftWith:numberCopy andDigits:1];

    }
    return binaryString;
}

- (NSString*) toBinaryString
{
    //Transform hash bits to binary strings
    NSString* buf = @"";
    long long bitsCopy = bits;
    
    for (int i = 0; i < significantBits; i++)
    {
        if ((bitsCopy & FIRST_BIT_FLAGGED) == FIRST_BIT_FLAGGED)
        {
            [buf stringByAppendingString:@"1"];
        }
        else
        {
            [buf stringByAppendingString:@"0"];
        }
        
        bitsCopy <<= 1;
    }
    
    return buf;
}


- (void) divideRangeEncode:(double)value andRange:(NSMutableArray*) range
{
    //Transform latitude/longitude value to bit representation
    double mid = 0;
    if ([range count] > 1)
    {
        double dNumber1 = [[range objectAtIndex:0] doubleValue];
        double dNumber2 = [[range objectAtIndex:1] doubleValue];
        mid = (dNumber1 + dNumber2) / 2;
    }
    
    if (value >= mid) 
    {
        [self addOnBitToEnd];
        [range replaceObjectAtIndex:0 withObject:[NSNumber numberWithDouble:mid]];
    } 
    else 
    {
        [self addOffBitToEnd];
        [range replaceObjectAtIndex:1 withObject:[NSNumber numberWithDouble:mid]];
    }
}

- (void) addOnBitToEnd
{
    self.significantBits++;
    //Bitwise left shift, adding a zero
    self.bits <<= 1;
    //Set introduced bit to 1 (0x1 representes 1 in Hex and is OR connected to the value)
    self.bits = bits | 0x1;
}

- (void) addOffBitToEnd
{
    self.significantBits++;
    //Bitwise left shift, adding a zero
    self.bits <<= 1;
}

+ (void) setBoundingBox:(GNGeoHash*)hash andLatitudeRange:(NSMutableArray*) latitudeRange andLongitudeRange:(NSMutableArray*) longitudeRange 
{
    //Set location area based on two points
    GNWGS84Point* p1 = [[GNWGS84Point alloc] initWithLatitude:[[latitudeRange objectAtIndex:0]doubleValue] andLongitude:[[longitudeRange objectAtIndex:0]doubleValue]];
    GNWGS84Point* p2 = [[GNWGS84Point alloc] initWithLatitude:[[latitudeRange objectAtIndex:1]doubleValue] andLongitude:[[longitudeRange objectAtIndex:1]doubleValue]];
    hash.boundingBox = [[GNBoundingBox alloc] initWithP1:p1 andP2:p2];
}

/**
 * returns the 8 adjacent hashes for this one. They are in the following
 * order:<br>
 * N, NE, E, SE, S, SW, W, NW
 */
- (NSArray*) getAdjacent 
{
    //Find neighbors of a given area
    GNGeoHash *northern = [self getNorthernNeighbour];
    GNGeoHash *eastern = [self getEasternNeighbour];
    GNGeoHash *southern = [self getSouthernNeighbour];
    GNGeoHash *western = [self getWesternNeighbour];
    
    return [NSArray arrayWithObjects:northern, [northern getEasternNeighbour], eastern, [southern getEasternNeighbour], southern,
            [southern getWesternNeighbour], western, [northern getWesternNeighbour], nil];
    return [[NSArray alloc] init];
}

- (GNGeoHash*) getNorthernNeighbour 
{
    //Find northern area corresponding to the given area through changing latitude
    NSMutableArray *latitudeBits = [self getRightAlignedLatitudeBits];
    NSMutableArray *longitudeBits = [self getRightAlignedLongitudeBits];
    long long value = [[latitudeBits objectAtIndex:0] longLongValue] + 1;    
    [latitudeBits replaceObjectAtIndex:0 withObject:[NSNumber numberWithLongLong:value]];

    return [self recombineLatLonBitsToHash:latitudeBits andLongBits:longitudeBits];    
}

- (GNGeoHash*) getSouthernNeighbour 
{
    //Find southern area corresponding to the given area through changing latitude
    NSMutableArray *latitudeBits = [self getRightAlignedLatitudeBits];
    NSMutableArray *longitudeBits = [self getRightAlignedLongitudeBits];
    long long value = [[latitudeBits objectAtIndex:0] longLongValue] - 1;
    [latitudeBits replaceObjectAtIndex:0 withObject:[NSNumber numberWithLongLong:value]];
    
    return [self recombineLatLonBitsToHash:latitudeBits andLongBits:longitudeBits];    
}

- (GNGeoHash*) getEasternNeighbour 
{
    //Find eastern area corresponding to the given area through changing longitude
    
    NSMutableArray *latitudeBits = [self getRightAlignedLatitudeBits];
    NSMutableArray *longitudeBits = [self getRightAlignedLongitudeBits];
    long long value = [[longitudeBits objectAtIndex:0]longLongValue] + 1;
    [longitudeBits replaceObjectAtIndex:0 withObject:[NSNumber numberWithLongLong:value]];
    
    return [self recombineLatLonBitsToHash:latitudeBits andLongBits:longitudeBits];    
}

- (GNGeoHash*) getWesternNeighbour 
{
    //Find western area corresponding to the given area through changing longitude
    NSMutableArray *latitudeBits = [self getRightAlignedLatitudeBits];
    NSMutableArray *longitudeBits = [self getRightAlignedLongitudeBits];
    long long value = [[longitudeBits objectAtIndex:0]longLongValue] - 1;
    [longitudeBits replaceObjectAtIndex:0 withObject:[NSNumber numberWithLongLong:value]];
    
    return [self recombineLatLonBitsToHash:latitudeBits andLongBits:longitudeBits];    
}

- (NSMutableArray*) getRightAlignedLatitudeBits
{
    //Identifies each second bit relevant for latitude starting from the second bit
    
    long long copyOfBits = self.bits << 1;
    long numberOfLatBits = [[[self getNumberOfLatLonBits] objectAtIndex:0] longValue];
    long long value = [self extractEverySecondBit:copyOfBits andNumberOfBits:numberOfLatBits];
    
    return [NSMutableArray arrayWithObjects:[NSNumber numberWithLongLong:value],[NSNumber numberWithLong:(int)numberOfLatBits], nil];
}

- (NSMutableArray*) getRightAlignedLongitudeBits
{
    //Identifies each second bit relevant for longitude starting from the first bit
    long long copyOfBits = self.bits;
    long numberOfLonBits = [[[self getNumberOfLatLonBits] objectAtIndex:1] longValue];
    long long value = [self extractEverySecondBit:copyOfBits andNumberOfBits:numberOfLonBits];
    
    return [NSMutableArray arrayWithObjects:[NSNumber numberWithLongLong:value],[NSNumber numberWithLong:(int)numberOfLonBits], nil];
}

- (NSArray*) getNumberOfLatLonBits
{
    //Calculates the amount of latitude and longitude related bits
    long halfvalue = self.significantBits / 2;
    long halfvaluePlusOne = self.significantBits / 2 + 1;
    
    if (self.significantBits % 2 == 0)
    {
        NSArray* array = [NSArray arrayWithObjects:[NSNumber numberWithInt:halfvalue], [NSNumber numberWithLong:halfvalue], nil];
        return array;
    }
    else
    {
        NSArray* array = [NSArray arrayWithObjects:[NSNumber numberWithInt:halfvalue], [NSNumber numberWithLong:halfvaluePlusOne], nil];
        return array;
    }
}

- (long long) extractEverySecondBit:(long long) copyOfBits andNumberOfBits:(int)numberOfBits
{
    //Returns each second bit of a value (extract either longitude or latitude related bits)
    long long value = 0;
    
    for (int i = 0; i < numberOfBits; i++)
    {
        if ((copyOfBits & self.FIRST_BIT_FLAGGED) == self.FIRST_BIT_FLAGGED)
        {
            value |= 0x1;
        }
        
        value <<= 1;
        copyOfBits <<= 2;
    }
    //Undo last left shift
    value = [GNGeoHash unsignedRightShiftWith:value andDigits:1];
    
    return value;
}

- (GNGeoHash*) recombineLatLonBitsToHash:(NSMutableArray*)latBits andLongBits:(NSMutableArray*)lonBits; 
{
    //Build the new bit representation of latitude/longitude based on the seperate lat and lon bit chains
    GNGeoHash *hash = [[GNGeoHash alloc] init];
    BOOL isEvenBit = false;
    
    long long latValue = [[latBits objectAtIndex:0]longLongValue];
    long long lonValue = [[lonBits objectAtIndex:0]longLongValue];
    
    latValue <<= (64 - [[latBits objectAtIndex:1]longValue]);
    lonValue <<= (64 - [[lonBits objectAtIndex:1]longValue]);
    
    [latBits replaceObjectAtIndex:0 withObject:[NSNumber numberWithLongLong:latValue]];
    [lonBits replaceObjectAtIndex:0 withObject:[NSNumber numberWithLongLong:lonValue]];
    
    NSMutableArray *latitudeRange = [NSMutableArray arrayWithObjects: [NSNumber numberWithDouble:-90] ,[NSNumber numberWithDouble:90], nil];
    NSMutableArray *longitudeRange = [NSMutableArray arrayWithObjects: [NSNumber numberWithDouble:-180] ,[NSNumber numberWithDouble:180], nil];

    for (int i = 0; i < ([[latBits objectAtIndex:1]longValue] + [[lonBits objectAtIndex:1]longValue]); i++) 
    {
        if (isEvenBit) 
        {
            [GNGeoHash divideRangeDecode:hash andRange:latitudeRange andBool:([[latBits objectAtIndex:0]longLongValue] & self.FIRST_BIT_FLAGGED) == self.FIRST_BIT_FLAGGED];

            latValue <<= 1;
            [latBits replaceObjectAtIndex:0 withObject:[NSNumber numberWithLongLong:latValue]];
        } else {
            [GNGeoHash divideRangeDecode:hash andRange:longitudeRange andBool:([[lonBits objectAtIndex:0]longLongValue] & self.FIRST_BIT_FLAGGED) == self.FIRST_BIT_FLAGGED];
            lonValue <<= 1;
            [lonBits replaceObjectAtIndex:0 withObject:[NSNumber numberWithLongLong:lonValue]];
        }
        
        isEvenBit = !isEvenBit;
    }

    hash.bits <<= (64 - hash.significantBits);
    [GNGeoHash setBoundingBox:hash andLatitudeRange:latitudeRange andLongitudeRange:longitudeRange];
    
    double pointLatitude = [[latitudeRange objectAtIndex:0]doubleValue] + ([[latitudeRange objectAtIndex:1]doubleValue] - [[latitudeRange objectAtIndex:0]doubleValue]) / 2;

    double pointLongitude = [[longitudeRange objectAtIndex:0]doubleValue] + ([[longitudeRange objectAtIndex:1]doubleValue] - [[longitudeRange objectAtIndex:0]doubleValue]) / 2;
    
    hash.point = [[GNWGS84Point alloc] initWithLatitude:pointLatitude andLongitude:pointLongitude];
    
    return hash;
}

+ (void) divideRangeDecode:(GNGeoHash*) hash andRange:(NSMutableArray*)range andBool:(BOOL) b 
{
    //Calculate Latitude/Longitude values based on bit representation and set bits
    double mid = ([[range objectAtIndex:0] doubleValue] + [[range objectAtIndex:1] doubleValue]) / 2;
    
    if (b)
    {
        [hash addOnBitToEnd];
        [range replaceObjectAtIndex:0 withObject:[NSNumber numberWithDouble:mid]];
    }
    else
    {
        [hash addOffBitToEnd];
        [range replaceObjectAtIndex:1 withObject:[NSNumber numberWithDouble:mid]];
    }
}


- (NSString*) toBase32
{
    //Transfer bit representation to Base32 representation of the location
    if (self.significantBits % 5 != 0)
    {
        return @"";
    }

    NSString* buf = @"";
    long long firstFiveBitsMask = 0xf800000000000000l;
    long long bitsCopy = self.bits;
    int partialChunks = (int) ceil(((double) self.significantBits / 5));
    
    for (int i = 0; i < partialChunks; i++)
    {
        int pointer = (int) [GNGeoHash unsignedRightShiftWith:(bitsCopy & firstFiveBitsMask) andDigits: 59];
        buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%c", [self.base32 characterAtIndex:pointer]]];
        bitsCopy <<= 5;
    }
    
    return buf;
}

+ (long long) unsignedRightShiftWith:(long long) number andDigits:(int) digits
{
    //After each right shift, set new digit (leftmost) to zero as it will be 1 if the former first bit (left most) was 1
    //That is because this bit represents a negative signed int and in objective c this flag will remain
    for (int i = 0; i < digits; i++)
    {
        number >>= 1;
        number &= 0x7fffffffffffffffl;
    }
    return number;
}
@end
