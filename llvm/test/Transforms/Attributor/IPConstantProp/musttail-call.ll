; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=3 -S < %s | FileCheck %s --check-prefixes=CHECK,TUNIT
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,CGSCC
; PR36485
; musttail call result can't be replaced with a constant, unless the call can be removed

declare i32 @external()

define i8* @start(i8 %v) {
;
; TUNIT-LABEL: define {{[^@]+}}@start
; TUNIT-SAME: (i8 [[V:%.*]]) {
; TUNIT-NEXT:    [[C1:%.*]] = icmp eq i8 [[V]], 0
; TUNIT-NEXT:    br i1 [[C1]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; TUNIT:       true:
; TUNIT-NEXT:    [[CA:%.*]] = musttail call noalias noundef align 4294967296 i8* @side_effects(i8 [[V]])
; TUNIT-NEXT:    ret i8* [[CA]]
; TUNIT:       false:
; TUNIT-NEXT:    [[C2:%.*]] = icmp eq i8 [[V]], 1
; TUNIT-NEXT:    br i1 [[C2]], label [[C2_TRUE:%.*]], label [[C2_FALSE:%.*]]
; TUNIT:       c2_true:
; TUNIT-NEXT:    ret i8* null
; TUNIT:       c2_false:
; TUNIT-NEXT:    [[CA2:%.*]] = musttail call noalias noundef align 4294967296 i8* @dont_zap_me(i8 undef)
; TUNIT-NEXT:    ret i8* [[CA2]]
;
; CGSCC-LABEL: define {{[^@]+}}@start
; CGSCC-SAME: (i8 [[V:%.*]]) {
; CGSCC-NEXT:    [[C1:%.*]] = icmp eq i8 [[V]], 0
; CGSCC-NEXT:    br i1 [[C1]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CGSCC:       true:
; CGSCC-NEXT:    [[CA:%.*]] = musttail call noalias noundef align 4294967296 i8* @side_effects(i8 [[V]])
; CGSCC-NEXT:    ret i8* [[CA]]
; CGSCC:       false:
; CGSCC-NEXT:    [[C2:%.*]] = icmp eq i8 [[V]], 1
; CGSCC-NEXT:    br i1 [[C2]], label [[C2_TRUE:%.*]], label [[C2_FALSE:%.*]]
; CGSCC:       c2_true:
; CGSCC-NEXT:    [[CA1:%.*]] = musttail call noalias noundef align 4294967296 i8* @no_side_effects(i8 [[V]])
; CGSCC-NEXT:    ret i8* [[CA1]]
; CGSCC:       c2_false:
; CGSCC-NEXT:    [[CA2:%.*]] = musttail call noalias noundef align 4294967296 i8* @dont_zap_me(i8 [[V]])
; CGSCC-NEXT:    ret i8* [[CA2]]
;
  %c1 = icmp eq i8 %v, 0
  br i1 %c1, label %true, label %false
true:
  ; FIXME: propagate the value information for %v
  %ca = musttail call i8* @side_effects(i8 %v)
  ret i8* %ca
false:
  %c2 = icmp eq i8 %v, 1
  br i1 %c2, label %c2_true, label %c2_false
c2_true:
  %ca1 = musttail call i8* @no_side_effects(i8 %v)
  ret i8* %ca1
c2_false:
  %ca2 = musttail call i8* @dont_zap_me(i8 %v)
  ret i8* %ca2
}

define internal i8* @side_effects(i8 %v) {
; CHECK-LABEL: define {{[^@]+}}@side_effects
; CHECK-SAME: (i8 [[V:%.*]]) {
; CHECK-NEXT:    [[I1:%.*]] = call i32 @external()
; CHECK-NEXT:    [[CA:%.*]] = musttail call noalias noundef align 4294967296 i8* @start(i8 0)
; CHECK-NEXT:    ret i8* [[CA]]
;
  %i1 = call i32 @external()

  ; since this goes back to `start` the SCPP should be see that the return value
  ; is always `null`.
  ; The call can't be removed due to `external` call above, though.

  %ca = musttail call i8* @start(i8 %v)

  ; Thus the result must be returned anyway
  ret i8* %ca
}

define internal i8* @no_side_effects(i8 %v) readonly nounwind {
; CGSCC: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CGSCC-LABEL: define {{[^@]+}}@no_side_effects
; CGSCC-SAME: (i8 [[V:%.*]]) #[[ATTR0:[0-9]+]] {
; CGSCC-NEXT:    ret i8* null
;
  ret i8* null
}

define internal i8* @dont_zap_me(i8 %v) {
; CHECK-LABEL: define {{[^@]+}}@dont_zap_me
; CHECK-SAME: (i8 [[V:%.*]]) {
; CHECK-NEXT:    [[I1:%.*]] = call i32 @external()
; CHECK-NEXT:    ret i8* null
;
  %i1 = call i32 @external()
  ret i8* null
}
;.
; CGSCC: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind readnone willreturn }
;.
