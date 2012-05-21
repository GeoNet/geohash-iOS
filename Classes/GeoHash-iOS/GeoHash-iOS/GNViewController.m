//
//  GNViewController.m
//  GeoHash-iOS
//
//  Created by Patrick Dockhorn on 22/05/12.
//  Copyright (c) 2012 KJEW Investments Pty Ltd. All rights reserved.
//

#import "GNViewController.h"

@interface GNViewController ()

@end

@implementation GNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
