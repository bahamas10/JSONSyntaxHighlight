//
//  ViewController.m
//  JSONSyntaxHighlightiOS
//
//  Created by Dave Eddy on 8/3/13.
//  Copyright (c) 2013 Dave Eddy. All rights reserved.
//

#import "ViewController.h"
#import "JSONSyntaxHighlight.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // read the example JSON
    NSString *path = [NSBundle.mainBundle pathForResource:@"example" ofType:@"json"];
    NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    id JSONObj = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
    // create the JSONSyntaxHighilight Object
    JSONSyntaxHighlight *jsh = [[JSONSyntaxHighlight alloc] initWithJSON:JSONObj];
    
    // place the text into the view
    self.textView.attributedText = [jsh highlightJSON];
}

@end
