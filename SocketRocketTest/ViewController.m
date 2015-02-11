//
//  ViewController.m
//  SocketRocketTest
//
//  Created by Lauren Lee on 2/9/15.
//  Copyright (c) 2015 Lauren Lee. All rights reserved.
//

#import "ViewController.h"

//static NSString *const server = @"example.com"; 
static NSString *const server = @"arrivelocation1.stg.usw2.spny.us";

@interface ViewController ()

@property (nonatomic, strong) SRWebSocket *socketio;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.allowsCellularAccess = YES;
    sessionConfig.HTTPAdditionalHeaders = @{@"Content-Type": @"application/json"};
    sessionConfig.timeoutIntervalForRequest = 30;
    sessionConfig.timeoutIntervalForResource = 60;
    sessionConfig.HTTPMaximumConnectionsPerHost = 1;

    self.session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    [self initHandshake];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickButton:(id)sender {
    
    NSDictionary *dict = @{@"name": @"test", @"args": @{@"Button": @"Pressed"}};
    
    NSError *sendError;
    NSData *jsonSend = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&sendError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonSend encoding:NSUTF8StringEncoding];
    NSLog(@"JSON SENT %@", jsonString);
    
    NSString *str = [NSString stringWithFormat:@"5:::%@",jsonString];
    [self.socketio send:str];
}

//- (instancetype)init
//{
//    NSLog(@"VC init");
//    
//    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    sessionConfig.allowsCellularAccess = YES;
//    sessionConfig.HTTPAdditionalHeaders = @{@"Content-Type": @"application/json"};
//    sessionConfig.timeoutIntervalForRequest = 30;
//    sessionConfig.timeoutIntervalForResource = 60;
//    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
//    
//    self = [super init];
//    if (self) {
//        
//        _session = [NSURLSession sessionWithConfiguration:sessionConfig];
//        
//        [self initHandshake];
//
//    }
//    return self;
//}

- (void)initHandshake
{
    [self socketConnect:nil];
    
//    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
//    NSString *endpoint = [NSString stringWithFormat:@"http://%@/socket.io/1?t=%.0f", server, time];
//    NSLog(@"endpoint %@", endpoint);
//    NSURL *requestURL = [NSURL URLWithString:endpoint];
//    
//    NSURLSessionTask *handshakeTask = [self.session dataTaskWithURL:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (!error) {
//            NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSString *handshakeToken = [[stringData componentsSeparatedByString:@":"] firstObject];
//            NSLog(@"HANDSHAKE %@ %@", handshakeToken, stringData);
//            
//            [self socketConnect:handshakeToken];
//        }
//        else {
//            NSLog(@"error handshake %@", error);
//        }
//    }];
//    
//    [handshakeTask resume];
}

- (void)socketConnect:(NSString *)token;
{
//    NSString *urlString = [NSString stringWithFormat:@"ws://%@/socket.io/1/websocket/%@", server, token];
//    NSString *urlString = [NSString stringWithFormat:@"http://%@/socket.io", server];
    NSString *urlString = [NSString stringWithFormat:@"ws://%@/position/socket.io/1/websocket", server];
    NSLog(@"url string %@", urlString);
    self.socketio = [[SRWebSocket alloc] initWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]]];
    self.socketio.delegate = self;
    [self.socketio open];
}


#pragma mark WebSocket Delegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"Socket Message: %@", message);
    
    NSError *error;
    NSArray *messageArray = [(NSString *)message componentsSeparatedByString:@":::"];
    NSData *data = [messageArray[messageArray.count - 1] dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:nil error:&error];
    
    if (json) {
        NSString *event = [json objectForKey:@"name"];
        NSDictionary *args = [[json objectForKey:@"args"] firstObject];
        
        if ([event isEqualToString:@"one"]) {
            
        }
        else if ([event isEqualToString:@"two"]) {
            
        }
        else if ([event isEqualToString:@"three"]) {
            
        }
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    // set variable to say it's open
    
    NSLog(@"socket open with ready state %d", self.socketio.readyState);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"socket did close with ready state %d reason %@", self.socketio.readyState, reason);
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"socket did fail with error %@ with ready state %d", error, self.socketio.readyState);
}

- (void)didReceiveEventOne:(NSDictionary *)args {
    NSDictionary *dict = @{@"name": @"event", @"args": @{@"Method": @"One"}};
    NSError *jsonSendError;
    NSData *jsonSend = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&jsonSendError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonSend encoding:NSUTF8StringEncoding];
    NSLog(@"JSON SENT %@", jsonString);
    NSString *str = [NSString stringWithFormat:@"5:::%@", jsonString];
    [self.socketio send:str];
}

- (void)didReceiveEventTwo:(NSDictionary *)args {
    NSDictionary *dict = @{@"name": @"event", @"args": @{@"Method": @"Two"}};
    NSError *jsonSendError;
    NSData *jsonSend = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&jsonSendError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonSend encoding:NSUTF8StringEncoding];
    NSLog(@"JSON SENT %@", jsonString);
    NSString *str = [NSString stringWithFormat:@"5:::%@", jsonString];
    [self.socketio send:str];
}

- (void)didReceiveEventThree:(NSDictionary *)args {
    NSDictionary *dict = @{@"name": @"event", @"args": @{@"Method": @"Three"}};
    NSError *jsonSendError;
    NSData *jsonSend = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&jsonSendError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonSend encoding:NSUTF8StringEncoding];
    NSLog(@"JSON SENT %@", jsonString);
    NSString *str = [NSString stringWithFormat:@"5:::%@", jsonString];
    [self.socketio send:str];
}

@end
