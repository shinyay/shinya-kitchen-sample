#
# Cookbook Name:: tinkerer
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "python"

python_pip "tinkerer" do
  action :install
end
