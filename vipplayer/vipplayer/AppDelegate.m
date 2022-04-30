//
//  AppDelegate.m
//  vipplayer
//
//  Created by LUOSUONAN on 2022/4/30.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SNMainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    ViewController *vc = [[ViewController alloc] init];
    
    
    self.window.rootViewController = vc;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}




@end
