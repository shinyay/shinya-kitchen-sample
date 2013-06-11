#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "nginx" do
  action :install
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

template "nginx.conf" do
  path "/etc/nginx/nginx.conf"
  source "nginx.conf.erb"
  owner node["nginx"]["user"]
  group node["nginx"]["group"]
  mode 0644
  notifies :reload, "service[nginx]"
end

directory "/etc/nginx/sites-enabled" do
  owner node["nginx"]["user"]
  owner node["nginx"]["group"]
  mode 0644
  action :create
end

template "default.conf" do
  path "/etc/nginx/sites-enabled/default.conf"
  source "sites-enabled.conf.erb"
  owner node["nginx"]["user"]
  group node["nginx"]["group"]
  mode 0644
  notifies :reload, "service[nginx]"
end

directory "/var/www" do
  owner node["user"]["name"]
  group node["user"]["group"]
  mode 0755
  action :create
end

#template "/etc/nginx/sites-enabled/default.conf" do
#  source "sites-enabled.conf.erb"
#  owner node["nginx"]["user"]
#  group node["nginx"]["group"]
#  mode 0644
#  notifies :reload, 'service[nginx]'
#end
