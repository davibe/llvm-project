; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,TUNIT
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,CGSCC

target datalayout = "E-p:64:64:64-a0:0:8-f32:32:32-f64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-v64:64:64-v128:128:128"

%struct.ss = type { i32, i32 }

; Argpromote + sroa should change this to passing the two integers by value.
define internal i32 @f(%struct.ss* inalloca(%struct.ss) %s) {
; CHECK: Function Attrs: argmemonly nofree norecurse nosync nounwind readonly willreturn
; CHECK-LABEL: define {{[^@]+}}@f
; CHECK-SAME: (%struct.ss* noalias nocapture nofree noundef nonnull inalloca([[STRUCT_SS:%.*]]) align 4 dereferenceable(8) [[S:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[F0:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 0
; CHECK-NEXT:    [[F1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; CHECK-NEXT:    [[A:%.*]] = load i32, i32* [[F0]], align 4
; CHECK-NEXT:    [[B:%.*]] = load i32, i32* [[F1]], align 4
; CHECK-NEXT:    [[R:%.*]] = add i32 [[A]], [[B]]
; CHECK-NEXT:    ret i32 [[R]]
;
entry:
  %f0 = getelementptr %struct.ss, %struct.ss* %s, i32 0, i32 0
  %f1 = getelementptr %struct.ss, %struct.ss* %s, i32 0, i32 1
  %a = load i32, i32* %f0, align 4
  %b = load i32, i32* %f1, align 4
  %r = add i32 %a, %b
  ret i32 %r
}

define i32 @main() {
; TUNIT: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; TUNIT-LABEL: define {{[^@]+}}@main
; TUNIT-SAME: () #[[ATTR1:[0-9]+]] {
; TUNIT-NEXT:  entry:
; TUNIT-NEXT:    [[S:%.*]] = alloca inalloca [[STRUCT_SS:%.*]], align 4
; TUNIT-NEXT:    [[F0:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 0
; TUNIT-NEXT:    [[F1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; TUNIT-NEXT:    store i32 1, i32* [[F0]], align 4
; TUNIT-NEXT:    store i32 2, i32* [[F1]], align 4
; TUNIT-NEXT:    [[R:%.*]] = call i32 @f(%struct.ss* noalias nocapture nofree noundef nonnull inalloca([[STRUCT_SS]]) align 4 dereferenceable(8) [[S]]) #[[ATTR2:[0-9]+]]
; TUNIT-NEXT:    ret i32 [[R]]
;
; CGSCC: Function Attrs: nofree nosync nounwind readnone willreturn
; CGSCC-LABEL: define {{[^@]+}}@main
; CGSCC-SAME: () #[[ATTR1:[0-9]+]] {
; CGSCC-NEXT:  entry:
; CGSCC-NEXT:    [[S:%.*]] = alloca inalloca [[STRUCT_SS:%.*]], align 4
; CGSCC-NEXT:    [[F0:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 0
; CGSCC-NEXT:    [[F1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; CGSCC-NEXT:    store i32 1, i32* [[F0]], align 4
; CGSCC-NEXT:    store i32 2, i32* [[F1]], align 4
; CGSCC-NEXT:    [[R:%.*]] = call i32 @f(%struct.ss* noalias nocapture nofree noundef nonnull inalloca([[STRUCT_SS]]) align 4 dereferenceable(8) [[S]]) #[[ATTR3:[0-9]+]]
; CGSCC-NEXT:    ret i32 [[R]]
;
entry:
  %S = alloca inalloca %struct.ss
  %f0 = getelementptr %struct.ss, %struct.ss* %S, i32 0, i32 0
  %f1 = getelementptr %struct.ss, %struct.ss* %S, i32 0, i32 1
  store i32 1, i32* %f0, align 4
  store i32 2, i32* %f1, align 4
  %r = call i32 @f(%struct.ss* inalloca(%struct.ss) %S)
  ret i32 %r
}

; Argpromote can't promote %a because of the icmp use.
define internal i1 @g(%struct.ss* %a, %struct.ss* inalloca(%struct.ss) %b) nounwind  {
; CGSCC: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CGSCC-LABEL: define {{[^@]+}}@g
; CGSCC-SAME: (%struct.ss* noalias nocapture nofree nonnull readnone align 4 dereferenceable(8) [[A:%.*]], %struct.ss* noalias nocapture nofree nonnull writeonly inalloca([[STRUCT_SS:%.*]]) align 4 dereferenceable(8) [[B:%.*]]) #[[ATTR2:[0-9]+]] {
; CGSCC-NEXT:  entry:
; CGSCC-NEXT:    ret i1 undef
;
entry:
  %c = icmp eq %struct.ss* %a, %b
  ret i1 %c
}

define i32 @test() {
; TUNIT: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; TUNIT-LABEL: define {{[^@]+}}@test
; TUNIT-SAME: () #[[ATTR1]] {
; TUNIT-NEXT:  entry:
; TUNIT-NEXT:    ret i32 0
;
; CGSCC: Function Attrs: nofree nosync nounwind readnone willreturn
; CGSCC-LABEL: define {{[^@]+}}@test
; CGSCC-SAME: () #[[ATTR1]] {
; CGSCC-NEXT:  entry:
; CGSCC-NEXT:    ret i32 0
;
entry:
  %S = alloca inalloca %struct.ss
  %c = call i1 @g(%struct.ss* %S, %struct.ss* inalloca(%struct.ss) %S)
  ret i32 0
}
;.
; TUNIT: attributes #[[ATTR0]] = { argmemonly nofree norecurse nosync nounwind readonly willreturn }
; TUNIT: attributes #[[ATTR1]] = { nofree norecurse nosync nounwind readnone willreturn }
; TUNIT: attributes #[[ATTR2]] = { nofree nosync nounwind readonly willreturn }
;.
; CGSCC: attributes #[[ATTR0]] = { argmemonly nofree norecurse nosync nounwind readonly willreturn }
; CGSCC: attributes #[[ATTR1]] = { nofree nosync nounwind readnone willreturn }
; CGSCC: attributes #[[ATTR2]] = { nofree norecurse nosync nounwind readnone willreturn }
; CGSCC: attributes #[[ATTR3]] = { readonly willreturn }
;.
