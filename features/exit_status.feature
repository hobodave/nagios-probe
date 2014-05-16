Feature: Exit Status
	In order to comply with official nagios-plugin development guidelines
	As a sysadmin building my own nagios-plugins
	I want the probe result converted into the corresponding exit status

	Scenario Outline: Critical, Warning and OK
		Given a file named "check_foo" with:
			"""
			require 'nagios-probe'
			class MyProbe < Nagios::Probe
	      def check_crit;		<crit> end
	      def check_warn;		<warn> end
	      def crit_message;	"Things are bad" end
	      def warn_message;	"Things aren't going well" end
	      def ok_message;		"Nothing to see here" end
	    end
			
			begin
	      options = {} # Nagios::Probe constructor accepts a single optional param that is assigned to @opts
	      probe = MyProbe.new(options)
	      probe.run
	    rescue Exception => e
	      puts "Unknown: " + e
	      exit Nagios::UNKNOWN
	    end

	    puts probe.message
	    exit probe.retval
			"""
		When I run `ruby check_foo`
		Then the exit status should be <exit>
		And the stdout should contain exactly:
			"""
			<stdout>
			
			"""
		Examples:
		 | crit  | warn  | exit | stdout                            |
		 | true  | true  | 2    | Critical: Things are bad          |
		 | true  | false | 2    | Critical: Things are bad          |
		 | false | true  | 1    | Warning: Things aren't going well |
		 | false | false | 0    | OK: Nothing to see here           |

	Scenario: Unknown when all checks are false
		Given a file named "check_bar" with:
			"""
			require 'nagios-probe'
			class MyProbe < Nagios::Probe
  		  def check_crit;		false end
  		  def check_warn;		false end
				def check_ok;			false end
  		end
			
			begin
  		  options = {} # Nagios::Probe constructor accepts a single optional param that is assigned to @opts
  		  probe = MyProbe.new(options)
  		  probe.run
  		rescue Exception => e
  		  puts "Unknown: " + e.to_s
  		  exit Nagios::UNKNOWN
  		end
  		
  		puts probe.message
  		exit probe.retval
			"""
		When I run `ruby check_bar`
		Then the exit status should be 3
		And the stdout should contain exactly:
			"""
			Unknown: crit? warn? and ok? all returned false
			
			"""
		
		