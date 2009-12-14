module Nagios
  OK = 0
  WARNING = 1
  CRITICAL = 2
  UNKNOWN = 3

  def crit(message)
    "Critical: #{message}"
  end

  def warn(message)
    "Warning: #{message}"
  end

  def ok(message)
    "OK: #{message}"
  end

  class Probe
    include Nagios
    attr_reader :retval, :message

    def initialize(opts = {})
      @opts = opts
      @retval = OK
      @message = ok(ok_message)
    end

    def crit?
      is_crit = check_crit
      return false unless is_crit
      @retval = CRITICAL
      @message = crit(crit_message)
      true
    end

    def warn?
      is_warn = check_warn
      return false unless is_warn
      @retval = WARNING
      @message = warn(warn_message)
      true
    end

    def ok?
      is_ok = check_ok
      return false unless is_ok
      @retval = OK
      @message = ok(ok_message)
      true
    end

    def check_ok
      true
    end

    def run
      if !crit?
        if !warn?
          if !ok?
            @retval = UNKNOWN
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