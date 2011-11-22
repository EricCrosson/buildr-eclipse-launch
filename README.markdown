Buildr Eclipse Launch
================

This project extends Buildr's default Eclipse task to generate .launch configurations

To enable add the following in your `Gemfile`:

    gem "buildr-eclipse-launch", :git => "git://github.com/niclabs/buildr-eclipse-launch.git"

Then, run

    bundle install
    
Finally add to the following at the top of your `buildfile`

    require 'buildr-eclipse-launch'


--
Mario Leyton

NIC Chile Research Labs
