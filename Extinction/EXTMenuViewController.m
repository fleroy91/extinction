//
//  EXTMenuViewController.m
//  Extinction
//
//  Created by Frédéric Leroy on 25/03/2014.
//  Copyright (c) 2014 Frédéric Leroy. All rights reserved.
//

#import "EXTMenuViewController.h"
#import "Game.h"

@interface EXTMenuViewController ()

@end

@implementation EXTMenuViewController

- (IBAction)unwindToMenu:(UIStoryboardSegue *)segue
{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    int a= 0;
}

@end
