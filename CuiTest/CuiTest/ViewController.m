//
//  ViewController.m
//  MJTestDemo
//
//  Created by 崔林豪 on 2021/5/4.
//

#import "ViewController.h"
#import "MJViewController1.h"



@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor purpleColor];
	self.title = @"MJTest";
	[self _initUI];
}

- (void)_initUI
{
	UITableView *tab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
	
	[self.view addSubview:tab];
	tab.delegate = self;
	tab.dataSource = self;
	
	[tab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MyCell"];
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
	
	cell.textLabel.text = @"123";
	
	if (indexPath.row % 2 == 0) {
		cell.contentView.backgroundColor = [UIColor systemRedColor];
	}else {
		cell.contentView.backgroundColor = [UIColor systemBlueColor];
	}
	
	return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0) {
		MJViewController1 *vc = [[MJViewController1 alloc] init];
		[self.navigationController pushViewController:vc animated:YES];
		
		
	}else {
		
	}
}





@end

