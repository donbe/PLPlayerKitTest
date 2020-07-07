//
//  FFT.m
//  ffttest
//
//  Created by donbe on 2020/6/28.
//  Copyright © 2020 donbe. All rights reserved.
//

#import "FFT.h"
#import <Accelerate/Accelerate.h>





@interface FFT(){
    FFTSetup fftSetup;
    int mLog2n;
    int fftsize ;
    int halfSize ;
}
    
@end

@implementation FFT

-(void)setupWithLog2n:(int)log2n{
    mLog2n = log2n;
    fftSetup = vDSP_create_fftsetup(log2n, FFT_RADIX2);
    fftsize = 1 << log2n;
    halfSize = fftsize/2;
}

-(void)destroy{
    vDSP_destroy_fftsetup(fftSetup);
}


-(void)performfft:(float *)indata out:(float *)outdata {
    
    //加窗函数
//    float window[fftsize];
//    memset(&window, 0, fftsize * sizeof(float));
//    
//    vDSP_hann_window(window, fftsize, (int32_t)(vDSP_HANN_NORM));
//    vDSP_vmul(indata, 1, window, 1, indata, 1, fftsize);
    
    
    float forwardInputReal[halfSize]; // 实数部分
    memset(forwardInputReal, 0, halfSize * sizeof(float));
    
    float forwardInputImag[halfSize]; // 虚数部分
    memset(forwardInputImag, 0, halfSize * sizeof(float));
    
    DSPSplitComplex fftInOut;
    fftInOut.realp = forwardInputReal;
    fftInOut.imagp = forwardInputImag;
    
    // 转换成ios特有的fft数据格式
    // 具体参考 vDSP Programming Guide ： Using Fourier Transforms
    vDSP_ctoz((DSPComplex*)indata, 2, &fftInOut, 1, (vDSP_Length)(halfSize));
    
    // 执行fft
    vDSP_fft_zrip(fftSetup, &fftInOut,1, mLog2n, (FFTDirection)(FFT_FORWARD));
    
    // 缩放结果
    float fftNormFactor = 1.0 / (float)(fftsize);
    vDSP_vsmul(fftInOut.realp, 1, &fftNormFactor, fftInOut.realp, 1, (vDSP_Length)(halfSize));
    vDSP_vsmul(fftInOut.imagp, 1, &fftNormFactor, fftInOut.imagp, 1, (vDSP_Length)(halfSize));
    
    // 合并实部和虚部（平方和后开方），填充到outdata，结果范围和采样点值范围一致
    vDSP_zvabs(&fftInOut, 1, outdata, 1, (vDSP_Length)(halfSize));
}

@end
