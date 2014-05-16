module Nagios
  OK = 0
  WARNING = 1
  CRITICAL = 2
  UNKNOWN = 3

  class Probe
    attr_reader :retval, :message

    def initialize(opts = {})
      @opts = opts
      @retval = Nagios::OK
      @message = "OK: #{ok_message}"
    end

    def crit?
      return false unless check_crit
      @retval = Nagios::CRITICAL
      @message = "Critical: #{crit_message}"
      true
    end

    def warn?
      return false unless check_warn
      @retval = Nagios::WARNING
      @message = "Warning: #{warn_message}"
      true
    end

    def ok?
      return false unless check_ok
      @retval = Nagios::OK
      @message = "OK: #{ok_message}"
      true
    end

    def check_ok
      true
    end

    def run
      if !crit?
        if !warn?
          if !ok?
            @retval = Nagios::UNKNOWN
            raise RuntimeError, "crit? warn? and ok? all returned false"
          end
        end
      end
    end

    def crit_message
      "Default message - override crit_message."
    end

    def warn_message
      "Default message - override warn_message."
    end

    def ok_message
      "Default message - override ok_message."
    end
    
    def self.run!(options = {})
      begin
	      probe = self.new(options)
	      probe.run
	    rescue Exception => e
	      puts "Unknown: " + e.to_s
	      exit Nagios::UNKNOWN
	    end
	    puts probe.message
	    exit probe.retval
    end
  end
end
