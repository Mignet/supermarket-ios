1. 开发过程中，我们在podfile中加入:

    pod 'MLeaksFinder'    #用于测试内存泄漏和循环引用问题引入
    pod 'FBRetainCycleDetector'

用于检测内存泄漏和引用循环并马上进行修复操作

在测试阶段和发布上线，则删除podfile中的:

    pod 'MLeaksFinder'    #用于测试内存泄漏和循环引用问题引入
    pod 'FBRetainCycleDetector'


减少包的大小

2. 检测页面是否卡顿情况（通过runloop或者cadisplaylink）
pod 'FHHFPSIndicator' ---通过CADisplayLink查看刷新帧数

[self.mainWindow makeKeyAndVisible];后面（同时去除预发布提示）

[[[FHHFPSIndicator sharedFPSIndicator] show];
[[FHHFPSIndicator sharedFPSIndicator] setFpsLabelPosition:FPSIndicatorPositionBottomCenter];

PerformanceMonitor 通过runloop查看卡顿情况

