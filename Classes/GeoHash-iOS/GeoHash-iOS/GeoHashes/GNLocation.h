//
//  GNLocation.h
//  GeoHash-iOS
//
//  Created by Patrick Dockhorn on 22/05/12
//

#import <Foundation/Foundation.h>

@interface GNLocation : NSObject 

@property (strong) NSString *locationName;
@property (assign) float longitude;
@property (assign) float latitude;
@property (assign) float distance;
@property (assign) float bearing;
@property (assign) float finalBearing;

@property (assign) BOOL isDistanceAndBearingCalculated;

-(id)initWithName:(NSString*)name andLatitude:(float)lat andLongitude:(float)lon;
-(id)initWithLatitude:(float)lat andLongitude:(float)lon;

-(float) distanceTo:(GNLocation*)dest;
-(float) bearingTo:(GNLocation*) dest;

@end
