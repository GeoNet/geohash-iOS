//
//  GNAppDelegate.h
//  GeoHash-iOS
//
//  Created by Patrick Dockhorn on 22/05/12.
//  Copyright (c) 2012 KJEW Investments Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GNViewController;

@interface GNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GNViewController *viewController;

@end
