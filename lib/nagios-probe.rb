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
      is_crit = check_crit
      return false unless is_crit
      @retval = Nagios::CRITICAL
      @message = "Critical: #{crit_message}"
      true
    end

    def warn?
      is_warn = check_warn
      return false unless is_warn
      @retval = Nagios::WARNING
      @message = "Warning: #{warn_message}"
      true
    end

    def ok?
      is_ok = check_ok
      return false unless is_ok
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
  end
end