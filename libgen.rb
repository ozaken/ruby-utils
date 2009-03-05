#!/usr/bin/ruby

# The MIT License
# 
# Copyright (c) 2009 http://d.hatena.ne.jp/big-eyed-hamster
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
  

# Shared Library template generator.
# This program provide you with the template source code, Makefile, 
# and mkmf ruby script for shared library.

if( ARGV.size <= 0 )
  puts "usage: ruby libgen.rb [libname]"
  abort()
end

class_name = ARGV.shift.to_s

src=<<-EXTCONF_SRC
require "mkmf"
create_makefile("#{class_name}")
EXTCONF_SRC

open("extconf.rb","w") { |fh|
  fh.write(src)
}

src=<<-LIB_SRC
#include <ruby.h>

/* Test function. */
VALUE test(VALUE self, VALUE va, VALUE vb, VALUE vc){
  VALUE r;
  
  r = printf("This is test function.\\n");
  r = INT2FIX(r);

  return r;
}

/* Class and function definitions. */
void Init_#{class_name}(void){
  VALUE rb_c#{class_name};

  rb_c#{class_name}= rb_define_class("#{class_name}", rb_cObject);

  /* メソッド定義 */
  rb_define_method(rb_c#{class_name}, "test", test, 3);
}
LIB_SRC

open("#{class_name}.c","w") { |fh|
  fh.write(src)
}

`ruby extconf.rb`
