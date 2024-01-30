#!/usr/bin/env ruby
puts ARGV[o].scan(/\[from: (.*?)\] \[to: (.*?)\] \[flags: (.*?)\]/).join(",")
