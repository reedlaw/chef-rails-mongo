#
# Cookbook Name:: application
# Recipe:: unicorn 
#
# Copyright 2009, Opscode, Inc.
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

include_recipe "unicorn"

pid = ::File.join(app['deploy_to'], "shared", "pids", "unicorn.pid")

node.default[:unicorn][:worker_timeout] = 60
node.default[:unicorn][:preload_app] = true
node.default[:unicorn][:worker_processes] = [node[:cpu][:total].to_i * 4, 8].min
node.default[:unicorn][:before_fork] = %{
  old_pid = '#{pid}.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
}
node.default[:unicorn][:after_fork] = %{
  begin
    uid, gid = Process.euid, Process.egid
    user, group = 'nobody', 'nogroup'
    target_uid = 65534
    target_gid = 65534
    worker.tmp.chown(target_uid, target_gid)
    if uid != target_uid || gid != target_gid
      Process.initgroups(user, target_gid)
      Process::GID.change_privilege(target_gid)
      Process::UID.change_privilege(target_uid)
    end
  rescue => e
    if RAILS_ENV == 'development'
      STDERR.puts "couldn't change user, oh well"
    else
      raise e
    end
  end
}
node.default[:unicorn][:port] = '8080'
node.default[:unicorn][:stderr_path] = ::File.join(app['deploy_to'], "current", "log", "unicorn.log")
node.default[:unicorn][:stdout_path] = ::File.join(app['deploy_to'], "current", "log", "unicorn.log")
node.default[:unicorn][:pid] = ::File.join(app['deploy_to'], "shared", "pids", "unicorn.pid")
node.set[:unicorn][:options] = { :tcp_nodelay => true, :backlog => 100 }

unicorn_config "/etc/unicorn/#{app['id']}.rb" do
  listen({ node[:unicorn][:port] => node[:unicorn][:options] })
  working_directory ::File.join(app['deploy_to'], 'current')
  stderr_path node[:unicorn][:stderr_path]
  stdout_path node[:unicorn][:stdout_path]
  pid node[:unicorn][:pid] 
  worker_timeout node[:unicorn][:worker_timeout] 
  preload_app node[:unicorn][:preload_app] 
  worker_processes node[:unicorn][:worker_processes]
  before_fork node[:unicorn][:before_fork]
end

template "/etc/init/unicorn.conf" do
  source "unicorn-upstart.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
            :app_name => app['id'],
            :deploy_to => app['deploy_to']
  )
end

service "unicorn" do
  provider Chef::Provider::Service::Upstart
  enabled true
  running true
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
