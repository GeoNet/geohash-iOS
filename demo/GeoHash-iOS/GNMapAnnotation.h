//
//  GNMapAnnotation.h
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
#import <MapKit/MapKit.h>

@interface GNMapAnnotation : NSObject <MKAnnotation> 

@property (assign) CLLocationCoordinate2D theCoordinate;
@property (strong) NSString* theTitle;
@property (strong) NSString* theSubTitle;
@property (assign) int pointPrecision;
@property (assign) int areaPrecision;
@property (strong) NSString* url;
@property (strong) MKMapView* mapView;
@property (strong) MKPolygon* poly;

-(id) initWithPointPrecision:(int)pointPrec andAreaPrecision:(int)areaPrec andMapView:(MKMapView*) theMapView;

@end
