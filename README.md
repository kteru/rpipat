RPiPat - "Patlamp" for Raspberry Pi
===================================

Requirements
------------

  * Raspberry Pi (Model B)
  * Ruby (>= 2.0.0-p0)

Quick Start
-----------

  Raspberry Pi

  * connect a LED to gpio, GPIO23 & Ground.
  * connect a buzzer to gpio, GPIO24 & Ground.

  Start

    # cd /path/to/rpipat
    # gem install bundler --no-rdoc --no-ri
    # bundle install --path vendor/bundle
    # bundle exec ruby app.rb -e production -p 10000 -o 0.0.0.0 -s Puma

Remarks
-------

  This contains Twitter Boostrap library.

