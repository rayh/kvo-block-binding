#import <UIKit/UIKit.h>

@class KVOBlockBindingViewController;

@interface KVOBlockBindingAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet KVOBlockBindingViewController *viewController;

@end
