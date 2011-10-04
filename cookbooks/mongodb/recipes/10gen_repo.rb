#
# Cookbook Name:: mongodb
# Recipe:: 10gen_repo
#
# Copyright 2011, edelight GmbH
# Authors:
#       Miquel Torres <miquel.torres@edelight.de>
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

# Sets up the repositories for stable 10gen packages found here:
# http://www.mongodb.org/downloads#packages

cookbook_file "/tmp/mongodb-10gen_2.0.0_i386.deb" do
  source "mongodb-10gen_2.0.0_i386.deb"
end

dpkg_package "mongodb-10gen" do
  source "/tmp/mongodb-10gen_2.0.0_i386.deb"
end
