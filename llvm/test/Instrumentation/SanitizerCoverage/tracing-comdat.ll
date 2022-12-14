; Test that the coverage guards have proper comdat
; Make sure asan does not instrument __sancov_gen_

; RUN: opt < %s -passes='module(sancov-module)' -sanitizer-coverage-level=3 -sanitizer-coverage-trace-pc-guard  -S  | FileCheck %s
; RUN: opt < %s -passes='module(sancov-module,asan)' -sanitizer-coverage-level=3 -sanitizer-coverage-trace-pc-guard  -S  | FileCheck %s
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"
$Foo = comdat any
; Function Attrs: uwtable
define linkonce_odr void @Foo() comdat {
entry:
  ret void
}

define linkonce_odr void @Bar() {
entry:
  ret void
}

; CHECK: @__sancov_gen_ = private global [1 x i32] zeroinitializer, section "__sancov_guards", comdat($Foo)
; CHECK: @__sancov_gen_.1 = private global [1 x i32] zeroinitializer, section "__sancov_guards"
