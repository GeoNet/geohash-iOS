//
//  GNGeohashUtil.h
//  GeoNetQuakeIB
//
//  Created by Manuel Beuttler on 20/04/12.
//  Copyright (c) 2012 KJEW Investments Pty Ltd t/as AppTastic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNGeohashUtil : NSObject

+ (NSString*) encodeLatitude: (double)latitude andLongitude:(double)longitude withPrecision:(int)numbChar;

+ (NSString*) encodeLatitude: (double)latitude andLongitude:(double)longitude;

+ (NSArray*) getBitsForLat:(double)lat floor:(double)floor ceiling:(double) ceiling;

+ (NSString*) base32:(long)i;
+(long)bin2long:(NSString*)binstr;
+(NSString*)base2tobase32:(NSString*)binstr;


@end
