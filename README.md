Buildr Eclipse Launch
=====================

This project extends [Apache Buildr]'s default [Eclipse] task to generate .launch configurations

Install
-------

To enable add the following in your `Gemfile`:

    gem "buildr-eclipse-launch", :git => "git://github.com/niclabs/buildr-eclipse-launch.git"

Then, run

    bundle install
    
Finally add the following at the top of your `buildfile`

    require 'buildr-eclipse-launch'
    
Usage
-----

To generate .launch files

    buildr eclipse


[Apache Buildr]: https://buildr.apache.org/
[Eclipse]: https://eclipse.org/downloads/