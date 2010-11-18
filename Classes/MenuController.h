//
//  MenuController.h
//  Trailers
//

#import <UIKit/UIKit.h>
@class TrailersViewController;

@interface MenuController : UIViewController {
	TrailersViewController *trailersViewController;
	
	IBOutlet UITextField *search;
	
	IBOutlet UIButton *recentButton;
	IBOutlet UIButton *popularButton;
//	IBOutlet UIButton *boxOfficeButton;
//	IBOutlet UIButton *soonButton;
	
	UIImage *menuLeft;
	UIImage *menuLeftHighlighted;
	UIImage *menuLeftSelected;
	UIImage *menuRight;
	UIImage *menuRightHighlighted;
	UIImage *menuRightSelected;
	UIImage *menuCenter;
	UIImage *menuCenterHighlighted;
	UIImage *menuCenterSelected;
}

@property (nonatomic,retain) TrailersViewController *trailersViewController;
@property (nonatomic,retain) IBOutlet UITextField *search;
@property (nonatomic,retain) IBOutlet UIButton *recentButton;
@property (nonatomic,retain) IBOutlet UIButton *popularButton;
//@property (nonatomic,retain) IBOutlet UIButton *boxOfficeButton;
//@property (nonatomic,retain) IBOutlet UIButton *soonButton;

- (IBAction)click:(id)sender;
//- (IBAction)clickPopular:(id)sender;
//- (IBAction)clickBoxOffice:(id)sender;
//- (IBAction)clickSoon:(id)sender;

@end
