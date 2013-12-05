#import "AFIncrementalStore.h"
#import "AFRestClient.h"

@interface iBetchyuAPIClient : AFRESTClient <AFIncrementalStoreHTTPClient>

+ (iBetchyuAPIClient *)sharedClient;

@end
