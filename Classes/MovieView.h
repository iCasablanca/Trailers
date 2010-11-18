//
//  MovieView.h
//  Trailers
//

#import <UIKit/UIKit.h>
@class Movie;
@class TrailersViewController;
@class MovieDetailView;

@interface MovieView : UIView {
    Movie *movie;
    MovieDetailView *detailView;
    
    BOOL highlighted;
	BOOL expanded;

	NSString *posterPath;
	NSMutableData *posterData;
	NSURLConnection *posterConnection;
    
	CGRect initialRect;
    
    TrailersViewController *trailersViewController;
}

@property (nonatomic,retain) Movie *movie;
@property (nonatomic,retain) MovieDetailView *detailView;
@property (nonatomic,retain) TrailersViewController *trailersViewController;

- (id)initWithMovie:(Movie*)movie;
+ (MovieView*)viewWithMovie:(Movie*)movie;

- (void)startPoster;

- (void)setUpDetailView;
- (void)updateDetailDescription;
- (void)updateDetailTrailers;

- (void)layoutInSuperView;
- (void)layoutDetailView;
- (void)setInitialRect:(CGRect)rect;


@end
