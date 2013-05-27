#
# Cookbook Name:: rbenv-custom
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install preconditon packages
%w{git gcc make readline-devel openssl-devel}.each do |pkg|
  package pkg do
    action :install
  end
end

# create rbenv group which can use rbenv
group "rbenv" do
  action :create
  members node['user']['name']
  append true
end

# checkout rbenv  from git
git node['user']['home'] + "/.rbenv" do
  user node['user']['name']
  group "rbenv"
  repository "git://github.com/sstephenson/rbenv.git"
  reference "master"
  action :checkout
end

# create directory for ruby-build plugin
directory node['user']['home'] + "/.rbenv" + "/plugins" do
  owner node['user']['name']
  group "rbenv"
  mode "0755"
  action :create
end

# checkout rbenv from git
git "/tmp/ruby-build" do
  repository "git://github.com/sstephenson/rbenv.git"
  reference "master"
  action :checkout
  user node['user']['name']
  group "rbenv"
end

# configure rbenv PATH
bash "rbenv" do
  user node['user']['name']
  group node['user']['group']
  cwd node['user']['home']
  environment "HOME" => node['user']['home']

  code <<-EOC
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    source ~/.bashrc
    rbenv install #{node['rbenv']['version']}
    rbenv global #{node['rbenv']['version']}
    rbenv versions
    rbenv rehash
  EOC

  not_if { File.exists?(node['user']['home'] + "/.rbenv/shims/ruby") }
end
