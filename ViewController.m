//
//  ViewController.m
//  Deprocrastinator
//
//  Created by tbredemeier on 5/19/14.
//  Copyright (c) 2014 Mobile Makers Academy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property UIButton *editButton;
@property NSMutableArray *toDoList;
@property UITableViewCell *cell;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.toDoList = [NSMutableArray arrayWithObjects:
                   [NSString stringWithFormat: @"Cut Grass"],
                   [NSString stringWithFormat: @"Get Groceries"],
                   [NSString stringWithFormat: @"Eat Dirt"],
                   [NSString stringWithFormat: @"Make Bean Whip"],
                   nil];
}

- (IBAction)onAddButtonPressed:(id)sender
{
    [self.textField resignFirstResponder];
    [self.toDoList addObject: self.textField.text];
    [self.myTableView reloadData];
    self.textField.text = @"";
}

- (IBAction)onEditButtonPressed:(id)sender
{
    self.editButton = ((UIButton *)sender);
    if([self.editButton.currentTitle isEqualToString:@"Edit"])
        [self.editButton setTitle:@"Done" forState:UIControlStateNormal];
    else
        [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
}

- (IBAction)onSwipe:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    if(swipeGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint point = [swipeGestureRecognizer locationInView:self.myTableView];
        NSIndexPath *path = [self.myTableView indexPathForRowAtPoint:point];
        self.cell = [self.myTableView cellForRowAtIndexPath:path];
        if([self.cell.textLabel.textColor isEqual:[UIColor greenColor]])
            self.cell.textLabel.textColor = [UIColor yellowColor];
        else if([self.cell.textLabel.textColor isEqual:[UIColor yellowColor]])
            self.cell.textLabel.textColor = [UIColor redColor];
        else
            self.cell.textLabel.textColor = [UIColor greenColor];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.toDoList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.cell = [tableView dequeueReusableCellWithIdentifier:@"TODO_Cell"];
    self.cell.textLabel.text = ((NSString*)self.toDoList[indexPath.row]);

    return self.cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.cell = [tableView cellForRowAtIndexPath:indexPath];
    if(![self.editButton.currentTitle isEqualToString:@"Done"])
    {
        self.cell.textLabel.textColor = [UIColor greenColor];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]init];
        alert.title = @"Sure you want to delete?";
        [alert addButtonWithTitle:@"Delete"];
        [alert addButtonWithTitle:@"Cancel"];
        [alert setDelegate:self];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self.toDoList removeObject:self.cell.textLabel.text];
        [self.myTableView reloadData];
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.toDoList removeObject:cell.textLabel.text];
        [self.myTableView reloadData];
    }
}

@end
