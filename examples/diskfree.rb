#!/usr/bin/env ruby
#
# Diskfree Example Plugin
#
# $ ./diskfree.rb -w 50 -c 75
#

$LOAD_PATH.unshift '../lib'
require 'nagios'

class DiskfreePlugin < Nagios::Plugin
  def warning (x)
    x > threshold(:warning)
  end

  def critical (x)
    x > threshold(:critical)
  end

  def measure
    # grab output from `df -m` and parse that SOB
    output = `df -m`.split("\n")
    words = output[1].split
    words.map! { |x| x.to_i > 0 ? x.to_i : x }
    @stats = {
      :partition => words[0],
      :size      => words[1],
      :used      => words[2],
      :free      => words[3],
      :used_pct  => words[4],
      :mount     => words[5]
    }
    @stats[:used_pct]
  end

  def to_s(value)
    "DISK #{status} " +
      "- free space: #{@stats[:mount]} " +
      "#{@stats[:used]} MB (#{@stats[:used_pct]}%)"
  end
end

DiskfreePlugin.run!
