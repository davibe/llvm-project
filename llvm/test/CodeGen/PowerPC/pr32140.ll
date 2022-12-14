; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=powerpc64le-linux-gnu -mcpu=pwr8 < %s | FileCheck %s --check-prefix CHECK-LE
; RUN: llc -mtriple=powerpc64-linux-gnu -mcpu=pwr8 < %s | FileCheck %s --check-prefix CHECK-BE

@as = dso_local local_unnamed_addr global i16 0, align 2
@bs = dso_local local_unnamed_addr global i16 0, align 2
@ai = dso_local local_unnamed_addr global i32 0, align 4
@bi = dso_local local_unnamed_addr global i32 0, align 4

define dso_local void @bswapStorei64Toi32() {
; CHECK-LABEL: bswapStorei64Toi32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 3, 2, ai@toc@ha
; CHECK-NEXT:    addis 4, 2, bi@toc@ha
; CHECK-NEXT:    lwa 3, ai@toc@l(3)
; CHECK-NEXT:    addi 4, 4, bi@toc@l
; CHECK-NEXT:    rldicl 3, 3, 32, 32
; CHECK-NEXT:    stwbrx 3, 0, 4
; CHECK-NEXT:    blr
; CHECK-LE-LABEL: bswapStorei64Toi32:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    addis 3, 2, ai@toc@ha
; CHECK-LE-NEXT:    addis 4, 2, bi@toc@ha
; CHECK-LE-NEXT:    lwa 3, ai@toc@l(3)
; CHECK-LE-NEXT:    addi 4, 4, bi@toc@l
; CHECK-LE-NEXT:    rldicl 3, 3, 32, 32
; CHECK-LE-NEXT:    stwbrx 3, 0, 4
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: bswapStorei64Toi32:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    addis 3, 2, ai@toc@ha
; CHECK-BE-NEXT:    addis 4, 2, bi@toc@ha
; CHECK-BE-NEXT:    lwa 3, ai@toc@l(3)
; CHECK-BE-NEXT:    addi 4, 4, bi@toc@l
; CHECK-BE-NEXT:    rldicl 3, 3, 32, 32
; CHECK-BE-NEXT:    stwbrx 3, 0, 4
; CHECK-BE-NEXT:    blr
entry:
  %0 = load i32, ptr @ai, align 4
  %conv.i = sext i32 %0 to i64
  %or26.i = tail call i64 @llvm.bswap.i64(i64 %conv.i)
  %conv = trunc i64 %or26.i to i32
  store i32 %conv, ptr @bi, align 4
  ret void
}

define dso_local void @bswapStorei32Toi16() {
; CHECK-LABEL: bswapStorei32Toi16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 3, 2, as@toc@ha
; CHECK-NEXT:    addis 4, 2, bs@toc@ha
; CHECK-NEXT:    lha 3, as@toc@l(3)
; CHECK-NEXT:    addi 4, 4, bs@toc@l
; CHECK-NEXT:    srwi 3, 3, 16
; CHECK-NEXT:    sthbrx 3, 0, 4
; CHECK-NEXT:    blr
; CHECK-LE-LABEL: bswapStorei32Toi16:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    addis 3, 2, as@toc@ha
; CHECK-LE-NEXT:    addis 4, 2, bs@toc@ha
; CHECK-LE-NEXT:    lha 3, as@toc@l(3)
; CHECK-LE-NEXT:    addi 4, 4, bs@toc@l
; CHECK-LE-NEXT:    srwi 3, 3, 16
; CHECK-LE-NEXT:    sthbrx 3, 0, 4
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: bswapStorei32Toi16:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    addis 3, 2, as@toc@ha
; CHECK-BE-NEXT:    addis 4, 2, bs@toc@ha
; CHECK-BE-NEXT:    lha 3, as@toc@l(3)
; CHECK-BE-NEXT:    addi 4, 4, bs@toc@l
; CHECK-BE-NEXT:    srwi 3, 3, 16
; CHECK-BE-NEXT:    sthbrx 3, 0, 4
; CHECK-BE-NEXT:    blr
entry:
  %0 = load i16, ptr @as, align 2
  %conv.i = sext i16 %0 to i32
  %or26.i = tail call i32 @llvm.bswap.i32(i32 %conv.i)
  %conv = trunc i32 %or26.i to i16
  store i16 %conv, ptr @bs, align 2
  ret void
}

define dso_local void @bswapStorei64Toi16() {
; CHECK-LABEL: bswapStorei64Toi16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 3, 2, as@toc@ha
; CHECK-NEXT:    addis 4, 2, bs@toc@ha
; CHECK-NEXT:    lha 3, as@toc@l(3)
; CHECK-NEXT:    addi 4, 4, bs@toc@l
; CHECK-NEXT:    rldicl 3, 3, 16, 48
; CHECK-NEXT:    sthbrx 3, 0, 4
; CHECK-NEXT:    blr
; CHECK-LE-LABEL: bswapStorei64Toi16:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    addis 3, 2, as@toc@ha
; CHECK-LE-NEXT:    addis 4, 2, bs@toc@ha
; CHECK-LE-NEXT:    lha 3, as@toc@l(3)
; CHECK-LE-NEXT:    addi 4, 4, bs@toc@l
; CHECK-LE-NEXT:    rldicl 3, 3, 16, 48
; CHECK-LE-NEXT:    sthbrx 3, 0, 4
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: bswapStorei64Toi16:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    addis 3, 2, as@toc@ha
; CHECK-BE-NEXT:    addis 4, 2, bs@toc@ha
; CHECK-BE-NEXT:    lha 3, as@toc@l(3)
; CHECK-BE-NEXT:    addi 4, 4, bs@toc@l
; CHECK-BE-NEXT:    rldicl 3, 3, 16, 48
; CHECK-BE-NEXT:    sthbrx 3, 0, 4
; CHECK-BE-NEXT:    blr
entry:
  %0 = load i16, ptr @as, align 2
  %conv.i = sext i16 %0 to i64
  %or26.i = tail call i64 @llvm.bswap.i64(i64 %conv.i)
  %conv = trunc i64 %or26.i to i16
  store i16 %conv, ptr @bs, align 2
  ret void
}

declare i32 @llvm.bswap.i32(i32)
declare i64 @llvm.bswap.i64(i64)
