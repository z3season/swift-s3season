//
//  RunLoopVC.swift
//  SwiftS3season
//
//  Created by season on 2021/8/4.
//

import UIKit

/**
 一个RunLopp 包含若干个Mode，每个Mode又包含若干个_sources0/_sources1/observer/timer
 RunLoop只能选择其中一个Mode 作为CurrentMode
 如果需要切换Mode 退出Loop 在Loop内部 再重新选择一个Mode进入
 不同Mode模式下的_sources0/_sources1/observer/timer可以分隔开来，互不影响
 */

/**
 常见的Mode
 
1，kCFRunLoopDefaultMode（swift：RunLoop.Mode.default  / CFRunLoopMode.defaultMode）
 App的默认Mode 通常主线程在这个Mode下运行
 
 2,UITrackingRunLoopMode (swift：RunLoop.Mode.tracking)
 界面跟踪Mode，用于ScrollView追踪触摸滑动 保证界面不受其它Mode影响
 
 3,kCFRunLoopCommonModes（swift：CFRunLoopMode.commonModes）通用模式 表示1，2都会监听
 */

// MARK: sources0/_sources1/observer/timer
/**
 source0
 触摸事件处理
 performSelector: onThread:
 
 source1
 基于Port的线层通信
 系统事件捕捉
 
 observers
 用于监听RunLoop状态
 UI刷新（BeforeWaiting）
 autorelease pool
 
 timers
 NSTimer
 performSelector: withObject: afterDelay:
 */

/**
 typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
     kCFRunLoopEntry = (1UL << 0), // 即将进入RunLoop
     kCFRunLoopBeforeTimers = (1UL << 1), 即将处理Timer
     kCFRunLoopBeforeSources = (1UL << 2), 即将处理Sourece
     kCFRunLoopBeforeWaiting = (1UL << 5), 即将进入休眠
     kCFRunLoopAfterWaiting = (1UL << 6), 刚从休眠中唤醒
     kCFRunLoopExit = (1UL << 7), 即将退出RunLoop
     kCFRunLoopAllActivities = 0x0FFFFFFFU
 };
 */

// MARK: bt可以打印完整的函数调用栈

class RunLoopVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
//        CFRunLoopObserverCreate(<#T##allocator: CFAllocator!##CFAllocator!#>, <#T##activities: CFOptionFlags##CFOptionFlags#>, <#T##repeats: Bool##Bool#>, <#T##order: CFIndex##CFIndex#>, <#T##callout: CFRunLoopObserverCallBack!##CFRunLoopObserverCallBack!##(CFRunLoopObserver?, CFRunLoopActivity, UnsafeMutableRawPointer?) -> Void#>, <#T##context: UnsafeMutablePointer<CFRunLoopObserverContext>!##UnsafeMutablePointer<CFRunLoopObserverContext>!#>)


        // 创建observer
        let observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.allActivities.rawValue, true, 0) { (observer, activity) in
//CFRunLoopActivity
            switch activity {
            case CFRunLoopActivity.afterWaiting: do {
                    print("CFRunLoopActivity.afterWaiting")
                }
                default:
                break
            }
            
        }
        // 添加observer到RunLoop
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, CFRunLoopMode.commonModes)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("")
    }
    
}

/**
 struct __CFRunLoop {
     CFRuntimeBase _base;
     pthread_mutex_t _lock;            /* locked for accessing mode list */
     __CFPort _wakeUpPort;            // used for CFRunLoopWakeUp
     Boolean _unused;
     volatile _per_run_data *_perRunData;              // reset for runs of the run loop
     pthread_t _pthread;
     uint32_t _winthread;
     CFMutableSetRef _commonModes;
     CFMutableSetRef _commonModeItems;
     CFRunLoopModeRef _currentMode;
     CFMutableSetRef _modes;
     struct _block_item *_blocks_head;
     struct _block_item *_blocks_tail;
     CFAbsoluteTime _runTime;
     CFAbsoluteTime _sleepTime;
     CFTypeRef _counterpart;
 };
 
 struct __CFRunLoopMode {
     CFRuntimeBase _base;
     pthread_mutex_t _lock;    /* must have the run loop locked before locking this */
     CFStringRef _name;
     Boolean _stopped;
     char _padding[3];
     CFMutableSetRef _sources0;
     CFMutableSetRef _sources1;
     CFMutableArrayRef _observers;
     CFMutableArrayRef _timers;
     CFMutableDictionaryRef _portToV1SourceMap;
     __CFPortSet _portSet;
     CFIndex _observerMask;
 #if USE_DISPATCH_SOURCE_FOR_TIMERS
     dispatch_source_t _timerSource;
     dispatch_queue_t _queue;
     Boolean _timerFired; // set to true by the source when a timer has fired
     Boolean _dispatchTimerArmed;
 #endif
 #if USE_MK_TIMER_TOO
     mach_port_t _timerPort;
     Boolean _mkTimerArmed;
 #endif
 #if DEPLOYMENT_TARGET_WINDOWS
     DWORD _msgQMask;
     void (*_msgPump)(void);
 #endif
     uint64_t _timerSoftDeadline; /* TSR */
     uint64_t _timerHardDeadline; /* TSR */
 };

// 屏幕的点击事件等
 struct __CFRunLoopSource {
     CFRuntimeBase _base;
     uint32_t _bits;
     pthread_mutex_t _lock;
     CFIndex _order;            /* immutable */
     CFMutableBagRef _runLoops;
     union {
     CFRunLoopSourceContext version0;    /* immutable, except invalidation */
         CFRunLoopSourceContext1 version1;    /* immutable, except invalidation */
     } _context;
 };
 
 // 监听事件
 struct __CFRunLoopObserver {
     CFRuntimeBase _base;
     pthread_mutex_t _lock;
     CFRunLoopRef _runLoop;
     CFIndex _rlCount;
     CFOptionFlags _activities;        /* immutable */
     CFIndex _order;            /* immutable */
     CFRunLoopObserverCallBack _callout;    /* immutable */
     CFRunLoopObserverContext _context;    /* immutable, except invalidation */
 };

 // 定时器时间
 struct __CFRunLoopTimer {
     CFRuntimeBase _base;
     uint16_t _bits;
     pthread_mutex_t _lock;
     CFRunLoopRef _runLoop;
     CFMutableSetRef _rlModes;
     CFAbsoluteTime _nextFireDate;
     CFTimeInterval _interval;        /* immutable */
     CFTimeInterval _tolerance;          /* mutable */
     uint64_t _fireTSR;            /* TSR units */
     CFIndex _order;            /* immutable */
     CFRunLoopTimerCallBack _callout;    /* immutable */
     CFRunLoopTimerContext _context;    /* immutable, except invalidation */
 };

 */
