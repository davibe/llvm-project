; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=s390x-linux-gnu -mcpu=z13 -O3 -pre-RA-sched=list-ilp -systemz-subreg-liveness -stress-sched -terminal-rule %s -o - | FileCheck %s
; This test used to fail because we were creating empty subranges
; instead of subranges with dead defs while rematerializing values
; during coalescing.
;
; PR46154
; REQUIRES: asserts

@g_39 = external dso_local unnamed_addr global i64, align 8
@g_151 = external dso_local global i32, align 4
@g_222 = external dso_local unnamed_addr global [7 x [10 x i8]], align 2

define void @main(i16 %in) {
; CHECK-LABEL: main:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lhr %r2, %r2
; CHECK-NEXT:    larl %r1, g_151
; CHECK-NEXT:    lghi %r3, 0
; CHECK-NEXT:    chi %r2, 0
; CHECK-NEXT:    lhi %r0, 1
; CHECK-NEXT:    locghile %r3, 1
; CHECK-NEXT:    o %r0, 0(%r1)
; CHECK-NEXT:    larl %r1, g_222
; CHECK-NEXT:    lghi %r5, 0
; CHECK-NEXT:    dsgfr %r2, %r0
; CHECK-NEXT:    stgrl %r2, g_39
; CHECK-NEXT:    stc %r5, 19(%r1)
; CHECK-NEXT:    br %r14
  %tmp = load i32, ptr @g_151, align 4
  %tmp3 = or i32 %tmp, 1
  %tmp4 = sext i32 %tmp3 to i64
  %tmp5 = srem i64 0, %tmp4
  %tmp6 = trunc i64 %tmp5 to i8
  store i8 %tmp6, ptr getelementptr inbounds ([7 x [10 x i8]], ptr @g_222, i64 0, i64 1, i64 9), align 1
  %tmp7 = icmp slt i16 %in, 1
  %tmp8 = zext i1 %tmp7 to i64
  %tmp9 = srem i64 %tmp8, %tmp4
  store i64 %tmp9, ptr @g_39, align 8
  ret void
}

