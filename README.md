Cooking from scratch
====================

We're going to start out by building our ideal system and then extract
the recipes from there.

Target system
-------------
* Ubuntu 11.04
* Ruby 1.9.2-p290
* Nginx 1.0.6
* Mongodb 2.0.0
* Unicorn
* Rails 3.1

To install the latest ruby, it will help to have a `.deb` package
available. I followed the instructions
[here](http://threebrothers.org/brendan/blog/ruby-1-9-2-on-ubuntu-11-04/). I
also packaged `nginx 1.0.6` according to [these instructions](http://ubuntuforums.org/showthread.php?t=1105902).

I created the Ruby and Nginx cookbooks from scratch because they were
relatively easy. Mostly they just copy the cookbook file `.deb`
package to `/tmp` and then install.

For MongoDB, I used the Opscode community cookbook:

    knife cookbook site vendor mongodb

I had to modify it to work with Ubuntu's Upstart system. Wherever
there was a `service` block in the cookbook files I added this line
inside the block:

    provider Chef::Provider::Service::Upstart

The Unicorn cookbook is relatively simple so I vendored it as well:

    knife cookbook site vendor unicorn


Cleanup
-------
You can easily get rid of all those branches created by knife like so:

    git branch -D `git for-each-ref --format="%(refname:short)" refs/heads/chef-vendor\*`



