nagios-rb
=========

A compact framework for writing [Nagios](http://www.nagios.org/) plugins.

Quick Start
===========

Subclass `Nagios::Plugin`, and define three methods:

 * **measure** - returns the measured value, and optionally sets `@stats` for later usage.

 * **critical** - for any given *n*, returns whether in critical state.

 * **warning** - for any given *n*, returns whether in warning state.

Optional methods:

 * **critical_msg** - Message to be used during a critical state.

 * **warning_msg** - Message to be used during a warning state.

 * **ok_msg** - Message to be used during an OK state.

Example Plugin
==============

In this trivial example, the plugin always measures 2, which is below both the warning and critical thresholds.  If critical status is reached, the custom `critical_msg` method is called; otherwise, the fallback message is just the measured value.

    require 'rubygems'
    require 'nagios'

    class FooPlugin < Nagios::Plugin
      def critical(n)
        n > 5
      end
    
      def critical_msg(n)
        "OH NOES!!! THE VALUE IS #{n}"
      end
    
      def warning(n)
        n > 3
      end
    
      def measure
        2
      end
    end

    FooPlugin.new.run!

Future Work
===========

Lots.