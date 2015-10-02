#import <UIKit/UIKit.h>

@interface LoadingView : UIView {

}

+ (id)loadingViewInView:(UIView *)aSuperview;
- (CGPathRef) newPathWithRoundRect:(CGRect)rect withRadious:(CGFloat)cornerRadius;
- (void)removeView;

@end
