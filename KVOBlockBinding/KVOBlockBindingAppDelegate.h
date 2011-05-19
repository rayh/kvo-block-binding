//
//  KVOBlockBindingAppDelegate.h
//  KVOBlockBinding
//
//  Created by Ray Yamamoto on 19/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KVOBlockBindingViewController;

@interface KVOBlockBindingAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet KVOBlockBindingViewController *viewController;

@end
