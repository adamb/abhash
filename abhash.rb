#!/usr/bin/env ruby

# Created: 2009-04-17
# Author: Adam Beguelin
require 'sha1'
require 'md5'

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
  def hex2abh(h)
    number = h.hex
    return '0' if number < 1
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
  abh = ab.hex2abh(digest.hexdigest)
  puts "sha('Adam') is #{digest.hexdigest.size} characters long: #{digest.hexdigest}"
  puts "abh('Adam') is #{abh.size} characters long: #{abh}"

  md5 = Digest::MD5.new
  md5 << 'Adam'
  abh = ab.hex2abh(md5.hexdigest)
  puts "md5('Adam') is #{md5.hexdigest.size} characters long: #{md5.hexdigest}"
  puts "abh('Adam') is #{abh.size} characters long: #{abh}"  

  puts "\nDefault mappings for 0-F are the identical"
  puts "hex\t abh"
  (0..ABHash::ALPHA_URL.size).each { |e| puts "#{e.to_s(16)}\t #{ab.hex2abh(e.to_s(16))}" }

  puts "ab.hex2abh('ffffffffff') #{ab.hex2abh("ffffffffff")}"
  
  ab = ABHash.new("特选视频")
  abh = ab.hex2abh(digest.hexdigest)
  puts "特选视频 abh('Adam') is #{abh.size} characters long: #{abh}"
  
  ident = ABHash.new("0123456789abcdef")
  abh = ident.hex2abh(digest.hexdigest)
  // These should be the exact same
  puts "  sha('Adam') is #{digest.hexdigest.size} characters long: #{digest.hexdigest}"
  puts "ident('Adam') is #{abh.size} characters long: #{abh}"
  
  lossy = "0123456789" + 
   "abcdefghijklmnopqrstuvwxyz" + 
   "ABCDEFGHIJKLMNOPQRSTUVWXYZ$-_" +
   "0123456789" + 
    "abcdefghijklmnopqrstuvwxyz" + 
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ$-_" +
    "abcdefghijklmnopqrstuvwxyz" + 
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ$-_" +
    "0123456789" + 
     "abcdefghijklmnopqrstuvwxyz" + 
     "ABCDEFGHIJKLMNOPQRSTUVWXYZ$-_";
    
  ab = ABHash.new(lossy)
  abh = ab.hex2abh(digest.hexdigest)
  puts "lossy abh('Adam') is #{abh.size} characters long: #{abh}"
  
end