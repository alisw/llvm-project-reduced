; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -passes=argpromotion,mem2reg -S < %s | FileCheck %s
target datalayout = "E-p:64:64:64-a0:0:8-f32:32:32-f64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-v64:64:64-v128:128:128"

; Checks if !prof metadata is corret in deadargelim.

define void @caller() #0 {
; CHECK-LABEL: define {{[^@]+}}@caller() {
; CHECK-NEXT:    call void @promote_i32_ptr(i32 42), !prof [[PROF0:![0-9]+]]
; CHECK-NEXT:    ret void
;
  %x = alloca i32
  store i32 42, i32* %x
  call void @promote_i32_ptr(i32* %x), !prof !0
  ret void
}

define internal void @promote_i32_ptr(i32* %xp) !prof !1 {
; CHECK-LABEL: define {{[^@]+}}@promote_i32_ptr
; CHECK-SAME: (i32 [[XP_0_VAL:%.*]]) !prof [[PROF1:![0-9]+]] {
; CHECK-NEXT:    call void @use_i32(i32 [[XP_0_VAL]])
; CHECK-NEXT:    ret void
;
  %x = load i32, i32* %xp
  call void @use_i32(i32 %x)
  ret void
}

declare void @use_i32(i32)

!0 = !{!"branch_weights", i32 30}
!1 = !{!"function_entry_count", i64 100}