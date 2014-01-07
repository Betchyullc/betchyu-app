#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "MTZoomContainerView.h"
#import "MTStackViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property NSString * ownId;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) UINavigationController* navController;
@property (strong, nonatomic) ViewController *mainViewController;
@property MTStackViewController *stackViewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)showLoginView;
- (void)openSession;

@end
