module Nagios
  class Plugin

    def initialize
      @config = Nagios::Config.new
      @status_used = nil
    end

    def run!
      @config.parse!
      begin
        @value = measure
        if critical(@value)
          exit_with :critical, @value
        elsif warning(@value)
          exit_with :warning, @value
        else
          exit_with :ok, @value
        end
      rescue => e
        exit_unknown e
      end
    end

    def threshold(level)
      if level == :warning
        @config[:warning] || -1
      elsif level == :critical
        @config[:critical] || -1
      else
        -1
      end
    end

    def to_s(value)
      "#{value}"
    end

    def status
      @status_used = true
      @status
    end

    private
      def exit_with(level, value)
        @status = level.to_s.upcase
        msg = to_s(@value)
        if @status_used
          puts msg
        else
          puts "#{@status}: #{msg}"
        end
        exit Nagios.const_get("EXIT_#{@status}")
      end

      def exit_unknown(exc_info)
        puts "UNKNOWN (Exception): #{exc_info}"
        exit Nagios::EXIT_UNKNOWN
      end

  end
end
