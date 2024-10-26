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
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Example";
    
    JTComponentsAssemblyView *componentAssemblyView = [[JTComponentsAssemblyView alloc] init];
    [self.view addSubview:componentAssemblyView];
    [componentAssemblyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
    }];
    [componentAssemblyView assembleComponents:@[[JTAComponent new], [JTBComponent new]]];
    __weak __typeof(self) weakSelf = self;
    [componentAssemblyView on:@"com.heikki.jumptoswiftexamplepage" callback:^(JTEventHubArgs * _Nonnull args) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        JTViewController *vc = [JTViewController new];
        [strongSelf.navigationController pushViewController:vc animated:YES];
    }];
//    componentAssemblyView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    componentAssemblyView.componentHeadersPinToVisibleBounds = YES;
}


@end
