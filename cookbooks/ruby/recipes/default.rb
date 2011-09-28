#
# Cookbook Name:: ruby
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

cookbook_file "/tmp/ruby1.9.2_1.9.2-p290-1_i386.deb" do
  source "ruby1.9.2_1.9.2-p290-1_i386.deb"
end

dpkg_package "ruby" do
  source "/tmp/ruby1.9.2_1.9.2-p290-1_i386.deb"
end

link "/usr/bin/ruby" do
  action :delete
  only_if "test -L /usr/bin/ruby"
end

link "/usr/bin/ruby" do
  to "/usr/bin/ruby1.9.2"
end

