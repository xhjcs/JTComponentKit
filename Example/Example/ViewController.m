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
    
    JTAComponent *a1 = [JTAComponent new];
    a1.pinningBehavior = JTComponentHeaderPinningBehaviorPin;
    a1.headerTitle = @"a1 吸顶";
    JTAComponent *a2 = [JTAComponent new];
    a2.pinningBehavior = JTComponentHeaderPinningBehaviorNone;
    a2.headerTitle = @"a2 不吸顶";
    JTAComponent *a3 = [JTAComponent new];
    a3.pinningBehavior = JTComponentHeaderPinningBehaviorAlwaysPin;
    a3.headerTitle = @"a3 一直吸顶";
    JTAComponent *a4 = [JTAComponent new];
    a4.pinningBehavior = JTComponentHeaderPinningBehaviorPinUntilNextPinHeader;
    a4.headerTitle = @"a4 直到下一个吸顶的header前一直吸顶";
    JTAComponent *a5 = [JTAComponent new];
    
    JTBComponent *b1 = [JTBComponent new];
    b1.pinningBehavior = JTComponentHeaderPinningBehaviorPinUntilNextPinHeader;
    b1.headerTitle = @"b1 直到下一个吸顶的header前一直吸顶";
    JTBComponent *b2 = [JTBComponent new];
    b2.pinningBehavior = JTComponentHeaderPinningBehaviorAlwaysPin;
    b2.headerTitle = @"b2 一直吸顶";
    JTBComponent *b3 = [JTBComponent new];
    b3.pinningBehavior = JTComponentHeaderPinningBehaviorNone;
    b3.headerTitle = @"b3 不吸顶";
    JTBComponent *b4 = [JTBComponent new];
    b4.pinningBehavior = JTComponentHeaderPinningBehaviorPin;
    b4.headerTitle = @"b4 吸顶";
    JTBComponent *b5 = [JTBComponent new];
    
    [componentAssemblyView assembleComponents:@[a1, b1, b5, a2, b2, a5, a3, b3, a4, b4]];
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
