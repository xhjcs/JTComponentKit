//
//  ViewController.m
//  Example
//
//  Created by xinghanjie on 2024/10/14.
//

#import "ViewController.h"
#import "Example-Swift.h"
#import "JTAComponent.h"
#import "JTBComponent.h"
#import <JTComponentKit/JTComponentKit.h>
#import "JTEventHubArgs.h"
#import <Masonry/Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    JTComponentAssemblyView *componentAssemblyView = [[JTComponentAssemblyView alloc] init];
    [self.view addSubview:componentAssemblyView];
    [componentAssemblyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [componentAssemblyView assembleComponents:@[[JTAComponent new], [JTBComponent new]]];
//    componentAssemblyView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    componentAssemblyView.componentHeadersPinToVisibleBounds = YES;
}


@end
