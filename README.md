Cooking from scratch
====================

We're going to start out by building our ideal system and then extract
the recipes from there.

Target system
-------------
* Ubuntu 11.04 Natty
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

Later, the recipe was getting stuck with adding the PPA repo so I
decided to include the `.deb` file.

The Unicorn cookbook is relatively simple so I vendored it as well:

    knife cookbook site vendor unicorn

The Rails cookbook was built from scratch. It includes configuration
for both nginx and unicorn. See `roles/chef-rails-mongo.rb` and
`data_bags/apps/chef-rails-mongo.json` for an
example role and data bag that will provide a working Rails app.

Deploy
------
Assuming a properly configured `knife.rb` and the proper keys for AWS
and Chef Server, you can simply run a command like this:

    knife ec2 server create --node-name chef-rails-mongo --groups single_instance_production --image ami-e2af508b --flavor m1.small --distro ubuntu11.04-apt --ssh-key ampms -i ~/.ec2/ampms -x ubuntu --environment production --run-list 'role[base],role[mongodb],role[chef-rails-mongo]'

Be sure you have an EC2 security group named
`single_instance_production` with ports 22 (SSH) and 80 (HTTP) opened.

Cleanup
-------
You can easily get rid of all those branches created by knife like so:

    git branch -D `git for-each-ref --format="%(refname:short)" refs/heads/chef-vendor\*`

TO-DO
-----
* Configure a monitoring service such as `bluepill` or Monit.
* Set up automated backup to S3
* Postfix or other mail service

