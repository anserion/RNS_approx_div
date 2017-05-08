//Copyright 2017 Andrey S. Ionisyan (anserion@gmail.com)
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

program approx_divizion;
type
   tbit=(zero,one);
   tbit_vector=array of tbit;
   tbit_table=array of tbit_vector;
   TLUT=array of tbit_vector;
   TLUT2=array of TLUT;

   tstat_bin=record   
      name:string;
      not_proc,and_proc,xor_proc,nand_proc,or_proc,lut_read:longint;
      bits_copy_proc,bits_ins_proc,bits_cut_proc,bits_set_proc:longint;
      bits_zero_proc,bits_one_proc,bits_two_proc:longint;
      adder,subtractor,multiplier,divider:longint;
      shift_left,shift_right,equ_proc,cmp_proc:longint;
      pow2_proc,log2_down,log2_up,random:longint;
      bin_to_LongInt,longint_to_bin,print:longint;
   end;   
var
   print_flag,stat_flag:boolean;
   stat_bin:tstat_bin;
   stat_bin_array:array[1..100]of tstat_bin;
   
   procedure stat_binary_reset;
   begin
   with stat_bin do
   begin
      name:='';
      
      not_proc:=0;
      and_proc:=0;
      xor_proc:=0;
      nand_proc:=0;
      or_proc:=0;
      lut_read:=0;
      
      bits_copy_proc:=0;
      bits_ins_proc:=0;
      bits_cut_proc:=0;
      bits_set_proc:=0;
      
      bits_zero_proc:=0;
      bits_one_proc:=0;
      bits_two_proc:=0;
      
      adder:=0;
      subtractor:=0;
      multiplier:=0;
      divider:=0;
      
      shift_left:=0;
      shift_right:=0;
      equ_proc:=0;
      cmp_proc:=0;
      
      pow2_proc:=0;
      log2_down:=0;
      log2_up:=0;
      random:=0;
      
      bin_to_LongInt:=0;
      longint_to_bin:=0;
      print:=0;   
   end;
   end;

   procedure stat_binary_print(s:string);
   begin
   with stat_bin do
   begin
      name:=s;
      writeln(name);
      writeln('low level statistic: ');
      writeln('   not=',not_proc,
              ' and=',and_proc,
              ' xor=',xor_proc,
              ' nand=',nand_proc,
              ' or=',or_proc,
              ' LUT_read=',lut_read);

      writeln('binary device statistic: ');
      writeln('   bits_copy=',bits_copy_proc,
              ' bits_ins=',bits_ins_proc,
              ' bits_cut=',bits_cut_proc,
              ' bits_set=',bits_set_proc);
              
      writeln('   zero_proc=',bits_zero_proc,
              ' one_proc=',bits_one_proc,
              ' two_proc=',bits_two_proc);
              
      writeln('arith device statistic: ');
      writeln('   shift_left=',shift_left,
              ' shift_right=',shift_right,
              ' bin_equ=',equ_proc,
              ' bin_cmp=',cmp_proc);
              
      writeln('   adder=',adder,
              ' subtractor=',subtractor,
              ' multiplier=',multiplier,
              ' divider=',divider);
              
      writeln('   pow2_proc=',pow2_proc,
              ' log2_down=',log2_down,
              ' log2_up=',log2_up,
              ' random=',random);
              
      writeln('convertion subroutines statistic: ');
      writeln('   bin_to_longint=',bin_to_longint,
              ' longint_to_bin=',longint_to_bin,
              ' print=',print);
   end;
end;

procedure stat_bin_cmp_table(s:string; idx1,idx2,width0,width1,width2:integer);
var i:integer;
begin
   for i:=1 to width0+width1+width2+4 do write('='); writeln;
   write('|');
   write(S:width0);
   write('|',stat_bin_array[idx1].name:width1);
   write('|',stat_bin_array[idx2].name:width2);
   writeln('|');
   for i:=1 to width0+width1+width2+4 do write('-'); writeln;
   write('|');
   write('bin_to_longint proc':width0);
   write('|',stat_bin_array[idx1].bin_to_LongInt:width1);
   write('|',stat_bin_array[idx2].bin_to_LongInt:width2);
   writeln('|');
   write('|');
   write('longint_to_bin proc':width0);
   write('|',stat_bin_array[idx1].longint_to_bin:width1);
   write('|',stat_bin_array[idx2].longint_to_bin:width2);
   writeln('|');
   for i:=1 to width0+width1+width2+4 do write('-'); writeln;
   write('|');
   write('copy bits proc':width0);
   write('|',stat_bin_array[idx1].bits_copy_proc:width1);
   write('|',stat_bin_array[idx2].bits_copy_proc:width2);
   writeln('|');
   write('|');
   write('insert bits proc':width0);
   write('|',stat_bin_array[idx1].bits_ins_proc:width1);
   write('|',stat_bin_array[idx2].bits_ins_proc:width2);
   writeln('|');
   write('|');
   write('cut bits proc':width0);
   write('|',stat_bin_array[idx1].bits_cut_proc:width1);
   write('|',stat_bin_array[idx2].bits_cut_proc:width2);
   writeln('|');
   write('|');
   write('set bits proc':width0);
   write('|',stat_bin_array[idx1].bits_set_proc:width1);
   write('|',stat_bin_array[idx2].bits_set_proc:width2);
   writeln('|');
   for i:=1 to width0+width1+width2+4 do write('-'); writeln;
   write('|');
   write('zero_proc':width0);
   write('|',stat_bin_array[idx1].bits_zero_proc:width1);
   write('|',stat_bin_array[idx2].bits_zero_proc:width2);
   writeln('|');
   write('|');
   write('one_proc':width0);
   write('|',stat_bin_array[idx1].bits_one_proc:width1);
   write('|',stat_bin_array[idx2].bits_one_proc:width2);
   writeln('|');
   write('|');
   write('two_proc':width0);
   write('|',stat_bin_array[idx1].bits_two_proc:width1);
   write('|',stat_bin_array[idx2].bits_two_proc:width2);
   writeln('|');
   for i:=1 to width0+width1+width2+4 do write('-'); writeln;
   write('|');
   write('shift left':width0);
   write('|',stat_bin_array[idx1].shift_left:width1);
   write('|',stat_bin_array[idx2].shift_left:width2);
   writeln('|');
   write('|');
   write('shift right':width0);
   write('|',stat_bin_array[idx1].shift_right:width1);
   write('|',stat_bin_array[idx2].shift_right:width2);
   writeln('|');
   write('|');
   write('equ':width0);
   write('|',stat_bin_array[idx1].equ_proc:width1);
   write('|',stat_bin_array[idx2].equ_proc:width2);
   writeln('|');
   write('|');
   write('cmp':width0);
   write('|',stat_bin_array[idx1].cmp_proc:width1);
   write('|',stat_bin_array[idx2].cmp_proc:width2);
   writeln('|');
   for i:=1 to width0+width1+width2+4 do write('-'); writeln;
   write('|');
   write('pow2 proc':width0);
   write('|',stat_bin_array[idx1].pow2_proc:width1);
   write('|',stat_bin_array[idx2].pow2_proc:width2);
   writeln('|');
   write('|');
   write('log2 down proc':width0);
   write('|',stat_bin_array[idx1].log2_down:width1);
   write('|',stat_bin_array[idx2].log2_down:width2);
   writeln('|');
   write('|');
   write('log2 up proc':width0);
   write('|',stat_bin_array[idx1].log2_up:width1);
   write('|',stat_bin_array[idx2].log2_up:width2);
   writeln('|');
   write('|');
   write('random proc':width0);
   write('|',stat_bin_array[idx1].random:width1);
   write('|',stat_bin_array[idx2].random:width2);
   writeln('|');
   for i:=1 to width0+width1+width2+4 do write('-'); writeln;
   write('|');
   write('adder':width0);
   write('|',stat_bin_array[idx1].adder:width1);
   write('|',stat_bin_array[idx2].adder:width2);
   writeln('|');
   write('|');
   write('subtractor':width0);
   write('|',stat_bin_array[idx1].subtractor:width1);
   write('|',stat_bin_array[idx2].subtractor:width2);
   writeln('|');
   write('|');
   write('multiplier':width0);
   write('|',stat_bin_array[idx1].multiplier:width1);
   write('|',stat_bin_array[idx2].multiplier:width2);
   writeln('|');
   write('|');
   write('divider':width0);
   write('|',stat_bin_array[idx1].divider:width1);
   write('|',stat_bin_array[idx2].divider:width2);
   writeln('|');
   for i:=1 to width0+width1+width2+4 do write('-'); writeln;
   write('|');   
   write('LUT read':width0);
   write('|',stat_bin_array[idx1].LUT_read:width1);
   write('|',stat_bin_array[idx2].LUT_read:width2);
   writeln('|');
   for i:=1 to width0+width1+width2+4 do write('-'); writeln;
   write('|');
   write('not':width0);
   write('|',stat_bin_array[idx1].not_proc:width1);
   write('|',stat_bin_array[idx2].not_proc:width2);
   writeln('|');
   write('|');
   write('and':width0);
   write('|',stat_bin_array[idx1].and_proc:width1);
   write('|',stat_bin_array[idx2].and_proc:width2);
   writeln('|');
   write('|');
   write('xor':width0);
   write('|',stat_bin_array[idx1].xor_proc:width1);
   write('|',stat_bin_array[idx2].xor_proc:width2);
   writeln('|');
   write('|');
   write('nand':width0);
   write('|',stat_bin_array[idx1].nand_proc:width1);
   write('|',stat_bin_array[idx2].nand_proc:width2);
   writeln('|');
   write('|');
   write('or':width0);
   write('|',stat_bin_array[idx1].or_proc:width1);
   write('|',stat_bin_array[idx2].or_proc:width2);
   writeln('|');
   for i:=1 to width0+width1+width2+4 do write('-'); writeln;
   write('|');
   write('gates summary':width0);
   with stat_bin_array[idx1] do
      write('|',(not_proc+and_proc+xor_proc+nand_proc+or_proc):width1);
   with stat_bin_array[idx2] do
      write('|',(not_proc+and_proc+xor_proc+nand_proc+or_proc):width2);
   writeln('|');
   for i:=1 to width0+width1+width2+4 do write('='); writeln;
end;

//=======================================================================
   function tt_not(op1:tbit):tbit;
   begin
        if op1=one then tt_not:=zero;
        if op1=zero then tt_not:=one;
        if stat_flag then inc(stat_bin.not_proc);
   end;

   function tt_and(op1,op2:tbit):tbit;
   begin
        if (op1=zero)and(op2=zero) then tt_and:=zero;
        if (op1=zero)and(op2=one) then tt_and:=zero;
        if (op1=one)and(op2=zero) then tt_and:=zero;
        if (op1=one)and(op2=one) then tt_and:=one;
        if stat_flag then inc(stat_bin.and_proc);
   end;

   function tt_xor(op1,op2:tbit):tbit;
   begin
        if (op1=zero)and(op2=zero) then tt_xor:=zero;
        if (op1=zero)and(op2=one) then tt_xor:=one;
        if (op1=one)and(op2=zero) then tt_xor:=one;
        if (op1=one)and(op2=one) then tt_xor:=zero;
        if stat_flag then inc(stat_bin.xor_proc);
   end;

   function tt_nand(op1,op2:tbit):tbit;
   begin
        if (op1=zero)and(op2=zero) then tt_nand:=one;
        if (op1=zero)and(op2=one) then tt_nand:=zero;
        if (op1=one)and(op2=zero) then tt_nand:=zero;
        if (op1=one)and(op2=one) then tt_nand:=zero;
        if stat_flag then inc(stat_bin.nand_proc);
   end;

   function tt_or(op1,op2:tbit):tbit;
   begin
        if (op1=zero)and(op2=zero) then tt_or:=zero;
        if (op1=zero)and(op2=one) then tt_or:=one;
        if (op1=one)and(op2=zero) then tt_or:=one;
        if (op1=one)and(op2=one) then tt_or:=one;
        if stat_flag then inc(stat_bin.or_proc);
   end;

   function bin_to_LongInt(A:tbit_vector):LongInt;
   var i,n:integer; tmp:LongInt;
   begin
      n:=length(A);
      tmp:=0;
      for i:=n-1 downto 0 do
      begin
         tmp:=tmp shl 1;
         if A[i]=one then tmp:=tmp+1;
      end;
      bin_to_LongInt:=tmp;
      if stat_flag then inc(stat_bin.bin_to_longint);
   end;

   procedure LongInt_to_bin(A:LongInt; var res:tbit_vector);
   var i,precision:integer;
   begin
      precision:=length(res);
      for i:=0 to precision-1 do
      begin
         if (a and 1)=1 then res[i]:=one else res[i]:=zero;
         a:=a shr 1;
      end;
      if stat_flag then inc(stat_bin.longint_to_bin);
   end;
 
   procedure bin_print(s:string; x:tbit_vector);
   var i,n:integer;
   begin
      if print_flag then
      begin
         n:=length(x);
         write(S);
         write(bin_to_LongInt(x):8,'=');
         for i:=n-1 downto 0 do
            if x[i]=zero then write('0 ') else write('1 ');
         writeln;
         if stat_flag then inc(stat_bin.print);
      end;
   end;
   
   //bits copier
   procedure bin_copy_bits(var src, dst:tbit_vector);
   var i,bin_n:integer;
   begin 
      bin_n:=length(src); for i:=0 to bin_n-1 do dst[i]:=src[i];
      if stat_flag then inc(stat_bin.bits_copy_proc);
   end;
   
   //bits cutter
   procedure bin_cut_bits(start_pos,end_pos:integer; var x,res:tbit_vector);
   var i:integer;
   begin
      for i:=start_pos to end_pos do res[i-start_pos]:=x[i];
      if stat_flag then inc(stat_bin.bits_cut_proc);
   end;

   //bits setter
   procedure bin_ins_bits(start_pos,end_pos:integer; var src,dst:tbit_vector);
   var i:integer;
   begin
      for i:=start_pos to end_pos do dst[i]:=src[i-start_pos];
      if stat_flag then inc(stat_bin.bits_ins_proc);
   end;

   procedure bin_set_bits(start_pos,end_pos:integer; value:tbit; var x:tbit_vector);
   var i:integer;
   begin
      for i:=start_pos to end_pos do x[i]:=value;
      if stat_flag then inc(stat_bin.bits_set_proc);
   end;

   {clear bits}
   procedure bin_zero(var a:tbit_vector);
   var i,n:integer;
   begin
      n:=length(a);
      for i:=0 to n-1 do a[i]:=zero;
      if stat_flag then inc(stat_bin.bits_zero_proc);
   end;
   
   {calc const 1 in binary system}
   procedure bin_one(var a:tbit_vector);
   begin
      bin_zero(a);
      a[0]:=one;
      if stat_flag then inc(stat_bin.bits_one_proc);
   end;

   {calc const 2 in binary system}
   procedure bin_two(var a:tbit_vector);
   begin
      bin_zero(a);
      a[1]:=one;
      if stat_flag then inc(stat_bin.bits_two_proc);
   end;
      
   {half-adder}
   procedure bin_half_adder(a,b:tbit; var s,c:tbit);
   begin
       c:=tt_and(a,b);
       s:=tt_xor(a,b);
   end;

   {full-adder}
   procedure bin_full_adder(a,b,c_in:tbit; var s,c_out:tbit);
   var s1,p1,p2:tbit;
   begin
       bin_half_adder(a,b,s1,p1);
       bin_half_adder(s1,c_in,s,p2);
       c_out:=tt_or(p1,p2);
   end;

   {n-bit shift left to m bit}
   procedure bin_shl(var a:tbit_vector; m:integer);
   var i,n:integer;
   begin
      n:=length(a);
      for i:=n-1 downto m do a[i]:=a[i-m];
      for i:=0 to m-1 do a[i]:=zero;
      if stat_flag then inc(stat_bin.shift_left);
   end;

   {n-bit shift right to m bit}
   procedure bin_shr(var a:tbit_vector; m:integer);
   var i,n:integer;
   begin
      n:=length(a);
      for i:=0 to n-m-1 do a[i]:=a[i+m];
      for i:=n-m to n-1 do a[i]:=zero;
      if stat_flag then inc(stat_bin.shift_right);
   end;
      
   {n-bit adder}
   procedure bin_add(a,b:tbit_vector; var s:tbit_vector);
   var i,n_a,n_b:integer; c:tbit_vector;
   begin
   n_a:=length(a); setlength(c,n_a+1);
   n_b:=length(b);
   c[0]:=zero;
   for i:=0 to n_b-1 do bin_full_adder(a[i],b[i],c[i],s[i],c[i+1]);
   for i:=n_b to n_a-1 do bin_full_adder(a[i],zero,c[i],s[i],c[i+1]);
   setlength(c,0);
   if stat_flag then inc(stat_bin.adder);
   end;

   {n-bit subtractor}
   procedure bin_sub(a,b:tbit_vector; var s:tbit_vector);
   var i,n_a,n_b:integer; c:tbit_vector;
   begin
   n_a:=length(a); setlength(c,n_a+1);
   n_b:=length(b);
   c[0]:=one;
   for i:=0 to n_b-1 do bin_full_adder(a[i],tt_not(b[i]),c[i],s[i],c[i+1]);
   for i:=n_b to n_a-1 do bin_full_adder(a[i],one,c[i],s[i],c[i+1]);
   setlength(c,0);
   if stat_flag then inc(stat_bin.subtractor);
   end;

   {n-bit multiplier}
   procedure bin_mul(a,b:tbit_vector; var res:tbit_vector);
   var i,n_a,n_b:integer;
       tmp_a:tbit_vector;
   begin
   n_a:=length(a); n_b:=length(b);
   setlength(tmp_a,n_a); bin_copy_bits(a,tmp_a);
   bin_zero(res);
   for i:=0 to n_b-1 do
   begin
      if b[i]=one then bin_add(res,tmp_a,res);
      bin_shl(tmp_a,1);
   end;
   setlength(tmp_a,0);
   if stat_flag then inc(stat_bin.multiplier);
   end;

   {n-bit equal compare. if a=b then res:=1}
   function bin_is_equal(a,b:tbit_vector):tbit;
   var res_tmp_bin:tbit_vector; i,n:integer;
   begin
      n:=length(a); setlength(res_tmp_bin,n+1);
      res_tmp_bin[0]:=zero;
      for i:=0 to n-1 do res_tmp_bin[i+1]:=tt_or(res_tmp_bin[i],tt_xor(a[i],b[i]));
      bin_is_equal:=tt_not(res_tmp_bin[n]);
      setlength(res_tmp_bin,0);
      if stat_flag then inc(stat_bin.equ_proc);
   end;

   {n-bit greater compare. if a>b then res:=1}
   function bin_is_greater_than(a,b:tbit_vector):tbit;
   var tmp_res,tmp_carry,tmp_cmp,tmp_equ:tbit_vector;
      i,n:integer;
   begin
      n:=length(a);
      setlength(tmp_res,n+1); setlength(tmp_carry,n+1);
      setlength(tmp_cmp,n); setlength(tmp_equ,n);

      tmp_res[n]:=zero;
      tmp_carry[n]:=one;
      for i:=n-1 downto 0 do
      begin
         tmp_cmp[i]:=tt_and(a[i],tt_not(b[i]));
         tmp_equ[i]:=tt_not(tt_xor(a[i],b[i]));
         tmp_carry[i]:=tt_and(tmp_carry[i+1],tmp_equ[i]);
         tmp_res[i]:=tt_or(tmp_res[i+1],tt_and(tmp_carry[i+1],tmp_cmp[i]));
      end;

      bin_is_greater_than:=tmp_res[0];
      setlength(tmp_res,0); setlength(tmp_carry,0);
      setlength(tmp_cmp,0); setlength(tmp_equ,0);
      if stat_flag then inc(stat_bin.cmp_proc);
   end;

   {n-bit divider}
   procedure bin_div(a,b:tbit_vector; var q,r:tbit_vector);
   var a_tmp,b_tmp,Delta,j_bin,one_bin,zero_bin:tbit_vector; bin_n:integer;
   begin
   if stat_flag then inc(stat_bin.divider);
   bin_n:=length(a);
   setlength(a_tmp,bin_n); setlength(b_tmp,bin_n);
   setlength(Delta,bin_n); setlength(j_bin,bin_n);
   setlength(zero_bin,bin_n); setlength(one_bin,bin_n); 
   
   bin_copy_bits(a,a_tmp); bin_copy_bits(b,b_tmp);
   bin_zero(q); bin_zero(r);
   if (bin_is_equal(a_tmp,b_tmp)=one)or
      (bin_is_greater_than(a_tmp,b_tmp)=one) then
   begin
      bin_zero(j_bin); bin_zero(zero_bin); bin_one(one_bin);
      bin_shl(b_tmp,1);
      while (bin_is_equal(a_tmp,b_tmp)=one)or
            (bin_is_greater_than(a_tmp,b_tmp)=one) do
      begin
         bin_add(j_bin,one_bin,j_bin);
         bin_shl(b_tmp,1);
      end;
      bin_shr(b_tmp,1);
      bin_sub(a_tmp,b_tmp,Delta);
      Q[bin_to_longint(j_bin)]:=one;
      while bin_is_equal(j_bin,zero_bin)=zero do
      begin
         bin_shr(b_tmp,1);
         if (bin_is_equal(Delta,b_tmp)=one)or
            (bin_is_greater_than(Delta,b_tmp)=one) then
         begin
            Q[bin_to_longint(j_bin)-1]:=one;
            bin_sub(Delta,b_tmp,Delta);
         end;
         bin_sub(j_bin,one_bin,j_bin);
      end;
   end;
   bin_mul(b,q,Delta);
   bin_sub(a,Delta,r);
   
   setlength(a_tmp,0); setlength(b_tmp,0);
   setlength(Delta,0); setlength(j_bin,0);
   setlength(one_bin,0); setlength(zero_bin,0);
   end;

procedure log2_down(x:tbit_vector; var res:tbit_vector);
var bin_n,tmp:integer;
begin
   bin_n:=length(x); tmp:=bin_n-1;
   while x[tmp]=zero do tmp:=tmp-1;
   longint_to_bin(tmp,res);
   if stat_flag then inc(stat_bin.log2_down);
end;

procedure log2_up(x:tbit_vector; var res:tbit_vector);
var tmp_bin:tbit_vector; bin_n,tmp:integer;
begin
   bin_n:=length(x);
   log2_down(x,res);
   tmp:=bin_to_longint(res);
   setlength(tmp_bin,bin_n);
   bin_zero(tmp_bin); tmp_bin[tmp]:=one;
   if bin_is_greater_than(x,tmp_bin)=one then
   begin
      bin_one(tmp_bin);
      bin_add(res,tmp_bin,res);
   end;
   setlength(tmp_bin,0);
   if stat_flag then inc(stat_bin.log2_up);
end;

procedure bin_pow2(pow2_value:tbit_vector; var res:tbit_vector);
var pow_tmp,tmp_zero,tmp_one:tbit_vector; bin_n:integer;
begin
   if stat_flag then inc(stat_bin.pow2_proc);
   bin_n:=length(pow2_value);
   setlength(pow_tmp,bin_n); bin_copy_bits(pow2_value,pow_tmp);
   setlength(tmp_zero,bin_n); bin_zero(tmp_zero);
   setlength(tmp_one,bin_n); bin_one(tmp_one);
   
   bin_one(res);
   while bin_is_equal(pow_tmp,tmp_zero)=zero do
   begin
      bin_add(res,res,res);
      bin_sub(pow_tmp,tmp_one,pow_tmp);
   end;
   setlength(pow_tmp,0);
   setlength(tmp_zero,0);
   setlength(tmp_one,0);
end;

procedure bin_random(var res:tbit_vector);
var i,bin_n:integer;
begin
   bin_n:=length(res);
   for i:=0 to bin_n-1 do if random(2)=1 then res[i]:=one else res[i]:=zero;
   if stat_flag then inc(stat_bin.random);
end;

//======================================================================
type
   TRNS=array of tbit_vector;
   tstat_rns=record
      name:string;
      adder,subtractor,multiplier,formal_divider:longint;
      copy_proc,equ_proc,sign_by_MRS,sign_by_Parhami,random:longint;
      RNS_to_MRS,RNS_to_BSS,BSS_to_RNS:longint;
   end;

var
   stat_RNS:tstat_rns;
   stat_rns_array:array[1..100]of tstat_rns;
   
   RNS_n,precision_RNS_n:integer;
   RNS_n_bin,pp_bin:tbit_vector;
   LUT_add,LUT_sub,LUT_mul,LUT_formal_div:array of TLUT2;
   LUT_neg,LUT_inv:array of TLUT;
   LUT_digs,LUT_inv_P:array of TRNS;
   LUT_p,LUT_ppi,LUT_mu,LUT_basis,LUT_k_approx:TLUT;
   pow2_RNS:array of TRNS;
   zero_RNS,one_RNS,two_RNS,Pm1_RNS,P_div2_RNS:TRNS;
   
   LUT_EF:TLUT2;

procedure stat_RNS_reset;
begin
   with stat_RNS do
   begin
      name:='';
      
      adder:=0;
      subtractor:=0;
      multiplier:=0;
      formal_divider:=0;
      
      copy_proc:=0;
      equ_proc:=0;
      random:=0;
      sign_by_MRS:=0;
      sign_by_Parhami:=0;
      
      RNS_to_MRS:=0;
      RNS_to_BSS:=0;
      BSS_to_RNS:=0;
   end;
end;

procedure stat_RNS_print(s:string);
begin
   with stat_RNS do
   begin
   name:=s;
   writeln(name);
   writeln('RNS device statistic: ');
   writeln('   RNS_add=',adder,
           ' RNS_sub=',subtractor,
           ' RNS_mul=',multiplier,
           ' RNS_formal_div=',formal_divider);
   writeln('   RNS_copy=',copy_proc,
           ' RNS_equ=',equ_proc,
           ' RNS_random=',random);
   writeln('   RNS_sign(MRS)=',sign_by_MRS,
           ' RNS_sign(Parhami)=',sign_by_Parhami);
   writeln('   RNS_to_MRS=',RNS_to_MRS,
           ' RNS_to_BSS=',RNS_to_BSS,
           ' BSS_to_RNS=',BSS_to_RNS);
   end;
   writeln();
end;

procedure stat_RNS_cmp_table(s:string; idx1,idx2,width0,width1,width2:integer);
var i:integer;
begin
   for i:=1 to width0+width1+width2+4 do write('='); writeln;
   write('|');
   write(S:width0);
   write('|',stat_rns_array[idx1].name:width1);
   write('|',stat_rns_array[idx2].name:width2);
   writeln('|');
   for i:=1 to width0+width1+width2+4 do write('-'); writeln;
   write('|');
   write('RNS_add':width0);
   write('|',stat_rns_array[idx1].adder:width1);
   write('|',stat_rns_array[idx2].adder:width2);
   writeln('|');
   write('|');
   write('RNS_sub':width0);
   write('|',stat_rns_array[idx1].subtractor:width1);
   write('|',stat_rns_array[idx2].subtractor:width2);
   writeln('|');
   write('|');
   write('RNS_mul':width0);
   write('|',stat_rns_array[idx1].multiplier:width1);
   write('|',stat_rns_array[idx2].multiplier:width2);
   writeln('|');
   write('|');
   write('RNS_formal_div':width0);
   write('|',stat_rns_array[idx1].formal_divider:width1);
   write('|',stat_rns_array[idx2].formal_divider:width2);
   writeln('|');
   write('|');
   write('RNS_copy':width0);
   write('|',stat_rns_array[idx1].copy_proc:width1);
   write('|',stat_rns_array[idx2].copy_proc:width2);
   writeln('|');
   write('|');
   write('RNS_equ':width0);
   write('|',stat_rns_array[idx1].equ_proc:width1);
   write('|',stat_rns_array[idx2].equ_proc:width2);
   writeln('|');
   write('|');
   write('RNS_random':width0);
   write('|',stat_rns_array[idx1].random:width1);
   write('|',stat_rns_array[idx2].random:width2);
   writeln('|');
   write('|');
   write('RNS_sign(MRS)':width0);
   write('|',stat_rns_array[idx1].sign_by_MRS:width1);
   write('|',stat_rns_array[idx2].sign_by_MRS:width2);
   writeln('|');
   write('|');
   write('RNS_sign(Parhami)':width0);
   write('|',stat_rns_array[idx1].sign_by_Parhami:width1);
   write('|',stat_rns_array[idx2].sign_by_Parhami:width2);
   writeln('|');
   write('|');
   write('RNS_to_MRS':width0);
   write('|',stat_rns_array[idx1].RNS_to_MRS:width1);
   write('|',stat_rns_array[idx2].RNS_to_MRS:width2);
   writeln('|');
   write('|');
   write('RNS_to_BSS':width0);
   write('|',stat_rns_array[idx1].RNS_to_BSS:width1);
   write('|',stat_rns_array[idx2].RNS_to_BSS:width2);
   writeln('|');
   write('|');
   write('BSS_to_RNS':width0);
   write('|',stat_rns_array[idx1].BSS_to_RNS:width1);
   write('|',stat_rns_array[idx2].BSS_to_RNS:width2);
   writeln('|');   
   for i:=1 to width0+width1+width2+4 do write('='); writeln;
end;

procedure RNS_print(s:string; x:TRNS);
var i:integer;
begin
   if print_flag then
   begin
      writeln(S);
      for i:=1 to RNS_n do bin_print('',x[i]);
      writeln;
   end;
end;

procedure RNS_copy(var src,dst:TRNS);
var k:integer;
begin
   for k:=1 to RNS_n do bin_copy_bits(src[k],dst[k]);
   if stat_flag then inc(stat_RNS.copy_proc);
end;

procedure RNS_random(var res:TRNS);
var k:integer;
begin
   for k:=1 to RNS_n do
   begin
      stat_flag:=false;
      repeat
         bin_random(res[k]);
      until bin_to_LongInt(res[k])<bin_to_LongInt(LUT_p[k]);
      stat_flag:=true;
   end;
   if stat_flag then inc(stat_RNS.random);
end;

procedure LUT_add_calc;
var i,j,k,tmp:integer;
begin
   for k:=1 to RNS_n do
   begin
      for i:=0 to bin_to_longint(LUT_p[k])-1 do
      for j:=0 to bin_to_longint(LUT_p[k])-1 do
      begin
         tmp:=i+j;
         if tmp>=bin_to_longint(LUT_p[k]) then tmp:=tmp-bin_to_longint(LUT_p[k]);
         LongInt_to_bin(tmp,LUT_add[k,i,j]);
      end;
   end;
end;

procedure LUT_sub_calc;
var i,j,k,tmp:integer;
begin
   for k:=1 to RNS_n do
   begin
      for i:=0 to bin_to_longint(LUT_p[k])-1 do
      for j:=0 to bin_to_longint(LUT_p[k])-1 do
      begin
         tmp:=i-j; if tmp<0 then tmp:=tmp+bin_to_longint(LUT_p[k]);
         LongInt_to_bin(tmp,LUT_sub[k,i,j]);
      end;
   end;
end;

procedure LUT_mul_calc;
var i,j,k,tmp:integer;
begin
   for k:=1 to RNS_n do
   begin
      for i:=0 to bin_to_longint(LUT_p[k])-1 do
      for j:=0 to bin_to_longint(LUT_p[k])-1 do
      begin
         tmp:=i*j;
         while tmp>=bin_to_longint(LUT_p[k]) do
            tmp:=tmp-bin_to_longint(LUT_p[k]);
         LongInt_to_bin(tmp,LUT_mul[k,i,j]);
      end;
   end;
end;

procedure LUT_neg_calc;
var i,k,tmp:integer;
begin
   for k:=1 to RNS_n do
   begin
      bin_zero(LUT_neg[k,0]);
      for i:=1 to bin_to_longint(LUT_p[k])-1 do
      begin
         tmp:=bin_to_longint(LUT_p[k])-i;
         LongInt_to_bin(tmp,LUT_neg[k,i]);
      end;
   end;
end;

procedure LUT_inv_calc;
var i,j,k:integer;
begin
   for k:=1 to RNS_n do
   begin
      for i:=1 to RNS_n do bin_zero(LUT_inv[k,i]);
      for i:=1 to bin_to_longint(LUT_p[k])-1 do
      for j:=1 to bin_to_longint(LUT_p[k])-1 do
         if bin_to_longint(LUT_mul[k,i,j])=1 then
            LongInt_to_bin(j,LUT_inv[k,i]);
   end;
end;

procedure LUT_formal_div_calc;
var i,j,k:integer;
begin
   for k:=1 to RNS_n do
      for i:=1 to bin_to_longint(LUT_p[k])-1 do
      for j:=1 to bin_to_longint(LUT_p[k])-1 do
 bin_copy_bits(LUT_mul[k,i,bin_to_longint(LUT_inv[k,j])],LUT_formal_div[k,i,j]);
end;

procedure LUT_inv_P_calc;
var k,i,Pk,P_i,digit:integer;
begin
   for k:=1 to RNS_n do
   begin
      Pk:=bin_to_LongInt(LUT_p[k]);
      for i:=1 to RNS_n do
      begin         
         digit:=bin_to_LongInt(LUT_digs[Pk,i]);
         P_i:=bin_to_LongInt(LUT_p[i]);
         while digit>=P_i do digit:=digit-P_i;
         bin_copy_bits(LUT_inv[i,digit],LUT_inv_p[k,i]);
      end;
   end;
end;

procedure RNS_LUT_inv_P(k:integer; var res:TRNS);
begin
   if stat_flag then inc(stat_bin.lut_read);
   RNS_copy(LUT_inv_p[k],res);
end;

procedure RNS_LUT_add(k:integer; var op1,op2,res:tbit_vector);
begin
   if stat_flag then inc(stat_bin.lut_read);
   bin_copy_bits(LUT_add[k,bin_to_longint(op1),bin_to_longint(op2)],res);
end;

procedure RNS_LUT_sub(k:integer; var op1,op2,res:tbit_vector);
begin
   if stat_flag then inc(stat_bin.lut_read);
   bin_copy_bits(LUT_sub[k,bin_to_longint(op1),bin_to_longint(op2)],res)
end;

procedure RNS_LUT_mul(k:integer; var op1,op2,res:tbit_vector);
begin
   if stat_flag then inc(stat_bin.lut_read);
   bin_copy_bits(LUT_mul[k,bin_to_longint(op1),bin_to_longint(op2)],res)
end;

procedure RNS_LUT_formal_div(k:integer; var op1,op2,res:tbit_vector);
begin
   if stat_flag then inc(stat_bin.lut_read);
   bin_copy_bits(LUT_formal_div[k,bin_to_longint(op1),bin_to_longint(op2)],res)
end;

procedure RNS_add(var A,B,res:TRNS);
var i:integer;
begin 
   for i:=1 to RNS_n do RNS_LUT_add(i,A[i],B[i],res[i]);
   if stat_flag then inc(stat_RNS.adder);
end;

procedure RNS_sub(var A,B,res:TRNS);
var i:integer;
begin
   for i:=1 to RNS_n do RNS_LUT_sub(i,A[i],B[i],res[i]);
   if stat_flag then inc(stat_RNS.subtractor);
end;

procedure RNS_mul(var A,B,res:TRNS);
var i:integer;
begin
for i:=1 to RNS_n do RNS_LUT_mul(i,A[i],B[i],res[i]);
   if stat_flag then inc(stat_RNS.multiplier);
end;

procedure RNS_formal_div(var A,B,res:TRNS);
var i:integer;
begin
   for i:=1 to RNS_n do RNS_LUT_formal_div(i,A[i],B[i],res[i]);
   if stat_flag then inc(stat_RNS.formal_divider);
end;

function RNS_is_equal(var A,B:TRNS):tbit;
var res:tbit; k:integer;
begin
   if stat_flag then inc(stat_RNS.equ_proc);
   res:=one;
   for k:=1 to RNS_n do if bin_is_equal(A[k],B[k])=zero then res:=zero;
   RNS_is_equal:=res;
end;

procedure RNS_pp_calc;
var i:integer;
begin
   bin_one(pp_bin);
   for i:=1 to RNS_n do bin_mul(pp_bin,LUT_p[i],pp_bin);
end;

procedure pow2_RNS_calc(max_pow2:integer);
var i:integer;
begin
   RNS_copy(one_RNS,pow2_RNS[0]);
   RNS_copy(two_RNS,pow2_RNS[1]);
   for i:=2 to max_pow2 do RNS_add(pow2_RNS[i-1],pow2_RNS[i-1],pow2_RNS[i]);
end;

procedure RNS_ppi_calc;
var i,k:integer;
begin
   for i:=1 to RNS_n do
   begin
      bin_one(LUT_ppi[i]);
      for k:=1 to RNS_n do
         if k<>i then bin_mul(LUT_ppi[i],LUT_p[k],LUT_ppi[i]);
   end;
end;

procedure RNS_mu_calc;
var
   i,k,bin_n:integer;
   one_bin,i_bin,ppi_mul_i,q_bin,r_bin,p_tmp:tbit_vector;
begin
   bin_n:=length(pp_bin);
   setlength(one_bin,bin_n); bin_one(one_bin);
   setlength(i_bin,bin_n);
   setlength(ppi_mul_i,bin_n);
   setlength(q_bin,bin_n);
   setlength(r_bin,bin_n);
   setlength(p_tmp,bin_n);
   for k:=1 to RNS_n do
   begin
      bin_zero(LUT_mu[k]);
      for i:=0 to bin_to_longint(LUT_p[k])-1 do
      begin
         //res_cmp:=((ppi[k]*i) mod p_bin[k])=1;
         LongInt_to_bin(i,i_bin);
         bin_mul(LUT_ppi[k],i_bin,ppi_mul_i);
         bin_n:=length(LUT_p[k]);
         if bin_n>length(pp_bin) then bin_n:=length(pp_bin);
         bin_ins_bits(0,bin_n-1,LUT_p[k],p_tmp);         
         bin_div(ppi_mul_i,p_tmp,q_bin,r_bin);
         if bin_is_equal(r_bin,one_bin)=one then LongInt_to_bin(i,LUT_mu[k]);
      end;
   end;
   setlength(one_bin,0);
   setlength(i_bin,0);
   setlength(ppi_mul_i,0);
   setlength(q_bin,0);
   setlength(r_bin,0);
   setlength(p_tmp,0);
end;

procedure RNS_basis_calc;
var i:integer;
begin
   for i:=1 to RNS_n do bin_mul(LUT_ppi[i],LUT_mu[i],LUT_basis[i]);
end;

procedure RNS_k_approx_calc;
var
   i,precision,bin_n:integer;
   pow2_prec_bin,tmp_bin,r_bin,p_tmp,one_bin:tbit_vector;
begin
   precision:=length(LUT_k_approx[1]);
   setlength(pow2_prec_bin,precision);
   setlength(tmp_bin,precision);
   setlength(one_bin,precision); bin_one(one_bin);
   setlength(r_bin,precision);
   setlength(p_tmp,precision);
   for i:=1 to RNS_n do
   begin
      bin_n:=length(LUT_p[i]); if bin_n>precision then bin_n:=precision;
      bin_zero(pow2_prec_bin); pow2_prec_bin[precision-1]:=one;
      bin_ins_bits(0,bin_n-1,LUT_p[i],p_tmp);
      bin_div(pow2_prec_bin,p_tmp,LUT_k_approx[i],r_bin);
      tmp_bin:=p_tmp; bin_shr(tmp_bin,1);
      if bin_is_greater_than(r_bin,tmp_bin)=one then
         bin_add(LUT_k_approx[i],one_bin,LUT_k_approx[i]);
      bin_mul(LUT_k_approx[i],LUT_mu[i],LUT_k_approx[i]);
      LUT_k_approx[i,precision-1]:=zero;
   end;
   setlength(pow2_prec_bin,0);
   setlength(tmp_bin,0);
   setlength(one_bin,0);
   setlength(r_bin,0);
   setlength(p_tmp,0);
end;

procedure F(x:TRNS; var res:tbit_vector);
var
   i,precision:integer;
   mul_tmp:tbit_vector;
begin
   precision:=length(LUT_k_approx[1]);
   setlength(mul_tmp,precision);
   
   bin_zero(res);
   for i:=1 to RNS_n do
   begin
      bin_mul(LUT_k_approx[i],x[i],mul_tmp);
      bin_add(res,mul_tmp,res);
   end;
   res[precision-1]:=zero;
   setlength(mul_tmp,0);
end;

procedure RNS_approx_div(Fa,Fb:tbit_vector; A,B:TRNS; var Q,R:TRNS);
var 
   i,bin_n:integer;
   Fa_tmp,Fb_tmp,Delta,j_bin,one_bin:tbit_vector;
   tmp_rns:TRNS;
begin
   bin_n:=length(Fa);
   setlength(Fa_tmp,bin_n);
   setlength(Fb_tmp,bin_n);
   setlength(Delta,bin_n);
   setlength(j_bin,bin_n); bin_zero(j_bin);
   setlength(one_bin,bin_n); bin_one(one_bin);
   setlength(tmp_rns,RNS_n+1,precision_RNS_n);
   bin_copy_bits(Fa,Fa_tmp); bin_copy_bits(Fb,Fb_tmp);
   for i:=1 to RNS_n do bin_zero(Q[i]);
   if (bin_is_equal(Fa_tmp,Fb_tmp)=one)or
      (bin_is_greater_than(Fa_tmp,Fb_tmp)=one) then
   begin
      bin_shl(Fb_tmp,1);
      while (bin_is_equal(Fa_tmp,Fb_tmp)=one)or
            (bin_is_greater_than(Fa_tmp,Fb_tmp)=one) do
      begin
         bin_add(j_bin,one_bin,j_bin);
         bin_shl(Fb_tmp,1);
      end;
      bin_shr(Fb_tmp,1);
      bin_sub(Fa_tmp,Fb_tmp,Delta);
      RNS_copy(pow2_RNS[bin_to_longint(j_bin)],Q);
      for i:=bin_to_longint(j_bin)-1 downto 0 do
      begin
         bin_shr(Fb_tmp,1);
         if (bin_is_equal(Delta,Fb_tmp)=one)or
            (bin_is_greater_than(Delta,Fb_tmp)=one) then
         begin
            RNS_add(Q,pow2_RNS[i],Q);
            bin_sub(Delta,Fb_tmp,Delta);
         end;
      end;
   end;
   RNS_mul(B,Q,tmp_rns);
   RNS_sub(A,tmp_rns,R);
   setlength(Delta,0);
   setlength(j_bin,0);
   setlength(one_bin,0);
   setlength(tmp_rns,0,0);
end;

procedure LUT_digs_calc(max_digit_value:integer);
var i:integer;
begin
   RNS_copy(zero_RNS,LUT_digs[0]);
   for i:=1 to max_digit_value do
      RNS_add(LUT_digs[i-1],one_RNS,LUT_digs[i]);
end;

procedure RNS_LUT_dig(digit:integer; var res:TRNS);
begin
   if stat_flag then inc(stat_bin.lut_read);
   RNS_copy(LUT_digs[digit],res);
end;

procedure RNS_to_MRS(var x,res:TRNS);
var k:integer; x_tmp,digit,inv_P:TRNS;
begin
   if stat_flag then inc(stat_RNS.RNS_to_MRS);
   setlength(x_tmp,RNS_n+1,precision_RNS_n);
   setlength(digit,RNS_n+1,precision_RNS_n);
   setlength(inv_P,RNS_n+1,precision_RNS_n);
   RNS_copy(x,x_tmp);
   for k:=1 to RNS_n do
   begin
      bin_copy_bits(x_tmp[k],res[k]);
      RNS_LUT_dig(bin_to_LongInt(x_tmp[k]),digit);
      RNS_sub(x_tmp,digit,x_tmp);
      RNS_LUT_inv_P(k,inv_P);
      RNS_mul(x_tmp,inv_P,x_tmp);
   end;
   setlength(x_tmp,0,0);
   setlength(digit,0,0);
   setlength(inv_P,0,0);
end;

function RNS_sign_by_MRS(var x:TRNS):integer;
var x_MRS:TRNS; k:integer; res:integer;
begin
   if stat_flag then inc(stat_RNS.sign_by_MRS);
   setlength(x_MRS,RNS_n+1,precision_RNS_n);
   res:=0;
   if RNS_is_equal(X,zero_RNS)=zero then
   begin
      RNS_to_MRS(x,x_MRS);
      for k:=RNS_n downto 1 do
      if (res=0) then
      begin
         if bin_is_greater_than(P_div2_RNS[k],x_MRS[k])=one then res:=1;
         if bin_is_greater_than(x_MRS[k],P_div2_RNS[k])=one then res:=-1;
      end;
   end;
   if RNS_is_equal(X,P_div2_RNS)=one then res:=1;
   RNS_sign_by_MRS:=res;
   setlength(x_MRS,0,0);
end;

procedure RNS_to_BSS(var x:TRNS; var res:tbit_vector);
var x_MRS:TRNS; k:integer;
begin
   if stat_flag then inc(stat_RNS.RNS_to_BSS);
   setlength(x_MRS,RNS_n+1,precision_RNS_n);
   RNS_to_MRS(x,x_MRS);
   bin_zero(res);
   for k:=RNS_n-1 downto 1 do
   begin
      bin_add(res,x_MRS[k+1],res);
      bin_mul(res,LUT_p[k],res);
   end;
   bin_add(res,x_MRS[1],res);
   setlength(x_MRS,0,0);
end;

procedure BSS_to_RNS(x:tbit_vector; var res:TRNS);
var i,bin_n:integer;
begin
   if stat_flag then inc(stat_RNS.BSS_to_RNS);
   RNS_copy(zero_RNS,res);
   bin_n:=length(x);
   for i:=0 to bin_n-1 do
      if x[i]=one then RNS_add(res,pow2_RNS[i],res);
end;

//=====================================================================
procedure Parhami_LUT_EF_calc(betta_bin:tbit_vector);
var
   i,j,betta,bin_n:integer;
   j_bin,tmp_bin,dummy,p_tmp,mu_tmp,two_pow_betta_bin:tbit_vector;
begin
   betta:=bin_to_longint(betta_bin);
   bin_n:=length(betta_bin);
   setlength(tmp_bin,bin_n);
   setlength(j_bin,bin_n);
   setlength(dummy,bin_n);
   setlength(p_tmp,bin_n);
   setlength(mu_tmp,bin_n);
   setlength(two_pow_betta_bin,bin_n);
   bin_pow2(betta_bin,two_pow_betta_bin);
   bin_copy_bits(betta_bin,tmp_bin);
   for i:=1 to RNS_n do
   begin
      bin_zero(p_tmp); bin_ins_bits(0,precision_RNS_n-1,LUT_p[i],p_tmp);
      bin_zero(mu_tmp); bin_ins_bits(0,precision_RNS_n-1,LUT_mu[i],mu_tmp);
      for j:=0 to bin_to_LongInt(LUT_p[i])-1 do
      begin
         longint_to_bin(j,j_bin); 
         bin_mul(j_bin,mu_tmp,tmp_bin); 
         bin_mul(tmp_bin,two_pow_betta_bin,tmp_bin); 
         bin_div(tmp_bin,p_tmp,tmp_bin,dummy); 
         bin_zero(LUT_EF[i,j]); 
         bin_ins_bits(0,betta-1,tmp_bin,LUT_EF[i,j]);
      end;
   end;
   setlength(tmp_bin,0);
   setlength(j_bin,0);
   setlength(dummy,0);
   setlength(p_tmp,0);
   setlength(mu_tmp,0);
end;

function Parhami_ES(var undef_edge_bin,center_edge_bin:tbit_vector; var x:TRNS):integer;
var res,bin_n,k:integer; sum_bin:tbit_vector;
begin
   if stat_flag then inc(stat_RNS.sign_by_Parhami);
   if stat_flag then inc(stat_bin.lut_read);
   bin_n:=length(LUT_EF[1,1]);
   setlength(sum_bin,bin_n);
   bin_zero(sum_bin);
   for k:=1 to RNS_n do bin_add(sum_bin,LUT_EF[k,bin_to_LongInt(x[k])],sum_bin);
   res:=1;
   if bin_is_greater_than(sum_bin,center_edge_bin)=one then res:=-1;
   if bin_is_greater_than(sum_bin,undef_edge_bin)=one then res:=0;
   setlength(sum_bin,0);
   Parhami_ES:=res;
   
end;

procedure Parhami_approx_div(var undef_edge_bin,center_edge_bin:tbit_vector; 
                             var Mdiv8,A,D,Q,R:TRNS);
var
   bin_n,ESA:integer; i_bin,j_bin,one_bin:tbit_vector;
   A_tmp,D_tmp,tmp_rns:TRNS;
begin
   setlength(A_tmp,RNS_n+1,precision_RNS_n);
   setlength(D_tmp,RNS_n+1,precision_RNS_n);
   setlength(tmp_rns,RNS_n+1,precision_RNS_n);
   RNS_copy(A,A_tmp);
   RNS_copy(D,D_tmp);
   
   bin_n:=length(undef_edge_bin);
   setlength(j_bin,bin_n);
   setlength(i_bin,bin_n);
   setlength(one_bin,bin_n); bin_one(one_bin);
   
   bin_zero(j_bin); 
   RNS_copy(zero_RNS,Q);
   
   RNS_sub(Mdiv8,D_tmp,tmp_rns);
   RNS_sub(tmp_rns,D_tmp,tmp_rns);
   while Parhami_ES(undef_edge_bin,center_edge_bin,tmp_rns)<>-1 do
   begin
      bin_add(j_bin,one_bin,j_bin);
      RNS_add(D_tmp,D_tmp,D_tmp);
      RNS_sub(Mdiv8,D_tmp,tmp_rns);
      RNS_sub(tmp_rns,D_tmp,tmp_rns);
   end;

   RNS_sub(A_tmp,D_tmp,tmp_rns);
   while Parhami_ES(undef_edge_bin,center_edge_bin,tmp_rns)<>-1 do
   begin
      RNS_sub(A_tmp,D_tmp,A_tmp);
      RNS_sub(A_tmp,D_tmp,A_tmp);
      RNS_add(Q,one_RNS,Q);
      RNS_add(Q,one_RNS,Q);
      RNS_sub(A_tmp,D_tmp,tmp_rns);
   end;
   
   bin_one(i_bin);
   while bin_is_greater_than(i_bin,j_bin)=zero do
   begin
      ESA:=Parhami_ES(undef_edge_bin,center_edge_bin,A_tmp);
      if ESA=1 then
      begin
         RNS_sub(A_tmp,D_tmp,A_tmp);
         RNS_add(A_tmp,A_tmp,A_tmp);
         RNS_add(Q,one_RNS,Q);
         RNS_add(Q,Q,Q);
      end;
      if ESA=-1 then
      begin
         RNS_add(A_tmp,D_tmp,A_tmp);
         RNS_add(A_tmp,A_tmp,A_tmp);
         RNS_sub(Q,one_RNS,Q);
         RNS_add(Q,Q,Q);
      end;
      if ESA=0 then
      begin
         RNS_add(A_tmp,A_tmp,A_tmp);
         RNS_add(Q,Q,Q);
      end;
      
      bin_add(i_bin,one_bin,i_bin);
   end;
   
   ESA:=Parhami_ES(undef_edge_bin,center_edge_bin,A_tmp);
   if ESA=1 then
   begin
      RNS_sub(A_tmp,D_tmp,A_tmp);
      RNS_add(Q,one_RNS,Q);
   end;
   if ESA=-1 then
   begin
      RNS_add(A_tmp,D_tmp,A_tmp);
      RNS_sub(Q,one_RNS,Q);
   end;
     
   ESA:=Parhami_ES(undef_edge_bin,center_edge_bin,A_tmp);
   if ESA=-1 then
   begin
      RNS_add(A_tmp,D_tmp,A_tmp);
      RNS_sub(Q,one_RNS,Q);
   end;
   
   if ESA=0 then
   begin
      if RNS_sign_by_MRS(A_tmp)=-1 then
      begin
         RNS_add(A_tmp,D_tmp,A_tmp);
         RNS_sub(Q,one_RNS,Q);
      end;
   end;

   RNS_mul(D,Q,tmp_rns);
   RNS_sub(A,tmp_rns,R);
   
   setlength(A_tmp,0,0);
   setlength(D_tmp,0,0);
   setlength(tmp_rns,0,0);
end;

//=====================================================================

var
   i,bin_n,precision:integer;
   A_RNS,B_RNS,Q_RNS,R_RNS:TRNS;
   A_bin,B_bin,Q_bin,R_bin:tbit_vector;
   Fa_bin,Fb_bin:tbit_vector;
   rho_bin,pp_mul_rho_bin,log2_pp_mul_rho_bin,log2_RNS_n_bin:tbit_vector;
   precision_bin,alpha_bin,betta_bin:tbit_vector;
   Parhami_undef_bin,Parhami_center_bin,Parhami_Mdiv8_bin:tbit_vector;
   Parhami_Mdiv8_RNS:TRNS;
   tmp_bin:tbit_vector;
   
begin
   print_flag:=true; stat_flag:=true;
   stat_binary_reset; stat_RNS_reset;
   for i:=1 to 100 do 
   begin
      stat_bin_array[i]:=stat_bin;
      stat_rns_array[i]:=stat_rns;
   end;
   
   writeln('Compare methods of RNS approx divizion');
   writeln('1. Prof. Chervyakov N.I. RNS approx method');
   writeln('2. Prof. Parhami RNS approx method');
   writeln('3. "Classic" binary divizion without RNS');
   writeln;
   
   bin_n:=24; writeln('bin_n=',bin_n);
   RNS_n:=4; writeln('RNS_n=',RNS_n);
   precision_RNS_n:=4; writeln('precision_RNS_n=',precision_RNS_n);
 
   setlength(LUT_p,RNS_n+1,precision_RNS_n);
   setlength(RNS_n_bin,bin_n);
   LongInt_to_bin(RNS_n,RNS_n_bin);   

   setlength(pp_bin,bin_n);
   setlength(LUT_ppi,RNS_n+1,bin_n);
   setlength(LUT_mu,RNS_n+1,precision_RNS_n);
   setlength(LUT_basis,RNS_n+1,bin_n);
   
   LongInt_to_bin(5,LUT_p[1]);
   LongInt_to_bin(7,LUT_p[2]);
   LongInt_to_bin(9,LUT_p[3]);
   LongInt_to_bin(11,LUT_p[4]);
   RNS_print('p=',LUT_p);
  
//===========================================================
   setlength(zero_RNS,RNS_n+1,precision_RNS_n);
   setlength(one_RNS,RNS_n+1,precision_RNS_n);
   setlength(two_RNS,RNS_n+1,precision_RNS_n);
   setlength(Pm1_RNS,RNS_n+1,precision_RNS_n);
   setlength(P_div2_RNS,RNS_n+1,precision_RNS_n);
   
   for i:=1 to RNS_n do
   begin
      bin_zero(zero_RNS[i]);
      bin_one(one_RNS[i]);
      if LUT_p[i,0]=zero then bin_zero(two_RNS[i]) else bin_two(two_RNS[i]);
      LongInt_to_bin(bin_to_longint(LUT_p[i])-1,Pm1_RNS[i]);
      bin_copy_bits(Pm1_RNS[i],P_div2_RNS[i]);
      bin_shr(P_div2_RNS[i],1);
   end;

//===========================================================

   setlength(LUT_add,RNS_n+1);
   setlength(LUT_sub,RNS_n+1);
   setlength(LUT_mul,RNS_n+1);
   setlength(LUT_formal_div,RNS_n+1);
   setlength(LUT_neg,RNS_n+1);
   setlength(LUT_inv,RNS_n+1);
   for i:=1 to RNS_n do
   begin
      setlength(LUT_add[i],bin_to_longint(LUT_p[i]),bin_to_longint(LUT_p[i]),precision_RNS_n);
      setlength(LUT_sub[i],bin_to_longint(LUT_p[i]),bin_to_longint(LUT_p[i]),precision_RNS_n);
      setlength(LUT_mul[i],bin_to_longint(LUT_p[i]),bin_to_longint(LUT_p[i]),precision_RNS_n);
      setlength(LUT_formal_div[i],bin_to_longint(LUT_p[i]),bin_to_longint(LUT_p[i]),precision_RNS_n);
      setlength(LUT_neg[i],bin_to_longint(LUT_p[i]),precision_RNS_n);
      setlength(LUT_inv[i],bin_to_longint(LUT_p[i]),precision_RNS_n);
   end;
   
   LUT_add_calc;
   LUT_neg_calc;
   LUT_sub_calc;
   LUT_mul_calc;
   LUT_inv_calc;
   LUT_formal_div_calc;
   
   setlength(LUT_digs,256,RNS_n+1,precision_RNS_n);
   LUT_digs_calc(255);
   
   setlength(LUT_inv_P,RNS_n+1,RNS_n+1,precision_RNS_n);
   LUT_inv_P_calc;

   setlength(pow2_RNS,bin_n+1,RNS_n+1,precision_RNS_n);
   pow2_RNS_calc(bin_n); 

//===========================================================   
   if print_flag then writeln();

   RNS_pp_calc;
   bin_print('pp=',pp_bin);
   
   RNS_ppi_calc;
   RNS_print('ppi=',LUT_ppi);
   
   RNS_mu_calc;
   RNS_print('mu=',LUT_mu);
   
   RNS_basis_calc;
   RNS_print('basis=',LUT_basis);

//===========================================================
   if print_flag then writeln;
   
   stat_binary_reset; stat_RNS_reset;
   setlength(rho_bin,bin_n); bin_zero(rho_bin);
   setlength(tmp_bin,bin_n); bin_zero(tmp_bin);

   for i:=1 to RNS_n do bin_add(rho_bin,LUT_p[i],rho_bin);
   bin_sub(rho_bin,RNS_n_bin,rho_bin);
   bin_print('            rho= ',rho_bin);
   
   setlength(pp_mul_rho_bin,bin_n);
   setlength(log2_pp_mul_rho_bin,bin_n);
   setlength(log2_RNS_n_bin,bin_n);
   setlength(precision_bin,bin_n);
   
   bin_mul(pp_bin,rho_bin,pp_mul_rho_bin);
   bin_print('             pp= ',pp_bin);
   bin_print('         pp*rho= ',pp_mul_rho_bin);
   log2_up(pp_mul_rho_bin,log2_pp_mul_rho_bin);
   bin_print('log2_up(pp*rho)= ',log2_pp_mul_rho_bin);
   log2_up(RNS_n_bin,log2_RNS_n_bin);
   bin_print(' log2_up(RNS_n)= ',log2_RNS_n_bin);
   bin_add(log2_pp_mul_rho_bin,log2_RNS_n_bin,precision_bin);
   precision:=bin_to_longint(precision_bin);
   bin_print('      precision= ',precision_bin);
   bin_zero(tmp_bin); tmp_bin[precision]:=one;
   bin_print('    2^precision= ',tmp_bin);
   
   bin_one(tmp_bin);
   bin_add(precision_bin,tmp_bin,precision_bin);
   
//   longint_to_bin(12,precision_bin);
   
   precision:=bin_to_longint(precision_bin);
   
   setlength(LUT_k_approx,RNS_n+1,precision);
   RNS_k_approx_calc;
   RNS_print('k_approx*2^precision=',LUT_k_approx);
   
   stat_binary_print('--precision calc--'); stat_RNS_print('--precision calc--');

//===========================================================
   if print_flag then writeln;
   
   setlength(A_bin,bin_n); longint_to_bin(125,A_bin);
   setlength(A_RNS,RNS_n+1,precision_RNS_n); BSS_to_RNS(A_bin,A_RNS);

   setlength(B_bin,bin_n); longint_to_bin(14,B_bin);
   setlength(B_RNS,RNS_n+1,precision_RNS_n); BSS_to_RNS(B_bin,B_RNS);

//===========================================================
   if print_flag then writeln;
   
   setlength(Fa_bin,precision);
   stat_binary_reset; stat_RNS_reset;
   F(A_RNS,Fa_bin);
   stat_binary_print('--F(a) calc--'); stat_RNS_print('--F(a) calc--');
   bin_print('F(A)=',Fa_bin);
   
   if print_flag then writeln;
   
   setlength(Fb_bin,precision);
   stat_binary_reset; stat_RNS_reset;
   F(B_RNS,Fb_bin);
   stat_binary_print('--F(b) calc--'); stat_RNS_print('--F(b) calc--');
   bin_print('F(B)=',Fb_bin);
   
   if print_flag then writeln;
   
   setlength(Q_RNS,RNS_n+1,precision_RNS_n); setlength(R_RNS,RNS_n+1,precision_RNS_n);
   stat_binary_reset; stat_RNS_reset;
   stat_flag:=true;
   F(A_RNS,Fa_bin);
   F(B_RNS,Fb_bin);
   RNS_approx_div(Fa_bin,Fb_bin,A_RNS,B_RNS,Q_RNS,R_RNS);
   stat_flag:=false;
   if print_flag then writeln;
   stat_binary_print('RNS divider');
   stat_RNS_print('RNS divider');
   stat_bin_array[1]:=stat_bin; stat_rns_array[1]:=stat_rns;

   bin_print('A=',A_bin);
   RNS_print('A=',A_RNS);
   bin_print('B=',B_bin);
   RNS_print('B=',B_RNS);
   
   setlength(Q_bin,bin_n);
   RNS_to_BSS(Q_RNS,Q_bin);
   bin_print('Q=',Q_bin);
   RNS_print('Q=',Q_RNS);

   setlength(R_bin,bin_n);
   RNS_to_BSS(R_RNS,R_bin);
   bin_print('R=',R_bin);
   RNS_print('R=',R_RNS);
//================================================

   if print_flag then writeln;

   if print_flag then writeln('Syntetic test (RNS)');
   stat_binary_reset; stat_RNS_reset; stat_flag:=false;
   for i:=1 to 1000 do
   begin
      RNS_random(A_RNS);
      RNS_random(B_RNS);
      if RNS_is_equal(B_RNS,zero_RNS)=zero then
      begin
         stat_flag:=true;
         F(A_RNS,Fa_bin); F(B_RNS,Fb_bin);
         RNS_approx_div(Fa_bin,Fb_bin,A_RNS,B_RNS,Q_RNS,R_RNS);
         stat_flag:=false;
      end;
   end;
   stat_binary_print('RNS divider (1000 times)');
   stat_RNS_print('RNS divider (1000 times)');
   stat_bin_array[2]:=stat_bin; stat_rns_array[2]:=stat_rns;
   
//====================================================================

   if print_flag then writeln;
   
   setlength(alpha_bin,bin_n); longint_to_bin(4,alpha_bin);
   bin_print('Parhami alpha=',alpha_bin);

   setlength(betta_bin,bin_n); bin_zero(betta_bin);
   log2_up(RNS_n_bin,betta_bin);
   bin_add(betta_bin,alpha_bin,betta_bin);
   bin_print('Parhami betta=',betta_bin);

   setlength(LUT_EF,RNS_n+1);
   for i:=1 to RNS_n do setlength(LUT_EF[i],bin_to_longint(LUT_p[i]),bin_to_longint(betta_bin));
   Parhami_LUT_EF_calc(betta_bin);
{
   for i:=1 to RNS_n do
   begin
      for j:=0 to bin_to_longint(LUT_p[i])-1 do
      begin;
         if print_flag then write('Parhami LUT_EF[',i:3,'][',j:3,']=');
         bin_print('',LUT_EF[i,j]);
      end;
      if print_flag then writeln;
   end;
}

   setlength(Parhami_center_bin,bin_to_longint(betta_bin));
   bin_zero(Parhami_center_bin);
   for i:=0 to bin_to_LongInt(betta_bin)-2 do Parhami_center_bin[i]:=one;

   setlength(Parhami_undef_bin,bin_to_longint(betta_bin));
   for i:=0 to bin_to_longint(betta_bin)-1 do Parhami_undef_bin[i]:=one;
   Parhami_undef_bin[bin_to_longint(betta_bin)-bin_to_longint(alpha_bin)]:=zero;

   bin_print(' Parhami undef_edge=',Parhami_undef_bin);
   bin_print('Parhami center_edge=',Parhami_center_bin);
   
   setlength(Parhami_Mdiv8_RNS,RNS_n+1,precision_RNS_n);
   setlength(Parhami_Mdiv8_bin,bin_n);
   bin_copy_bits(pp_bin,Parhami_Mdiv8_bin);
   bin_shr(Parhami_Mdiv8_bin,3);
   BSS_to_RNS(Parhami_Mdiv8_bin,Parhami_Mdiv8_RNS);

   setlength(A_bin,bin_n);
   longint_to_bin(125,A_bin);
   BSS_to_RNS(A_bin,A_RNS);

   setlength(B_bin,bin_n);
   longint_to_bin(14,B_bin);
   BSS_to_RNS(B_bin,B_RNS);
   
   setlength(Q_RNS,RNS_n+1,precision_RNS_n); setlength(R_RNS,RNS_n+1,precision_RNS_n);
   stat_binary_reset; stat_RNS_reset;
   stat_flag:=true;
   Parhami_approx_div(Parhami_undef_bin,Parhami_center_bin,Parhami_Mdiv8_RNS,A_RNS,B_RNS,Q_RNS,R_RNS);
   stat_flag:=false;
   if print_flag then writeln;
   stat_binary_print('Parhami divider');
   stat_RNS_print('Parhami divider');
   stat_bin_array[3]:=stat_bin; stat_rns_array[3]:=stat_rns;

   bin_print('A=',A_bin);
   RNS_print('A=',A_RNS);
   bin_print('B=',B_bin);
   RNS_print('B=',B_RNS);

   setlength(Q_bin,bin_n);
   RNS_to_BSS(Q_RNS,Q_bin);
   bin_print('Q=',Q_bin);
   RNS_print('Q=',Q_RNS);

   setlength(R_bin,bin_n);
   RNS_to_BSS(R_RNS,R_bin);
   bin_print('R=',R_bin);
   RNS_print('R=',R_RNS);

//================================================

   if print_flag then writeln;

   if print_flag then writeln('Syntetic test (Parhami)');
   stat_binary_reset; stat_RNS_reset; stat_flag:=false;
   for i:=1 to 1000 do
   begin
      RNS_random(A_RNS);
      RNS_random(B_RNS);
      if RNS_is_equal(B_RNS,zero_RNS)=zero then
      begin
         stat_flag:=true;
   Parhami_approx_div(Parhami_undef_bin,Parhami_center_bin,Parhami_Mdiv8_RNS,A_RNS,B_RNS,Q_RNS,R_RNS);
         stat_flag:=false;
      end;
   end;
   stat_binary_print('Parhami divider (1000 times)');
   stat_RNS_print('Parhami divider (1000 times)');
   stat_bin_array[4]:=stat_bin; stat_rns_array[4]:=stat_rns;
//=================================================================

   if print_flag then writeln;

   log2_up(pp_bin,precision_bin);
   setlength(A_bin,bin_to_LongInt(precision_bin));
   setlength(B_bin,bin_to_LongInt(precision_bin));
   setlength(Q_bin,bin_to_LongInt(precision_bin));
   setlength(R_bin,bin_to_LongInt(precision_bin));

   stat_binary_reset; stat_RNS_reset; stat_flag:=false;
   LongInt_to_bin(125,A_bin);
   LongInt_to_bin(14,B_bin);
   stat_flag:=true;
   bin_div(A_bin,B_bin,Q_bin,R_bin);
   stat_flag:=false;
   stat_binary_print('BSS divider');
   stat_RNS_print('BSS divider');
   stat_bin_array[5]:=stat_bin; stat_rns_array[5]:=stat_rns;
   bin_print('A=',A_bin);
   bin_print('B=',B_bin);
   bin_print('Q=',Q_bin);
   bin_print('R=',R_bin);

   setlength(tmp_bin,bin_to_LongInt(precision_bin));
   bin_zero(tmp_bin);
   if print_flag then writeln;
   if print_flag then writeln('Syntetic test (BSS)');
   stat_binary_reset; stat_RNS_reset; stat_flag:=false;
   for i:=1 to 1000 do
   begin
      bin_random(A_bin); A_bin[bin_to_LongInt(precision_bin)-1]:=zero;
      bin_random(B_bin); B_bin[bin_to_LongInt(precision_bin)-1]:=zero;
      if bin_is_equal(B_bin,tmp_bin)=zero then
      begin
         stat_flag:=true;
         bin_div(A_bin,B_bin,Q_bin,R_bin);
         stat_flag:=false;
      end;
   end;
   stat_binary_print('BSS divider (1000 times)');
   stat_RNS_print('BSS divider (1000 times)');
   stat_bin_array[6]:=stat_bin; stat_rns_array[6]:=stat_rns;
 //=====================================================================
 writeln;
 stat_bin_cmp_table('bin compare table',1,3,20,30,30);
 stat_RNS_cmp_table('RNS compare table',1,3,20,30,30);
 writeln;
 stat_bin_cmp_table('bin compare table',1,5,20,30,30);
 stat_RNS_cmp_table('RNS compare table',1,5,20,30,30);
 writeln;
 stat_bin_cmp_table('bin compare table',3,5,20,30,30);
 stat_RNS_cmp_table('RNS compare table',3,5,20,30,30);
 writeln;
 writeln;
 stat_bin_cmp_table('bin compare table',2,4,20,30,30);
 stat_RNS_cmp_table('RNS compare table',2,4,20,30,30);
 writeln;
 stat_bin_cmp_table('bin compare table',2,6,20,30,30);
 stat_RNS_cmp_table('RNS compare table',2,6,20,30,30);
 writeln;
 stat_bin_cmp_table('bin compare table',4,6,20,30,30);
 stat_RNS_cmp_table('RNS compare table',4,6,20,30,30);
 
end.
