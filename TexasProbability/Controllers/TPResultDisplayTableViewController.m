//
//  TPResultDisplayTableViewController.m
//  TexasProbability
//
//  Created by ocean tang on 14-6-20.
//  Copyright (c) 2014年 ocean tang. All rights reserved.
//

#import "TPResultDisplayTableViewController.h"
#import "TPProbabilityManager.h"

@interface TPResultDisplayTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *HJLabel;
@property (weak, nonatomic) IBOutlet UILabel *JGLabel;
@property (weak, nonatomic) IBOutlet UILabel *HLLabel;
@property (weak, nonatomic) IBOutlet UILabel *THLabel;
@property (weak, nonatomic) IBOutlet UILabel *SZLabel;
@property (weak, nonatomic) IBOutlet UILabel *STLabel;
@property (weak, nonatomic) IBOutlet UILabel *LDLabel;
@property (weak, nonatomic) IBOutlet UILabel *DDLabel;
@property (weak, nonatomic) IBOutlet UILabel *winLabel;
@property (weak, nonatomic) IBOutlet UILabel *adviceLabel;

@end

@implementation TPResultDisplayTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshNotification:)
                                                 name:REFRESH_PB_RESULT
                                               object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)refreshNotification:(NSNotification*)sender
{
    TPProbabilityManager *manager = [TPProbabilityManager sharedInstance];
    self.HJLabel.text = [NSString stringWithFormat:@"皇家：%2.2f%%", manager.HJ_PB * 100];
    self.JGLabel.text = [NSString stringWithFormat:@"金刚：%2.2f%%", manager.JG_PB * 100];
    self.HLLabel.text = [NSString stringWithFormat:@"葫芦：%2.2f%%", manager.HL_PB * 100];
    self.THLabel.text = [NSString stringWithFormat:@"同花：%2.2f%%", manager.TH_PB * 100];
    self.SZLabel.text = [NSString stringWithFormat:@"顺子：%2.2f%%", manager.SZ_PB * 100];
    self.STLabel.text = [NSString stringWithFormat:@"三条：%2.2f%%", manager.ST_PB * 100];
    self.LDLabel.text = [NSString stringWithFormat:@"两对：%2.2f%%", manager.LD_PB * 100];
    self.DDLabel.text = [NSString stringWithFormat:@"单对：%2.2f%%", manager.DD_PB * 100];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
