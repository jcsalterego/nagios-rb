require 'optparse'

module Nagios
  class Config

    attr_accessor :options

    def initialize
      @settings = {}
      @options = OptionParser.new do |options|
        options.on("-wWARNING",
                   "--warning=WARNING",
                   "Warning Threshold") do |x|
          @settings[:warning] = int_if_possible(x)
        end
        options.on("-cCRITICAL",
                   "--critical=CRITICAL",
                   "Critical Threshold") do |x|
          @settings[:critical] = int_if_possible(x)
        end
      end
    end

    def [](setting)
      @settings[setting]
    end

    def []=(field, value)
      @settings[field] = value
    end

    def parse!
      @options.parse!
    end

    private
      def int_if_possible(x)
        (x.to_i > 0 || x == '0') ? x.to_i : x
      end
  end
end
