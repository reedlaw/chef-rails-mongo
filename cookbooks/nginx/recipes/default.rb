#
# Cookbook Name:: nginx
# Recipe:: default
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

%w{libgd2-noxpm libjpeg62 libxslt1.1}.each do |pkg|
  package pkg do
    action :install
  end
end

cookbook_file "/tmp/nginx-common_1.0.6-0ubuntu1_all.deb" do
  source "nginx-common_1.0.6-0ubuntu1_all.deb"
end

dpkg_package "nginx-common" do
  source "/tmp/nginx-common_1.0.6-0ubuntu1_all.deb"
end

cookbook_file "/tmp/nginx-full_1.0.6-0ubuntu1_i386.deb" do
  source "nginx-full_1.0.6-0ubuntu1_i386.deb"
end

dpkg_package "nginx-full" do
  source "/tmp/nginx-full_1.0.6-0ubuntu1_i386.deb"
end

%w{nxensite nxdissite}.each do |nxscript|
  template "/usr/sbin/#{nxscript}" do
    source "#{nxscript}.erb"
    mode 0755
    owner "root"
    group "root"
  end
end

template "nginx.conf" do
  path "/etc/nginx/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
