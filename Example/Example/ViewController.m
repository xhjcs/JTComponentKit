//
//  ViewController.m
//  Example
//
//  Created by xinghanjie on 2024/10/14.
//

#import "ViewController.h"
#import "Example-Swift.h"
#import "JTAComponent.h"
#import <JTComponentKit/JTComponentKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    JTComponentAssemblyView *componentAssemblyView = [[JTComponentAssemblyView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:componentAssemblyView];
    [componentAssemblyView assembleComponents:@[[JTAComponent new], [JTAComponent new]]];
    
    NSLog(@"sssss %lf", UITableViewAutomaticDimension);
}


@end
