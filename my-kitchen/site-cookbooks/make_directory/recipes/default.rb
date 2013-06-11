#
# Cookbook Name:: make_directory
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
directory "/home/#{node.user.name}/work" do
  owner node["user"]["name"]
  group node["user"]["group"]
  recursive true
  mode 0755
  action :create
  not_if { File.exists? "/home/#{node.user.name}/work"  }
end
