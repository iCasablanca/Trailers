//
//  TrailerView.h
//  Trailers
//

#import <UIKit/UIKit.h>
@class Trailer;
@class TrailersViewController;
@interface TrailerView : UIView <UITableViewDelegate,UITableViewDataSource> {
    Trailer *trailer;
    
    UIImage *image;
    NSMutableData *imageData;
    NSURLConnection *imageConnection;
	
	UIPopoverController *pop;
	TrailersViewController *trailersViewController;
}

@property (nonatomic,retain) Trailer *trailer;
@property (nonatomic,retain) TrailersViewController *trailersViewController;

- (id)initWithTrailer:(Trailer*)trailer;
+ (TrailerView*)viewWithTrailer:(Trailer*)trailer;
- (void)rotate;
- (void)startImage;

@end
