require 'helper'

class TestNagiosProbe < Test::Unit::TestCase
  context "A probe" do
    setup do
      @crit = CriticalProbe.new
      @warn = WarnProbe.new
      @ok = OKProbe.new
    end

    should "have retval of 2 when critical" do
      @crit.run
      assert_equal 2, @crit.retval
    end

    should "have retval of 1 when warn" do
      @warn.run
      assert_equal 1, @warn.retval
    end

    should "have retval of 0 when OK" do
      @ok.run
      assert_equal 0, @ok.retval
    end

    should "return default message when no user overrides are defined" do
      @crit.run
      @warn.run
      @ok.run
      assert_equal "Critical: Default message - override crit_message.", @crit.message
      assert_equal "Warning: Default message - override warn_message.", @warn.message
      assert_equal "OK: Default message - override ok_message.", @ok.message
    end

    should "throw exception when all valid statuses are false (Critical, Warning, OK)" do
      @bad = BadProbe.new
      assert_raise RuntimeError do
        @bad.run
      end
    end
  end
end
