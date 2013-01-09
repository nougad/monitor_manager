

# MONITOR MANAGER

Monitor Manager is a web interface for the window manager.

This app was develop to controll wall panels remotly, and make it easy to play arround it.



# USAGE

    monitor_manager -p 8080


# INSTALL

This gem uses ruby-wmctrl ( the ruby bindings to talk to the X server ). To run
that, you will need some development libraries. In ubuntu you can run as root
the following command.

    apt-get install libx11-dev libglib2.0-dev libxmu-dev

Once you have that install with gem in **ruby 1.9**.

    gem install monitor_manager


**This will NOT work in ruby 1.8.**

# Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
