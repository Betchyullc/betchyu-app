//
//  CreateBetVC.m
//  betchyu
//
//  Created by Adam Baratz on 6/16/14.
//  Copyright (c) 2014 BetchyuLLC. All rights reserved.
//

#import "CreateBetVC.h"

@interface CreateBetVC ()

@end

@implementation CreateBetVC

@synthesize betTypes;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        // remove the "Create Bet" from the back button on following pages
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        
        betTypes = [[NSMutableArray alloc] init];
        [betTypes addObject:@"Lose Weight"];
        [betTypes addObject:@"Stop Smoking"];
        [betTypes addObject:@"Run More"];
        [betTypes addObject:@"Workout More"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 75;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = NO;
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.betTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [self.betTypes objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:18.0];
    cell.textLabel.textColor = Bmid;
    UIImage *img;
    if ([[self.betTypes objectAtIndex:indexPath.row] isEqualToString:@"Lose Weight"]) {
        img = [UIImage imageNamed:@"scale-circle.png"];
    } else if ([[self.betTypes objectAtIndex:indexPath.row] isEqualToString:@"Stop Smoking"]) {
        img = [UIImage imageNamed:@"smoke-circle.png"];
    } else if ([[self.betTypes objectAtIndex:indexPath.row] isEqualToString:@"Run More"]) {
        img = [UIImage imageNamed:@"run-circle.png"];
    } else if ([[self.betTypes objectAtIndex:indexPath.row] isEqualToString:@"Workout More"]) {
        img = [UIImage imageNamed:@"workout-circle.png"];
    }
    cell.imageView.image = img;
    
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-16.png"]];
    ((UIImageView *)cell.accessoryView).image = [((UIImageView *)cell.accessoryView).image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    ((UIImageView *)cell.accessoryView).tintColor = Bmid;
    ((UIImageView *)cell.accessoryView).bounds = CGRectMake(0, 0, 10, 20);

    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"I want to:";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 500, 32)];
    title.text = @"\tI want to:";
    title.font = [UIFont fontWithName:@"ProximaNova-Regular" size:18.0];
    title.textColor = Borange;
    
    UIView *line = [UIView new];
    line.frame = CGRectMake(0, title.frame.size.height - 2, title.frame.size.width, 2);
    line.backgroundColor = Bmid;
    [title addSubview:line];
    
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0;
}

// moves to next step in flow
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *verb = [self.betTypes objectAtIndex:indexPath.row];
    BetDetailsVC *vc =[[BetDetailsVC alloc] initWithBetVerb:verb];
    vc.title = @"Bet Options";
    [self.navigationController pushViewController:vc animated:true];
    return NO;
}

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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
