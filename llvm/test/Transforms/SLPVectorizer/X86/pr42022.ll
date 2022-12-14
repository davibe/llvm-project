; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=slp-vectorizer -S -mtriple=x86_64-unknown-linux-gnu < %s | FileCheck %s

; See https://reviews.llvm.org/D70068 and https://reviews.llvm.org/D70587 for context

; Checks that vector insertvalues into the struct become SLP seeds.
define { <2 x float>, <2 x float> } @StructOfVectors(float *%Ptr) {
; CHECK-LABEL: @StructOfVectors(
; CHECK-NEXT:    [[GEP0:%.*]] = getelementptr inbounds float, float* [[PTR:%.*]], i64 0
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast float* [[GEP0]] to <4 x float>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x float>, <4 x float>* [[TMP1]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = fadd fast <4 x float> [[TMP2]], <float 1.100000e+01, float 1.200000e+01, float 1.300000e+01, float 1.400000e+01>
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <4 x float> [[TMP3]], <4 x float> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP5:%.*]] = shufflevector <4 x float> [[TMP3]], <4 x float> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[RET0:%.*]] = insertvalue { <2 x float>, <2 x float> } undef, <2 x float> [[TMP4]], 0
; CHECK-NEXT:    [[RET1:%.*]] = insertvalue { <2 x float>, <2 x float> } [[RET0]], <2 x float> [[TMP5]], 1
; CHECK-NEXT:    ret { <2 x float>, <2 x float> } [[RET1]]
;
  %GEP0 = getelementptr inbounds float, float* %Ptr, i64 0
  %L0 = load float, float * %GEP0
  %GEP1 = getelementptr inbounds float, float* %Ptr, i64 1
  %L1 = load float, float * %GEP1
  %GEP2 = getelementptr inbounds float, float* %Ptr, i64 2
  %L2 = load float, float * %GEP2
  %GEP3 = getelementptr inbounds float, float* %Ptr, i64 3
  %L3 = load float, float * %GEP3

  %Fadd0 = fadd fast float %L0, 1.1e+01
  %Fadd1 = fadd fast float %L1, 1.2e+01
  %Fadd2 = fadd fast float %L2, 1.3e+01
  %Fadd3 = fadd fast float %L3, 1.4e+01

  %VecIn0 = insertelement <2 x float> undef, float %Fadd0, i64 0
  %VecIn1 = insertelement <2 x float> %VecIn0, float %Fadd1, i64 1

  %VecIn2 = insertelement <2 x float> undef, float %Fadd2, i64 0
  %VecIn3 = insertelement <2 x float> %VecIn2, float %Fadd3, i64 1

  %Ret0 = insertvalue {<2 x float>, <2 x float>} undef, <2 x float> %VecIn1, 0
  %Ret1 = insertvalue {<2 x float>, <2 x float>} %Ret0, <2 x float> %VecIn3, 1
  ret {<2 x float>, <2 x float>} %Ret1
}

%StructTy = type { float, float}

define [2 x %StructTy] @ArrayOfStruct(float *%Ptr) {
; CHECK-LABEL: @ArrayOfStruct(
; CHECK-NEXT:    [[GEP0:%.*]] = getelementptr inbounds float, float* [[PTR:%.*]], i64 0
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast float* [[GEP0]] to <4 x float>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x float>, <4 x float>* [[TMP1]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = fadd fast <4 x float> [[TMP2]], <float 1.100000e+01, float 1.200000e+01, float 1.300000e+01, float 1.400000e+01>
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x float> [[TMP3]], i32 0
; CHECK-NEXT:    [[STRUCTIN0:%.*]] = insertvalue [[STRUCTTY:%.*]] undef, float [[TMP4]], 0
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <4 x float> [[TMP3]], i32 1
; CHECK-NEXT:    [[STRUCTIN1:%.*]] = insertvalue [[STRUCTTY]] [[STRUCTIN0]], float [[TMP5]], 1
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <4 x float> [[TMP3]], i32 2
; CHECK-NEXT:    [[STRUCTIN2:%.*]] = insertvalue [[STRUCTTY]] undef, float [[TMP6]], 0
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <4 x float> [[TMP3]], i32 3
; CHECK-NEXT:    [[STRUCTIN3:%.*]] = insertvalue [[STRUCTTY]] [[STRUCTIN2]], float [[TMP7]], 1
; CHECK-NEXT:    [[RET0:%.*]] = insertvalue [2 x %StructTy] undef, [[STRUCTTY]] [[STRUCTIN1]], 0
; CHECK-NEXT:    [[RET1:%.*]] = insertvalue [2 x %StructTy] [[RET0]], [[STRUCTTY]] [[STRUCTIN3]], 1
; CHECK-NEXT:    ret [2 x %StructTy] [[RET1]]
;
  %GEP0 = getelementptr inbounds float, float* %Ptr, i64 0
  %L0 = load float, float * %GEP0
  %GEP1 = getelementptr inbounds float, float* %Ptr, i64 1
  %L1 = load float, float * %GEP1
  %GEP2 = getelementptr inbounds float, float* %Ptr, i64 2
  %L2 = load float, float * %GEP2
  %GEP3 = getelementptr inbounds float, float* %Ptr, i64 3
  %L3 = load float, float * %GEP3

  %Fadd0 = fadd fast float %L0, 1.1e+01
  %Fadd1 = fadd fast float %L1, 1.2e+01
  %Fadd2 = fadd fast float %L2, 1.3e+01
  %Fadd3 = fadd fast float %L3, 1.4e+01

  %StructIn0 = insertvalue %StructTy undef, float %Fadd0, 0
  %StructIn1 = insertvalue %StructTy %StructIn0, float %Fadd1, 1

  %StructIn2 = insertvalue %StructTy undef, float %Fadd2, 0
  %StructIn3 = insertvalue %StructTy %StructIn2, float %Fadd3, 1

  %Ret0 = insertvalue [2 x %StructTy] undef, %StructTy %StructIn1, 0
  %Ret1 = insertvalue [2 x %StructTy] %Ret0, %StructTy %StructIn3, 1
  ret [2 x %StructTy] %Ret1
}

define {%StructTy, %StructTy} @StructOfStruct(float *%Ptr) {
; CHECK-LABEL: @StructOfStruct(
; CHECK-NEXT:    [[GEP0:%.*]] = getelementptr inbounds float, float* [[PTR:%.*]], i64 0
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast float* [[GEP0]] to <4 x float>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x float>, <4 x float>* [[TMP1]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = fadd fast <4 x float> [[TMP2]], <float 1.100000e+01, float 1.200000e+01, float 1.300000e+01, float 1.400000e+01>
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x float> [[TMP3]], i32 0
; CHECK-NEXT:    [[STRUCTIN0:%.*]] = insertvalue [[STRUCTTY:%.*]] undef, float [[TMP4]], 0
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <4 x float> [[TMP3]], i32 1
; CHECK-NEXT:    [[STRUCTIN1:%.*]] = insertvalue [[STRUCTTY]] [[STRUCTIN0]], float [[TMP5]], 1
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <4 x float> [[TMP3]], i32 2
; CHECK-NEXT:    [[STRUCTIN2:%.*]] = insertvalue [[STRUCTTY]] undef, float [[TMP6]], 0
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <4 x float> [[TMP3]], i32 3
; CHECK-NEXT:    [[STRUCTIN3:%.*]] = insertvalue [[STRUCTTY]] [[STRUCTIN2]], float [[TMP7]], 1
; CHECK-NEXT:    [[RET0:%.*]] = insertvalue { [[STRUCTTY]], [[STRUCTTY]] } undef, [[STRUCTTY]] [[STRUCTIN1]], 0
; CHECK-NEXT:    [[RET1:%.*]] = insertvalue { [[STRUCTTY]], [[STRUCTTY]] } [[RET0]], [[STRUCTTY]] [[STRUCTIN3]], 1
; CHECK-NEXT:    ret { [[STRUCTTY]], [[STRUCTTY]] } [[RET1]]
;
  %GEP0 = getelementptr inbounds float, float* %Ptr, i64 0
  %L0 = load float, float * %GEP0
  %GEP1 = getelementptr inbounds float, float* %Ptr, i64 1
  %L1 = load float, float * %GEP1
  %GEP2 = getelementptr inbounds float, float* %Ptr, i64 2
  %L2 = load float, float * %GEP2
  %GEP3 = getelementptr inbounds float, float* %Ptr, i64 3
  %L3 = load float, float * %GEP3

  %Fadd0 = fadd fast float %L0, 1.1e+01
  %Fadd1 = fadd fast float %L1, 1.2e+01
  %Fadd2 = fadd fast float %L2, 1.3e+01
  %Fadd3 = fadd fast float %L3, 1.4e+01

  %StructIn0 = insertvalue %StructTy undef, float %Fadd0, 0
  %StructIn1 = insertvalue %StructTy %StructIn0, float %Fadd1, 1

  %StructIn2 = insertvalue %StructTy undef, float %Fadd2, 0
  %StructIn3 = insertvalue %StructTy %StructIn2, float %Fadd3, 1

  %Ret0 = insertvalue {%StructTy, %StructTy} undef, %StructTy %StructIn1, 0
  %Ret1 = insertvalue {%StructTy, %StructTy} %Ret0, %StructTy %StructIn3, 1
  ret {%StructTy, %StructTy} %Ret1
}

define {%StructTy, float, float} @NonHomogeneousStruct(float *%Ptr) {
; CHECK-LABEL: @NonHomogeneousStruct(
; CHECK-NEXT:    [[GEP0:%.*]] = getelementptr inbounds float, float* [[PTR:%.*]], i64 0
; CHECK-NEXT:    [[L0:%.*]] = load float, float* [[GEP0]], align 4
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr inbounds float, float* [[PTR]], i64 1
; CHECK-NEXT:    [[L1:%.*]] = load float, float* [[GEP1]], align 4
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr inbounds float, float* [[PTR]], i64 2
; CHECK-NEXT:    [[L2:%.*]] = load float, float* [[GEP2]], align 4
; CHECK-NEXT:    [[GEP3:%.*]] = getelementptr inbounds float, float* [[PTR]], i64 3
; CHECK-NEXT:    [[L3:%.*]] = load float, float* [[GEP3]], align 4
; CHECK-NEXT:    [[FADD0:%.*]] = fadd fast float [[L0]], 1.100000e+01
; CHECK-NEXT:    [[FADD1:%.*]] = fadd fast float [[L1]], 1.200000e+01
; CHECK-NEXT:    [[FADD2:%.*]] = fadd fast float [[L2]], 1.300000e+01
; CHECK-NEXT:    [[FADD3:%.*]] = fadd fast float [[L3]], 1.400000e+01
; CHECK-NEXT:    [[STRUCTIN0:%.*]] = insertvalue [[STRUCTTY:%.*]] undef, float [[FADD0]], 0
; CHECK-NEXT:    [[STRUCTIN1:%.*]] = insertvalue [[STRUCTTY]] [[STRUCTIN0]], float [[FADD1]], 1
; CHECK-NEXT:    [[RET0:%.*]] = insertvalue { [[STRUCTTY]], float, float } undef, [[STRUCTTY]] [[STRUCTIN1]], 0
; CHECK-NEXT:    [[RET1:%.*]] = insertvalue { [[STRUCTTY]], float, float } [[RET0]], float [[FADD2]], 1
; CHECK-NEXT:    [[RET2:%.*]] = insertvalue { [[STRUCTTY]], float, float } [[RET1]], float [[FADD3]], 2
; CHECK-NEXT:    ret { [[STRUCTTY]], float, float } [[RET2]]
;
  %GEP0 = getelementptr inbounds float, float* %Ptr, i64 0
  %L0 = load float, float * %GEP0
  %GEP1 = getelementptr inbounds float, float* %Ptr, i64 1
  %L1 = load float, float * %GEP1
  %GEP2 = getelementptr inbounds float, float* %Ptr, i64 2
  %L2 = load float, float * %GEP2
  %GEP3 = getelementptr inbounds float, float* %Ptr, i64 3
  %L3 = load float, float * %GEP3

  %Fadd0 = fadd fast float %L0, 1.1e+01
  %Fadd1 = fadd fast float %L1, 1.2e+01
  %Fadd2 = fadd fast float %L2, 1.3e+01
  %Fadd3 = fadd fast float %L3, 1.4e+01

  %StructIn0 = insertvalue %StructTy undef, float %Fadd0, 0
  %StructIn1 = insertvalue %StructTy %StructIn0, float %Fadd1, 1

  %Ret0 = insertvalue {%StructTy, float, float} undef, %StructTy %StructIn1, 0
  %Ret1 = insertvalue {%StructTy, float, float} %Ret0, float %Fadd2, 1
  %Ret2 = insertvalue {%StructTy, float, float} %Ret1, float %Fadd3, 2
  ret {%StructTy, float, float} %Ret2
}

%Struct1Ty = type { i16, i16 }
%Struct2Ty = type { %Struct1Ty, %Struct1Ty}

define {%Struct2Ty, %Struct2Ty} @StructOfStructOfStruct(i16 *%Ptr) {
; CHECK-LABEL: @StructOfStructOfStruct(
; CHECK-NEXT:    [[GEP0:%.*]] = getelementptr inbounds i16, i16* [[PTR:%.*]], i64 0
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i16* [[GEP0]] to <8 x i16>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <8 x i16>, <8 x i16>* [[TMP1]], align 2
; CHECK-NEXT:    [[TMP3:%.*]] = add <8 x i16> [[TMP2]], <i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7, i16 8>
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <8 x i16> [[TMP3]], i32 0
; CHECK-NEXT:    [[STRUCTIN0:%.*]] = insertvalue [[STRUCT1TY:%.*]] undef, i16 [[TMP4]], 0
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <8 x i16> [[TMP3]], i32 1
; CHECK-NEXT:    [[STRUCTIN1:%.*]] = insertvalue [[STRUCT1TY]] [[STRUCTIN0]], i16 [[TMP5]], 1
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <8 x i16> [[TMP3]], i32 2
; CHECK-NEXT:    [[STRUCTIN2:%.*]] = insertvalue [[STRUCT1TY]] undef, i16 [[TMP6]], 0
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <8 x i16> [[TMP3]], i32 3
; CHECK-NEXT:    [[STRUCTIN3:%.*]] = insertvalue [[STRUCT1TY]] [[STRUCTIN2]], i16 [[TMP7]], 1
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <8 x i16> [[TMP3]], i32 4
; CHECK-NEXT:    [[STRUCTIN4:%.*]] = insertvalue [[STRUCT1TY]] undef, i16 [[TMP8]], 0
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <8 x i16> [[TMP3]], i32 5
; CHECK-NEXT:    [[STRUCTIN5:%.*]] = insertvalue [[STRUCT1TY]] [[STRUCTIN4]], i16 [[TMP9]], 1
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <8 x i16> [[TMP3]], i32 6
; CHECK-NEXT:    [[STRUCTIN6:%.*]] = insertvalue [[STRUCT1TY]] undef, i16 [[TMP10]], 0
; CHECK-NEXT:    [[TMP11:%.*]] = extractelement <8 x i16> [[TMP3]], i32 7
; CHECK-NEXT:    [[STRUCTIN7:%.*]] = insertvalue [[STRUCT1TY]] [[STRUCTIN6]], i16 [[TMP11]], 1
; CHECK-NEXT:    [[STRUCT2IN0:%.*]] = insertvalue [[STRUCT2TY:%.*]] undef, [[STRUCT1TY]] [[STRUCTIN1]], 0
; CHECK-NEXT:    [[STRUCT2IN1:%.*]] = insertvalue [[STRUCT2TY]] [[STRUCT2IN0]], [[STRUCT1TY]] [[STRUCTIN3]], 1
; CHECK-NEXT:    [[STRUCT2IN2:%.*]] = insertvalue [[STRUCT2TY]] undef, [[STRUCT1TY]] [[STRUCTIN5]], 0
; CHECK-NEXT:    [[STRUCT2IN3:%.*]] = insertvalue [[STRUCT2TY]] [[STRUCT2IN2]], [[STRUCT1TY]] [[STRUCTIN7]], 1
; CHECK-NEXT:    [[RET0:%.*]] = insertvalue { [[STRUCT2TY]], [[STRUCT2TY]] } undef, [[STRUCT2TY]] [[STRUCT2IN1]], 0
; CHECK-NEXT:    [[RET1:%.*]] = insertvalue { [[STRUCT2TY]], [[STRUCT2TY]] } [[RET0]], [[STRUCT2TY]] [[STRUCT2IN3]], 1
; CHECK-NEXT:    ret { [[STRUCT2TY]], [[STRUCT2TY]] } [[RET1]]
;
  %GEP0 = getelementptr inbounds i16, i16* %Ptr, i64 0
  %L0 = load i16, i16 * %GEP0
  %GEP1 = getelementptr inbounds i16, i16* %Ptr, i64 1
  %L1 = load i16, i16 * %GEP1
  %GEP2 = getelementptr inbounds i16, i16* %Ptr, i64 2
  %L2 = load i16, i16 * %GEP2
  %GEP3 = getelementptr inbounds i16, i16* %Ptr, i64 3
  %L3 = load i16, i16 * %GEP3
  %GEP4 = getelementptr inbounds i16, i16* %Ptr, i64 4
  %L4 = load i16, i16 * %GEP4
  %GEP5 = getelementptr inbounds i16, i16* %Ptr, i64 5
  %L5 = load i16, i16 * %GEP5
  %GEP6 = getelementptr inbounds i16, i16* %Ptr, i64 6
  %L6 = load i16, i16 * %GEP6
  %GEP7 = getelementptr inbounds i16, i16* %Ptr, i64 7
  %L7 = load i16, i16 * %GEP7

  %Fadd0 = add i16 %L0, 1
  %Fadd1 = add i16 %L1, 2
  %Fadd2 = add i16 %L2, 3
  %Fadd3 = add i16 %L3, 4
  %Fadd4 = add i16 %L4, 5
  %Fadd5 = add i16 %L5, 6
  %Fadd6 = add i16 %L6, 7
  %Fadd7 = add i16 %L7, 8

  %StructIn0 = insertvalue %Struct1Ty undef, i16 %Fadd0, 0
  %StructIn1 = insertvalue %Struct1Ty %StructIn0, i16 %Fadd1, 1

  %StructIn2 = insertvalue %Struct1Ty undef, i16 %Fadd2, 0
  %StructIn3 = insertvalue %Struct1Ty %StructIn2, i16 %Fadd3, 1

  %StructIn4 = insertvalue %Struct1Ty undef, i16 %Fadd4, 0
  %StructIn5 = insertvalue %Struct1Ty %StructIn4, i16 %Fadd5, 1

  %StructIn6 = insertvalue %Struct1Ty undef, i16 %Fadd6, 0
  %StructIn7 = insertvalue %Struct1Ty %StructIn6, i16 %Fadd7, 1

  %Struct2In0 = insertvalue %Struct2Ty undef, %Struct1Ty %StructIn1, 0
  %Struct2In1 = insertvalue %Struct2Ty %Struct2In0, %Struct1Ty %StructIn3, 1

  %Struct2In2 = insertvalue %Struct2Ty undef, %Struct1Ty %StructIn5, 0
  %Struct2In3 = insertvalue %Struct2Ty %Struct2In2, %Struct1Ty %StructIn7, 1

  %Ret0 = insertvalue {%Struct2Ty, %Struct2Ty} undef, %Struct2Ty %Struct2In1, 0
  %Ret1 = insertvalue {%Struct2Ty, %Struct2Ty} %Ret0, %Struct2Ty %Struct2In3, 1
  ret {%Struct2Ty, %Struct2Ty} %Ret1
}
