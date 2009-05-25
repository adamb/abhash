#!/usr/bin/env ruby

# Created: 2009-04-17
# Author: Adam Beguelin

require 'sha1'
require 'md5'
require 'base64'

# ABHash convert hash hex strings to shorter strings using Any Base (thus ABHash)

# Converting hashs like MD5 or SHA1 to hex strings is very common.  Unfortunately this results
# in a lot of really long strings being passed around, 40 characters for SHA1 and 32 for MD5.

class ABHash

  # alpha numeric characters that work in urls
  ALPHA_URL = 
    "0123456789" + 
     "abcdefghijklmnopqrstuvwxyz" + 
     "ABCDEFGHIJKLMNOPQRSTUVWXYZ$-_";
    
  def initialize(base_alphabet = ALPHA_URL)
    @ab_digit = base_alphabet.split(//);
  end

  # convert hex number to number in base alphabet
  def hex2abhash(h)
    number = h.hex # what if it's already a hex string?
    base = @ab_digit.size
    rc = ''
    while(number !=0)
      rc = String(@ab_digit[number % base]) + rc
      number = number / base
    end
    return rc
  end

end


begin
  ab = ABHash.new 
  digest = Digest::SHA1.new
  digest << 'Adam'
  (1..10).each { |e| 
    digest << e.to_s 
    puts digest.hexdigest
    puts ab.hex2abhash(digest.hexdigest.to_s)
    puts digest.hexdigest.to_s.size    
    puts ab.hex2abhash(digest.hexdigest.to_s).size
  }

  md5 = Digest::MD5.new
  md5 << 'Adam'
  puts md5.hexdigest
  puts md5.hexdigest.size  

  puts ab.hex2abhash("a")
  puts ab.hex2abhash("ffffffffff")
  
  puts "FFFFffffffff #{'ffffffffffff'.hex.size}"
  
end