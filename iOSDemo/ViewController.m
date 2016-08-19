//
//  ViewController.m
//  iOSDemo
//
//  Created by Ezreal on 16/8/18.
//
//

#import "ViewController.h"
#import "TestApi.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    TestApi *api = [[TestApi alloc]init];
    [api startWithCompletionBlockWithSuccess:^(__kindof EZRequest *request) {
        NSLog(@"aa");
    } failure:^(__kindof EZRequest *request) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
