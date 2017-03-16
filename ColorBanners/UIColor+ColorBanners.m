// Adapted from https://github.com/thisandagain/color.

#import "UIColor+ColorBanners.h"

static CGFloat clamp(CGFloat x) {
  return (x > 1.0) ? 1.0 : ((x < 0.0) ? 0.0 : x);
}

// HSL to RGB converter.
static void hsl_to_rgb(CGFloat h, CGFloat s, CGFloat l, CGFloat *outR, CGFloat *outG, CGFloat *outB) {
  CGFloat temp1, temp2;
  CGFloat temp[3];
  int i;
  
  // Check for saturation. If there isn't any, just return the luminance value for each, which results in gray.
  if(s == 0.0) {
    if(outR) {
      *outR = l;
    }
    if(outG) {
      *outG = l;
    }
    if(outB) {
      *outB = l;
    }
    return;
  }
  
  // Test for luminance and compute temporary values based on luminance and saturation.
  if(l < 0.5) {
    temp2 = l * (1.0 + s);
  }
  else {
    temp2 = l + s - l * s;
  }
  
  temp1 = 2.0 * l - temp2;
  
  // Compute intermediate values based on hue.
  temp[0] = h + 1.0 / 3.0;
  temp[1] = h;
  temp[2] = h - 1.0 / 3.0;
    
  for(i = 0; i < 3; ++i) {
    // Adjust the range.
    if(temp[i] < 0.0) {
      temp[i] += 1.0;
    }
    if(temp[i] > 1.0) {
      temp[i] -= 1.0;
    }
    
    if(6.0 * temp[i] < 1.0) {
      temp[i] = temp1 + (temp2 - temp1) * 6.0 * temp[i];
    } else {
      if(2.0 * temp[i] < 1.0) {
        temp[i] = temp2;
      } else {
        if(3.0 * temp[i] < 2.0) {
          temp[i] = temp1 + (temp2 - temp1) * ((2.0 / 3.0) - temp[i]) * 6.0;
        }
        else {
          temp[i] = temp1;
        }
      }
    }
  }
  
  // Assign temporary values to R, G, B.
  if(outR) {
    *outR = temp[0];
  }
  if(outG) {
    *outG = temp[1];
  }
  if(outB) {
    *outB = temp[2];
  }
}

// RGB to HSL converter.
static void rgb_to_hsl(CGFloat r, CGFloat g, CGFloat b, CGFloat *outH, CGFloat *outS, CGFloat *outL) {    
  CGFloat h, s, l, v, m, vm, r2, g2, b2;
  
  h = 0; s = 0;
  v = MAX(r, g);
  v = MAX(v, b);
  m = MIN(r, g);
  m = MIN(m, b);
  
  l = (m + v) / 2.0f;
  
  if (l <= 0.0) {
    if(outH) {
      *outH = h;
    }
    if(outS) {
      *outS = s;
    }
    if(outL) {
      *outL = l;
    }
    return;
  }
  
  vm = v - m;
  s = vm;
  
  if (s > 0.0f) {
    s /= (l <= 0.5f) ? (v + m) : (2.0 - v - m);
  } else {
    if(outH) {
      *outH = h;
    }
    if(outS) {
      *outS = s;
    }
    if(outL) {
      *outL = l;
    }
    return;
  }
  
  r2 = (v - r) / vm;
  g2 = (v - g) / vm;
  b2 = (v - b) / vm;
  
  if (r == v){
    h = (g == m ? 5.0f + b2 : 1.0f - g2);
  }else if (g == v){
    h = (b == m ? 1.0f + r2 : 3.0 - b2);
  }else{
    h = (r == m ? 3.0f + g2 : 5.0f - r2);
  }
  
  h /= 6.0f;
  
  if(outH) {
    *outH = h;
  }
  if(outS) {
    *outS = s;
  }
  if(outL) {
    *outL = l;
  }
}

@implementation UIColor(ColorBanners)

+ (UIColor *)cbr_colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation lightness:(CGFloat)lightness alpha:(CGFloat)alpha {
  CGFloat r, g, b;
  hsl_to_rgb(hue, saturation, lightness, &r, &g, &b);
  return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

- (void)cbr_getHue:(CGFloat *)hue saturation:(CGFloat *)saturation lightness:(CGFloat *)lightness alpha:(CGFloat *)alpha {
  CGFloat r, g, b;
  [self getRed:&r green:&g blue:&b alpha:alpha];
  rgb_to_hsl(r, g, b, hue, saturation, lightness);
}

- (UIColor *)cbr_offsetWithHue:(CGFloat)hue saturation:(CGFloat)saturation lightness:(CGFloat)lightness alpha:(CGFloat)alpha {
  CGFloat h, s, l, a;
  [self cbr_getHue:&h saturation:&s lightness:&l alpha:&a];

  h = fmodf(hue + h, 1.0f);
  s = clamp(saturation + s);
  l = clamp(lightness + l);
  a = clamp(alpha + a);
  
  return [UIColor cbr_colorWithHue:h saturation:s lightness:l alpha:a];
}

- (UIColor *)cbr_lighten:(CGFloat)amount {
  return [self cbr_offsetWithHue:0.0f saturation:0.0f lightness:amount alpha:0.0f];
}

- (UIColor *)cbr_darken:(CGFloat)amount {
  return [self cbr_offsetWithHue:0.0f saturation:0.0f lightness:-amount alpha:0.0f];
}

@end
