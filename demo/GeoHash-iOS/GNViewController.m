//
//  GNViewController.m
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

#import "GNViewController.h"
#import "GNGeoHash.h"
#import "GNMapAnnotation.h"

@interface GNViewController ()

@end

@implementation GNViewController
@synthesize demoMap;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.demoMap.delegate = self;
    
    //Initial Point
    CLLocationCoordinate2D  ctrpoint;
    ctrpoint.latitude = -34.042579;
    ctrpoint.longitude = 151.052139;
     
    //Maximum precision is 12
    int pointPrecision = 12; //to obtain hash according to http://geohash.org
    int areaPrecision = 2; //to draw larger area according to precision
    
    GNMapAnnotation *theAnnotation = [[GNMapAnnotation alloc]initWithPointPrecision:pointPrecision andAreaPrecision:areaPrecision andMapView:self.demoMap];
    
    [theAnnotation setCoordinate:ctrpoint];
    
    [self.demoMap addAnnotation:theAnnotation];    
    [self.demoMap setRegion:MKCoordinateRegionMake(ctrpoint, MKCoordinateSpanMake(10, 10)) animated:YES];
    
    [self.demoMap selectAnnotation:theAnnotation animated:true];
}

- (void)viewDidUnload
{
    [self setDemoMap:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation 
{
    // Configure the little bubble view for each annotation here.
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    if (!pinView) 
    {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = rightButton;
    } 
    else 
    {
        pinView.annotation = annotation;
    }
    pinView.draggable = YES;
    return pinView;
}

-(void)buttonTouched:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) 
    {
        NSString* url = [(GNMapAnnotation*) [self.demoMap.selectedAnnotations objectAtIndex:0] url];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    // Configure area settings
    if ([overlay isKindOfClass:[MKPolygon class]])
    {
        MKPolygonView* aView = [[MKPolygonView alloc] initWithPolygon:(MKPolygon*)overlay];
        
        aView.fillColor = [[UIColor orangeColor] colorWithAlphaComponent:0.2];
        aView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
        aView.lineWidth = 1;
        
        return aView;
    }
    
    return nil;
}


-(void)testGeoHashes
{
    NSLog(@"GeoHash Test started");
    NSArray *coords = [NSArray arrayWithObjects:[NSNumber numberWithFloat: -34.042580],[NSNumber numberWithFloat: 151.052139], nil];

//    NSArray *coords = [NSArray arrayWithObjects:[NSNumber numberWithFloat: -39.125237],[NSNumber numberWithFloat: 175.3386],[NSNumber numberWithFloat: -38.60373],[NSNumber numberWithFloat: 176.81163],[NSNumber numberWithFloat: -43.9],[NSNumber numberWithFloat:171.75], nil];
    
	int nc = [coords count] / 2;
    
    
	NSLog(@"Looking at %d coordinates...",nc);
    NSString *output = [NSString stringWithFormat:@"Looking at %d coordinates...",nc];
    
	for (int i = 0; i < [coords count] ; i += 2) {

	    float lat = [[coords objectAtIndex:i] floatValue];
	    float lon = [[coords objectAtIndex:i+1] floatValue];
        
	    //Maximum precision is 12      
	    GNGeoHash *gh = [GNGeoHash withCharacterPrecision:lat andLongitude:lon andNumberOfCharacters:12];
        
        NSString *temp = [NSString stringWithFormat:@"GeoHash is %@",gh];
        output = [NSString stringWithFormat:@"%@\n%@",output,temp];
        NSLog(@"%@",temp);
        
        NSArray *dirs = [NSArray arrayWithObjects:@"N",@"NE", @"E", @"SE", @"S", @"SW", @"W", @"NW", nil];
        
        NSArray *adjgeos = [gh getAdjacent];
       
	    for (int j = 0; j < [dirs count]; j++) 
        {
            temp = [NSString stringWithFormat:@"Neighbour to the %@ has GeoHash %@",[dirs objectAtIndex:j],[[adjgeos objectAtIndex:j] toBase32]];
            output = [NSString stringWithFormat:@"%@\n%@",output,temp];
            NSLog(@"%@",temp);
	    }
    }

    NSLog(@"GeoHash Test finished");
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
