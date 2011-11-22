Buildr Eclipse Launch
================

This project extends Buildr's default Eclipse task to generate .launch configurations

-   *adkintun:commons* 
    Common code for other modules.

-   *adkintun:control*   
    Controler daemon in charge of dispatching tasks to clients.

-   *adkintun:proxy*  
    Proxy daemon provides an HTTP interface for [RabbitMQ](http://www.rabbitmq.com/)  queues.

-   *adkintun:bwserver*  
    BWServer daemon provides an HTTP server for Bandwidth Measurements.


Getting Started
---------------

-   You must have Apache Buildr installed on your system. 
    [Apache Buildr](http://buildr.apache.org)

-   You should have Bundler installed on your system 
    [Gem Bundler](http://gembundler.com)

-   Install project required gems
    -   `$ bundle install`

    -   `./buildfile` provides the Buildr definitions for this project

    -   `./profiles.yaml` provides users, development, testing and production configurations.

    -   Classes and packages are generated into in `sub-project/target` dir.

    -   To generate eclipse poject files (`.classpath` and `.project`) 
        `$ buildr eclipse`

    -   To generate eclipse libs (`lib/eclipse_libss`) 
        `$ buildr eclipse_libss`

    -   To generate NetBeans `nblibraries.properties` file 
        `$ buildr netbeans`


Quick References
----------------

-   Build all sub-projects 
    `$ buildr`

-   Disable testing 
    `$ buildr test=no`

-   Build only specific sub-projects 
    `$ buildr adkintun:[commons|control|proxy|bwserver]`

-   Package a sub-project 
    `$ buildr adkintun:[commons|control|proxy|bwserver]:package`

-   To run control or proxy with name in {development, test, production} 
    `$ buildr adkintun:[control|proxy|bwserver]:run -e [name]`

-   To download dependencies sources
    `$ buildr artifacts:sources`

-   Further help on buildr 
    `$ buildr help`


Versioning Scheme
-----------------

The current version is 2.2.0

Any software release must be versioned according to the following scheme:

>    *Major.Minor.Release*

Where 

-   *Major* is an Integer,

-   *Minor* is an Integer, and 

-   *Release* is an Integer which represents one of the following:

    - 0 for alpha (status)
    - 1 for beta (status)
    - 2 for release candidate
    - 3 for (final) release
    - +4 for bugfixes


--
Mario Leyton

NIC Chile Research Labs
