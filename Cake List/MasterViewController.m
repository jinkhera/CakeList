//
//  MasterViewController.m
//  Cake List
//
//  Created by Stewart Hart on 19/05/2015.
//  Copyright (c) 2015 Stewart Hart. All rights reserved.
//

#import "MasterViewController.h"
#import "CakeCell.h"

#import <Cake_List-Swift.h>

@interface MasterViewController ()
#pragma mark - vars
@property (strong, nonatomic) NSArray<Cake*> *objects;
@property (strong, nonatomic) CakesDatasource *dataSource;
@end

@implementation MasterViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [[CakesDatasource alloc] initWithTableView:self.tableView cakes:[[NSArray<Cake*> alloc] init]];
    [self getData];
}

#pragma mark - Table View
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - load data
- (void)getData{
    
    [CakeList loadCakes:^(NSArray<Cake *> * cakes) {
        // make sure we are back on the main/ui thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [_dataSource updateWithCakes:cakes];
            [self.tableView reloadData];
        });
    }];
}

@end
