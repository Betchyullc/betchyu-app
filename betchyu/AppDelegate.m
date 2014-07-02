#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "API.h"
#import "FlyoutMenuVC.h"

@implementation AppDelegate

@synthesize ownId;
@synthesize ownName;
@synthesize token;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize navController = _navController;
@synthesize mainViewController = _mainViewController;
@synthesize stackViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge
                                                                           | UIRemoteNotificationTypeSound
                                                                           | UIRemoteNotificationTypeAlert)];
    
    // clear some stuff
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    self.ownId = @"";
    self.token = @"derp";
    
    // setup url cache
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:8 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    // setup view controller stuff
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.stackViewController = [[MTStackViewController alloc] initWithNibName:nil bundle:nil];
    [stackViewController setAnimationDurationProportionalToPosition:YES];
    stackViewController.disableSwipeWhenContentNavigationControllerDrilledDown = YES;
    stackViewController.leftViewControllerEnabled = NO;
    
    CGRect foldFrame = CGRectMake(0, 0, stackViewController.slideOffset, CGRectGetHeight(self.window.bounds));
    FlyoutMenuVC *menuViewController = [[FlyoutMenuVC alloc] initWithFrame:foldFrame];
    UINavigationController *flyOutNav =[[UINavigationController alloc] initWithRootViewController:menuViewController];
    flyOutNav.navigationBarHidden = YES;
    
    stackViewController.delegate = menuViewController;
    
    [stackViewController setLeftContainerView:[[MTZoomContainerView alloc] initWithFrame:foldFrame]];
    [stackViewController setLeftViewController:flyOutNav];
    
    self.mainViewController = [[DashboardVC alloc] initWithInviteNumber:@"0"];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    [stackViewController setContentViewController:self.navController];
    
    // See if the app has a valid token for the current state.
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // Yes, so just open the session (this won't display any UX).
        [self openSession];
    } else {
        // No, display the login page.
        [self showLoginView];
    }
    
    
    // Setup the navigation bar appearance
    UIColor *betchyu = [UIColor colorWithRed:243.0/255 green:(116.0/255.0) blue:(67/255.0) alpha:1.0];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      NSForegroundColorAttributeName,
      [UIFont fontWithName:@"ProximaNova-Black" size:18.0],
      NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setBackgroundColor:betchyu];
    [[UINavigationBar appearance] setBarTintColor:betchyu];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // SETUP GOOGLE ANALYTICS!!!!11!1!
    // default to tracking is on
    [[GAI sharedInstance] setOptOut:NO];
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 25;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-44517037-1"];
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    [tracker set:kGAIAppVersion value:version];
    //[tracker set:kGAISampleRate value:@"100.0"]; // change this?
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self.navController popToRootViewControllerAnimated:NO];
    [self.mainViewController viewDidAppear:YES];
    [self sendDeviceTokenToServer:self.token];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface..
    
    // We need to properly handle activation of the application with regards to Facebook Login
    // (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Push Notification stuff
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    // format that dirty, dirty token
    NSString *newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    // log it for pleasureable release
	NSLog(@"My token is: %@", newToken);
    
    // save it up for later, baby
    self.token = newToken;
    
    // post it in there. right up in there.
    [self sendDeviceTokenToServer:newToken];
}

-(void)sendDeviceTokenToServer:(NSString*)theToken {
    // make sure the ownId is properly applied to our own member
    if ([self.ownId isEqualToString:@""]) {
        // the ownId was broken, so we'll try again later, baby.
        [self performSelector:@selector(sendDeviceTokenToServer:) withObject:theToken afterDelay:1];
        return;
    }
    // sensually massage the parameters
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.ownId, @"fb_id",
                                    theToken, @"device",
                                    self.ownName, @"name",
                                    [[self.fbUser valueForKey:@"gender"] isEqualToString:@"male"] ? @"true" : @"false", @"is_male",
                                    [self.fbUser valueForKey:@"email"], @"email",
                                    [[self.fbUser valueForKey:@"location"] valueForKey:@"name"], @"location",
                                    nil];
    // ejaculate our data to the server's port-hole
    [[API sharedInstance] post:@"user" withParams:params onCompletion:^(NSDictionary *json) {
        // throw the used response in the trash can
    }];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
    [self sendDeviceTokenToServer:@"derp"];
    // save it up for later, baby
    self.token = @"derp";
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        NSString *cancelTitle = @"Close";
        NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:cancelTitle
                                                  otherButtonTitles:nil];
        [alertView show];
    } else {
        //Do stuff that you would do if the application was not active
    }
}

#pragma mark - FB stuff

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)showLoginView {
    // If the login screen is not already displayed, display it. If the login screen is
    // displayed, then getting back here means the login in progress did not successfully
    // complete. In that case, notify the login view so it can update its UI appropriately.
    if (![self.window.rootViewController isKindOfClass:[LoginViewController class]]) {
        LoginViewController* loginViewController = [[LoginViewController alloc]
                                                    initWithNibName:nil
                                                    bundle:nil];
        
        [self.window setRootViewController:loginViewController];
        [self.window makeKeyAndVisible];
    } else {
        LoginViewController* loginViewController = (LoginViewController*)self.window.rootViewController;
        [loginViewController loginFailed];
    }
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpenTokenExtended:
        case FBSessionStateOpen: {
            // Fetch user data
            [FBRequestConnection
             startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                               id<FBGraphUser> user,
                                               NSError *error) {
                 if (!error) {
                     self.ownId = user.id;
                     self.ownName = user.name;
                     NSLog(@"FBuserId: %@", user.id);
                     NSLog(@"FBuser: %@", user);
                     self.fbUser = user; // it's okay, because it seems to work
                     [self askAboutGAI];
                 } else {
                     self.ownId = @"";
                     self.ownName = @"";
                     [[[UIAlertView alloc] initWithTitle:@"UH OH" message:@"Facebook isn't responding. You might not be connected to the internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                 }
             }];
            
            [self.window setRootViewController:stackViewController];
            [self.window makeKeyAndVisible];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            if (error) {
                // handle error here, for example by showing an alert to the user
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not login with Facebook"
                                                                message:@"Facebook login failed. Please check your Facebook settings on your phone to allow this app."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [self.navController popToRootViewControllerAnimated:NO];
            
            [self showLoginView];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - GAI stuff
-(void) askAboutGAI {
    [[API sharedInstance] get:[NSString stringWithFormat:@"user/%@", self.ownId] withParams:nil onCompletion:^(NSDictionary *json) {
        if ([[json valueForKey:@"allow_analytics"] boolValue]) {
            //just set the opt in
            [[GAI sharedInstance] setOptOut:NO];
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Google Analytics" message:@"Help us make Betchyu better. Do we have your permission to collect anonymous data?" delegate:self cancelButtonTitle:@"Opt Out" otherButtonTitles:@"Opt In", nil];
            [av show];
        }
    }];
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            [[GAI sharedInstance] setOptOut:YES];
            break;
        }
        case 1: {
            [[GAI sharedInstance] setOptOut:NO];
            NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.ownId, @"fb_id", self.token, @"device", @"true", @"allow_analytics", nil];
            [[API sharedInstance] post:@"user" withParams:params onCompletion:^(NSDictionary *json) {
                // do nothing
            }];
            break;
        }
        default:
            break;
    }
}
@end
