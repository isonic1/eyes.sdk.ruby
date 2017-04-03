#include "eyes_core.h"

void Init_eyes_core() {
  VALUE Applitools = rb_define_module("Applitools");
  VALUE Resampling = rb_define_module_under(Applitools, "ResamplingFast");
  rb_define_method(Resampling, "interpolate_cubic", c_interpolate_cubic, 1);
  rb_define_method(Resampling, "merge_pixels", c_merge_pixels, 1);
  rb_define_method(Resampling, "bicubic_points2", c_bicubic_points, 3);
  rb_define_method(Resampling, "scale_points2", scale_points2, 4);
};


VALUE c_interpolate_cubic(VALUE self, VALUE data) {
  double t = NUM2DBL(rb_ary_entry(data, 1));
  VALUE p0, p1, p2, p3;

  p0 = NUM2UINT(rb_ary_entry(data, 2));
  p1 = NUM2UINT(rb_ary_entry(data, 3));
  p2 = NUM2UINT(rb_ary_entry(data, 4));
  p3 = NUM2UINT(rb_ary_entry(data, 5));

  return raw_interpolate_cubic(self, t, p0, p1, p2, p3);
};

VALUE raw_interpolate_cubic(VALUE self, double t, VALUE p0, VALUE p1, VALUE p2, VALUE p3) {
  BYTE  new_r, new_g, new_b, new_a;

  new_r = interpolate_char(t, R_BYTE(p0), R_BYTE(p1), R_BYTE(p2), R_BYTE(p3));
  new_g = interpolate_char(t, G_BYTE(p0), G_BYTE(p1), G_BYTE(p2), G_BYTE(p3));
  new_b = interpolate_char(t, B_BYTE(p0), B_BYTE(p1), B_BYTE(p2), B_BYTE(p3));
  new_a = interpolate_char(t, A_BYTE(p0), A_BYTE(p1), A_BYTE(p2), A_BYTE(p3));

  return UINT2NUM(BUILD_PIXEL(new_r, new_g, new_b, new_a));
}

BYTE interpolate_char(double t, BYTE c0, BYTE c1, BYTE c2, BYTE c3) {
  double a, b, c, d, res;
  a = - 0.5 * c0 + 1.5 * c1 - 1.5 * c2 + 0.5 * c3;
  b = c0 - 2.5 * c1 + 2 * c2 - 0.5 * c3;
  c = 0.5 * c2 - 0.5 * c0;
  d = c1;
  res = a * t * t * t + b * t * t + c * t + d + 0.5;
  if(res < 0) {
    res = 0;
  } else if(res > 255) {
    res = 255;
  };
  return (BYTE)(res);
};

VALUE c_merge_pixels(VALUE self, VALUE pixels) {
  unsigned int i, size, real_colors, acum_r, acum_g, acum_b, acum_a;
  BYTE new_r, new_g, new_b, new_a;
  PIXEL pix;

  acum_r = 0;
  acum_g = 0;
  acum_b = 0;
  acum_a = 0;

  new_r = 0;
  new_g = 0;
  new_b = 0;
  new_a = 0;

  size = NUM2UINT(rb_funcall(pixels, rb_intern("size"), 0, Qnil)) - 1;
  real_colors = 0;

  for(i=1; i < size; i++) {
    pix = NUM2UINT(rb_ary_entry(pixels, i));
    if(A_BYTE(pix) != 0) {
      acum_r += R_BYTE(pix);
      acum_g += G_BYTE(pix);
      acum_b += B_BYTE(pix);
      acum_a += A_BYTE(pix);
      real_colors += 1;
    }
  }

  if(real_colors > 0) {
    new_r = (BYTE)(acum_r/real_colors + 0.5);
    new_g = (BYTE)(acum_g/real_colors + 0.5);
    new_b = (BYTE)(acum_b/real_colors + 0.5);
  }
  new_a = (BYTE)(acum_a/(size - 1) + 0.5);
  return UINT2NUM(BUILD_PIXEL(new_r, new_g, new_b, new_a));
}

VALUE raw_merge_pixels(VALUE merge_pixels[], unsigned int size) {
  unsigned int i, real_colors, acum_r, acum_g, acum_b, acum_a;
  BYTE new_r, new_g, new_b, new_a;
  PIXEL pix;

  acum_r = 0;
  acum_g = 0;
  acum_b = 0;
  acum_a = 0;

  new_r = 0;
  new_g = 0;
  new_b = 0;
  new_a = 0;

  real_colors = 0;

  for(i=0; i < size; i++) {
    pix = NUM2UINT(merge_pixels[i]);
    if(A_BYTE(pix) != 0) {
      acum_r += R_BYTE(pix);
      acum_g += G_BYTE(pix);
      acum_b += B_BYTE(pix);
      acum_a += A_BYTE(pix);
      real_colors += 1;
    }
  }

  if(real_colors > 0) {
    new_r = (BYTE)(acum_r/real_colors + 0.5);
    new_g = (BYTE)(acum_g/real_colors + 0.5);
    new_b = (BYTE)(acum_b/real_colors + 0.5);
  }
  new_a = (BYTE)(acum_a/(size - 1) + 0.5);
  return UINT2NUM(BUILD_PIXEL(new_r, new_g, new_b, new_a));
}

VALUE c_bicubic_points(VALUE self, VALUE src_dimension, VALUE dst_dimension, VALUE direction) {
  unsigned long y_bounds, pixels_size, c_src_dimension, c_dst_dimension, index, index_y, i, y, x;
  double step;
  VALUE result_array;

  unsigned long steps [NUM2UINT(dst_dimension)];
  double residues [NUM2UINT(dst_dimension)];
  VALUE line_bounds;

  c_src_dimension = NUM2UINT(src_dimension);
  c_dst_dimension = NUM2UINT(dst_dimension);
  
  step = (double)(c_src_dimension - 1) / c_dst_dimension;

  if (RTEST(direction)) {
    y_bounds = NUM2UINT(rb_funcall(self, rb_intern("width"), 0, NULL));
  } else {
    y_bounds = NUM2UINT(rb_funcall(self, rb_intern("height"), 0, NULL));
  };

  pixels_size = y_bounds * c_dst_dimension;
  result_array = rb_ary_new2(pixels_size);

  for (i = 0; i < c_dst_dimension; i++) {
    steps[i] = (unsigned long)i*step;
    residues[i] = i*step - steps[i];
  };

  for (y = 0; y < y_bounds; y++) {
    line_bounds = rb_funcall(self, rb_intern("line_with_bounds"), 3, UINT2NUM(y), src_dimension, direction);

    index_y = c_dst_dimension * y;
    for (x = 0; x < c_dst_dimension; x++) {
      if (RTEST(direction)) {
        index = y_bounds * x + y;
      } else {
        index = index_y + x;
      }
      rb_ary_store(result_array, index, raw_interpolate_cubic(self, residues[x],
        NUM2UINT(rb_ary_entry(line_bounds, steps[x])),
        NUM2UINT(rb_ary_entry(line_bounds, steps[x] + 1)),
        NUM2UINT(rb_ary_entry(line_bounds, steps[x] + 2)),
        NUM2UINT(rb_ary_entry(line_bounds, steps[x] + 3)))
      );
    }
  }

  return result_array;
}

VALUE scale_points2(VALUE self, VALUE dst_width, VALUE dst_height, VALUE w_m, VALUE h_m) {
  unsigned long c_dst_height, c_dst_width, y_pos, x_pos, index, i, j;
  unsigned int c_w_m, c_h_m, buffer_index, buffer_size, x, y;
  VALUE pixels_to_merge [NUM2UINT(w_m) * NUM2UINT(h_m)];
  VALUE result;

  c_dst_height = NUM2UINT(dst_height);
  c_dst_width = NUM2UINT(dst_width);

  c_w_m = NUM2UINT(w_m);
  c_h_m = NUM2UINT(h_m);

  result = rb_ary_new2(c_dst_width * c_dst_height);
  buffer_size = c_h_m * c_w_m;

  for (i = 0; i < c_dst_height; i++) {
    for (j = 0; j < c_dst_width; j++) {
      buffer_index = 0;
      for (y = 0; y < c_h_m; y++) {
        y_pos = i * c_h_m + y;
        for (x = 0; x < c_w_m; x++) {
          x_pos = j * c_w_m + x;
          pixels_to_merge[buffer_index++] = rb_funcall(self, rb_intern("get_pixel"), 2, UINT2NUM(x_pos), UINT2NUM(y_pos));
        }
      }
      index = i * c_dst_width + j;
      rb_ary_store(result, index, raw_merge_pixels(pixels_to_merge, buffer_size));
    }
  }
  return result;
}
