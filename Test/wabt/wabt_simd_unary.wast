;; Tests from wabt: https://github.com/WebAssembly/wabt/tree/master/test/interp
;; Distributed under the terms of the wabt license: https://github.com/WebAssembly/wabt/blob/master/LICENSE
;; Modified for compatibility with WAVM's interpretation of the proposed spec.

(module
  ;; i8x16 neg
  (func (export "i8x16_neg_0") (result v128)
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    i8x16.neg)

  ;; i16x8 neg
  (func (export "i16x8_neg_0") (result v128)
    v128.const i32x4 0x0000ffff 0x00007fff 0x00000003 0x00000004
    i16x8.neg)

  ;; i32x4 neg
  (func (export "i32x4_neg_0") (result v128)
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    i32x4.neg)

  ;; i64x2 neg
  (func (export "i64x2_neg_0") (result v128)
    v128.const i32x4 0x00000001 0x00000002 0x00000003 0x00000004
    i64x2.neg)

  ;; v128 not
  (func (export "v128_not_0") (result v128)
    v128.const i32x4 0x00ff0001 0x00550002 0x00000003 0x00000004
    v128.not)

  ;; i8x16 any_true
  (func (export "i8x16_any_true_0") (result i32)
    v128.const i32x4 0x00ff0001 0x00550002 0x00000003 0x00000004
    i8x16.any_true)
  (func (export "i8x16_any_true_1") (result i32)
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    i8x16.any_true)

  ;; i16x8 any_true
  (func (export "i16x8_any_true_0") (result i32)
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    i16x8.any_true)
  (func (export "i16x8_any_true_1") (result i32)
    v128.const i32x4 0x00ff0001 0x00550002 0x00000003 0x00000004
    i16x8.any_true)

  ;; i32x4 any_true
  (func (export "i32x4_any_true_0") (result i32)
    v128.const i32x4 0x00ff0001 0x00550002 0x00000003 0x00000004
    i32x4.any_true)
  (func (export "i32x4_any_true_1") (result i32)
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    i32x4.any_true)

  ;; i64x2 any_true
  (func (export "i64x2_any_true_0") (result i32)
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    i64x2.any_true)
  (func (export "i64x2_any_true_1") (result i32)
    v128.const i32x4 0x00ff0001 0x00550002 0x00000003 0x00000004
    i64x2.any_true)

  ;; i8x16 all_true
  (func (export "i8x16_all_true_0") (result i32)
    v128.const i32x4 0x01020304 0x01050706 0x10020403 0x20103004
    i8x16.all_true)
  (func (export "i8x16_all_true_1") (result i32)
    v128.const i32x4 0x00000001 0x00000200 0x00030000 0x00000000
    i8x16.all_true)

  ;; i16x8 all_true
  (func (export "i16x8_all_true_0") (result i32)
    v128.const i32x4 0x00040004 0x00030003 0x00020002 0x00010001
    i16x8.all_true)
  (func (export "i16x8_all_true_1") (result i32)
    v128.const i32x4 0x00ff0001 0x00550002 0x00000003 0x00000004
    i16x8.all_true)

  ;; i32x4 all_true
  (func (export "i32x4_all_true_0") (result i32)
    v128.const i32x4 0x00ff0001 0x00550002 0x00000003 0x00000004
    i32x4.all_true)
  (func (export "i32x4_all_true_1") (result i32)
    v128.const i32x4 0x01010101 0x000000ff 0x000ff000 0x00000000
    i32x4.all_true)

  ;; i64x2 all_true
  (func (export "i64x2_all_true_0") (result i32)
    v128.const i32x4 0x00000001 0x00000000 0x00000001 0x00000000
    i64x2.all_true)
  (func (export "i64x2_all_true_1") (result i32)
    v128.const i32x4 0x00ff0001 0x00550002 0x00000000 0x00000000
    i64x2.all_true)

  ;; f32x4 neg
  ;; For Floating num:
  ;; +0.0 = 0x00000000, -0.0 = 0x80000000
  ;; 0xffc00000 is a NaN, 0x7fc00000 is a NaN.
  ;;  1234.5 = 0x449a5000,  1.0 = 0x3f800000
  ;; -1234.5 = 0xc49a5000, -1.0 = 0xbf800000
  ;; test is:   [-0.0, NaN,  1234.5, -1.0]
  ;; expect is: [ 0.0, NaN, -1234.5,  1.0]
  (func (export "f32x4_neg_0") (result v128)
    v128.const i32x4 0x80000000 0xffc00000 0x449a5000 0xbf800000
    f32x4.neg)

  ;; f64x2 neg
  ;; For Double num:
  ;; +0.0 = 0x0000000000000000, -0.0 = 0x8000000000000000
  ;; 0xfff8000000000000 is a NaN, 0x7ff8000000000000 is a NaN.
  ;; 1234.5  = 0x40934a0000000000,  1.0 = 0x3ff0000000000000
  ;; -1234.5 = 0xc0934a0000000000, -1.0 = 0xbff0000000000000
  ;; tests are:   [ 0.0, NaN],  [-1234.5,  1.0]
  ;; expects are: [-0.0, NaN],  [ 1234.5, -1.0]
  (func (export "f64x2_neg_0") (result v128)
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0xfff80000
    f64x2.neg)
  (func (export "f64x2_neg_1") (result v128)
    v128.const i32x4 0x00000000 0xc0934a00 0x00000000 0x3ff00000
    f64x2.neg)

  ;; f32x4 abs
  ;; For Floating num:
  ;; +0.0 = 0x00000000, -0.0 = 0x80000000
  ;; 0xffc00000 is a NaN, 0x7fc00000 is a NaN.
  ;;  1234.5 = 0x449a5000,  1.0 = 0x3f800000
  ;; -1234.5 = 0xc49a5000, -1.0 = 0xbf800000
  ;; test is:   [-0.0, NaN,  1234.5, -1.0]
  ;; expect is: [ 0.0, NaN,  1234.5,  1.0]
  (func (export "f32x4_abs_0") (result v128)
    v128.const i32x4 0x80000000 0xffc00000 0x449a5000 0xbf800000
    f32x4.abs)

  ;; f64x2 abs
  ;; For Double num:
  ;; +0.0 = 0x0000000000000000, -0.0 = 0x8000000000000000
  ;; 0xfff8000000000000 is a NaN, 0x7ff8000000000000 is a NaN.
  ;; 1234.5  = 0x40934a0000000000,  1.0 = 0x3ff0000000000000
  ;; -1234.5 = 0xc0934a0000000000, -1.0 = 0xbff0000000000000
  ;; tests are:   [-0.0, NaN],  [-1234.5, 1.0]
  ;; expects are: [ 0.0, NaN],  [ 1234.5, 1.0]
  (func (export "f64x2_abs_0") (result v128)
    v128.const i32x4 0x00000000 0x80000000 0x00000000 0xfff80000
    f64x2.abs)
  (func (export "f64x2_abs_1") (result v128)
    v128.const i32x4 0x00000000 0xc0934a00 0x00000000 0x3ff00000
    f64x2.abs)

  ;; f32x4 sqrt
  ;; For Floating num:
  ;; 0xffc00000 is a NaN, 0x7fc00000 is a NaN.
  ;; -1.0 = 0xbf800000, 4.0 = 0x40800000, 2.0 = 0x40000000 
  ;;  9.0 = 0x41100000, 3.0 = 0x40400000
  ;; test is:   [-1.0, NaN,  4.0, 9.0]
  ;; expect is: [ NaN, NaN,  2.0, 3.0]
  (func (export "f32x4_sqrt_0") (result v128)
    v128.const i32x4 0xbf800000 0xffc00000 0x40800000 0x41100000
    f32x4.sqrt)

  ;; f64x2 sqrt
  ;; For Double num:
  ;; 0xfff8000000000000 is a NaN, 0x7ff8000000000000 is a NaN.
  ;; -1.0 = 0xbff0000000000000, 4.0 = 0x4010000000000000
  ;;  2.0 = 0x4000000000000000, 9.0 = 0x4022000000000000
  ;;  3.0 = 0x4008000000000000
  ;; tests are:   [-1.0, NaN],  [ 4.0, 9.0]
  ;; expects are: [ NaN, NaN],  [ 2.0, 3.0]
  (func (export "f64x2_sqrt_0") (result v128)
    v128.const i32x4 0x00000000 0xbff00000 0x00000000 0xfff80000
    f64x2.sqrt)
  (func (export "f64x2_sqrt_1") (result v128)
    v128.const i32x4 0x00000000 0x40100000 0x00000000 0x40220000
    f64x2.sqrt)

  ;; f32x4 convert_i32x4_s
  ;; For Floating num:
  ;; 1.0 = 0x3f800000 -1.0 = 0xbf800000 3.0 = 0x40400000
  ;; test is:   [   1,   -1,   0,   3]
  ;; expect is: [ 1.0, -1.0, 0.0, 3.0]
  (func (export "f32x4_convert_i32x4_s_0") (result v128)
    v128.const i32x4 0x00000001 0xffffffff 0x00000000 0x00000003
    f32x4.convert_i32x4_s)

  ;; f32x4 convert_i32x4_u
  ;; For Floating num:
  ;; 1.0 = 0x3f800000 0.0 = 0x00000000 3.0 = 0x40400000
  ;; 2.0 = 0x40000000
  ;; test is:   [   1,   2,   0,   3]
  ;; expect is: [ 1.0, 2.0, 0.0, 3.0]
  (func (export "f32x4_convert_i32x4_u_0") (result v128)
    v128.const i32x4 0x00000001 0x00000002 0x00000000 0x00000003
    f32x4.convert_i32x4_u)

  ;; f64x2 convert_i64x2_s
  ;; For Double num:
  ;; 1.0 = 0x3ff0000000000000  -3.0 = 0xc008000000000000
  ;; test is:   [   1,   -3]
  ;; expect is: [ 1.0, -3.0]
  (func (export "f64x2_convert_i64x2_s_0") (result v128)
    v128.const i32x4 0x00000001 0x00000000 0xfffffffd 0xffffffff
    f64x2.convert_i64x2_s)

  ;; f64x2 convert_i64x2_u
  ;; For Double num:
  ;; 1.0 = 0x3ff0000000000000 3.0 = 0x4008000000000000
  ;; test is:   [   1,   3]
  ;; expect is: [ 1.0, 3.0]
  (func (export "f64x2_convert_i64x2_u_0") (result v128)
    v128.const i32x4 0x00000001 0x00000000 0x00000003 0x00000000
    f64x2.convert_i64x2_u)

  ;; i32x4 trunc_sat_f32x4_s
  ;; For Floating num:
  ;; 0xffc00000 is a NaN.
  ;; 1.5 = 0x3fc00000 -4.5 = 0xc0900000 1234.8 = 0x449a599a
  ;; 1234 = 0x000004d2
  ;; test is:   [ 1.5, -4.5, NaN,  1234.8]
  ;; expect is: [   1,   -4,   0,    1234]
  (func (export "i32x4_trunc_sat_f32x4_s_0") (result v128)
    v128.const i32x4 0x3fc00000 0xc0900000 0xffc00000 0x449a599a
    i32x4.trunc_sat_f32x4_s)

  ;; i32x4 trunc_sat_f32x4_u
  ;; For Floating num:
  ;; 0xffc00000 is a NaN.
  ;; 1.5 = 0x3fc00000 4.5 = 0x40900000 1234.8 = 0x449a599a
  ;; 1234 = 0x000004d2
  ;; test is:   [ 1.5, 4.5, NaN,  1234.8]
  ;; expect is: [   1,   4,   0,    1234]
  (func (export "i32x4_trunc_sat_f32x4_u_0") (result v128)
    v128.const i32x4 0x3fc00000 0x40900000 0xffc00000 0x449a599a
    i32x4.trunc_sat_f32x4_u)

  ;; i64x2 trunc_sat_f64x2_s
  ;; For Floating num:
  ;; 0xfff8000000000000 is a NaN.
  ;; -4.5 = 0xc012000000000000
  ;; test is:   [ NaN, -4.5]
  ;; expect is: [   0,   -4]
  (func (export "i64x2_trunc_sat_f64x2_s_0") (result v128)
    v128.const i32x4 0x00000000 0xfff80000 0x00000000 0xc0120000
    i64x2.trunc_sat_f64x2_s)

  ;; i64x2 trunc_sat_f64x2_u
  ;; For Floating num:
  ;; 0xfff8000000000000 is a NaN.
  ;; 4.5 = 0x4012000000000000
  ;; test is:   [ NaN, 4.5]
  ;; expect is: [   0,   4]
  (func (export "i64x2_trunc_sat_f64x2_u_0") (result v128)
    v128.const i32x4 0x00000000 0xfff80000 0x00000000 0x40120000
    i64x2.trunc_sat_f64x2_u)
)

(assert_return (invoke "i8x16_neg_0") (v128.const i32x4 0x000000ff 0x000000fe 0x000000fd 0x000000fc))
(assert_return (invoke "i16x8_neg_0") (v128.const i32x4 0x00000001 0x00008001 0x0000fffd 0x0000fffc))
(assert_return (invoke "i32x4_neg_0") (v128.const i32x4 0xffffffff 0xfffffffe 0xfffffffd 0xfffffffc))
(assert_return (invoke "i64x2_neg_0") (v128.const i32x4 0xffffffff 0xfffffffd 0xfffffffd 0xfffffffb))
(assert_return (invoke "v128_not_0") (v128.const i32x4 0xff00fffe 0xffaafffd 0xfffffffc 0xfffffffb))
(assert_return (invoke "i8x16_any_true_0") (i32.const 1))
(assert_return (invoke "i8x16_any_true_1") (i32.const 0))
(assert_return (invoke "i16x8_any_true_0") (i32.const 0))
(assert_return (invoke "i16x8_any_true_1") (i32.const 1))
(assert_return (invoke "i32x4_any_true_0") (i32.const 1))
(assert_return (invoke "i32x4_any_true_1") (i32.const 0))
(assert_return (invoke "i64x2_any_true_0") (i32.const 0))
(assert_return (invoke "i64x2_any_true_1") (i32.const 1))
(assert_return (invoke "i8x16_all_true_0") (i32.const 1))
(assert_return (invoke "i8x16_all_true_1") (i32.const 0))
(assert_return (invoke "i16x8_all_true_0") (i32.const 1))
(assert_return (invoke "i16x8_all_true_1") (i32.const 0))
(assert_return (invoke "i32x4_all_true_0") (i32.const 1))
(assert_return (invoke "i32x4_all_true_1") (i32.const 0))
(assert_return (invoke "i64x2_all_true_0") (i32.const 1))
(assert_return (invoke "i64x2_all_true_1") (i32.const 0))
(assert_return (invoke "f32x4_neg_0") (v128.const i32x4 0x00000000 0x7fc00000 0xc49a5000 0x3f800000))
(assert_return (invoke "f64x2_neg_0") (v128.const i32x4 0x00000000 0x80000000 0x00000000 0x7ff80000))
(assert_return (invoke "f64x2_neg_1") (v128.const i32x4 0x00000000 0x40934a00 0x00000000 0xbff00000))
(assert_return (invoke "f32x4_abs_0") (v128.const i32x4 0x00000000 0x7fc00000 0x449a5000 0x3f800000))
(assert_return (invoke "f64x2_abs_0") (v128.const i32x4 0x00000000 0x00000000 0x00000000 0x7ff80000))
(assert_return (invoke "f64x2_abs_1") (v128.const i32x4 0x00000000 0x40934a00 0x00000000 0x3ff00000))
(assert_return (invoke "f32x4_sqrt_0") (v128.const f32x4 nan:canonical nan:canonical 2.0 3.0))
(assert_return (invoke "f64x2_sqrt_0") (v128.const f64x2 nan:canonical nan:canonical))
(assert_return (invoke "f64x2_sqrt_1") (v128.const i32x4 0x00000000 0x40000000 0x00000000 0x40080000))
(assert_return (invoke "f32x4_convert_i32x4_s_0") (v128.const i32x4 0x3f800000 0xbf800000 0x00000000 0x40400000))
(assert_return (invoke "f32x4_convert_i32x4_u_0") (v128.const i32x4 0x3f800000 0x40000000 0x00000000 0x40400000))
(assert_return (invoke "f64x2_convert_i64x2_s_0") (v128.const i32x4 0x00000000 0x3ff00000 0x00000000 0xc0080000))
(assert_return (invoke "f64x2_convert_i64x2_u_0") (v128.const i32x4 0x00000000 0x3ff00000 0x00000000 0x40080000))
(assert_return (invoke "i32x4_trunc_sat_f32x4_s_0") (v128.const i32x4 0x00000001 0xfffffffc 0x00000000 0x000004d2))
(assert_return (invoke "i32x4_trunc_sat_f32x4_u_0") (v128.const i32x4 0x00000001 0x00000004 0x00000000 0x000004d2))
(assert_return (invoke "i64x2_trunc_sat_f64x2_s_0") (v128.const i32x4 0x00000000 0x00000000 0xfffffffc 0xffffffff))
(assert_return (invoke "i64x2_trunc_sat_f64x2_u_0") (v128.const i32x4 0x00000000 0x00000000 0x00000004 0x00000000))