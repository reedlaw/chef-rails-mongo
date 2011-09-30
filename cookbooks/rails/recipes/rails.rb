#
# Cookbook Name:: rails
# Recipe:: rails
#
# Copyright 2011, Smashing Boxes
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

app = node.run_state[:current_app]
rails_env = (node.chef_environment =~ /_default/ ? "production" : node.chef_environment)
node.run_state[:rails_env] = rails_env

## First, install any application specific packages
if app['packages']
  app['packages'].each do |pkg,ver|
    package pkg do
      action :install
      version ver if ver && ver.length > 0
    end
  end
end

## Next, install any application specific gems
if app['gems']
  app['gems'].each do |gem,ver|
    gem_package gem do
      action :install
      version ver if ver && ver.length > 0
    end
  end
end

# We'll need this to install bundled gems
gem_package "bundler" do
  options("--no-rdoc --no-ri")
  action :install
end

directory app['deploy_to'] do
  owner "nobody"
  group "nogroup"
  mode '0755'
  recursive true
end

directory "#{app['deploy_to']}/shared" do
  owner "nobody"
  group "nogroup"
  mode '0755'
  recursive true
end

%w{ log pids system vendor_bundle }.each do |dir|

  directory "#{app['deploy_to']}/shared/#{dir}" do
    owner "nobody"
    group "nogroup"
    mode '0755'
    recursive true
  end

end

if app.has_key?("deploy_key")
  ruby_block "write_key" do
    block do
      f = ::File.open("#{app['deploy_to']}/id_deploy", "w")
      f.print(app["deploy_key"])
      f.close
    end
    not_if do ::File.exists?("#{app['deploy_to']}/id_deploy"); end
  end

  file "#{app['deploy_to']}/id_deploy" do
    owner "nobody"
    group "nogroup"
    mode '0600'
  end

  template "#{app['deploy_to']}/deploy-ssh-wrapper" do
    source "deploy-ssh-wrapper.erb"
    owner "nobody"
    group "nogroup"
    mode "0755"
    variables app.to_hash
  end
end


## Then, deploy
deploy_revision app['id'] do
  revision app['revision'][node.chef_environment]
  repository app['repository']
  user "nobody"
  group "nogroup"
  deploy_to app['deploy_to']
  environment 'RAILS_ENV' => rails_env
  action app['force'][node.chef_environment] ? :force_deploy : :deploy
  ssh_wrapper "#{app['deploy_to']}/deploy-ssh-wrapper" if app['deploy_key']
  shallow_clone true
  before_migrate do
    user "nobody"
    group "nogroup"
    link "#{release_path}/vendor/bundle" do
      to "#{app['deploy_to']}/shared/vendor_bundle"
    end
    common_groups = %w{development test cucumber staging production}
    execute "bundle install --local --deployment --without #{(common_groups -([node.chef_environment])).join(' ')}" do
      user "nobody"
      group "nogroup"
      ignore_failure true
      cwd release_path
    end
  end
  before_symlink do
    user "nobody"
    group "nogroup"
    execute "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  end
end
