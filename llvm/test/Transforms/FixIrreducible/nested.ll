; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -fix-irreducible -S | FileCheck %s -check-prefix=CHECK

define void @nested_irr_top_level(i1 %Pred0, i1 %Pred1, i1 %Pred2, i1 %Pred3, i1 %Pred4, i1 %Pred5) {
; CHECK-LABEL: @nested_irr_top_level(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[IRR_GUARD:%.*]]
; CHECK:       A1:
; CHECK-NEXT:    br label [[IRR_GUARD1:%.*]]
; CHECK:       B1:
; CHECK-NEXT:    br i1 [[PRED2:%.*]], label [[IRR_GUARD1]], label [[A3:%.*]]
; CHECK:       B2:
; CHECK-NEXT:    br i1 [[PRED3:%.*]], label [[IRR_GUARD1]], label [[A3]]
; CHECK:       A3:
; CHECK-NEXT:    br i1 [[PRED4:%.*]], label [[IRR_GUARD]], label [[EXIT:%.*]]
; CHECK:       A2:
; CHECK-NEXT:    br i1 [[PRED5:%.*]], label [[IRR_GUARD]], label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
; CHECK:       irr.guard:
; CHECK-NEXT:    [[GUARD_A1:%.*]] = phi i1 [ true, [[A2:%.*]] ], [ [[PRED0:%.*]], [[ENTRY:%.*]] ], [ false, [[A3]] ]
; CHECK-NEXT:    br i1 [[GUARD_A1]], label [[A1:%.*]], label [[A2]]
; CHECK:       irr.guard1:
; CHECK-NEXT:    [[GUARD_B1:%.*]] = phi i1 [ true, [[B2:%.*]] ], [ [[PRED1:%.*]], [[A1]] ], [ false, [[B1:%.*]] ]
; CHECK-NEXT:    br i1 [[GUARD_B1]], label [[B1]], label [[B2]]
;
entry:
  br i1 %Pred0, label %A1, label %A2

A1:
  br i1 %Pred1, label %B1, label %B2

B1:
  br i1 %Pred2, label %B2, label %A3

B2:
  br i1 %Pred3, label %B1, label %A3

A3:
  br i1 %Pred4, label %A2, label %exit

A2:
  br i1 %Pred5, label %A1, label %exit

exit:
  ret void
}

define void @nested_irr_in_loop(i1 %Pred0, i1 %Pred1, i1 %Pred2, i1 %Pred3, i1 %Pred4, i1 %Pred5, i1 %Pred6) {
; CHECK-LABEL: @nested_irr_in_loop(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[H1:%.*]]
; CHECK:       H1:
; CHECK-NEXT:    br label [[IRR_GUARD:%.*]]
; CHECK:       A1:
; CHECK-NEXT:    br label [[IRR_GUARD1:%.*]]
; CHECK:       B1:
; CHECK-NEXT:    br i1 [[PRED2:%.*]], label [[IRR_GUARD1]], label [[A3:%.*]]
; CHECK:       B2:
; CHECK-NEXT:    br i1 [[PRED3:%.*]], label [[IRR_GUARD1]], label [[A3]]
; CHECK:       A3:
; CHECK-NEXT:    br i1 [[PRED4:%.*]], label [[IRR_GUARD]], label [[L1:%.*]]
; CHECK:       A2:
; CHECK-NEXT:    br i1 [[PRED5:%.*]], label [[IRR_GUARD]], label [[L1]]
; CHECK:       L1:
; CHECK-NEXT:    br i1 [[PRED6:%.*]], label [[EXIT:%.*]], label [[H1]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
; CHECK:       irr.guard:
; CHECK-NEXT:    [[GUARD_A1:%.*]] = phi i1 [ true, [[A2:%.*]] ], [ [[PRED0:%.*]], [[H1]] ], [ false, [[A3]] ]
; CHECK-NEXT:    br i1 [[GUARD_A1]], label [[A1:%.*]], label [[A2]]
; CHECK:       irr.guard1:
; CHECK-NEXT:    [[GUARD_B1:%.*]] = phi i1 [ true, [[B2:%.*]] ], [ [[PRED1:%.*]], [[A1]] ], [ false, [[B1:%.*]] ]
; CHECK-NEXT:    br i1 [[GUARD_B1]], label [[B1]], label [[B2]]
;
entry:
  br label %H1

H1:
  br i1 %Pred0, label %A1, label %A2

A1:
  br i1 %Pred1, label %B1, label %B2

B1:
  br i1 %Pred2, label %B2, label %A3

B2:
  br i1 %Pred3, label %B1, label %A3

A3:
  br i1 %Pred4, label %A2, label %L1

A2:
  br i1 %Pred5, label %A1, label %L1

L1:
  br i1 %Pred6, label %exit, label %H1

exit:
  ret void
}

define void @loop_in_irr(i1 %Pred0, i1 %Pred1, i1 %Pred2) {
; CHECK-LABEL: @loop_in_irr(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[IRR_GUARD:%.*]]
; CHECK:       A1:
; CHECK-NEXT:    br label [[H1:%.*]]
; CHECK:       H1:
; CHECK-NEXT:    br label [[L1:%.*]]
; CHECK:       L1:
; CHECK-NEXT:    br i1 [[PRED1:%.*]], label [[H1]], label [[A3:%.*]]
; CHECK:       A3:
; CHECK-NEXT:    br i1 [[PRED2:%.*]], label [[IRR_GUARD]], label [[EXIT:%.*]]
; CHECK:       A2:
; CHECK-NEXT:    br label [[IRR_GUARD]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
; CHECK:       irr.guard:
; CHECK-NEXT:    [[GUARD_A1:%.*]] = phi i1 [ true, [[A2:%.*]] ], [ [[PRED0:%.*]], [[ENTRY:%.*]] ], [ false, [[A3]] ]
; CHECK-NEXT:    br i1 [[GUARD_A1]], label [[A1:%.*]], label [[A2]]
;
entry:
  br i1 %Pred0, label %A1, label %A2

A1:
  br label %H1

H1:
  br label %L1

L1:
  br i1 %Pred1, label %H1, label %A3

A3:
  br i1 %Pred2, label %A2, label %exit

A2:
  br label %A1

exit:
  ret void
}

define void @loop_in_irr_shared_header(i1 %Pred0, i1 %Pred1, i1 %Pred2) {
; CHECK-LABEL: @loop_in_irr_shared_header(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[IRR_GUARD:%.*]]
; CHECK:       H1:
; CHECK-NEXT:    br label [[L1:%.*]]
; CHECK:       L1:
; CHECK-NEXT:    br i1 [[PRED1:%.*]], label [[IRR_GUARD]], label [[A3:%.*]]
; CHECK:       A3:
; CHECK-NEXT:    br i1 [[PRED2:%.*]], label [[IRR_GUARD]], label [[EXIT:%.*]]
; CHECK:       A2:
; CHECK-NEXT:    br label [[IRR_GUARD]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
; CHECK:       irr.guard:
; CHECK-NEXT:    [[GUARD_H1:%.*]] = phi i1 [ true, [[A2:%.*]] ], [ true, [[L1]] ], [ [[PRED0:%.*]], [[ENTRY:%.*]] ], [ false, [[A3]] ]
; CHECK-NEXT:    br i1 [[GUARD_H1]], label [[H1:%.*]], label [[A2]]
;
entry:
  br i1 %Pred0, label %H1, label %A2

H1:
  br label %L1

L1:
  br i1 %Pred1, label %H1, label %A3

A3:
  br i1 %Pred2, label %A2, label %exit

A2:
  br label %H1

exit:
  ret void
}

define void @siblings_top_level(i1 %Pred0, i1 %Pred1, i1 %Pred2, i1 %Pred3, i1 %Pred4, i1 %Pred5, i1 %Pred6) {
; CHECK-LABEL: @siblings_top_level(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[PRED0:%.*]], label [[H1:%.*]], label [[FORK1:%.*]]
; CHECK:       H1:
; CHECK-NEXT:    br label [[IRR_GUARD1:%.*]]
; CHECK:       A1:
; CHECK-NEXT:    br label [[IRR_GUARD1]]
; CHECK:       A2:
; CHECK-NEXT:    br i1 [[PRED2:%.*]], label [[IRR_GUARD1]], label [[L1:%.*]]
; CHECK:       L1:
; CHECK-NEXT:    br i1 [[PRED3:%.*]], label [[H1]], label [[EXIT:%.*]]
; CHECK:       fork1:
; CHECK-NEXT:    br label [[IRR_GUARD:%.*]]
; CHECK:       B1:
; CHECK-NEXT:    br label [[H2:%.*]]
; CHECK:       H2:
; CHECK-NEXT:    br label [[L2:%.*]]
; CHECK:       L2:
; CHECK-NEXT:    br i1 [[PRED5:%.*]], label [[H2]], label [[IRR_GUARD]]
; CHECK:       B2:
; CHECK-NEXT:    br i1 [[PRED6:%.*]], label [[IRR_GUARD]], label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
; CHECK:       irr.guard:
; CHECK-NEXT:    [[GUARD_B1:%.*]] = phi i1 [ true, [[B2:%.*]] ], [ [[PRED4:%.*]], [[FORK1]] ], [ false, [[L2]] ]
; CHECK-NEXT:    br i1 [[GUARD_B1]], label [[B1:%.*]], label [[B2]]
; CHECK:       irr.guard1:
; CHECK-NEXT:    [[GUARD_A1:%.*]] = phi i1 [ true, [[A2:%.*]] ], [ [[PRED1:%.*]], [[H1]] ], [ false, [[A1:%.*]] ]
; CHECK-NEXT:    br i1 [[GUARD_A1]], label [[A1]], label [[A2]]
;
entry:
  br i1 %Pred0, label %H1, label %fork1

H1:
  br i1 %Pred1, label %A1, label %A2

A1:
  br label %A2

A2:
  br i1 %Pred2, label %A1, label %L1

L1:
  br i1 %Pred3, label %H1, label %exit

fork1:
  br i1 %Pred4, label %B1, label %B2

B1:
  br label %H2

H2:
  br label %L2

L2:
  br i1 %Pred5, label %H2, label %B2

B2:
  br i1 %Pred6, label %B1, label %exit

exit:
  ret void
}

define void @siblings_in_loop(i1 %Pred0, i1 %Pred1, i1 %Pred2, i1 %Pred3, i1 %Pred4, i1 %Pred5, i1 %Pred6, i1 %Pred7) {
; CHECK-LABEL: @siblings_in_loop(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[H0:%.*]]
; CHECK:       H0:
; CHECK-NEXT:    br i1 [[PRED0:%.*]], label [[H1:%.*]], label [[FORK1:%.*]]
; CHECK:       H1:
; CHECK-NEXT:    br label [[IRR_GUARD1:%.*]]
; CHECK:       A1:
; CHECK-NEXT:    br label [[IRR_GUARD1]]
; CHECK:       A2:
; CHECK-NEXT:    br i1 [[PRED2:%.*]], label [[IRR_GUARD1]], label [[L1:%.*]]
; CHECK:       L1:
; CHECK-NEXT:    br i1 [[PRED3:%.*]], label [[H1]], label [[L0:%.*]]
; CHECK:       fork1:
; CHECK-NEXT:    br label [[IRR_GUARD:%.*]]
; CHECK:       B1:
; CHECK-NEXT:    br label [[H2:%.*]]
; CHECK:       H2:
; CHECK-NEXT:    br label [[L2:%.*]]
; CHECK:       L2:
; CHECK-NEXT:    br i1 [[PRED5:%.*]], label [[H2]], label [[IRR_GUARD]]
; CHECK:       B2:
; CHECK-NEXT:    br i1 [[PRED6:%.*]], label [[IRR_GUARD]], label [[L0]]
; CHECK:       L0:
; CHECK-NEXT:    br i1 [[PRED7:%.*]], label [[EXIT:%.*]], label [[H0]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
; CHECK:       irr.guard:
; CHECK-NEXT:    [[GUARD_B1:%.*]] = phi i1 [ true, [[B2:%.*]] ], [ [[PRED4:%.*]], [[FORK1]] ], [ false, [[L2]] ]
; CHECK-NEXT:    br i1 [[GUARD_B1]], label [[B1:%.*]], label [[B2]]
; CHECK:       irr.guard1:
; CHECK-NEXT:    [[GUARD_A1:%.*]] = phi i1 [ true, [[A2:%.*]] ], [ [[PRED1:%.*]], [[H1]] ], [ false, [[A1:%.*]] ]
; CHECK-NEXT:    br i1 [[GUARD_A1]], label [[A1]], label [[A2]]
;
entry:
  br label %H0

H0:
  br i1 %Pred0, label %H1, label %fork1

H1:
  br i1 %Pred1, label %A1, label %A2

A1:
  br label %A2

A2:
  br i1 %Pred2, label %A1, label %L1

L1:
  br i1 %Pred3, label %H1, label %L0

fork1:
  br i1 %Pred4, label %B1, label %B2

B1:
  br label %H2

H2:
  br label %L2

L2:
  br i1 %Pred5, label %H2, label %B2

B2:
  br i1 %Pred6, label %B1, label %L0

L0:
  br i1 %Pred7, label %exit, label %H0

exit:
  ret void
}

define void @irreducible_mountain_bug(i1 %Pred0, i1 %Pred1, i1 %Pred2, i1 %Pred3, i1 %Pred4, i1 %Pred5, i1 %Pred6, i1 %Pred7, i1 %Pred8, i1 %Pred9, i1 %Pred10, i1 %Pred11, i1 %Pred12, i1 %Pred13) {
; CHECK-LABEL: @irreducible_mountain_bug(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[PRED0:%.*]], label [[IF_END:%.*]], label [[IF_THEN:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    br i1 [[PRED1:%.*]], label [[IF_THEN7:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then7:
; CHECK-NEXT:    br label [[IF_END16:%.*]]
; CHECK:       if.else:
; CHECK-NEXT:    br label [[IF_END16]]
; CHECK:       if.end16:
; CHECK-NEXT:    br i1 [[PRED2:%.*]], label [[WHILE_COND_PREHEADER:%.*]], label [[IF_THEN39:%.*]]
; CHECK:       while.cond.preheader:
; CHECK-NEXT:    br label [[WHILE_COND:%.*]]
; CHECK:       while.cond:
; CHECK-NEXT:    br i1 [[PRED3:%.*]], label [[IRR_GUARD:%.*]], label [[LOR_RHS:%.*]]
; CHECK:       cond.true49:
; CHECK-NEXT:    br i1 [[PRED4:%.*]], label [[IF_THEN69:%.*]], label [[WHILE_BODY63:%.*]]
; CHECK:       while.body63:
; CHECK-NEXT:    br i1 [[PRED5:%.*]], label [[EXIT:%.*]], label [[WHILE_COND47:%.*]]
; CHECK:       while.cond47:
; CHECK-NEXT:    br label [[IRR_GUARD]]
; CHECK:       cond.end61:
; CHECK-NEXT:    br i1 [[PRED7:%.*]], label [[WHILE_BODY63]], label [[WHILE_COND]]
; CHECK:       if.then69:
; CHECK-NEXT:    br i1 [[PRED8:%.*]], label [[EXIT]], label [[WHILE_COND]]
; CHECK:       lor.rhs:
; CHECK-NEXT:    br i1 [[PRED9:%.*]], label [[IRR_GUARD]], label [[WHILE_END76:%.*]]
; CHECK:       while.end76:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       if.then39:
; CHECK-NEXT:    br i1 [[PRED10:%.*]], label [[EXIT]], label [[IF_END_I145:%.*]]
; CHECK:       if.end.i145:
; CHECK-NEXT:    br i1 [[PRED11:%.*]], label [[EXIT]], label [[IF_END8_I149:%.*]]
; CHECK:       if.end8.i149:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       if.then:
; CHECK-NEXT:    br i1 [[PRED12:%.*]], label [[EXIT]], label [[IF_END_I:%.*]]
; CHECK:       if.end.i:
; CHECK-NEXT:    br i1 [[PRED13:%.*]], label [[EXIT]], label [[IF_END8_I:%.*]]
; CHECK:       if.end8.i:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
; CHECK:       irr.guard:
; CHECK-NEXT:    [[GUARD_COND_TRUE49:%.*]] = phi i1 [ [[PRED6:%.*]], [[WHILE_COND47]] ], [ true, [[WHILE_COND]] ], [ false, [[LOR_RHS]] ]
; CHECK-NEXT:    br i1 [[GUARD_COND_TRUE49]], label [[COND_TRUE49:%.*]], label [[COND_END61:%.*]]
;
entry:
  br i1 %Pred0, label %if.end, label %if.then

if.end:
  br i1 %Pred1, label %if.then7, label %if.else

if.then7:
  br label %if.end16

if.else:
  br label %if.end16

if.end16:
  br i1 %Pred2, label %while.cond.preheader, label %if.then39

while.cond.preheader:
  br label %while.cond

while.cond:
  br i1 %Pred3, label %cond.true49, label %lor.rhs

cond.true49:
  br i1 %Pred4, label %if.then69, label %while.body63

while.body63:
  br i1 %Pred5, label %exit, label %while.cond47

while.cond47:
  br i1 %Pred6, label %cond.true49, label %cond.end61

cond.end61:
  br i1 %Pred7, label %while.body63, label %while.cond

if.then69:
  br i1 %Pred8, label %exit, label %while.cond

lor.rhs:
  br i1 %Pred9, label %cond.end61, label %while.end76

while.end76:
  br label %exit

if.then39:
  br i1 %Pred10, label %exit, label %if.end.i145

if.end.i145:
  br i1 %Pred11, label %exit, label %if.end8.i149

if.end8.i149:
  br label %exit

if.then:
  br i1 %Pred12, label %exit, label %if.end.i

if.end.i:
  br i1 %Pred13, label %exit, label %if.end8.i

if.end8.i:
  br label %exit

exit:
  ret void
}