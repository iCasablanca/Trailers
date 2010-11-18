//
//  MovieDetailPhoneView.h
//  Trailers
//
//  Created by Lucas Harding on 10-04-26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LHGalleryScroll.h"
@class MovieView;

@interface MovieDetailPhoneView : UIViewController {
	MovieView *movieView;
    
	IBOutlet UIButton *poster;
	IBOutlet UILabel *releaseDateLabel;
	IBOutlet UILabel *genreLabel;
	IBOutlet UILabel *directorLabel;
	IBOutlet UITextView *castLabel;
	IBOutlet UITextView *descriptionLabel;
	IBOutlet UIImageView *descriptionSeperator;
	IBOutlet UIImageView *infoSeperator;
	
	IBOutlet UIActivityIndicatorView *loadingView;
	
	IBOutlet LHGalleryScroll *trailers;
}
@property (nonatomic,retain) MovieView *movieView;

@property (nonatomic,retain) IBOutlet UIButton *poster;
@property (nonatomic,retain) IBOutlet UILabel *releaseDateLabel;
@property (nonatomic,retain) IBOutlet UILabel *genreLabel;
@property (nonatomic,retain) IBOutlet UILabel *directorLabel;
@property (nonatomic,retain) IBOutlet UITextView *castLabel;
@property (nonatomic,retain) IBOutlet UITextView *descriptionLabel;
@property (nonatomic,retain) IBOutlet UIImageView *descriptionSeperator;
@property (nonatomic,retain) IBOutlet UIImageView *infoSeperator;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic,retain) IBOutlet LHGalleryScroll *trailers;

- (void)layoutSubviews;

@end
