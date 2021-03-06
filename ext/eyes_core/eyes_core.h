#ifndef APPLITOOLS_RESAMPLING_EXT
#define APPLITOOLS_RESAMPLING_EXT
#include "ruby.h"

typedef uint32_t PIXEL; // Pixels use 32 bits unsigned integers
typedef unsigned char BYTE; // Bytes use 8 bits unsigned integers

#define R_BYTE(pixel)  ((BYTE) (((pixel) & (PIXEL) 0xff000000) >> 24))
#define G_BYTE(pixel)  ((BYTE) (((pixel) & (PIXEL) 0x00ff0000) >> 16))
#define B_BYTE(pixel)  ((BYTE) (((pixel) & (PIXEL) 0x0000ff00) >> 8))
#define A_BYTE(pixel)  ((BYTE) (((pixel) & (PIXEL) 0x000000ff)))

#define BUILD_PIXEL(r, g, b, a)  (((PIXEL) (r) << 24) + ((PIXEL) (g) << 16) + ((PIXEL) (b) << 8) + (PIXEL) (a))
#define INT8_MULTIPLY(a, b)      (((((a) * (b) + 0x80) >> 8) + ((a) * (b) + 0x80)) >> 8)

BYTE interpolate_char(double, BYTE, BYTE, BYTE, BYTE);

PIXEL* get_bicubic_points(PIXEL*, unsigned long int, unsigned long int, unsigned long int, unsigned long int);

PIXEL* get_c_array(VALUE);
VALUE c_resampling_first_step(VALUE, VALUE, VALUE);
VALUE get_ruby_array(VALUE, PIXEL*, unsigned long int);
PIXEL get_line_pixel(PIXEL*, unsigned long int, long int, unsigned long int);
PIXEL get_column_pixel(PIXEL*, unsigned long int, long int, unsigned long int, unsigned long int);
PIXEL raw_merge_pixels(PIXEL*, unsigned long int);
PIXEL* c_scale_points(PIXEL*, unsigned long int, unsigned long int, unsigned long int, unsigned long int);

#endif
