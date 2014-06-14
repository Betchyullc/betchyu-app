#import <UIKit/UIKit.h>
#import "MTZoomContainerView.h"
#import "MTStackViewController.h"
#import "DashboardVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property NSString * ownId;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) UINavigationController* navController;
@property (strong, nonatomic) DashboardVC *mainViewController;
@property MTStackViewController *stackViewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)showLoginView;
- (void)openSession;

@end
