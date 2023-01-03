//
//  XPCHelperProtocol.h
//  XPCHelper
//
//  Created by joey on 2022/11/22.
//

#import <Foundation/Foundation.h>

// The protocol that this service will vend as its API. This header file will
// also need to be visible to the process hosting the service.
@protocol XPCHelperProtocol
- (void)upperCaseString:(NSString *)aString withReply:(void (^)(NSString *))reply;

- (void)registerAsAppWithListenerEndpoint:(NSXPCListenerEndpoint *)endpoint reply:(void (^)(void))reply;
- (void)unregisterAsApp;
- (void)connectWithProcessIdToApp:(NSUInteger)processId ioType:(bool)isInput withReply:(void (^)(NSError *))reply;
@end

/*
 To use the service from an application or other process, use NSXPCConnection to
establish a connection to the service by doing something like this:

     _connectionToService = [[NSXPCConnection alloc]
initWithServiceName:@"com.gaudiolab.XPCHelper"];
     _connectionToService.remoteObjectInterface = [NSXPCInterface
interfaceWithProtocol:@protocol(XPCHelperProtocol)];
     [_connectionToService resume];

Once you have a connection to the service, you can use it like this:

     [[_connectionToService remoteObjectProxy] upperCaseString:@"hello"
withReply:^(NSString *aString) {
         // We have received a response. Update our text field, but do it on the
main thread. NSLog(@"Result string was: %@", aString);
     }];

 And, when you are finished with the service, clean up the connection like this:

     [_connectionToService invalidate];
*/
