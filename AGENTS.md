# JTComponentKit — Agent Guide

## 项目概述

JTComponentKit 是一个基于 `UICollectionView` 的 iOS 模块化页面框架。核心思想是：**每个 `UICollectionView` section 对应一个 `JTComponent` 实例**，由组件自行实现原本属于 delegate/dataSource 的逻辑，从而实现页面模块的解耦、复用与独立测试。

- **语言**: Objective-C（框架主体），Swift 可继承 `JTComponent`（见 Example）
- **最低版本**: iOS 11.0
- **分发**: CocoaPods / Swift Package Manager
- **当前版本**: 2.2.0

## 架构总览

```
ViewController
  └── JTComponentsAssemblyView          # 页面容器，持有 CollectionView
        ├── JTCollectionView            # 自动注册 Cell/SupplementaryView 的 CollectionView
        ├── JTComponentLayout           # FlowLayout 子类，处理吸顶 Header 与 Section 背景
        ├── JTEventHub                  # 组件间事件总线
        └── [JTComponent, ...]          # 每个组件 = 一个 Section
              ├── Header / Items / Footer / Background
              └── 业务 View（UILabel、自定义 View 等）
```

**数据流**: `JTComponentsAssemblyView` 作为 `UICollectionViewDelegate/DataSource`，将每个 delegate 回调转发给对应 section 的 `JTComponent`。组件通过 `dequeueReusable*ViewOfClass:` 获取业务 View，框架用 `JTComponentCell` / `JTComponentReusableView` 包装。

## 目录结构

```
Sources/JTComponentKit/           # 框架源码（Pod / SPM 入口）
  JTComponent.{h,m}               # 组件基类
  JTComponentsAssemblyView.{h,m}  # 组装容器
  JTCollectionView.{h,m}          # 自动注册复用标识的 CollectionView
  JTComponentLayout.{h,m}         # 自定义 FlowLayout（吸顶、背景）
  JTComponentCell.{h,m}           # Item 包装 Cell
  JTComponentReusableView.{h,m}   # Header/Footer/Background 包装视图
  JTSpacingComponent.{h,m}        # 内置间距组件
  JTComponentDefines.{h,m}        # 常量与枚举
  JTComponentCommunicationProtocol.h
  JTComponentPageLifeCycleProtocol.h
  EventHub/                       # 事件总线实现
Example/                          # 示例 App（CocoaPods 集成）
  Example/Components/A|B|C/       # ObjC / Swift 组件示例
  Example/Playground.swift        # Swift 组件完整示例
```

## 核心类职责

| 类 | 职责 |
|---|---|
| `JTComponent` | 模块基类。子类重写 section 布局、Header/Item/Footer/Background 等方法 |
| `JTComponentsAssemblyView` | 创建 CollectionView，组装组件数组，转发 delegate 与生命周期 |
| `JTComponentLayout` | 基于 FlowLayout，实现 Header 吸顶（Pin/AlwaysPin）与 Section 背景布局 |
| `JTCollectionView` | 首次 dequeue 时自动 `registerClass:`，业务侧无需手动注册 |
| `JTComponentCell` | 将业务 View 作为 `renderView` 嵌入 Cell，`prepareForReuse` 会转发给 renderView |
| `JTEventHub` | 发布/订阅模式，`emit` / `on` 支持最多 6 个参数（`JTEventHubArgs`） |
| `JTSpacingComponent` | 仅提供 top/left 间距的内置组件，无 Item |

## 快速上手：创建页面

### 1. 创建 AssemblyView 并组装组件

```objc
JTComponentsAssemblyView *assemblyView = [[JTComponentsAssemblyView alloc] init];
[assemblyView assembleComponents:@[componentA, componentB, [JTSpacingComponent componentWithSpacing:20]]];
assemblyView.allowsInteractiveMovement = YES; // 可选：开启拖拽排序
```

### 2. 实现自定义组件（ObjC）

继承 `JTComponent`，按需重写以下方法：

```objc
// 生命周期
- (void)setup;                    // 首次 assemble 时调用一次，初始化数据
- (void)componentDidMount;         // 每次 assemble 后调用，适合注册事件
- (void)componentWillUnmount;      // 被替换或销毁前调用，自动 offEvents

// Section 布局
- (UIEdgeInsets)insets;            // 默认 UIEdgeInsetsZero
- (CGFloat)minimumLineSpacing;     // 默认 10
- (CGFloat)minimumInteritemSpacing;// 默认 10

// Header
- (CGSize)headerSize;              // CGSizeZero 表示无 Header
- (UIView *)headerView;            // 通过 dequeueReusableHeaderViewOfClass: 获取

// Items（必须实现）
- (NSInteger)numberOfItems;        // 默认 0
- (CGSize)sizeForItemAtIndex:(NSInteger)index;
- (UIView *)itemViewForIndex:(NSInteger)index;

// Footer / Background（可选）
- (CGSize)footerSize;
- (UIView *)footerView;
- (UIEdgeInsets)insetsForBackgroundView;
- (NSInteger)zIndexForBackgroundView;  // 负值时在 cell 下方
- (UIView *)backgroundView;
```

### 3. View 复用模式

组件不直接使用 `UICollectionViewCell`，而是 dequeue **业务 View**：

```objc
UILabel *label = [self dequeueReusableItemViewOfClass:[UILabel class] forIndex:index];
label.text = self.items[index];
return label;
```

- 复用标识 = View 类名（`NSStringFromClass`）
- `JTCollectionView` 首次 dequeue 时自动注册 `JTComponentCell` / `JTComponentReusableView`
- 若业务 View 实现了 `prepareForReuse`，复用时会被调用

### 4. 刷新与滚动

```objc
[self reloadData];              // 刷新整个 CollectionView
[self scrollToSelf:animated];   // 滚动到当前组件所在 section
```

## 组件间通信（EventHub）

同一 `JTComponentsAssemblyView` 下的所有组件共享一个 `JTEventHub`。

```objc
// 发送
[self emit:@"com.example.event" arg0:data arg1:nil];

// 订阅（在 componentDidMount 中）
__weak typeof(self) weakSelf = self;
[self on:@"com.example.event" callback:^(JTEventHubArgs *args) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    strongSelf.title = args.arg0;
    [strongSelf reloadData];
}];
```

**约定**:
- 事件名建议使用反向域名格式，如 `com.heikki.example`
- `componentWillUnmount` / `dealloc` 会自动取消订阅，无需手动 off
- `JTComponentsAssemblyView` 本身也遵循 `JTComponentCommunicationProtocol`，可在 VC 层监听事件

## Header 吸顶

通过 `pinningBehaviorForHeader` 控制（枚举 `JTComponentHeaderPinningBehavior`）：

| 值 | 行为 |
|---|---|
| `JTComponentHeaderPinningBehaviorNone` | 不吸顶（默认） |
| `JTComponentHeaderPinningBehaviorPin` | 吸顶，直到下一个 Pin/AlwaysPin Header 将其顶出 |
| `JTComponentHeaderPinningBehaviorAlwaysPin` | 一直吸顶，且占用滚动区域偏移 |

实现原理：`JTComponentLayout` 使用系统 `UICollectionElementKindSectionHeader` 作为占位（fake header），真实 Header 使用自定义 kind `JTComponentElementKindSectionHeader` 单独布局。

## 拖拽排序（Interactive Movement）

开启 `allowsInteractiveMovement = YES` 后，长按 Item 可拖拽。组件需重写 `JTComponent (Movable)` 方法：

```objc
- (BOOL)canMoveItemAtIndex:(NSInteger)index;           // 是否允许拖出，默认 NO
- (BOOL)canMoveItemToIndex:(NSInteger)destinationIndex
             fromComponent:(JTComponent *)sourceComponent
                   atIndex:(NSInteger)sourceIndex;     // 是否允许放入，默认同 section
- (id)didMoveItemFromIndex:(NSInteger)index;           // 返回被移走的数据
- (void)didMoveItem:(id)item toIndex:(NSInteger)index;  // 接收数据并插入
```

支持跨组件（跨 section）拖拽，需在 `canMoveItemToIndex:fromComponent:atIndex:` 中显式允许。

## 页面生命周期

`JTComponentsAssemblyView` 遵循 `JTComponentPageLifeCycleProtocol`。在 ViewController 中手动转发：

```objc
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.assemblyView pageWillAppear:animated];
}
// pageDidAppear / pageWillDisappear / pageDidDisappear 同理
```

组件可重写对应方法响应页面显隐。

## Scroll 事件

组件可实现 `UIScrollViewDelegate` 方法（通过 `JTComponent (Scroll)` category）。`JTComponentsAssemblyView` 会将 scroll 事件广播给所有实现了对应 selector 的组件。

## Swift 集成

Swift 组件继承 `JTComponent`，使用 `@objc` / `@objcMembers` 暴露给 ObjC runtime：

```swift
@objcMembers class MyComponent: JTComponent {
    override func numberOfItems() -> Int { 10 }
    override func sizeForItem(at index: Int) -> CGSize { .init(width: 60, height: 60) }
    override func itemView(for index: Int) -> UIView {
        let view = dequeueReusableItemView(of: UIView.self, for: index)
        view.backgroundColor = .yellow
        return view
    }
}
```

参考 `Example/Example/Playground.swift` 与 `Example/Example/Components/C/JTCComponent.swift`。

## 内置组件

### JTSpacingComponent

用于模块间留白，仅设置 `insets` 的 top 和 left：

```objc
[JTSpacingComponent componentWithSpacing:100]
```

## 重要约束与陷阱

1. **组件实例不可重复**: `assembleComponents:` 在 DEBUG 下断言数组中不能有相同 Component 对象
2. **setup 只调用一次**: 通过 `hasSetup` 标记；重新 assemble 同一实例不会再次 setup，但会调用 `componentDidMount`
3. **Header 尺寸为零**: `headerSize` 返回 `CGSizeZero` 时不展示 Header
4. **Background zIndex**: 仅 `zIndex < 0` 的背景视图会在 cell 下层渲染
5. **不要手动注册 Cell**: 使用 `dequeueReusableItemViewOfClass:` 即可，`JTCollectionView` 会自动处理
6. **renderView 层级**: `itemViewForIndex:` 返回的 View 已被嵌入 `JTComponentCell`，不要再手动 addSubview 到 CollectionView
7. **私有 API**: `JTComponent_Private.h`、`JTComponentCell`、`JTComponentLayout` 等为内部实现，业务代码不应依赖
8. **assembleComponents 会 reloadData**: 更新组件列表后整页刷新，局部更新请用 `[component reloadData]`

## 构建与调试

```bash
# CocoaPods 示例
cd Example && pod install
open Example.xcworkspace

# SPM
swift build
```

示例入口：
- ObjC: `Example/Example/ViewController.m`
- Swift: `Example/Example/Playground.swift` → `JTViewController`

## 修改框架时的注意事项

| 场景 | 关注文件 |
|---|---|
| 新增 Component 可重写 API | `JTComponent.h/.m`，同步更新 `JTComponentsAssemblyView.m` 转发 |
| 修改吸顶逻辑 | `JTComponentLayout.m` |
| 修改复用机制 | `JTCollectionView.m`、`JTComponentCell.m`、`JTComponentReusableView.m` |
| 修改事件系统 | `EventHub/` 目录 |
| 新增 SupplementaryView kind | `JTComponentDefines.h`，Layout 与 AssemblyView 需同步 |

保持 ObjC 公开 API 稳定；Swift 侧通过 ObjC 桥接头文件 `Example/Example/Example-Bridging-Header.h` 引用。

## 代码风格

- 框架使用 Objective-C，遵循 Apple 命名规范（`JT` 前缀）
- Category 按能力拆分：`Communication`、`Movable`、`PageLifeCycle`、`Scroll`、`Pin`
- 示例组件按 A/B/C 分组，Header/Item/Footer View 独立文件
- 新增组件时优先参考 `JTAComponent`（功能完整）和 `Playground.swift`（Swift 模式）

## 常见任务速查

| 任务 | 做法 |
|---|---|
| 新增页面模块 | 继承 `JTComponent`，实现 Items 相关方法，加入 `assembleComponents:` 数组 |
| 模块间传数据 | `emit` / `on` 事件，或 assemble 前注入属性 |
| 模块间留白 | 插入 `JTSpacingComponent` |
| Header 吸顶 | 重写 `pinningBehaviorForHeader` |
| Section 背景色 | 实现 `backgroundView` + `zIndexForBackgroundView`（负值） |
| 横向滚动 | `assemblyView.scrollDirection = UICollectionViewScrollDirectionHorizontal` |
| 跳转到某模块 | `[component scrollToSelf:YES]` 或监听事件后调用 |
| 局部刷新 | `[self reloadData]`（组件内） |
