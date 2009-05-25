#!/usr/bin/env ruby

require 'sha1'
require 'md5'
require 'base64'

# convert a hex string to something shorter.

# The basic idea is to use a base 52 number instead of base 16.  The digits will be a-z,A-Z.
# This will allow really long hex strings to be reduced to much shorter alpha strings.
# We could include the digits 0-9 too and make it base 62, etc.  If we go with alphanum
# then we can be sure that they can be encoded into urls.  We just want to avoid special
# characters in urls.  
# 
# The hex

def hex2aln(h)
   number = h.hex
   aln_digit = ("0123456789" + 
               "abcdefghijklmnopqrstuvwxyz" + 
               "ABCDEFGHIJKLMNOPQRSTUVWXYZ$-_").split(//);
   
   base = aln_digit.size
   ret_aln = '';
   while(number != 0)
      ret_aln = String(aln_digit[number % base ] ) + ret_aln;
      number = number / base;
   end
   return ret_aln; ## Returning ALN
end


# Created: 2009-04-17
# Author: Adam Beguelin

begin
  digest = Digest::SHA1.new
  digest << 'Adam'
  (1..10).each { |e| 
    digest << e.to_s 
    puts digest.hexdigest
    puts digest.hexdigest.hex
    puts digest.hexdigest.hex.to_s.size    
    puts hex2aln(digest.hexdigest.to_s).size
  }

  md5 = Digest::MD5.new
  md5 << 'Adam'
  puts md5.hexdigest
  puts md5.hexdigest.size  

  puts hex2aln("a")
  puts hex2aln("ffffffffff")
  
  puts "FFFFffffffff #{'ffffffffffff'.hex.size}"
  
end