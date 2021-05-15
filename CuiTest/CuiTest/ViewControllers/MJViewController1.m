//
//  MJViewController1.m
//  MJTestDemo
//
//  Created by 崔林豪 on 2021/5/4.
//

#import "MJViewController1.h"

//Darwin.Mach.task

//#import <Darwin.apinotes>
#include <mach/task.h>
#include <mach/vm_map.h>
#include <mach/mach_init.h>
#include <mach/thread_act.h>





@interface MJViewController1 ()

@end

@implementation MJViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.view.backgroundColor = UIColor.systemRedColor;
	NSInteger ff =  [MJViewController1 cpuUsage];
	NSLog(@"_____%ld", (long)ff);
	
//	[self test1];
//	[self test2];
//	[self test3];
	[self test4];
	
}


/** 注释
 https://time.geekbang.org/column/article/90546
 
 
 因为每个线程都会有这个 thread_basic_info 结构体，所以接下来的事情就好办了，你只需要定时（比如，将定时间隔设置为 2s）去遍历每个线程，累加每个线程的 cpu_usage 字段的值，就能够得到当前 App 所在进程的 CPU 使用率了。实现代码如下：
 
 */

struct thread_basic_info11 {
  time_value_t    user_time;     // 用户运行时长
  time_value_t    system_time;   // 系统运行时长
  integer_t       cpu_usage;     // CPU 使用率
  policy_t        policy;        // 调度策略
  integer_t       run_state;     // 运行状态
  integer_t       flags;         // 各种标记
  integer_t       suspend_count; // 暂停线程的计数
  integer_t       sleep_time;    // 休眠的时间
};


+ (integer_t)cpuUsage {
	
	thread_act_array_t threads; //int 组成的数组比如 thread[1] = 5635
	mach_msg_type_number_t threadCount = 0; //mach_msg_type_number_t 是 int 类型
	const task_t thisTask = mach_task_self();
	//根据当前 task 获取所有线程
	kern_return_t kr = task_threads(thisTask, &threads, &threadCount);
	
	if (kr != KERN_SUCCESS) {
		return 0;
	}
	
	integer_t cpuUsage = 0;
	// 遍历所有线程
	for (int i = 0; i < threadCount; i++) {
		
		thread_info_data_t threadInfo;
		thread_basic_info_t threadBaseInfo;
		mach_msg_type_number_t threadInfoCount = THREAD_INFO_MAX;
		
		if (thread_info((thread_act_t)threads[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount) == KERN_SUCCESS) {
			// 获取 CPU 使用率
			threadBaseInfo = (thread_basic_info_t)threadInfo;
			if (!(threadBaseInfo->flags & TH_FLAGS_IDLE)) {
				cpuUsage += threadBaseInfo->cpu_usage;//CPU 使用率
				
			}
		}
	}
	assert(vm_deallocate(mach_task_self(), (vm_address_t)threads, threadCount * sizeof(thread_t)) == KERN_SUCCESS);
	return cpuUsage;
}

- (void)printThreadCount
{
	kern_return_t kr = { 0 };
	thread_array_t thread_list = { 0 };
	mach_msg_type_number_t thread_count = { 0 };
	
	////根据当前 task 获取所有线程
	//kern_return_t kr = task_threads(thisTask, &threads, &threadCount);
	kr = task_threads(mach_task_self(), &thread_list, &thread_count);
	
	
	if (kr != KERN_SUCCESS) {
		return;
	}
	NSLog(@"线程数量:%@", @(thread_count));

	kr = vm_deallocate( mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t) );
	if (kr != KERN_SUCCESS) {
		return;
	}
	return;
}


#pragma mark - 全局队列 - CPU 繁忙
- (void)test1 {
	//经过测试：线程数量是 2
	/** 注释
	 2021-05-04 22:27:01.802939+0800 MJTestDemo[27215:1615073] GCD 创建的线程数量:12
	 2021-05-04 22:27:01.803263+0800 MJTestDemo[27215:1615073] 线程数量:15
	 
	 */
	NSMutableSet<NSThread *> *set = [NSMutableSet set];
	for (int i=0; i < 1000; i++) {
		dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
		dispatch_async(queue, ^{
			NSThread *thread = [NSThread currentThread];
			[set addObject:[NSThread currentThread]];
			dispatch_async(dispatch_get_main_queue(), ^{
				NSLog(@"开始:%@", thread);
				NSLog(@"GCD 创建的线程数量:%lu",(unsigned long)set.count);
				[self printThreadCount];
			});

			NSDate *date = [NSDate dateWithTimeIntervalSinceNow:10];
			long i=0;
			while ([date compare:[NSDate date]]) {
				i++;
			}
			[set removeObject:thread];
			NSLog(@"结束:%@", thread);
		});
	}
}

#pragma mark - 全局队列 - CPU 空闲
//线程数量最高是 64 个
//2021-05-04 22:29:10.973620+0800 MJTestDemo[32619:1638432] GCD 创建的线程数量:64
//2021-05-04 22:29:10.973863+0800 MJTestDemo[32619:1638432] 线程数量:67
- (void)test2 {

	NSMutableSet<NSThread *> *set = [NSMutableSet set];
	for (int i=0; i < 1000; i++) {
		dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
		dispatch_async(queue, ^{
			NSThread *thread = [NSThread currentThread];
			[set addObject:[NSThread currentThread]];
			dispatch_async(dispatch_get_main_queue(), ^{
				NSLog(@"开始:%@", thread);
				NSLog(@"GCD 创建的线程数量:%lu",(unsigned long)set.count);
				[self printThreadCount];
			});
			// 当前线程睡眠 10 秒
			[NSThread sleepForTimeInterval:10];
			[set removeObject:thread];
			NSLog(@"结束:%@", thread);
			return;
		});
	}
}


#pragma mark - 自建队列 - CPU 繁忙
//GCD 创建的线程数量最高是 512 个

- (void)test3 {
	NSMutableSet<NSThread *> *set = [NSMutableSet set];
	for (int i=0; i < 1000; i++) {
		const char *label = [NSString stringWithFormat:@"label-:%d", i].UTF8String;
		NSLog(@"创建:%s", label);
		dispatch_queue_t queue = dispatch_queue_create(label, DISPATCH_QUEUE_SERIAL);
		dispatch_async(queue, ^{
			NSThread *thread = [NSThread currentThread];
			[set addObject:[NSThread currentThread]];

			dispatch_async(dispatch_get_main_queue(), ^{
				static NSInteger lastCount = 0;
				if (set.count <= lastCount) {
					return;
				}
				lastCount = set.count;
				NSLog(@"开始:%@", thread);
				NSLog(@"GCD 创建的线程数量:%lu",(unsigned long)set.count);
				[self printThreadCount];
			});

			NSDate *date = [NSDate dateWithTimeIntervalSinceNow:10];
			long i=0;
			while ([date compare:[NSDate date]]) {
				i++;
			}
			[set removeObject:thread];
			NSLog(@"结束:%@", thread);
		});
	}
}


#pragma mark - 自建队列 - CPU 空闲
//创建的线程数量最高是 512 个
//2021-05-04 22:30:57.085367+0800 MJTestDemo[38837:1665532] GCD 创建的线程数量:512
//2021-05-04 22:30:57.085573+0800 MJTestDemo[38837:1665532] 线程数量:514

- (void)test4 {
	NSMutableSet<NSThread *> *set = [NSMutableSet set];
	for (int i=0; i < 10000; i++) {
		const char *label = [NSString stringWithFormat:@"label-:%d", i].UTF8String;
		NSLog(@"创建:%s", label);
		dispatch_queue_t queue = dispatch_queue_create(label, DISPATCH_QUEUE_SERIAL);
		dispatch_async(queue, ^{
			NSThread *thread = [NSThread currentThread];

			dispatch_async(dispatch_get_main_queue(), ^{
				[set addObject:thread];
				static NSInteger lastCount = 0;
				if (set.count <= lastCount) {
					return;
				}
				lastCount = set.count;
				NSLog(@"开始:%@", thread);
				NSLog(@"GCD 创建的线程数量:%lu",(unsigned long)set.count);
				[self printThreadCount];
			});

			[NSThread sleepForTimeInterval:10];
			dispatch_async(dispatch_get_main_queue(), ^{
				[set removeObject:thread];
				NSLog(@"结束:%@", thread);
			});
		});
	}
}

#pragma mark - 经过测试，GCD 的全局队列会自动将线程数量限制在一个比较合理的数量。与之相比，自建队列创建的线程数量会偏大。 考虑到线程数量过大会导致 CPU 调度成本上涨。

-(void)dealloc
{
	NSLog(@"__%s__销毁了");
	
}


@end
