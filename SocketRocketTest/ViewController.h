//
//  ViewController.h
//  SocketRocketTest
//
//  Created by Lauren Lee on 2/9/15.
//  Copyright (c) 2015 Lauren Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"

@import Foundation;

@interface ViewController : UIViewController <SRWebSocketDelegate>

@property (weak, nonatomic) IBOutlet UIButton *button;

@end

