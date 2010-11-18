//
//  MovieDetailView.h
//  Trailers
//
//  Created by Lucas Harding on 10-03-25.
//  Copyright 2010 Apple Inc. All rights reserved.
//

@class LHGalleryScroll;
@class MovieView;

@interface MovieDetailView : UIViewController {
	MovieView *movieView;
	

	CGRect initialPosterFrame;
	IBOutlet UIButton *poster;
	IBOutlet UIImageView *posterLarge;
	IBOutlet UIImageView *posterCover;
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *releaseDateLabel;
	IBOutlet UILabel *genreLabel;
	IBOutlet UILabel *directorLabel;
	IBOutlet UITextView *castLabel;
	IBOutlet UITextView *descriptionLabel;
	
	IBOutlet UIImageView *infoSeperator;
	IBOutlet UIImageView *descriptionSeperator;

	IBOutlet UIImageView *backgroundTopImage;
	IBOutlet UIImageView *backgroundMiddleImage;
	IBOutlet UIImageView *backgroundBottomImage;
	IBOutlet UIActivityIndicatorView *loadingView;
	
	IBOutlet LHGalleryScroll *trailers;

}

@property (nonatomic,retain) MovieView *movieView;

@property (nonatomic,retain) IBOutlet UIButton *poster;
@property (nonatomic,retain) IBOutlet UIImageView *posterCover;
@property (nonatomic,retain) IBOutlet UILabel *titleLabel;
@property (nonatomic,retain) IBOutlet UILabel *releaseDateLabel;
@property (nonatomic,retain) IBOutlet UILabel *genreLabel;
@property (nonatomic,retain) IBOutlet UILabel *directorLabel;
@property (nonatomic,retain) IBOutlet UITextView *castLabel;
@property (nonatomic,retain) IBOutlet UITextView *descriptionLabel;

@property (nonatomic,retain) IBOutlet UIImageView *infoSeperator;
@property (nonatomic,retain) IBOutlet UIImageView *descriptionSeperator;

@property (nonatomic,retain) IBOutlet UIImageView *backgroundTopImage;
@property (nonatomic,retain) IBOutlet UIImageView *backgroundMiddleImage;
@property (nonatomic,retain) IBOutlet UIImageView *backgroundBottomImage;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic,retain) IBOutlet LHGalleryScroll *trailers;


- (void)addTrailer:(UIView*)v;
- (void)clearTrailers;

- (void)setDescription:(NSString*)s;
- (void)setGenre:(NSString*)s;
- (void)setDirector:(NSString*)s;
- (void)setReleaseDate:(NSString*)s;
- (void)setCast:(NSString*)s;
- (void)setPosterImage:(UIImage*)i;

- (NSString*)getDescription;
- (NSString*)getGenre;
- (NSString*)getDirector;
- (NSString*)getReleaseDate;
- (NSString*)getCast;

- (void)layoutSubviews;
- (void)startAnimating;
- (void)stopAnimating;

- (IBAction)closeClicked;


@end
