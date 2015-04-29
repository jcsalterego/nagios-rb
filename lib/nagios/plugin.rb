module Nagios
  class Plugin

    class << self
      # Syntactic sugar for creating a new instance automagically
      def run!
        new.run!
      end
    end

    def initialize
      @config = Nagios::Config.new
      @status_used = nil
    end

    def run!
      @config.parse!
      begin
        @value = measure
        if critical(@value)
          exit_with :critical, get_msg(:critical, @value)
        elsif warning(@value)
          exit_with :warning, get_msg(:warning, @value)
        else
          exit_with :ok, get_msg(:ok, @value)
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
      def get_msg(level, value)
        msg_method = "#{level}_msg".to_sym
        if self.respond_to?(msg_method)
          self.send(msg_method, value)
        else
          value
        end
      end

      def exit_with(level, value)
        @status = level.to_s.upcase
        msg = to_s(value)
        if @status_used
          puts msg
        else
          puts "#{@status}: #{msg}"
        end
        exit Nagios.const_get("EXIT_#{@status}")
      end

      def exit_unknown(exc_info)
        puts "UNKNOWN (Exception): #{exc_info}"
        puts exc_info.backtrace.join("\n")
        exit Nagios::EXIT_UNKNOWN
      end

  end
end
