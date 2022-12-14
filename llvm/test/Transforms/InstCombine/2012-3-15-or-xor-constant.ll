; RUN: opt < %s -passes=instcombine -S | FileCheck %s
; PR12234

@g = extern_weak global i32
define i32 @function(i32 %x) nounwind {
entry:
  %xor = xor i32 %x, 1
  store volatile i32 %xor, ptr inttoptr (i64 1 to ptr), align 4
  %or4 = or i32 or (i32 zext (i1 icmp eq (ptr @g, ptr null) to i32), i32 1), %xor
  ret i32 %or4
}
; CHECK-LABEL: define i32 @function(
