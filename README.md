Curathor
=======


Curathor is a simple, fast and nice looking RSS reader.

![Curathor Screenshot](https://user-images.githubusercontent.com/133809/192301669-ffc7f86e-ad0a-434d-9b76-219f41b62f4b.png)

Support
-------

Support is available to Curathor customers by emailing [support@feedbin.com](mailto:support@feedbin.com). This is also the best way to [submit feature requests](https://feedbin.com/help/making-a-feature-request/).

No support is provided for installing/running Curathor.

Introduction
------------

Curathor is a web based RSS reader. It provides a user interface for reading and managing feeds as well as a [REST-like API](https://github.com/feedbin/feedbin-api) for clients to connect to.

Curathor's goal is to be a great web-based RSS service. This goal is at odds with being a great self-hosted RSS reader. There are a lot of moving parts and things to configure, and for that reason I do not recommend that you run Curathor in production unless you have plenty of time to get it properly configured.

If you're looking for a self-hosted RSS reader check out:

- [yarr](https://github.com/nkanaev/yarr)
- [Tiny Tiny RSS](https://tt-rss.org)
- [Fresh RSS](https://freshrss.org)

And if you really want to run the whole Curathor stack, take a look at this [Docker version](https://github.com/angristan/feedbin-docker). If you would like to try Curathor out you can [sign up](https://feedbin.com/) for an account.

The main Curathor project is a [Rails 7](https://rubyonrails.org/) application. In addition to the main project there are several other services that provide additional functionality. None of these services are required to get Curathor running locally.

**Optional Extras**

 - [**Privacy Please:**](https://github.com/feedbin/privacy-please)
   Privacy Please is an https image proxy. In production Curathor is https only. One issue with https is all assets must be served over https as well or the browser will show insecure content warnings. Privacy Please proxies all image requests through an https enabled host to prevent this. Using a proxy has the added benefit of providing privacy while using Curathor.
 - [**extract:**](https://github.com/feedbin/extract)
   Extract is a Node.js service that extract content from web pages. It is used to extract the full content of an article when a feed only provide excerpts.
 - [**pigo:**](https://github.com/esimov/pigo/releases)
   pigo provides face detection for better [preview image cropping](https://feedbin.com/blog/2015/10/22/image-previews/). Make sure it's available in your PATH or provide a PIGO_PATH environment variable.

Requirements
------------

 - Linux or macOS
 - [Ruby 3.2](http://www.ruby-lang.org/en/)
 - [Postgres 11](http://www.postgresql.org/)
 - [Redis 6](http://redis.io/)
 - [Elasticsearch 8.5](https://www.elastic.co/downloads/past-releases/#elasticsearch)

Installation
-------------
First 

    git clone https://github.com/feedbin/feedbin.git
    cd feedbin

Inside the `server_scripts` folder, there is a file that installs all the necessary dependencies for the project. Executing this command you will install, postgres (+ pasword user), ruby and ruby on rails. After this command, the server will reboot.

    ./server-scripts/pre-fligth.sh

There are some credentials defined on the project. These are necesary to connect with the database. You can acces to this credentials using

    EDITOR="vi" rails credentials:edit

On this file you must put the same password defined on the `pre-fligth.sh`: 

    USER_PASSWORD_DB="CHANGE ME"

Finally for acces to `credentials:edit`, you must create inside the folder `config/` a `master.key` file. 

    touch master.key

Ask the admin to get this key.

**Configure**

Curathor uses environment variables for configuration. Curathor will run without most of these, but various features and functionality will be turned off.

Rename [.env.example](.env.example) to `.env` and customize it with your settings.

**Setup the database**

    rake db:setup

**Start the processes**

    bundle exec foreman start


Status Badges
-------------
![Ruby CI](https://github.com/feedbin/feedbin/workflows/Ruby%20CI/badge.svg)
