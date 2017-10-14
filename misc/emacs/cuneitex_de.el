;;; latin-ltx.el --- Quail package for TeX-style input -*-coding: iso-2022-7bit-*-

;; Copyright (C) 2001 Electrotechnical Laboratory, JAPAN.
;; Licensed to the Free Software Foundation.
;; Copyright (C) 2001  Free Software Foundation, Inc.

;; Author: TAKAHASHI Naoto <ntakahas@m17n.org>
;;         Dave Love <fx@gnu.org>
;; Keywords: multilingual, input, Greek, i18n

;; This file is part of GNU Emacs.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;; ORACC version 1.1

;;; Commentary:

;;; Code:

(require 'quail)
(if (eq system-type 'ms-dos)
    (IT-setup-unicode-display))

(quail-define-package
 "Cuneiform_de" "UTF-8" "\\" t
 "LaTeX-like input method optimized for cuneiform transliterations.
These characters are from the charsets used by the `utf-8' coding
system, including many technical ones.  Examples:
 \,'a -> ,Aa(B  \,`{a} -> ,A`(B
 \,pi -> $,1'@(B  \,int -> $,1xK(B  ^1 -> ,A9(B"

 nil t t nil nil nil nil nil nil nil t)

(quail-define-rules
 ("!`" ?,A!(B)
 ("{\,pounds}" ?,A#(B) ("\,pounds" ?,A#(B)
 ("{\,S}" ?,A'(B) ("\,S" ?,A'(B)
 ("\,\"{}" ?,A((B)
 ("{\,copyright}" ?,A)(B) ("\,copyright" ?,A)(B)
 ("$^a$" ?,A*(B)
 ("\,={}" ?,A/(B)
 ("$\,pm$" ?,A1(B) ("\,pm" ?,A1(B)
 ("$^2$" ?,A2(B)
 ("$^3$" ?,A3(B)
 ("\,'{}" ?,A4(B)
 ("{\,P}" ?,A6(B) ("\,P" ?,A6(B)
 ;; Fixme: Yudit has the equivalent of ("\\cdot" ?$,1z%(B), for U+22C5, DOT
 ;; OPERATOR, whereas ,A7(B is MIDDLE DOT.  JadeTeX translates both to
 ;; \cdot.
 ("$\,cdot$" ?,A7(B) ("\,cdot" ?,A7(B)
 ("\,c{}" ?,A8(B)
 ("$^1$" ?,A9(B)
 ("$^o$" ?,A:(B)
 ("?`" ?,A?(B)
 ("^o" ?,A0(B)

; ("\,[" ?$,1zh(B)
; ("\,]" ?$,1zi(B)

 ("\,[" ?$,28B(B)
 ("\,]" ?$,28C(B)
 ("\,_[" ?$,28D(B)
 ("\,_]" ?$,28E(B)

; ("\,ldq" ?,Y4(B)
; ("\,rdq" ?,Y!(B)

 ("\,alef" ?$,1$^(B)
 ("\,ayin" ?$,1$_(B)

 ("\,`{A}" ?,A@(B)  ("\,`A" ?,A@(B)
 ("\,'{A}" ?,AA(B)  ("\,'A" ?,AA(B)
 ("\,^{A}" ?,AB(B)  ("\,^A" ?,AB(B)
 ("\,~{A}" ?,AC(B)  ("\,~A" ?,AC(B)
 ("\,\"{A}" ?,AD(B)  ("\,\"A" ?,AD(B)
 ("\,\k{A}" ?$,1 $(B)
 ("{\,AA}" ?,AE(B) ("\,AA" ?,AE(B)
 ("{\,AE}" ?,AF(B) ("\,AE" ?,AF(B)
 ("\,c{C}" ?,AG(B)  ("\,cC" ?,AG(B)
 ("\,`{E}" ?,AH(B)  ("\,`E" ?,AH(B)
 ("\,'{E}" ?,AI(B)  ("\,'E" ?,AI(B)
 ("\,^{E}" ?,AJ(B)  ("\,^E" ?,AJ(B)
 ("\,\"{E}" ?,AK(B)  ("\,\"E" ?,AK(B)
 ("\,\k{E}" ?$,1 8(B)
 ("\,`{I}" ?,AL(B)  ("\,`I" ?,AL(B)
 ("\,'{I}" ?,AM(B)  ("\,'I" ?,AM(B)
 ("\,^{I}" ?,AN(B)  ("\,^I" ?,AN(B)
 ("\,\"{I}" ?,AO(B)  ("\,\"I" ?,AO(B)
 ("\,\k{I}" ?$,1 N(B)

 ("\,~{N}" ?,AQ(B)  ("\,~N" ?,AQ(B)
 ("\,`{O}" ?,AR(B)  ("\,`O" ?,AR(B)
 ("\,'{O}" ?,AS(B)  ("\,'O" ?,AS(B)
 ("\,^{O}" ?,AT(B)  ("\,^O" ?,AT(B)
 ("\,~{O}" ?,AU(B)  ("\,~O" ?,AU(B)
 ("\,\"{O}" ?,AV(B)  ("\,\"O" ?,AV(B)
 ("\,\k{O}" ?$,1"J(B)
 ("$\,times$" ?,AW(B) ("\,times" ?,AW(B)
 ("{\,O}" ?,AX(B) ("\,O" ?,AX(B)
 ("\,`{U}" ?,AY(B) ("\,`U" ?,AY(B)
 ("\,'{U}" ?,AZ(B) ("\,'U" ?,AZ(B)
 ("\,^{U}" ?,A[(B) ("\,^U" ?,A[(B)
 ("\,\"{U}" ?,A\(B) ("\,\"U" ?,A\(B)
 ("\,\k{U}" ?$,1!2(B)
 ("\,'{Y}" ?,A](B) ("\,'Y" ?,A](B)
 ("{\,ss}" ?,A_(B) ("\,ss" ?,A_(B)

 ("\,{at}" ?@) ("\,at" ?@)
 ("\,`{a}" ?,A`(B) ("\,`a" ?,A`(B)
 ("\,'{a}" ?,Aa(B) ("\,'a" ?,Aa(B)
 ("\,^{a}" ?,Ab(B) ("\,^a" ?,Ab(B)
 ("\,~{a}" ?,Ac(B) ("\,~a" ?,Ac(B)
 ("\,\"{a}" ?,Ad(B) ("\,\"a" ?,Ad(B)
 ("\,\k{a}" ?$,1 %(B)
 ("{\,aa}" ?,Ae(B) ("\,aa" ?,Ae(B)
 ("{\,ae}" ?,Af(B) ("\,ae" ?,Af(B)
 ("\,c{c}" ?,Ag(B) ("\,cc" ?,Ag(B)
 ("\,`{e}" ?,Ah(B) ("\,`e" ?,Ah(B)
 ("\,'{e}" ?,Ai(B) ("\,'e" ?,Ai(B)
 ("\,^{e}" ?,Aj(B) ("\,^e" ?,Aj(B)
 ("\,\"{e}" ?,Ak(B) ("\,\"e" ?,Ak(B)
 ("\,\k{e}" ?$,1 9(B)
 ("\,\`{\,i}" ?,Al(B)  ("\,\`i" ?,Al(B)
 ("\,'{\,i}" ?,Am(B)  ("\,'i" ?,Am(B)
 ("\,^{\,i}" ?,An(B) ("\,^i" ?,An(B)
 ("\,\"{\,i}" ?,Ao(B) ("\,\"i" ?,Ao(B)
 ("\,\k{i}" ?$,1 O(B)

 ("\,~{n}" ?,Aq(B) ("\,~n" ?,Aq(B)
 ("\,`{o}" ?,Ar(B) ("\,`o" ?,Ar(B)
 ("\,'{o}" ?,As(B) ("\,'o" ?,As(B)
 ("\,^{o}" ?,At(B) ("\,^o" ?,At(B)
 ("\,~{o}" ?,Au(B) ("\,~o" ?,Au(B)
 ("\,\"{o}" ?,Av(B) ("\,\"o" ?,Av(B)
 ("\,\k{o}" ?$,1"K(B)
 ("$\,div$" ?,Aw(B) ("\,div" ?,Aw(B)
 ("{\,o}" ?,Ax(B) ("\,o" ?,Ax(B)
 ("\,`{u}" ?,Ay(B) ("\,`u" ?,Ay(B)
 ("\,'{u}" ?,Az(B) ("\,'u" ?,Az(B)
 ("\,^{u}" ?,A{(B) ("\,^u" ?,A{(B)
 ("\,\"{u}" ?,A|(B) ("\,\"u" ?,A|(B)
 ("\,\k{u}" ?$,1!3(B)
 ("\,'{y}" ?,A}(B) ("\,'y" ?,A}(B)
 ("\,\"{y}" ?,A(B) ("\,\"y" ?,A(B)

 ("\,={A}" ?$,1  (B) ("\,=A" ?$,1  (B)
 ("\,={a}" ?$,1 !(B) ("\,=a" ?$,1 !(B)
 ("\,u{A}" ?$,1 "(B) ("\,uA" ?$,1 "(B)
 ("\,u{a}" ?$,1 #(B) ("\,ua" ?$,1 #(B)
 ("\,'{C}" ?$,1 &(B) ("\,'C" ?$,1 &(B)
 ("\,'{c}" ?$,1 '(B) ("\,'c" ?$,1 '(B)
 ("\,^{C}" ?$,1 ((B) ("\,^C" ?$,1 ((B)
 ("\,^{c}" ?$,1 )(B) ("\,^c" ?$,1 )(B)
 ("\,.{C}" ?$,1 *(B) ("\,.C" ?$,1 *(B)
 ("\,.{c}" ?$,1 +(B) ("\,.c" ?$,1 +(B)
 ("\,v{C}" ?$,1 ,(B) ("\,vC" ?$,1 ,(B)
 ("\,v{c}" ?$,1 -(B) ("\,vc" ?$,1 -(B)
 ("\,v{D}" ?$,1 .(B) ("\,vD" ?$,1 .(B)
 ("\,v{d}" ?$,1 /(B) ("\,vd" ?$,1 /(B)

 ("\,={E}" ?$,1 2(B) ("\,=E" ?$,1 2(B)
 ("\,={e}" ?$,1 3(B) ("\,=e" ?$,1 3(B)
 ("\,u{E}" ?$,1 4(B) ("\,uE" ?$,1 4(B)
 ("\,u{e}" ?$,1 5(B) ("\,ue" ?$,1 5(B)
 ("\,.{E}" ?$,1 6(B) ("\,.E" ?$,1 6(B)
 ("\,e{e}" ?$,1 7(B) ("\,ee" ?$,1 7(B)
 ("\,v{E}" ?$,1 :(B) ("\,vE" ?$,1 :(B)
 ("\,v{e}" ?$,1 ;(B) ("\,ve" ?$,1 ;(B)
 ("\,^{G}" ?$,1 <(B) ("\,^G" ?$,1 <(B)
 ("\,^{g}" ?$,1 =(B) ("\,^g" ?$,1 =(B)
 ("\,u{G}" ?$,1 >(B) ("\,uG" ?$,1 >(B)
 ("\,u{g}" ?$,1 ?(B) ("\,ug" ?$,1 ?(B)

 ("\,.{G}" ?$,1 @(B) ("\,.G" ?$,1 @(B)
 ("\,.{g}" ?$,1 A(B) ("\,.g" ?$,1 A(B)
 ("\,c{G}" ?$,1 B(B) ("\,cG" ?$,1 B(B)
 ("\,c{g}" ?$,1 C(B) ("\,cg" ?$,1 C(B)
 ("\,^{H}" ?$,1 D(B) ("\,^H" ?$,1 D(B)
 ("\,^{h}" ?$,1 E(B) ("\,^h" ?$,1 E(B)
 ("\,~{I}" ?$,1 H(B) ("\,~I" ?$,1 H(B)
 ("\,~{\,i}" ?$,1 I(B) ("\,~i" ?$,1 I(B)
 ("\,={I}" ?$,1 J(B) ("\,=I" ?$,1 J(B)
 ("\,={\,i}" ?$,1 K(B) ("\,=i" ?$,1 K(B)
 ("\,u{I}" ?$,1 L(B) ("\,uI" ?$,1 L(B)
 ("\,u{\,i}" ?$,1 M(B) ("\,ui" ?$,1 M(B)

 ("\,.{I}" ?$,1 P(B) ("\,.I" ?$,1 P(B)
 ("{\,i}" ?$,1 Q(B) ("\,i" ?$,1 Q(B)
 ("\,^{J}" ?$,1 T(B) ("\,^J" ?$,1 T(B)
 ("\,^{\,j}" ?$,1 U(B) ("\,^j" ?$,1 U(B)
 ("\,c{K}" ?$,1 V(B) ("\,cK" ?$,1 V(B)
 ("\,c{k}" ?$,1 W(B) ("\,ck" ?$,1 W(B)
 ("\,'{L}" ?$,1 Y(B) ("\,'L" ?$,1 Y(B)
 ("\,'{l}" ?$,1 Z(B) ("\,'l" ?$,1 Z(B)
 ("\,c{L}" ?$,1 [(B) ("\,cL" ?$,1 [(B)
 ("\,c{l}" ?$,1 \(B) ("\,cl" ?$,1 \(B)

 ("{\,L}" ?$,1 a(B) ("\,L" ?$,1 a(B)
 ("{\,l}" ?[) ("\,l" ?[)
 ("{\,r}" ?]) ("\,r" ?])
 ("\,'{N}" ?$,1 c(B) ("\,'N" ?$,1 c(B)
 ("\,'{n}" ?$,1 d(B) ("\,'n" ?$,1 d(B)
 ("\,c{N}" ?$,1 e(B) ("\,cN" ?$,1 e(B)
 ("\,c{n}" ?$,1 f(B) ("\,cn" ?$,1 f(B)
 ("\,v{N}" ?$,1 g(B) ("\,vN" ?$,1 g(B)
 ("\,v{n}" ?$,1 h(B) ("\,vn" ?$,1 h(B)
 ("\,={O}" ?$,1 l(B) ("\,=O" ?$,1 l(B)
 ("\,={o}" ?$,1 m(B) ("\,=o" ?$,1 m(B)
 ("\,u{O}" ?$,1 n(B) ("\,uO" ?$,1 n(B)
 ("\,u{o}" ?$,1 o(B) ("\,uo" ?$,1 o(B)

 ("\,H{O}" ?$,1 p(B) ("\,HO" ?$,1 p(B)
 ("\,U{o}" ?$,1 q(B) ("\,Uo" ?$,1 q(B)
 ("{\,OE}" ?$,1 r(B) ("\,OE" ?$,1 r(B)
 ("{\,oe}" ?$,1 s(B) ("\,oe" ?$,1 s(B)
 ("\,'{R}" ?$,1 t(B) ("\,'R" ?$,1 t(B)
 ("\,'{r}" ?$,1 u(B) ("\,'r" ?$,1 u(B)
 ("\,c{R}" ?$,1 v(B) ("\,cR" ?$,1 v(B)
 ("\,c{r}" ?$,1 w(B) ("\,cr" ?$,1 w(B)
 ("\,v{R}" ?$,1 x(B) ("\,vR" ?$,1 x(B)
 ("\,v{r}" ?$,1 y(B) ("\,vr" ?$,1 y(B)
 ("\,'{S}" ?$,1 z(B) ("\,'S" ?$,1 z(B)
 ("\,'{s}" ?$,1 {(B) ("\,'s" ?$,1 {(B)
 ("\,^{S}" ?$,1 |(B) ("\,^S" ?$,1 |(B)
 ("\,^{s}" ?$,1 }(B) ("\,^s" ?$,1 }(B)
 ("\,c{S}" ?$,1 ~(B) ("\,cS" ?$,1 ~(B)
 ("\,c{s}" ?$,1 (B) ("\,cs" ?$,1 (B)

 ("\,v{S}" ?$,1! (B) ("\,vS" ?$,1! (B) ("\,VS" ?$,1! (B) ("\,SZ" ?$,1! (B) 
 ("\,v{s}" ?$,1!!(B) ("\,vs" ?$,1!!(B) ("\,sz" ?$,1!!(B) 
 ("\,c{T}" ?$,1!"(B) ("\,cT" ?$,1!"(B)
 ("\,c{t}" ?$,1!#(B) ("\,ct" ?$,1!#(B)
 ("\,v{T}" ?$,1!$(B) ("\,vT" ?$,1!$(B)
 ("\,v{t}" ?$,1!%(B) ("\,vt" ?$,1!%(B)
 ("\,~{U}" ?$,1!((B) ("\,~U" ?$,1!((B)
 ("\,~{u}" ?$,1!)(B) ("\,~u" ?$,1!)(B)
 ("\,={U}" ?$,1!*(B) ("\,=U" ?$,1!*(B)
 ("\,={u}" ?$,1!+(B) ("\,=u" ?$,1!+(B)
 ("\,u{U}" ?$,1!,(B) ("\,uU" ?$,1!,(B)
 ("\,u{u}" ?$,1!-(B) ("\,uu" ?$,1!-(B)

 ("\,H{U}" ?$,1!0(B) ("\,HU" ?$,1!0(B)
 ("\,H{u}" ?$,1!1(B) ("\,Hu" ?$,1!1(B)
 ("\,^{W}" ?$,1!4(B) ("\,^W" ?$,1!4(B)
 ("\,^{w}" ?$,1!5(B) ("\,^w" ?$,1!5(B)
 ("\,^{Y}" ?$,1!6(B) ("\,^Y" ?$,1!6(B)
 ("\,^{y}" ?$,1!7(B) ("\,^y" ?$,1!7(B)
 ("\,\"{Y}" ?$,1!8(B) ("\,\"Y" ?$,1!8(B)
 ("\,'{Z}" ?$,1!9(B) ("\,'Z" ?$,1!9(B)
 ("\,'{z}" ?$,1!:(B) ("\,'z" ?$,1!:(B)
 ("\,.{Z}" ?$,1!;(B) ("\,.Z" ?$,1!;(B)
 ("\,.{z}" ?$,1!<(B) ("\,.z" ?$,1!<(B)
 ("\,v{Z}" ?$,1!=(B) ("\,vZ" ?$,1!=(B)
 ("\,v{z}" ?$,1!>(B) ("\,vz" ?$,1!>(B)

 ("\,v{A}" ?$,1"-(B) ("\,vA" ?$,1"-(B)
 ("\,v{a}" ?$,1".(B) ("\,va" ?$,1".(B)
 ("\,v{I}" ?$,1"/(B) ("\,vI" ?$,1"/(B)
 ("\,v{\,i}" ?$,1"0(B) ("\,vi" ?$,1"0(B)
 ("\,v{O}" ?$,1"1(B) ("\,vO" ?$,1"1(B)
 ("\,v{o}" ?$,1"2(B) ("\,vo" ?$,1"2(B)
 ("\,v{U}" ?$,1"3(B) ("\,vU" ?$,1"3(B)
 ("\,v{u}" ?$,1"4(B) ("\,vu" ?$,1"4(B)

 ("\,={\,AE}" ?$,1"B(B) ("\,=\,AE" ?$,1"B(B)
 ("\,={\,ae}" ?$,1"C(B) ("\,=\,ae" ?$,1"C(B)
 ("\,v{G}" ?$,1"F(B) ("\,vG" ?$,1"F(B)
 ("\,v{g}" ?$,1"G(B) ("\,vg" ?$,1"G(B)
 ("\,v{K}" ?$,1"H(B) ("\,vK" ?$,1"H(B)
 ("\,v{k}" ?k) ("\,vk" ?k)

 ("\,v{\,j}" ?$,1"P(B) ("\,vj" ?$,1"P(B)
 ("\,'{G}" ?$,1"T(B) ("\,'G" ?$,1"T(B)
 ("\,'{g}" ?$,1"U(B) ("\,'g" ?$,1"U(B)
 ("\,`{N}" ?$,1"X(B) ("\,`N" ?$,1"X(B)
 ("\,`{n}" ?$,1"Y(B) ("\,`n" ?$,1"Y(B)
 ("\,'{\,AE}" ?$,1"\(B) ("\,'\,AE" ?$,1"\(B)
 ("\,'{\,ae}" ?$,1"](B) ("\,'\,ae" ?$,1"](B)
 ("\,'{\,O}" ?$,1"^(B) ("\,'\,O" ?$,1"^(B)
 ("\,'{\,o}" ?$,1"_(B) ("\,'\,o" ?$,1"_(B)

 ("\,v{H}" ?$,1"~(B) ("\,vH" ?$,1"~(B)
 ("\,v{h}" ?$,1"(B) ("\,vh" ?$,1"(B)
 ("\,.{A}" ?$,1#&(B) ("\,.A" ?$,1#&(B)
 ("\,.{a}" ?$,1#'(B) ("\,.a" ?$,1#'(B)
 ("\,c{E}" ?$,1#((B) ("\,cE" ?$,1#((B)
 ("\,c{e}" ?$,1#)(B) ("\,ce" ?$,1#)(B)
 ("\,.{O}" ?$,1#.(B) ("\,.O" ?$,1#.(B)
 ("\,.{o}" ?$,1#/(B) ("\,.o" ?$,1#/(B)
 ("\,={Y}" ?$,1#2(B) ("\,=Y" ?$,1#2(B)
 ("\,={y}" ?$,1#3(B) ("\,=y" ?$,1#3(B)

 ("\,v{}" ?$,1$g(B)
 ("\,u{}" ?$,1$x(B)
 ("\,.{}" ?$,1$y(B)
 ("\,~{}" ?$,1$|(B)
 ("\,H{}" ?$,1$}(B)

 ("\,'" ?$,1%A(B)
 ("\,'K" ?$,1mp(B)
 ("\,'M" ?$,1m~(B)
 ("\,'P" ?$,1n4(B)
 ("\,'W" ?$,1nb(B)
 ("\,'k" ?$,1mq(B)
 ("\,'m" ?$,1m(B)
 ("\,'p" ?$,1n5(B)
 ("\,'w" ?$,1nc(B)
 ("\,," ?$,1rf(B)
 ("\,." ?$,1%G(B)
 ("\,.B" ?$,1mB(B)
 ("\,.D" ?$,1mJ(B)
 ("\,.F" ?$,1m^(B)
 ("\,.H" ?$,1mb(B)
 ("\,.M" ?$,1n (B)
 ("\,.N" ?$,1n$(B)
 ("\,.P" ?$,1n6(B)
 ("\,.R" ?$,1n8(B)
 ("\,.S" ?$,1n@(B)
 ("\,.T" ?$,1nJ(B)
 ("\,.W" ?$,1nf(B)
 ("\,.X" ?$,1nj(B)
 ("\,.Y" ?$,1nn(B)
 ("\,.b" ?$,1mC(B)
 ("\,.d" ?$,1mK(B)
 ("\,.e" ?$,1 7(B)
 ("\,.f" ?$,1m_(B)
 ("\,.h" ?$,1mc(B)
 ("\,.m" ?$,1n!(B)
 ("\,.n" ?$,1n%(B)
 ("\,.p" ?$,1n7(B)
 ("\,.r" ?$,1n9(B)
 ("\,.s" ?$,1nA(B)
 ("\,.t" ?$,1nK(B)
 ("\,.w" ?$,1ng(B)
 ("\,.x" ?$,1nk(B)
 ("\,.y" ?$,1no(B)
 ("\,/" ?$,1rl(B)
 ("\,:" ?$,1re(B)
 ("\,;" ?$,1rd(B)
 ("\,=" ?$,1%D(B)
 ("\,=G" ?$,1m`(B)
 ("\,=g" ?$,1ma(B)
 ("\,h" ?$,1mk(B)
 ("\,H" ?$,1mj(B)
 ("\,j" ?$,1 k(B)
 ("\,J" ?$,1 j(B)

 ("^(" ?$,1s}(B)
 ("^)" ?$,1s~(B)
 ("^+" ?$,1sz(B)
 ("^-" ?$,1s{(B)
 ("\,^0" ?$,1sp(B)
 ("\,^1" ?,A9(B)
 ("\,^2" ?,A2(B)
 ("\,^3" ?,A3(B)
 ("\,^4" ?$,1st(B)
 ("\,^5" ?$,1su(B)
 ("\,^6" ?$,1sv(B)
 ("\,^7" ?$,1sw(B)
 ("\,^8" ?$,1sx(B)
 ("\,^9" ?$,1sy(B)
 ("^=" ?$,1s|(B)
 ("^\,gamma" ?$,1% (B)
 ("^h" ?$,1$P(B)
 ("^j" ?$,1$R(B)
 ("^l" ?$,1%!(B)
 ("^n" ?$,1s(B)
 ("^o" ?,A:(B)
 ("^r" ?$,1$S(B)
 ("^s" ?$,1%"(B)
 ("^w" ?$,1$W(B)
 ("^x" ?$,1%#(B)
 ("^y" ?$,1$X(B)
 ("^{SM}" ?$,1u`(B)
 ("^{TEL}" ?$,1ua(B)
 ("^{TM}" ?$,1ub(B)
 ("_(" ?$,1t-(B)  ("\,(" ?$,28B(B)
 ("_)" ?$,1t.(B)  ("\,)" ?$,28C(B)
 ("_+" ?$,1t*(B)  ("\,+" ?$,1t*(B)
 ("_x" ?$,1t3(B)  ("\,x" ?$,1t3(B)
 ("_-" ?$,1t+(B)  ("\,-" ?$,1t+(B)
 ("_0" ?$,1t (B)  ("\,0" ?$,1t (B)
 ("_1" ?$,1t!(B)  ("\,1" ?$,1t!(B)
 ("_2" ?$,1t"(B)  ("\,2" ?$,1t"(B)
 ("_3" ?$,1t#(B)  ("\,3" ?$,1t#(B)
 ("_4" ?$,1t$(B)  ("\,4" ?$,1t$(B)
 ("_5" ?$,1t%(B)  ("\,5" ?$,1t%(B)
 ("_6" ?$,1t&(B)  ("\,6" ?$,1t&(B)
 ("_7" ?$,1t'(B)  ("\,7" ?$,1t'(B)
 ("_8" ?$,1t((B)  ("\,8" ?$,1t((B)
 ("_9" ?$,1t)(B)  ("\,9" ?$,1t)(B)
 ("_=" ?$,1t,(B)

; ("\\~" ?$,1%C(B)
 ("\,~E" ?$,1o<(B)
 ("\,~V" ?$,1n\(B)
 ("\,~Y" ?$,1ox(B)
 ("\,~e" ?$,1o=(B)
 ("\,~v" ?$,1n](B)
 ("\,~y" ?$,1oy(B)

 ("\,\"" ?$,1%H(B)
 ("\,\"H" ?$,1mf(B)
 ("\,\"W" ?$,1nd(B)
 ("\,\"X" ?$,1nl(B)
 ("\,\"h" ?$,1mg(B)
 ("\,\"t" ?$,1nw(B)
 ("\,\"w" ?$,1ne(B)
 ("\,\"x" ?$,1nm(B)
 ("\,^" ?$,1%B(B)
 ("\,^Z" ?$,1np(B)
 ("\,^z" ?$,1nq(B)
 ("\,`" ?$,1%@(B)
 ("\,`W" ?$,1n`(B)
 ("\,`Y" ?$,1or(B)
 ("\,`w" ?$,1na(B)
 ("\,`y" ?$,1os(B)
 ("\,b" ?$,1%q(B)
 ("\,c" ?$,1%g(B)
 ("\,c{D}" ?$,1mP(B)
 ("\,c{H}" ?$,1mh(B)
 ("\,c{d}" ?$,1mQ(B)
 ("\,c{h}" ?$,1mi(B)
 ("\,d" ?$,1%c(B)
 ("\,d{A}" ?$,1o (B)
 ("\,d{B}" ?$,1mD(B)
 ("\,d{D}" ?$,1mL(B)
 ("\,d{E}" ?$,1o8(B)
 ("\,d{H}" ?$,1md(B)
 ("\,d{I}" ?$,1oJ(B)
 ("\,d{K}" ?$,1mr(B)
 ("\,d{L}" ?$,1mv(B)
 ("\,d{M}" ?$,1n"(B)
 ("\,d{N}" ?$,1n&(B)
 ("\,d{O}" ?$,1oL(B)
 ("\,d{R}" ?$,1n:(B)
 ("\,d{S}" ?$,1nB(B) ("\,dS" ?$,1nB(B)
 ("\,d{T}" ?$,1nL(B) ("\,dT" ?$,1nL(B)
 ("\,d{U}" ?$,1od(B)
 ("\,d{V}" ?$,1n^(B)
 ("\,d{W}" ?$,1nh(B)
 ("\,d{Y}" ?$,1ot(B)
 ("\,d{Z}" ?$,1nr(B)
 ("\,d{a}" ?$,1o!(B)
 ("\,d{b}" ?$,1mE(B)
 ("\,d{d}" ?$,1mM(B)
 ("\,d{e}" ?$,1o9(B)
 ("\,d{h}" ?$,1me(B)
 ("\,d{i}" ?$,1oK(B)
 ("\,d{k}" ?$,1ms(B)
 ("\,d{l}" ?$,1mw(B)
 ("\,d{m}" ?$,1n#(B)
 ("\,d{n}" ?$,1n'(B)
 ("\,d{o}" ?$,1oM(B)
 ("\,d{r}" ?$,1n;(B)
 ("\,d{s}" ?$,1nC(B) ("\,ds" ?$,1nC(B)
 ("\,d{t}" ?$,1nM(B) ("\,dt" ?$,1nM(B)
 ("\,d{u}" ?$,1oe(B)
 ("\,d{v}" ?$,1n_(B)
 ("\,d{w}" ?$,1ni(B)
 ("\,d{y}" ?$,1ou(B)
 ("\,d{z}" ?$,1ns(B)
 ("\,rq" ?$,1ry(B)
 ("\,u" ?$,1%F(B)
 ("\,v" ?$,1%L(B)
 ("\,v{L}" ?$,1 ](B)
 ("\,v{i}" ?$,1"0(B)
 ("\,v{j}" ?$,1"P(B)
 ("\,v{l}" ?$,1 ^(B)
 ("\,yen" ?,A%(B)

 ("\,Box" ?$,2!a(B)
 ("\,Bumpeq" ?$,1xn(B)
 ("\,Cap" ?$,1z2(B)
 ("\,Cup" ?$,1z3(B)
 ("\,Delta" ?$,1&t(B)
 ("\,Diamond" ?$,2"'(B)
 ("\,Downarrow" ?$,1wS(B)
 ("\,Gamma" ?$,1&s(B)
 ("\,H" ?$,1%K(B)
 ("\,H{o}" ?$,1 q(B)
 ("\,Im" ?$,1uQ(B)
 ("\,Join" ?$,1z((B)
 ("\,Lambda" ?$,1&{(B)
 ("\,Leftarrow" ?$,1wP(B)
 ("\,Leftrightarrow" ?$,1wT(B)
 ("\,Ll" ?$,1z8(B)
 ("\,Lleftarrow" ?$,1wZ(B)
 ("\,Longleftarrow" ?$,1wP(B)
 ("\,Longleftrightarrow" ?$,1wT(B)
 ("\,Longrightarrow" ?$,1wR(B)
 ("\,Lsh" ?$,1w0(B)
 ("\,Omega" ?$,1')(B)
 ("\,Phi" ?$,1'&(B)
 ("\,Pi" ?$,1' (B)
 ("\,Psi" ?$,1'((B)
 ("\,Re" ?$,1u\(B)
 ("\,Rightarrow" ?$,1wR(B)
 ("\,Rrightarrow" ?$,1w[(B)
 ("\,Rsh" ?$,1w1(B)
 ("\,Sigma" ?$,1'#(B)
 ("\,Subset" ?$,1z0(B)
 ("\,Supset" ?$,1z1(B)
 ("\,Theta" ?$,1&x(B)
 ("\,Uparrow" ?$,1wQ(B)
 ("\,Updownarrow" ?$,1wU(B)
 ("\,Upsilon" ?$,1'%(B)
 ("\,Vdash" ?$,1yi(B)
 ("\,Vert" ?$,1rv(B)
 ("\,Vvdash" ?$,1yj(B)
 ("\,Xi" ?$,1&~(B)
 ("\,aleph" ?$,1uu(B)
 ("\,alpha" ?$,1'1(B)
 ("\,amalg" ?$,1x0(B)
 ("\,angle" ?$,1x@(B)
 ("\,approx" ?$,1xh(B)
 ("\,approxeq" ?$,1xj(B)
 ("\,ast" ?$,1x7(B)
 ("\,asymp" ?$,1xm(B)
 ("\,backcong" ?$,1xl(B)
 ("\,backepsilon" ?$,1x-(B)
 ("\,backprime" ?$,1s5(B)
 ("\,backsim" ?$,1x](B)
 ("\,backsimeq" ?$,1z-(B)
 ("\,backslash" ?\,)
 ("\,barwedge" ?$,1y|(B)
 ("\,because" ?$,1xU(B)
 ("\,beta" ?$,1'2(B)
 ("\,beth" ?$,1uv(B)
 ("\,between" ?$,1y,(B)
 ("\,bigcap" ?$,1z"(B)
 ("\,bigcirc" ?$,2"O(B)
 ("\,bigcup" ?$,1z#(B)
 ("\,bigstar" ?$,2"e(B)
 ("\,bigtriangledown" ?$,2!}(B)
 ("\,bigtriangleup" ?$,2!s(B)
 ("\,bigvee" ?$,1z!(B)
 ("\,bigwedge" ?$,1z (B)
 ("\,blacklozenge" ?$,2%f(B)
 ("\,blacksquare" ?$,2!j(B)
 ("\,blacktriangle" ?$,2!t(B)
 ("\,blacktriangledown" ?$,2!~(B)
 ("\,blacktriangleleft" ?$,2""(B)
 ("\,blacktriangleright" ?$,2!x(B)
 ("\,bot" ?$,1ye(B)
 ("\,bowtie" ?$,1z((B)
 ("\,boxminus" ?$,1y_(B)
 ("\,boxplus" ?$,1y^(B)
 ("\,boxtimes" ?$,1y`(B)
 ("\,bullet" ?$,1s"(B)
 ("\,bumpeq" ?$,1xo(B)
 ("\,cap" ?$,1xI(B)
 ("\,cdots" ?$,1zO(B)
 ("\,centerdot" ?,A7(B)
 ("\,checkmark" ?$,2%S(B)
 ("\,chi" ?$,1'G(B)
 ("\,circ" ?$,2"+(B)
 ("\,circeq" ?$,1xw(B)
 ("\,circlearrowleft" ?$,1w:(B)
 ("\,circlearrowright" ?$,1w;(B)
 ("\,circledR" ?,A.(B)
 ("\,circledS" ?$,1H(B)
 ("\,circledast" ?$,1y[(B)
 ("\,circledcirc" ?$,1yZ(B)
 ("\,circleddash" ?$,1y](B)
 ("\,clubsuit" ?$,2#c(B)
 ("\,colon" ?:)
 ("\,coloneq" ?$,1xt(B)
 ("\,complement" ?$,1x!(B)
 ("\,cong" ?$,1xe(B)
 ("\,coprod" ?$,1x0(B)
 ("\,cup" ?$,1xJ(B)
 ("\,curlyeqprec" ?$,1z>(B)
 ("\,curlyeqsucc" ?$,1z?(B)
 ("\,curlypreceq" ?$,1y<(B)
 ("\,curlyvee" ?$,1z.(B)
 ("\,curlywedge" ?$,1z/(B)
 ("\,curvearrowleft" ?$,1w6(B)
 ("\,curvearrowright" ?$,1w7(B)

 ("\,dag" ?$,1s (B)
 ("\,dagger" ?$,1s (B)
 ("\,daleth" ?$,1ux(B)
 ("\,dashv" ?$,1yc(B)
 ("\,ddag" ?$,1s!(B)
 ("\,ddagger" ?$,1s!(B)
 ("\,ddots" ?$,1zQ(B)
 ("\,delta" ?$,1'4(B)
 ("\,diamond" ?$,1z$(B)
 ("\,diamondsuit" ?$,2#b(B)
 ("\,digamma" ?$,1'\(B)
 ("\,divideontimes" ?$,1z'(B)
 ("\,doteq" ?$,1xp(B)
 ("\,doteqdot" ?$,1xq(B)
 ("\,dotplus" ?$,1x4(B)
 ("\,dotsquare" ?$,1ya(B)
 ("\,downarrow" ?$,1vs(B)
 ("\,downdownarrows" ?$,1wJ(B)
 ("\,downleftharpoon" ?$,1wC(B)
 ("\,downrightharpoon" ?$,1wB(B)
 ("\,ell" ?$,1uS(B)
 ("\,emptyset" ?$,1x%(B)
 ("\,epsilon" ?$,1'5(B)
 ("\,eqcirc" ?$,1xv(B)
 ("\,eqcolon" ?$,1xu(B)
 ("\,eqslantgtr" ?$,1z=(B)
 ("\,eqslantless" ?$,1z<(B)
 ("\,equiv" ?$,1y!(B)
 ("\,eta" ?$,1'7(B)
 ("\,euro" ?$,1tL(B)
 ("\,exists" ?$,1x#(B)
 ("\,fallingdotseq" ?$,1xr(B)
 ("\,flat" ?$,2#m(B)
 ("\,forall" ?$,1x (B)
 ("\,frac1" ?$,1v?(B)
 ("\,frac12" ?,A=(B)
 ("\,frac13" ?$,1v3(B)
 ("\,frac14" ?,A<(B)
 ("\,frac15" ?$,1v5(B)
 ("\,frac16" ?$,1v9(B)
 ("\,frac18" ?$,1v;(B)
 ("\,frac23" ?$,1v4(B)
 ("\,frac25" ?$,1v6(B)
 ("\,frac34" ?,A>(B)
 ("\,frac35" ?$,1v7(B)
 ("\,frac38" ?$,1v<(B)
 ("\,frac45" ?$,1v8(B)
 ("\,frac56" ?$,1v:(B)
 ("\,frac58" ?$,1v=(B)
 ("\,frac78" ?$,1v>(B)
 ("\,frown" ?$,1{"(B)
 ("\,gamma" ?$,1'3(B)
 ("\,ge" ?$,1y%(B)
 ("\,geq" ?$,1y%(B)
 ("\,geqq" ?$,1y'(B)
 ("\,geqslant" ?$,1y%(B)
 ("\,gets" ?$,1vp(B)
 ("\,gg" ?$,1y+(B)
 ("\,ggg" ?$,1z9(B)
 ("\,gimel" ?$,1uw(B)
 ("\,gnapprox" ?$,1zG(B)
 ("\,gneq" ?$,1y)(B)
 ("\,gneqq" ?$,1y)(B)
 ("\,gnsim" ?$,1zG(B)
 ("\,gtrapprox" ?$,1y3(B)
 ("\,gtrdot" ?$,1z7(B)
 ("\,gtreqless" ?$,1z;(B)
 ("\,gtreqqless" ?$,1z;(B)
 ("\,gtrless" ?$,1y7(B)
 ("\,gtrsim" ?$,1y3(B)
 ("\,gvertneqq" ?$,1y)(B)
 ("\,hbar" ?$,1uO(B)
 ("\,heartsuit" ?$,2#e(B)
 ("\,hookleftarrow" ?$,1w)(B)
 ("\,hookrightarrow" ?$,1w*(B)
 ("\,iff" ?$,1wT(B)
 ("\,imath" ?$,1 Q(B)
 ("\,in" ?$,1x((B)
 ("\,infty" ?$,1x>(B)
 ("\,int" ?$,1xK(B)
 ("\,intercal" ?$,1yz(B)
 ("\,iota" ?$,1'9(B)
 ("\,kappa" ?$,1':(B)
 ("\,lambda" ?$,1';(B)
 ("\,langle" ?$,1{)(B)
 ("\,lbrace" ?{)
 ("\,lbrack" ?[)
 ("\,lceil" ?$,1zh(B)
 ("\,ldots" ?$,1s&(B)
 ("\,le" ?$,1y$(B)
 ("\,leadsto" ?$,1v}(B)
 ("\,leftarrow" ?$,1vp(B)
 ("\,leftarrowtail" ?$,1w"(B)
 ("\,leftharpoondown" ?$,1w=(B)
 ("\,leftharpoonup" ?$,1w<(B)
 ("\,leftleftarrows" ?$,1wG(B)
 ("\,leftparengtr" ?$,1{)(B)
 ("\,leftrightarrow" ?$,1vt(B)
 ("\,leftrightarrows" ?$,1wF(B)
 ("\,leftrightharpoons" ?$,1wK(B)
 ("\,leftrightsquigarrow" ?$,1w-(B)
 ("\,leftthreetimes" ?$,1z+(B)
 ("\,leq" ?$,1y$(B)
 ("\,leqq" ?$,1y&(B)
 ("\,leqslant" ?$,1y$(B)
 ("\,lessapprox" ?$,1y2(B)
 ("\,lessdot" ?$,1z6(B)
 ("\,lesseqgtr" ?$,1z:(B)
 ("\,lesseqqgtr" ?$,1z:(B)
 ("\,lessgtr" ?$,1y6(B)
 ("\,lesssim" ?$,1y2(B)
 ("\,lfloor" ?$,1zj(B)
 ("\,lhd" ?$,2"!(B)
 ("\,ll" ?$,1y*(B)
 ("\,llcorner" ?$,1z~(B)
 ("\,lnapprox" ?$,1zF(B)
 ("\,lneq" ?$,1y((B)
 ("\,lneqq" ?$,1y((B)
 ("\,lnsim" ?$,1zF(B)
 ("\,longleftarrow" ?$,1vp(B)
 ("\,longleftrightarrow" ?$,1vt(B)
 ("\,longmapsto" ?$,1w&(B)
 ("\,longrightarrow" ?$,1vr(B)
 ("\,looparrowleft" ?$,1w+(B)
 ("\,looparrowright" ?$,1w,(B)
 ("\,lozenge" ?$,2%g(B)
 ("\,lq" ?$,1rx(B)
 ("\,lrcorner" ?$,1z(B)
 ("\,ltimes" ?$,1z)(B)
 ("\,lvertneqq" ?$,1y((B)
 ("\,maltese" ?$,2%`(B)
 ("\,mapsto" ?$,1w&(B)
 ("\,measuredangle" ?$,1xA(B)
 ("\,mho" ?$,1ug(B)
 ("\,mid" ?$,1xC(B)
 ("\,models" ?$,1yg(B)
 ("\,mp" ?$,1x3(B)
 ("\,multimap" ?$,1yx(B)
 ("\,nLeftarrow" ?$,1wM(B)
 ("\,nLeftrightarrow" ?$,1wN(B)
 ("\,nRightarrow" ?$,1wO(B)
 ("\,nVDash" ?$,1yo(B)
 ("\,nVdash" ?$,1yn(B)
 ("\,nabla" ?$,1x'(B)
 ("\,napprox" ?$,1xi(B)
 ("\,natural" ?$,2#n(B)
 ("\,ncong" ?$,1xg(B)
 ("\,ne" ?$,1y (B)
 ("\,nearrow" ?$,1vw(B)
 ("\,neg" ?,A,(B)
 ("\,neq" ?$,1y (B)
 ("\,nequiv" ?$,1y"(B)
 ("\,newline" ?$,1s((B)
 ("\,nexists" ?$,1x$(B)
 ("\,ngeq" ?$,1y1(B)
 ("\,ngeqq" ?$,1y1(B)
 ("\,ngeqslant" ?$,1y1(B)
 ("\,ngtr" ?$,1y/(B)
 ("\,ni" ?$,1x+(B)
 ("\,nleftarrow" ?$,1vz(B)
 ("\,nleftrightarrow" ?$,1w.(B)
 ("\,nleq" ?$,1y0(B)
 ("\,nleqq" ?$,1y0(B)
 ("\,nleqslant" ?$,1y0(B)
 ("\,nless" ?$,1y.(B)
 ("\,nmid" ?$,1xD(B)
 ("\,not" ?$,1%x(B)
 ("\,notin" ?$,1x)(B)
 ("\,nparallel" ?$,1xF(B)
 ("\,nprec" ?$,1y@(B)
 ("\,npreceq" ?$,1z@(B)
 ("\,nrightarrow" ?$,1v{(B)
 ("\,nshortmid" ?$,1xD(B)
 ("\,nshortparallel" ?$,1xF(B)
 ("\,nsim" ?$,1xa(B)
 ("\,nsimeq" ?$,1xd(B)
 ("\,nsubset" ?$,1yD(B)
 ("\,nsubseteq" ?$,1yH(B)
 ("\,nsubseteqq" ?$,1yH(B)
 ("\,nsucc" ?$,1yA(B)
 ("\,nsucceq" ?$,1zA(B)
 ("\,nsupset" ?$,1yE(B)
 ("\,nsupseteq" ?$,1yI(B)
 ("\,nsupseteqq" ?$,1yI(B)
 ("\,ntriangleleft" ?$,1zJ(B)
 ("\,ntrianglelefteq" ?$,1zL(B)
 ("\,ntriangleright" ?$,1zK(B)
 ("\,ntrianglerighteq" ?$,1zM(B)
 ("\,nu" ?$,1'=(B)
 ("\,nvDash" ?$,1ym(B)
 ("\,nvdash" ?$,1yl(B)
 ("\,nwarrow" ?$,1vv(B)
 ("\,odot" ?$,1yY(B)
 ("\,oint" ?$,1xN(B)
 ("\,omega" ?$,1'I(B)
 ("\,ominus" ?$,1yV(B)
 ("\,oplus" ?$,1yU(B)
 ("\,oslash" ?$,1yX(B)
 ("\,otimes" ?$,1yW(B)
 ("\,par" ?$,1s)(B)
 ("\,parallel" ?$,1xE(B)
 ("\,partial" ?$,1x"(B)
 ("\,perp" ?$,1ye(B)
 ("\,phi" ?$,1'F(B)
 ("\,pi" ?$,1'@(B)
 ("\,pitchfork" ?$,1z4(B)
 ("\,prec" ?$,1y:(B)
 ("\,precapprox" ?$,1y>(B)
 ("\,preceq" ?$,1y<(B)
 ("\,precnapprox" ?$,1zH(B)
 ("\,precnsim" ?$,1zH(B)
 ("\,precsim" ?$,1y>(B)
 ("\,prime" ?$,1s2(B)
 ("\,prod" ?$,1x/(B)
 ("\,propto" ?$,1x=(B)
 ("\,psi" ?$,1'H(B)
 ("\,quad" ?$,1ra(B)
 ("\,rangle" ?$,1{*(B)
 ("\,rbrace" ?})
 ("\,rbrack" ?])
 ("\,rceil" ?$,1zi(B)
 ("\,rfloor" ?$,1zk(B)
 ("\,rightarrow" ?$,1vr(B)
 ("\,rightarrowtail" ?$,1w#(B)
 ("\,rightharpoondown" ?$,1wA(B)
 ("\,rightharpoonup" ?$,1w@(B)
 ("\,rightleftarrows" ?$,1wD(B)
 ("\,rightleftharpoons" ?$,1wL(B)
 ("\,rightparengtr" ?$,1{*(B)
 ("\,rightrightarrows" ?$,1wI(B)
 ("\,rightthreetimes" ?$,1z,(B)
 ("\,risingdotseq" ?$,1xs(B)
 ("\,rtimes" ?$,1z*(B)
 ("\,sbs" ?$,3q((B)
 ("\,searrow" ?$,1vx(B)
 ("\,setminus" ?$,1x6(B)
 ("\,sharp" ?$,2#o(B)
 ("\,shortmid" ?$,1xC(B)
 ("\,shortparallel" ?$,1xE(B)
 ("\,sigma" ?$,1'C(B)
 ("\,sim" ?$,1x\(B)
 ("\,simeq" ?$,1xc(B)
 ("\,smallamalg" ?$,1x0(B)
 ("\,smallsetminus" ?$,1x6(B)
 ("\,smallsmile" ?$,1{#(B)
 ("\,smile" ?$,1{#(B)
 ("\,spadesuit" ?$,2#`(B)
 ("\,sphericalangle" ?$,1xB(B)
 ("\,sqcap" ?$,1yS(B)
 ("\,sqcup" ?$,1yT(B)
 ("\,sqsubset" ?$,1yO(B)
 ("\,sqsubseteq" ?$,1yQ(B)
 ("\,sqsupset" ?$,1yP(B)
 ("\,sqsupseteq" ?$,1yR(B)
 ("\,square" ?$,2!a(B)
 ("\,squigarrowright" ?$,1w](B)
 ("\,star" ?$,1z&(B)
 ("\,straightphi" ?$,1'F(B)
 ("\,subset" ?$,1yB(B)
 ("\,subseteq" ?$,1yF(B)
 ("\,subseteqq" ?$,1yF(B)
 ("\,subsetneq" ?$,1yJ(B)
 ("\,subsetneqq" ?$,1yJ(B)
 ("\,succ" ?$,1y;(B)
 ("\,succapprox" ?$,1y?(B)
 ("\,succcurlyeq" ?$,1y=(B)
 ("\,succeq" ?$,1y=(B)
 ("\,succnapprox" ?$,1zI(B)
 ("\,succnsim" ?$,1zI(B)
 ("\,succsim" ?$,1y?(B)
 ("\,sum" ?$,1x1(B)
 ("\,supset" ?$,1yC(B)
 ("\,supseteq" ?$,1yG(B)
 ("\,supseteqq" ?$,1yG(B)
 ("\,supsetneq" ?$,1yK(B)
 ("\,supsetneqq" ?$,1yK(B)
 ("\,surd" ?$,1x:(B)
 ("\,swarrow" ?$,1vy(B)
 ("\,tau" ?$,1'D(B)
 ("\,therefore" ?$,1xT(B)
 ("\,theta" ?$,1'8(B)
 ("\,thickapprox" ?$,1xh(B)
 ("\,thicksim" ?$,1x\(B)
 ("\,to" ?$,1vr(B)
 ("\,top" ?$,1yd(B)
 ("\,triangle" ?$,2!u(B)
 ("\,triangledown" ?$,2!(B)
 ("\,triangleleft" ?$,2"#(B)
 ("\,trianglelefteq" ?$,1yt(B)
 ("\,triangleq" ?$,1x|(B)
 ("\,triangleright" ?$,2!y(B)
 ("\,trianglerighteq" ?$,1yu(B)
 ("\,twoheadleftarrow" ?$,1v~(B)
 ("\,twoheadrightarrow" ?$,1w (B)
 ("\,ulcorner" ?$,1z|(B)
 ("\,uparrow" ?$,1vq(B)
 ("\,updownarrow" ?$,1vu(B)
 ("\,upleftharpoon" ?$,1w?(B)
 ("\,uplus" ?$,1yN(B)
 ("\,uprightharpoon" ?$,1w>(B)
 ("\,upsilon" ?$,1'E(B)
 ("\,upuparrows" ?$,1wH(B)
 ("\,urcorner" ?$,1z}(B)
 ("\,u{i}" ?$,1 M(B)
 ("\,vDash" ?$,1yh(B)
 ("\,varkappa" ?$,1'p(B)
 ("\,varphi" ?$,1'U(B)
 ("\,varpi" ?$,1'V(B)
 ("\,varprime" ?$,1s2(B)
 ("\,varpropto" ?$,1x=(B)
 ("\,varrho" ?$,1'q(B)
 ("\,varsigma" ?$,1'B(B)
 ("\,vartheta" ?$,1'Q(B)
 ("\,vartriangleleft" ?$,1yr(B)
 ("\,vartriangleright" ?$,1ys(B)
 ("\,vdash" ?$,1yb(B)
 ("\,vdots" ?$,1zN(B)
 ("\,vee" ?$,1xH(B)
 ("\,veebar" ?$,1y{(B)
 ("\,vert" ?|)
 ("\,wedge" ?$,1xG(B)
 ("\,wp" ?$,1uX(B)
 ("\,wr" ?$,1x`(B)
 ("\,xi" ?$,1'>(B)
 ("\,zeta" ?$,1'6(B)

 ("\,Bbb{N}" ?$,1uU(B)			; AMS commands for blackboard bold
 ("\,Bbb{P}" ?$,1uY(B)			; Also sometimes \mathbb.
 ("\,Bbb{R}" ?$,1u](B)
 ("\,Bbb{Z}" ?$,1ud(B)

; ("--" ?$,1rs(B)
; ("---" ?$,1rt(B)
; ("~" ?\xa0)				; nbsp

 ("\,--" ?$,1rs(B) 				; en dash
 ("\,---" ?$,1rt(B) 				; em dash
; ("\,~" ?\xa0)				; nbsp

 ("\,mu" ?$,1'<(B)
 ("\,rho" ?$,1'A(B)
)

;;; latin-ltx.el ends here