//
//  HelloWorldLayer.m
//  lightning
//
//  Created by 金 珍奕 on 12/07/31.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "testnode.h"
#import "Lightning.h"

// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
//		// create and initialize a Label
//		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
//
//		// ask director for the window size
//		CGSize size = [[CCDirector sharedDirector] winSize];
//	
//		// position the label on the center of the screen
//		label.position =  ccp( size.width /2 , size.height/2 );
//		
//		// add the label as a child to this Layer
//		[self addChild: label];
//		
//		
//		
//		//
//		// Leaderboards and Achievements
//		//
//		
//		// Default font size will be 28 points.
//		[CCMenuItemFont setFontSize:28];
//		
//		// Achievement Menu Item using blocks
//		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
//			
//			
//			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
//			achivementViewController.achievementDelegate = self;
//			
//			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//			
//			[[app navController] presentModalViewController:achivementViewController animated:YES];
//			
//			[achivementViewController release];
//		}
//									   ];
//
//		// Leaderboard Menu Item using blocks
//		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
//			
//			
//			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
//			leaderboardViewController.leaderboardDelegate = self;
//			
//			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//			
//			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
//			
//			[leaderboardViewController release];
//		}
//									   ];
//		
//		CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
//		
//		[menu alignItemsHorizontallyWithPadding:20];
//		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
//		
//		// Add the menu to the layer
//		[self addChild:menu];

        
//        Lightning* lig = [Lightning lightningWithStrikePoint: ccp(100, 0)];
//        lig.position = ccp(220, 320);
//        [self addChild: lig];
        
        testnode* node = [testnode testnode];
        [self addChild: node];
        
        
//        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate: self
//                                                         priority: 0
//                                                  swallowsTouches: YES];
        
        NSMutableArray* ar = [NSMutableArray arrayWithCapacity: 20];
        
        for (int i = 0; i < 20; i++)
        {
            Lightning* lightning = [Lightning lightningWithStrikePoint: ccp(0, 100)];
            lightning.position = ccp(100, 100);
            [self addChild: lightning];
            [ar addObject: lightning];
            [lightning strikeRandom];
        }
        
        lightningList_ = [[NSArray arrayWithArray: ar] retain];
        
        
        //        [self scheduleUpdate];
//        [self schedule: @selector(update:)
//              interval: 0.1f];
        
        point_.x = 100;
        point_.y = 100;
        
        
	}
	return self;
}

- (void) update: (ccTime)dt
{
    for (Lightning* lightning in lightningList_)
    {
        //        lightning.strikePoint = ccp(0, 0);
        //        lightning.strikePoint2 = location;
        lightning.strikePoint = ccp(480 - point_.x, 320 - point_.y);
        lightning.position = point_;
        [lightning strikeRandom];
        //        lightning.color = ccc3(rand() % 255, rand() % 255, rand() % 255);
    }
}

- (BOOL) ccTouchBegan: (UITouch*)touch
            withEvent: (UIEvent*)event
{
    CGPoint locationInView = [touch locationInView: [touch view]];
    CGPoint location = [[CCDirector sharedDirector] convertToGL: locationInView];
    
    point_.x = location.x;
    point_.y = location.y;
    //    for (Lightning* lightning in lightningList_)
    //    {
    ////        lightning.strikePoint = ccp(0, 0);
    ////        lightning.strikePoint2 = location;
    //        lightning.strikePoint = ccp(480 - location.x, 320 - location.y);
    //        lightning.position = location;
    //        [lightning strikeRandom];
    //    }
    
    //    Lightning *l = [Lightning lightningWithStrikePoint: location];
    ////    l.position = sprite.position;
    //    [self addChild:l];
    //    [l strikeRandom];
    
    return YES;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
