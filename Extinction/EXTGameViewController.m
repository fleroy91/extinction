//
//  EXTGameViewController.m
//  Extinction
//
//  Created by Frédéric Leroy on 28/03/2014.
//  Copyright (c) 2014 Frédéric Leroy. All rights reserved.
//

#import "EXTGameViewController.h"
#import "Game.h"
#import "EXTImageRowView.h"

@interface EXTGameViewController ()
@property NSMutableArray *rows;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property Game *game;
@property NSTimer *timer;
@property NSTimeInterval ellapsedTime;
@property (weak, nonatomic) IBOutlet UILabel *FlashLabel;
@property (weak, nonatomic) IBOutlet UILabel *FastLabel;
@property (weak, nonatomic) IBOutlet UILabel *SlowLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *timeProgressBar;
@property (weak, nonatomic) IBOutlet UIImageView *bigCircle;
- (IBAction)startGame:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

- (EXTImageRowView *)createRowView:(int)row_index;
- (IBAction)doGo:(id)sender;

- (void)manageProgressBar;

- (void)deallocGame;
- (void)initGame;


@end

@implementation EXTGameViewController

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
    self.rows = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (EXTImageRowView *)createRowView:(int)row_index {
    CGFloat decal_x = self.game.width / 2;
    if(fmod(row_index, 2) == 1) {
        decal_x += self.game.width / 2;
    }
    
    CGPoint start = CGPointMake(decal_x - self.game.nbCols * self.game.width, 100 + row_index * self.game.height);
    CGSize size = CGSizeMake(3 * self.game.nbCols * self.game.width, self.game.width);
    CGRect rect = {start, size};
    GameRow *row = [self.game rowAt:row_index];
    row.decalX = decal_x;
    EXTImageRowView *view = [[EXTImageRowView alloc] initWithFrame:rect andGameRow:row];
    row.view = view;
    if([row canMove]) {
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
                                                 initWithTarget:view action:@selector(panRow:)];
        // Add the tap gesture recognizer to the view
        [view addGestureRecognizer:panRecognizer];
    }
    return view;
}

- (void)addHiderViews:(int)row_index {
    CGFloat decal_x = self.game.width / 2;
    if(fmod(row_index, 2) == 1) {
        decal_x += self.game.width / 2;
    }
    
    CGSize size = CGSizeMake(2 * self.game.width, self.game.width);
    GameRow *row = [self.game rowAt:row_index];
    
    CGPoint start = CGPointMake(decal_x - 2 * self.game.width, 100 + row_index * self.game.height);
    CGRect rect = {start, size};
    row.decalX = decal_x;
    EXTImageRowView *view = [[EXTImageRowView alloc] initHiderWithFrame:rect andGameRow:row andInput:left andWidth:self.game.width];
    // [view setBackgroundColor:[UIColor redColor]];
    [self.containerView addSubview:view];
    
    start = CGPointMake(decal_x + self.game.nbCols * self.game.width, 100 + row_index * self.game.height);
    rect = CGRectMake(start.x, start.y, size.width, size.height);
    view = [[EXTImageRowView alloc] initHiderWithFrame:rect andGameRow:row andInput:right andWidth:self.game.width];
    // [view setBackgroundColor:[UIColor redColor]];
    [self.containerView addSubview:view];
}

- (IBAction)doGo:(id)sender {
    [self.timer invalidate];
    Boolean isSolved = [self.game isSolved];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(isSolved ? @"Game won :D" : @"Game lost :-(")
                                                    message:(isSolved ? @"You succeed : congrats. Try again ?" : @"There is still some fires")
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)startGame:(id)sender {
    [self deallocGame];
    // TODO : what game difficulty ?
    self.game = [[Game alloc] init:easy];
    [self initGame];
}
- (void)manageProgressBar {
    self.ellapsedTime++;
    float progress = self.ellapsedTime / (self.game.nbSecondsToSolve * 10);
    if(progress >= 1) {
        [self doGo:NULL];
    }
    [self.timeProgressBar setProgress:progress animated:YES];
    self.FlashLabel.enabled = (progress < (0.5 * 0.35));
    self.FastLabel.enabled = (progress >= (0.5 * 0.35) && progress < 0.5);
    self.SlowLabel.enabled = (progress >= 0.5);
}

-(void)initGame
{
    for(int row = 0; row < self.game.nbRows; row++) {
        EXTImageRowView *rowView = [self createRowView:row];
        [self.rows addObject:rowView];
        [self.containerView addSubview:rowView];
    }
    for(int row = 0; row < self.game.nbRows; row++) {
        [self addHiderViews:row];
    }
    
    // We start the timer
    self.ellapsedTime = 0;
    [self.timeProgressBar setProgress:0 animated:YES];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(manageProgressBar) userInfo:nil repeats:YES];
}

- (void)deallocGame
{
    if(self.timer) {
        [self.timer invalidate];
        self.timer = NULL;
    }
    if(self.game) {
        for(int i =0; i < [self.rows count]; i++) {
            [self.rows[i] removeFromSuperview];
        }
    }
}
@end
