//
//  SpectrumScrollView.m
//  ffttest
//
//  Created by donbe on 2020/6/29.
//  Copyright © 2020 donbe. All rights reserved.
//

#import "SpectrumScrollView.h"


@interface SpectrumScrollView(){
    NSArray *drawdata;
}

@end

@implementation SpectrumScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
        self.scale = 0.5;
    }
    return self;
}

-(void)setdata:(NSArray *)data{
    self->drawdata = data;
    [self setNeedsDisplay];
}


-(void)drawRect:(CGRect)rect{

    int offsetx = MAX(0, self.contentOffset.x);
    
    for (int i=MAX(offsetx-100, 0) / self.scale; i< MIN(offsetx / self.scale + self.bounds.size.width / self.scale , [self->drawdata count]); i++) {
    
        float y = (self.bounds.size.height - 40) - 10 * [self->drawdata[i] floatValue];
        CGContextFillRect(UIGraphicsGetCurrentContext(),
                          CGRectMake(i * self.scale,
                                     y,
                                     self.scale,
                                     10 * [self->drawdata[i] floatValue]
                                     )
                          );
        
        // 画刻度
        if (i % 100 == 0) {
            
            NSString *str = [NSString stringWithFormat:@"%d", i];
            NSDictionary *attr = @{
                NSFontAttributeName:[UIFont systemFontOfSize:8],
                NSForegroundColorAttributeName:[UIColor blackColor]
            };
            
            CGRect rect = [str boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
            
            [str drawAtPoint:CGPointMake(i * self.scale - rect.size.width/2, self.bounds.size.height - 22) withAttributes:attr];
            
            CGContextFillRect(UIGraphicsGetCurrentContext(),
                              CGRectMake(i * self.scale,
                                         self.bounds.size.height - 10,
                                         0.5,
                                         self.bounds.size.height
                                         )
                              );
        }
    }
    
    
    //画底线
    CGContextFillRect(UIGraphicsGetCurrentContext(),
                      CGRectMake(offsetx,
                                 self.bounds.size.height - 0.5,
                                 self.bounds.size.width,
                                 self.bounds.size.height
                                 )
                      );
}
@end
