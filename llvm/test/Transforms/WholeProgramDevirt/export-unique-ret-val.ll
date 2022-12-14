; RUN: opt -passes=wholeprogramdevirt -whole-program-visibility -wholeprogramdevirt-summary-action=export -wholeprogramdevirt-read-summary=%S/Inputs/export.yaml -wholeprogramdevirt-write-summary=%t -S -o - %s | FileCheck %s
; RUN: FileCheck --check-prefix=SUMMARY %s < %t

; SUMMARY-NOT:  TypeTests:

; SUMMARY:      TypeIdMap:
; SUMMARY-NEXT:   typeid3:
; SUMMARY-NEXT:     TTRes:
; SUMMARY-NEXT:       Kind:            Unknown
; SUMMARY-NEXT:       SizeM1BitWidth:  0
; SUMMARY-NEXT:       AlignLog2:       0
; SUMMARY-NEXT:       SizeM1:          0
; SUMMARY-NEXT:       BitMask:         0
; SUMMARY-NEXT:       InlineBits:      0
; SUMMARY-NEXT:     WPDRes:
; SUMMARY-NEXT:       0:
; SUMMARY-NEXT:         Kind:            Indir
; SUMMARY-NEXT:         SingleImplName:  ''
; SUMMARY-NEXT:         ResByArg:
; SUMMARY-NEXT:           12,24:
; SUMMARY-NEXT:             Kind:            UniqueRetVal
; SUMMARY-NEXT:             Info:            0
; SUMMARY-NEXT:             Byte:            0
; SUMMARY-NEXT:             Bit:             0
; SUMMARY-NEXT:   typeid4:
; SUMMARY-NEXT:     TTRes:
; SUMMARY-NEXT:       Kind:            Unknown
; SUMMARY-NEXT:       SizeM1BitWidth:  0
; SUMMARY-NEXT:       AlignLog2:       0
; SUMMARY-NEXT:       SizeM1:          0
; SUMMARY-NEXT:       BitMask:         0
; SUMMARY-NEXT:       InlineBits:      0
; SUMMARY-NEXT:     WPDRes:
; SUMMARY-NEXT:       0:
; SUMMARY-NEXT:         Kind:            Indir
; SUMMARY-NEXT:         SingleImplName:  ''
; SUMMARY-NEXT:         ResByArg:
; SUMMARY-NEXT:           24,12:
; SUMMARY-NEXT:             Kind:            UniqueRetVal
; SUMMARY-NEXT:             Info:            1
; SUMMARY-NEXT:             Byte:            0
; SUMMARY-NEXT:             Bit:             0

; CHECK: @vt3a = constant ptr @vf3a
@vt3a = constant ptr @vf3a, !type !0

; CHECK: @vt3b = constant ptr @vf3b
@vt3b = constant ptr @vf3b, !type !0

; CHECK: @vt3c = constant ptr @vf3c
@vt3c = constant ptr @vf3c, !type !0

; CHECK: @vt4a = constant ptr @vf4a
@vt4a = constant ptr @vf4a, !type !1

; CHECK: @vt4b = constant ptr @vf4b
@vt4b = constant ptr @vf4b, !type !1

; CHECK: @vt4c = constant ptr @vf4c
@vt4c = constant ptr @vf4c, !type !1

; CHECK: @__typeid_typeid3_0_12_24_unique_member = hidden alias i8, ptr @vt3b
; CHECK: @__typeid_typeid4_0_24_12_unique_member = hidden alias i8, ptr @vt4b

define i1 @vf3a(ptr, i32, i32) {
  ret i1 true
}

define i1 @vf3b(ptr, i32, i32) {
  ret i1 false
}

define i1 @vf3c(ptr, i32, i32) {
  ret i1 true
}

define i1 @vf4a(ptr, i32, i32) {
  ret i1 false
}

define i1 @vf4b(ptr, i32, i32) {
  ret i1 true
}

define i1 @vf4c(ptr, i32, i32) {
  ret i1 false
}

!0 = !{i32 0, !"typeid3"}
!1 = !{i32 0, !"typeid4"}
