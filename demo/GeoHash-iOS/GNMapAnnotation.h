//
//  GNMapAnnotation.h
//  GeoHashes
//
//  Created by AppTastic Technologies (www.apptastic.com.au) for GNS Science
//  Copyright (c) 2012 GNS Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GNMapAnnotation : NSObject <MKAnnotation> 

@property (assign) CLLocationCoordinate2D theCoordinate;
@property (strong) NSString* theTitle;
@property (strong) NSString* theSubTitle;
@property (assign) int precision;
@property (strong) NSString* url;

-(id) initWithPrecision:(int)precision;

@end
