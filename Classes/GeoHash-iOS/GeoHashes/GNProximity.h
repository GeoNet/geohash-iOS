//
//  GNProximity.h
//  GeoNetQuakeIB
//
//  Created by Patrick Dockhorn on 17/04/12.
//  Copyright (c) 2012 KJEW Investments Pty Ltd t/as AppTastic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNProximity : NSObject

@property (assign) float bearing;
@property (assign) float distance;
@property (strong) NSString *localityName;

-(NSString*) localityString;
-(id)initWithDistance:(float)distance andBearing:(float)bearing andLocalityName:(NSString*)localityName;
+(int) metersToIntFiveKm:(float)distance;
+(NSString*)compassAzimuthForBearing:(float)inbearing;
-(NSString*) localityString;

@end
