//
//  NRThumbnailCell.m
//  NRPDFReader
//
//  Created by Naveen R on 19/09/13.
//

#import "NRThumbnailCell.h"

@implementation NRThumbnailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 140.0f, 105.0f)];
        _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_thumbnailImageView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:_thumbnailImageView];
        
        _thumbnailBorderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 160.0f, 115.0f)];
        _thumbnailBorderImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_thumbnailBorderImageView setHidden:YES];
        [_thumbnailBorderImageView setImage:[UIImage imageNamed:@"pdf_frame_highlight"]];
        [self.contentView addSubview:_thumbnailBorderImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
