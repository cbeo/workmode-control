
A CL script to juggle `/etc/hosts` based on the time of day.

To build with ecl:

`cd` into this directory, fire up ecl, and do:

    (compile-file "workmode.lisp" :output-file "workmode.o" :system-p t)
    (c::build-program "workmode_control" :lisp-files '("workmode.o"))

To "install" with cron, do 

    $ sudo crontab -e 
    
and add something like this to your crontab

    */5 * * * * /home/you/workmode/workmode_control 
    
to have the script run every 5 minutes. 

To "configure", create two files. An `/etc/hosts_worktime` which is
your blocklist, and `/etc/hosts_worktime_off` which is a copy of your
original hosts file. 

You can tweak the hours of operation by setting `+work-starts-hour+`
and `+work-stops-hour+`

I have used `ecl` to compile the script into a small stand-alone
executable (around 79k on my system).

If you want to change the workmode hours you must manually recompile
the script. I have not included a makefile either. This is to
discourage you (well, me) from frivilously "clocking out early".
