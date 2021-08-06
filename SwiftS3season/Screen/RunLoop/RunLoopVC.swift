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
 系统默认注册的5个的Mode
 
 1. kCFRunLoopDefaultMode:（swift：RunLoop.Mode.default  / CFRunLoopMode.defaultMode） App的默认 Mode，通常主线程是在这个 Mode 下运行的。
 2. UITrackingRunLoopMode:  (swift：RunLoop.Mode.tracking)界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 Mode 影响。
 3. UIInitializationRunLoopMode: 在刚启动 App 时第进入的第一个 Mode，启动完成后就不再使用。
 4: GSEventReceiveRunLoopMode: 接受系统事件的内部 Mode，通常用不到。
 5: kCFRunLoopCommonModes: （swift：CFRunLoopMode.commonModes）这是一个占位的 Mode，没有实际作用。


 */

// MARK: sources0/_sources1/observer/timer
/**
 source0
 （Source0只包含了一个回调（函数指针），它并不能主动触发事件。使用时，你需要先调用 CFRunLoopSourceSignal(source)，将这个 Source 标记为待处理，然后手动调用 CFRunLoopWakeUp(runloop) 来唤醒RunLoop，让其处理这个事件。）
 触摸事件处理
 performSelector: onThread:
 
 source1
 （Source1 包含了一个 mach_port 和一个回调（函数指针），被用于通过内核和其他线程相互发送消息。这种 Source 能主动唤醒 RunLoop 的线程，）
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

    var observer: CFRunLoopObserver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        CFRunLoopObserverCreate(kCFAllocatorDefault, CFRunLoopActivity.allActivities.rawValue, true, 0, { (observer, activity, p) in
//
//        }, nil)

        // 创建observer
        self.observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.allActivities.rawValue, true, 0) { (observer, activity) in
            switch activity {
                case CFRunLoopActivity.entry:
                    print("entry")
                case CFRunLoopActivity.beforeTimers:
                    print("beforeTimers")
                case CFRunLoopActivity.beforeSources:
                    print("beforeSources")
                case CFRunLoopActivity.beforeWaiting:
                    print("beforeWaiting")
                case CFRunLoopActivity.afterWaiting:
                    print("afterWaiting")
                case CFRunLoopActivity.exit:
                    print("exit")
                default:
                    break
            }
        }
        
        // 添加observer到RunLoop
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), self.observer, CFRunLoopMode.commonModes)
        
        // 处理timer
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (timer) in
            print("-------- timer 倒计时 -------")
        }
                
    }

    // 处理系统点击事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("--- touchesBegan --- ")
    }
    
    deinit {
        CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), self.observer, CFRunLoopMode.commonModes)
    }
    
}

// MARK: CFRunLoopRef NSRunLoop
/*
 CFRunLoopRef 是在 CoreFoundation 框架内的，它提供了纯 C 函数的 API，所有这些 API 都是线程安全的。
 NSRunLoop 是基于 CFRunLoopRef 的封装，提供了面向对象的 API，但是这些 API 不是线程安全的。
 */

class RunLoopThread: NSObject {
    
}

// MARK: RunLoop运行的步骤
/*
 /// 1. 通知Observers，即将进入RunLoop
 /// 此处有Observer会创建AutoreleasePool: _objc_autoreleasePoolPush();
 __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopEntry);
 do {

     /// 2. 通知 Observers: 即将触发 Timer 回调。
     __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopBeforeTimers);
     /// 3. 通知 Observers: 即将触发 Source (非基于port的,Source0) 回调。
     __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopBeforeSources);
     __CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__(block);

     /// 4. 触发 Source0 (非基于port的) 回调。
     __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__(source0);
     __CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__(block);

     /// 6. 通知Observers，即将进入休眠
     /// 此处有Observer释放并新建AutoreleasePool: _objc_autoreleasePoolPop(); _objc_autoreleasePoolPush();
     __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopBeforeWaiting);

     /// 7. sleep to wait msg.
     mach_msg() -> mach_msg_trap();
     

     /// 8. 通知Observers，线程被唤醒
     __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopAfterWaiting);

     /// 9. 如果是被Timer唤醒的，回调Timer
     __CFRUNLOOP_IS_CALLING_OUT_TO_A_TIMER_CALLBACK_FUNCTION__(timer);

     /// 9. 如果是被dispatch唤醒的，执行所有调用 dispatch_async 等方法放入main queue 的 block
     __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__(dispatched_block);

     /// 9. 如果如果Runloop是被 Source1 (基于port的) 的事件唤醒了，处理这个事件
     __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE1_PERFORM_FUNCTION__(source1);


 } while (...);

 /// 10. 通知Observers，即将退出RunLoop
 /// 此处有Observer释放AutoreleasePool: _objc_autoreleasePoolPop();
 __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopExit);
}

 */

// MARK: 获取RunLoop 线程关系
// 根据获取RunLoop的代码可得知
// 1, 线程和 RunLoop 之间是一一对应的，其关系是保存在一个全局的 Dictionary 里。
// 2, 线程刚创建时并没有 RunLoop，如果你不主动获取，那它一直都不会有。
// 3, RunLoop 的创建是发生在第一次获取时，RunLoop 的销毁是发生在线程结束时。
// 4, 你只能在一个线程的内部获取其 RunLoop（主线程除外）。

/*
 /// 全局的Dictionary，key 是 pthread_t， value 是 CFRunLoopRef
 static CFMutableDictionaryRef __CFRunLoops = NULL;
 /// 访问 __CFRunLoops 时的锁
 #define __CFLock(LP) ({ (void)pthread_mutex_lock(LP); })
 
 // pthread_mutex_lock 互斥锁
 
 /// 获取一个 _CFThreadRef 对应的 RunLoop。
 CF_EXPORT CFRunLoopRef _CFRunLoopGet0(pthread_t t) {
     if (pthread_equal(t, kNilPthreadT)) {
     t = pthread_main_thread_np();
     }
     __CFLock(&loopsLock);
     if (!__CFRunLoops) {
         __CFUnlock(&loopsLock);
    
    // 第一次进入时，初始化全局Dic，并先为主线程创建一个 RunLoop。
     CFMutableDictionaryRef dict = CFDictionaryCreateMutable(kCFAllocatorSystemDefault, 0, NULL, &kCFTypeDictionaryValueCallBacks);
     CFRunLoopRef mainLoop = __CFRunLoopCreate(pthread_main_thread_np());
     CFDictionarySetValue(dict, pthreadPointer(pthread_main_thread_np()), mainLoop);
     if (!OSAtomicCompareAndSwapPtrBarrier(NULL, dict, (void * volatile *)&__CFRunLoops)) {
         CFRelease(dict);
     }
     CFRelease(mainLoop);
         __CFLock(&loopsLock);
     }
    
     /// 直接从 Dictionary 里获取。
     CFRunLoopRef loop = (CFRunLoopRef)CFDictionaryGetValue(__CFRunLoops, pthreadPointer(t));
     __CFUnlock(&loopsLock);
    
    /// 取不到时，创建一个
     if (!loop) {
     CFRunLoopRef newLoop = __CFRunLoopCreate(t);
         __CFLock(&loopsLock);
     loop = (CFRunLoopRef)CFDictionaryGetValue(__CFRunLoops, pthreadPointer(t));
     if (!loop) {
         CFDictionarySetValue(__CFRunLoops, pthreadPointer(t), newLoop);
         loop = newLoop;
     }
         // don't release run loops inside the loopsLock, because CFRunLoopDeallocate may end up taking it
         __CFUnlock(&loopsLock);
     CFRelease(newLoop);
     }
     if (pthread_equal(t, pthread_self())) {
        /// 注册一个回调，当线程销毁时，顺便也销毁其对应的 RunLoop。
         _CFSetTSD(__CFTSDKeyRunLoop, (void *)loop, NULL);
         if (0 == _CFGetTSD(__CFTSDKeyRunLoopCntr)) {
             _CFSetTSD(__CFTSDKeyRunLoopCntr, (void *)(PTHREAD_DESTRUCTOR_ITERATIONS-1), (void (*)(void *))__CFFinalizeRunLoop);
         }
     }
     return loop;
 }
 */

// MARK: C _CFRunLoop的一些结构体
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
