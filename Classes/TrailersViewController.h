//
//  TrailersViewController.h
//  Trailers
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Movie.h"
@class MenuController;

@interface TrailersViewController : UIViewController {
	MenuController *menu;
    UIScrollView *scrollView;
    UIView *shading;
    
    NSArray *movies;
    MPMoviePlayerViewController *movie;

    int orientation;
}
- (void)loadMoviesWithMode:(MovieMode)mode;
- (void)loadMoviesWithTerm:(NSString*)term;
- (void)loadMoviesRecent;
- (void)loadMoviesPopular;
- (void)loadMoviesWithSearchTerm:(NSString*)term;
- (void)clearMovies;
- (void)updateMovies:(NSArray*)movies;
- (void)layoutWithInterfaceOrientation:(UIInterfaceOrientation)orientation;
- (void)layoutMoviesWithInterfaceOrientation:(UIInterfaceOrientation)orientation;

- (void)detailViewStarting;
- (void)detailViewEnding;

- (void)playMovie:(NSURL*)url;
- (void)stopMovie;
@end
