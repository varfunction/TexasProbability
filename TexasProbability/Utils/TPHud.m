//
//  TPHud.m
//  TexasProbability
//
//  Created by ocean tang on 14-6-23.
//  Copyright (c) 2014年 ocean tang. All rights reserved.
//

#import "TPHud.h"
#import <MBProgressHUD.h>

#define WINDOW_LEVEL_FOR_SHOW (UIWindowLevelStatusBar + 10.0f)
#define WINDOW_LEVEL_FOR_HIDE (-1.0f)

static UIWindow *hudWindow = nil;

@interface UIWindow(Hud)

- (void)showWin;
- (void)hideWin;

@end

@implementation UIWindow(Hud)

- (void)showWin
{
    hudWindow.windowLevel = WINDOW_LEVEL_FOR_SHOW;
    hudWindow.hidden = NO;
}

- (void)hideWin
{
    self.windowLevel = WINDOW_LEVEL_FOR_HIDE;
    self.hidden = YES;
}

@end

@implementation TPHud

+ (void)hide
{
    [MBProgressHUD hideAllHUDsForView:hudWindow animated:YES];
    [hudWindow hideWin];
}

+ (void)showLoading:(NSString *)message
{
    [self doInMainThread:^{
        [self hide];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self windowForHud] animated:YES];
        hud.removeFromSuperViewOnHide = YES;
        hud.detailsLabelText = message;
    }];
}

+ (UIWindow *)windowForHud
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hudWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    [hudWindow showWin];
    return hudWindow;
}

+ (void)doInMainThread:(dispatch_block_t)block
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), block);
    } else {
        block();
    }
}

@end
