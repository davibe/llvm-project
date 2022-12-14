; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O3 -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names \
; RUN:   -ppc-vsr-nums-as-vr < %s | FileCheck %s
; RUN: llc -O3 -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names \
; RUN:   -ppc-vsr-nums-as-vr < %s | FileCheck %s --check-prefix=CHECK-BE

declare <256 x i1> @llvm.ppc.vsx.assemble.pair(<16 x i8>, <16 x i8>)
declare <512 x i1> @llvm.ppc.mma.xxsetaccz()
declare <512 x i1> @llvm.ppc.mma.xvf64gerpp(<512 x i1>, <256 x i1>, <16 x i8>)
declare { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } @llvm.ppc.mma.disassemble.acc(<512 x i1>)
define void @testPHI1(ptr %Dst, ptr %Src, i32 signext %Len) {
; CHECK-LABEL: testPHI1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xxsetaccz acc0
; CHECK-NEXT:    cmpwi r5, 3
; CHECK-NEXT:    blt cr0, .LBB0_3
; CHECK-NEXT:  # %bb.1: # %for.body.preheader
; CHECK-NEXT:    lxv v2, 0(r4)
; CHECK-NEXT:    lxv v3, 16(r4)
; CHECK-NEXT:    clrldi r5, r5, 32
; CHECK-NEXT:    addi r4, r4, 32
; CHECK-NEXT:    addi r5, r5, -2
; CHECK-NEXT:    mtctr r5
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  .LBB0_2: # %for.body
; CHECK-NEXT:    #
; CHECK-NEXT:    lxv vs4, 0(r4)
; CHECK-NEXT:    addi r4, r4, 16
; CHECK-NEXT:    xvf64gerpp acc0, vsp34, vs4
; CHECK-NEXT:    bdnz .LBB0_2
; CHECK-NEXT:  .LBB0_3: # %for.cond.cleanup
; CHECK-NEXT:    xxmfacc acc0
; CHECK-NEXT:    stxv vs3, 0(r3)
; CHECK-NEXT:    stxv vs2, 16(r3)
; CHECK-NEXT:    stxv vs1, 32(r3)
; CHECK-NEXT:    stxv vs0, 48(r3)
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testPHI1:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xxsetaccz acc0
; CHECK-BE-NEXT:    cmpwi r5, 3
; CHECK-BE-NEXT:    blt cr0, .LBB0_3
; CHECK-BE-NEXT:  # %bb.1: # %for.body.preheader
; CHECK-BE-NEXT:    lxv v2, 0(r4)
; CHECK-BE-NEXT:    lxv v3, 16(r4)
; CHECK-BE-NEXT:    clrldi r5, r5, 32
; CHECK-BE-NEXT:    addi r4, r4, 32
; CHECK-BE-NEXT:    addi r5, r5, -2
; CHECK-BE-NEXT:    mtctr r5
; CHECK-BE-NEXT:    .p2align 4
; CHECK-BE-NEXT:  .LBB0_2: # %for.body
; CHECK-BE-NEXT:    #
; CHECK-BE-NEXT:    lxv vs4, 0(r4)
; CHECK-BE-NEXT:    addi r4, r4, 16
; CHECK-BE-NEXT:    xvf64gerpp acc0, vsp34, vs4
; CHECK-BE-NEXT:    bdnz .LBB0_2
; CHECK-BE-NEXT:  .LBB0_3: # %for.cond.cleanup
; CHECK-BE-NEXT:    xxmfacc acc0
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    stxv vs2, 32(r3)
; CHECK-BE-NEXT:    stxv vs3, 48(r3)
; CHECK-BE-NEXT:    blr
entry:
  %0 = load <16 x i8>, ptr %Src, align 16
  %arrayidx1 = getelementptr inbounds <16 x i8>, ptr %Src, i64 1
  %1 = load <16 x i8>, ptr %arrayidx1, align 16
  %2 = tail call <256 x i1> @llvm.ppc.vsx.assemble.pair(<16 x i8> %0, <16 x i8> %1)
  %3 = tail call <512 x i1> @llvm.ppc.mma.xxsetaccz()
  %cmp11 = icmp sgt i32 %Len, 2
  br i1 %cmp11, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:
  %wide.trip.count = zext i32 %Len to i64
  br label %for.body

for.cond.cleanup:
  %Acc.0.lcssa = phi <512 x i1> [ %3, %entry ], [ %13, %for.body ]
  %4 = tail call { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } @llvm.ppc.mma.disassemble.acc(<512 x i1> %Acc.0.lcssa)
  %5 = extractvalue { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } %4, 0
  store <16 x i8> %5, ptr %Dst, align 16
  %6 = extractvalue { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } %4, 1
  %7 = getelementptr inbounds <16 x i8>, ptr %Dst, i64 1
  store <16 x i8> %6, ptr %7, align 16
  %8 = extractvalue { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } %4, 2
  %9 = getelementptr inbounds <16 x i8>, ptr %Dst, i64 2
  store <16 x i8> %8, ptr %9, align 16
  %10 = extractvalue { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } %4, 3
  %11 = getelementptr inbounds <16 x i8>, ptr %Dst, i64 3
  store <16 x i8> %10, ptr %11, align 16
  ret void

for.body:
  %indvars.iv = phi i64 [ 2, %for.body.preheader ], [ %indvars.iv.next, %for.body ]
  %Acc.012 = phi <512 x i1> [ %3, %for.body.preheader ], [ %13, %for.body ]
  %arrayidx2 = getelementptr inbounds <16 x i8>, ptr %Src, i64 %indvars.iv
  %12 = load <16 x i8>, ptr %arrayidx2, align 16
  %13 = tail call <512 x i1> @llvm.ppc.mma.xvf64gerpp(<512 x i1> %Acc.012, <256 x i1> %2, <16 x i8> %12)
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body
}

declare <512 x i1> @llvm.ppc.mma.xvf64ger(<256 x i1>, <16 x i8>)
define dso_local void @testPHI2(ptr %Dst, ptr %Src, i32 signext %Len) {
; CHECK-LABEL: testPHI2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv v2, 0(r4)
; CHECK-NEXT:    lxv v3, 16(r4)
; CHECK-NEXT:    cmpwi r5, 4
; CHECK-NEXT:    lxv vs4, 32(r4)
; CHECK-NEXT:    xvf64ger acc0, vsp34, vs4
; CHECK-NEXT:    blt cr0, .LBB1_3
; CHECK-NEXT:  # %bb.1: # %for.body.preheader
; CHECK-NEXT:    clrldi r5, r5, 32
; CHECK-NEXT:    addi r4, r4, 48
; CHECK-NEXT:    addi r5, r5, -3
; CHECK-NEXT:    mtctr r5
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  .LBB1_2: # %for.body
; CHECK-NEXT:    #
; CHECK-NEXT:    lxv vs4, 0(r4)
; CHECK-NEXT:    addi r4, r4, 16
; CHECK-NEXT:    xvf64gerpp acc0, vsp34, vs4
; CHECK-NEXT:    bdnz .LBB1_2
; CHECK-NEXT:  .LBB1_3: # %for.cond.cleanup
; CHECK-NEXT:    xxmfacc acc0
; CHECK-NEXT:    stxv vs3, 0(r3)
; CHECK-NEXT:    stxv vs2, 16(r3)
; CHECK-NEXT:    stxv vs1, 32(r3)
; CHECK-NEXT:    stxv vs0, 48(r3)
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testPHI2:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv v2, 0(r4)
; CHECK-BE-NEXT:    lxv v3, 16(r4)
; CHECK-BE-NEXT:    cmpwi r5, 4
; CHECK-BE-NEXT:    lxv vs4, 32(r4)
; CHECK-BE-NEXT:    xvf64ger acc0, vsp34, vs4
; CHECK-BE-NEXT:    blt cr0, .LBB1_3
; CHECK-BE-NEXT:  # %bb.1: # %for.body.preheader
; CHECK-BE-NEXT:    clrldi r5, r5, 32
; CHECK-BE-NEXT:    addi r4, r4, 48
; CHECK-BE-NEXT:    addi r5, r5, -3
; CHECK-BE-NEXT:    mtctr r5
; CHECK-BE-NEXT:    .p2align 4
; CHECK-BE-NEXT:  .LBB1_2: # %for.body
; CHECK-BE-NEXT:    #
; CHECK-BE-NEXT:    lxv vs4, 0(r4)
; CHECK-BE-NEXT:    addi r4, r4, 16
; CHECK-BE-NEXT:    xvf64gerpp acc0, vsp34, vs4
; CHECK-BE-NEXT:    bdnz .LBB1_2
; CHECK-BE-NEXT:  .LBB1_3: # %for.cond.cleanup
; CHECK-BE-NEXT:    xxmfacc acc0
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    stxv vs2, 32(r3)
; CHECK-BE-NEXT:    stxv vs3, 48(r3)
; CHECK-BE-NEXT:    blr
entry:
  %0 = load <16 x i8>, ptr %Src, align 16
  %arrayidx1 = getelementptr inbounds <16 x i8>, ptr %Src, i64 1
  %1 = load <16 x i8>, ptr %arrayidx1, align 16
  %2 = tail call <256 x i1> @llvm.ppc.vsx.assemble.pair(<16 x i8> %0, <16 x i8> %1)
  %arrayidx2 = getelementptr inbounds <16 x i8>, ptr %Src, i64 2
  %3 = load <16 x i8>, ptr %arrayidx2, align 16
  %4 = tail call <512 x i1> @llvm.ppc.mma.xvf64ger(<256 x i1> %2, <16 x i8> %3)
  %cmp14 = icmp sgt i32 %Len, 3
  br i1 %cmp14, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:
  %wide.trip.count = zext i32 %Len to i64
  br label %for.body

for.cond.cleanup:
  %Acc.0.lcssa = phi <512 x i1> [ %4, %entry ], [ %14, %for.body ]
  %5 = tail call { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } @llvm.ppc.mma.disassemble.acc(<512 x i1> %Acc.0.lcssa)
  %6 = extractvalue { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } %5, 0
  store <16 x i8> %6, ptr %Dst, align 16
  %7 = extractvalue { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } %5, 1
  %8 = getelementptr inbounds <16 x i8>, ptr %Dst, i64 1
  store <16 x i8> %7, ptr %8, align 16
  %9 = extractvalue { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } %5, 2
  %10 = getelementptr inbounds <16 x i8>, ptr %Dst, i64 2
  store <16 x i8> %9, ptr %10, align 16
  %11 = extractvalue { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } %5, 3
  %12 = getelementptr inbounds <16 x i8>, ptr %Dst, i64 3
  store <16 x i8> %11, ptr %12, align 16
  ret void

for.body:
  %indvars.iv = phi i64 [ 3, %for.body.preheader ], [ %indvars.iv.next, %for.body ]
  %Acc.015 = phi <512 x i1> [ %4, %for.body.preheader ], [ %14, %for.body ]
  %arrayidx3 = getelementptr inbounds <16 x i8>, ptr %Src, i64 %indvars.iv
  %13 = load <16 x i8>, ptr %arrayidx3, align 16
  %14 = tail call <512 x i1> @llvm.ppc.mma.xvf64gerpp(<512 x i1> %Acc.015, <256 x i1> %2, <16 x i8> %13)
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body
}

; This test uses an unprimed accumulator PHI node with two operands: an
; implicitely defined unprimed accumulator and the unprimed result of the call
; to xvf64gerpp. The compiler should replace this PHI node by a primed
; accumulator PHI node.
define void @testImplicitDef(ptr %ptr) {
; CHECK-LABEL: testImplicitDef:
; CHECK:       # %bb.0: # %label1
; CHECK-NEXT:    # implicit-def: $acc0
; CHECK-NEXT:    bc 12, 4*cr5+lt, .LBB2_2
; CHECK-NEXT:  # %bb.1: # %label2
; CHECK-NEXT:    xvf64gerpp acc0, vsp34, vs0
; CHECK-NEXT:  .LBB2_2: # %label3
; CHECK-NEXT:    xxmfacc acc0
; CHECK-NEXT:    stxv vs0, 0(r3)
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testImplicitDef:
; CHECK-BE:       # %bb.0: # %label1
; CHECK-BE-NEXT:    # implicit-def: $acc0
; CHECK-BE-NEXT:    bc 12, 4*cr5+lt, .LBB2_2
; CHECK-BE-NEXT:  # %bb.1: # %label2
; CHECK-BE-NEXT:    xvf64gerpp acc0, vsp34, vs0
; CHECK-BE-NEXT:  .LBB2_2: # %label3
; CHECK-BE-NEXT:    xxmfacc acc0
; CHECK-BE-NEXT:    stxv vs3, 0(r3)
; CHECK-BE-NEXT:    blr
label1:
  br i1 undef, label %label3, label %label2

label2:
  %0 = call <512 x i1> @llvm.ppc.mma.xvf64gerpp(<512 x i1> undef, <256 x i1> undef, <16 x i8> undef)
  br label %label3

label3:
  %1 = phi <512 x i1> [ undef, %label1 ], [ %0, %label2 ]
  %2 = call { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } @llvm.ppc.mma.disassemble.acc(<512 x i1> %1)
  %3 = extractvalue { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } %2, 3
  store <16 x i8> %3, ptr %ptr, align 16
  ret void
}

; This test uses an unprimed accumulator PHI node with an unprimed accumulator
; PHI node operand. The compiler should replace these PHI nodes by primed
; accumulator PHI nodes.
declare <512 x i1> @llvm.ppc.mma.xvf32gernp(<512 x i1>, <16 x i8>, <16 x i8>)
define dso_local signext i32 @testNestedPHI(i32 signext %cond, i32 signext %count, ptr nocapture %ptr, <16 x i8> %vc) {
; CHECK-LABEL: testNestedPHI:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmplwi r3, 0
; CHECK-NEXT:    beq cr0, .LBB3_2
; CHECK-NEXT:  # %bb.1: # %if.then
; CHECK-NEXT:    xvf32gernp acc0, v2, v2
; CHECK-NEXT:    cmpwi r4, 1
; CHECK-NEXT:    bge cr0, .LBB3_3
; CHECK-NEXT:    b .LBB3_5
; CHECK-NEXT:  .LBB3_2:
; CHECK-NEXT:    # implicit-def: $acc0
; CHECK-NEXT:    cmpwi r4, 1
; CHECK-NEXT:    blt cr0, .LBB3_5
; CHECK-NEXT:  .LBB3_3: # %for.body.preheader
; CHECK-NEXT:    addi r3, r4, -1
; CHECK-NEXT:    clrldi r3, r3, 32
; CHECK-NEXT:    addi r3, r3, 1
; CHECK-NEXT:    mtctr r3
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  .LBB3_4: # %for.body
; CHECK-NEXT:    #
; CHECK-NEXT:    xvf32gernp acc0, v2, v2
; CHECK-NEXT:    bdnz .LBB3_4
; CHECK-NEXT:  .LBB3_5: # %for.cond.cleanup
; CHECK-NEXT:    xxmfacc acc0
; CHECK-NEXT:    li r3, 0
; CHECK-NEXT:    stxv vs0, 48(r5)
; CHECK-NEXT:    stxv vs1, 32(r5)
; CHECK-NEXT:    stxv vs2, 16(r5)
; CHECK-NEXT:    stxv vs3, 0(r5)
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testNestedPHI:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmplwi r3, 0
; CHECK-BE-NEXT:    beq cr0, .LBB3_2
; CHECK-BE-NEXT:  # %bb.1: # %if.then
; CHECK-BE-NEXT:    xvf32gernp acc0, v2, v2
; CHECK-BE-NEXT:    cmpwi r4, 1
; CHECK-BE-NEXT:    bge cr0, .LBB3_3
; CHECK-BE-NEXT:    b .LBB3_5
; CHECK-BE-NEXT:  .LBB3_2:
; CHECK-BE-NEXT:    # implicit-def: $acc0
; CHECK-BE-NEXT:    cmpwi r4, 1
; CHECK-BE-NEXT:    blt cr0, .LBB3_5
; CHECK-BE-NEXT:  .LBB3_3: # %for.body.preheader
; CHECK-BE-NEXT:    addi r3, r4, -1
; CHECK-BE-NEXT:    clrldi r3, r3, 32
; CHECK-BE-NEXT:    addi r3, r3, 1
; CHECK-BE-NEXT:    mtctr r3
; CHECK-BE-NEXT:    .p2align 4
; CHECK-BE-NEXT:  .LBB3_4: # %for.body
; CHECK-BE-NEXT:    #
; CHECK-BE-NEXT:    xvf32gernp acc0, v2, v2
; CHECK-BE-NEXT:    bdnz .LBB3_4
; CHECK-BE-NEXT:  .LBB3_5: # %for.cond.cleanup
; CHECK-BE-NEXT:    xxmfacc acc0
; CHECK-BE-NEXT:    li r3, 0
; CHECK-BE-NEXT:    stxv vs1, 16(r5)
; CHECK-BE-NEXT:    stxv vs0, 0(r5)
; CHECK-BE-NEXT:    stxv vs3, 48(r5)
; CHECK-BE-NEXT:    stxv vs2, 32(r5)
; CHECK-BE-NEXT:    blr
entry:
  %tobool.not = icmp eq i32 %cond, 0
  br i1 %tobool.not, label %if.end, label %if.then

if.then:
  %0 = tail call <512 x i1> @llvm.ppc.mma.xvf32gernp(<512 x i1> undef, <16 x i8> %vc, <16 x i8> %vc)
  br label %if.end

if.end:
  %vq.0 = phi <512 x i1> [ %0, %if.then ], [ undef, %entry ]
  %cmp9 = icmp sgt i32 %count, 0
  br i1 %cmp9, label %for.body, label %for.cond.cleanup

for.cond.cleanup:
  %vq.1.lcssa = phi <512 x i1> [ %vq.0, %if.end ], [ %1, %for.body ]
  store <512 x i1> %vq.1.lcssa, ptr %ptr, align 64
  ret i32 0

for.body:
  %i.011 = phi i32 [ %inc, %for.body ], [ 0, %if.end ]
  %vq.110 = phi <512 x i1> [ %1, %for.body ], [ %vq.0, %if.end ]
  %1 = tail call <512 x i1> @llvm.ppc.mma.xvf32gernp(<512 x i1> %vq.110, <16 x i8> %vc, <16 x i8> %vc)
  %inc = add nuw nsw i32 %i.011, 1
  %exitcond.not = icmp eq i32 %inc, %count
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body
}
