require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'nagios-probe'

class Test::Unit::TestCase
end

class CriticalProbe < Nagios::Probe
  def check_crit
    true
  end
end

class WarnProbe < Nagios::Probe
  def check_crit
    false
  end

  def check_warn
    true
  end
end

class OKProbe < Nagios::Probe
  def check_crit
    false
  end

  def check_warn
    false
  end
end

class BadProbe < Nagios::Probe
  def check_crit
    false
  end
  alias :check_warn :check_crit
  alias :check_ok :check_crit
end

class AllTrueProbe < Nagios::Probe
  def check_crit
    true
  end
  alias :check_warn :check_crit
  alias :check_ok :check_crit
end