#import "AppDelegate.h"

@interface AppDelegate (siri)
    - (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler ;
    @property (nonatomic, strong) IBOutlet NSUserActivity* userActivity;
@end
