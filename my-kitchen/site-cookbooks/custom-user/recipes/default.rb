#
# Cookbook Name:: custom-user
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Get encrypted data bag
user = Chef::EncryptedDataBagItem.load("users", 'shinyay2')
user_name = user['name']
password = user['password']
ssh_key = user['ssh_key']
home = "/home/#{user_name}"

# Create User 'shinyay2'
user user_name do
  password password
  home home
  shell "/bin/bash"
  supports :manage_home => true
end

# Add shinyay2 to 'wheel'group
group "wheel" do
  action [:modify]
  members [user_name]
  append true
end

# Create .ssh directory
directory "#{home}/.ssh" do
  owner user_name
  group user_name
end

# Create authorized_keys file
authorized_keys_file = "#{home}/.ssh/authorized_keys"
file authorized_keys_file do
  owner user_name
  mode 0600
  content '#{ssh_key} #{user_name}'
  not_if { ::File.exists?("#{authorized_keys_file}")}
end


# 1. bash_profile include用のディレクトリを作ります
directory "#{home}/.bash_profile_inc" do
  owner user_name
  group user_name
end

# 2.「base_profile.sh（静的ファイル）」をbash_profile include用のディレクトリに配置します
cookbook_file "#{home}/.bash_profile_inc/base_profile.sh" do
  source "base_profile.sh"
  mode 0644
  owner user_name
  group user_name
end

# 3. bash_profile本体に「.bash_profile_incディレクトリ以下のファイルを読み込む」ような処理を追加しています
script "include bash_profile" do
  environment 'HOME' => home
  user   user_name
  group  user_name
  interpreter "bash"
  not_if "grep -q 'bash_profile_include' #{home}/.bash_profile"
  flags  "-e"
  code <<-"EOH"
cat << EOF >> #{home}/.bash_profile 2>&1
# bash_profile_include
for file in \\`find ~/.bash_profile_inc -type f\\`; do
  source \\$file
done
EOF
  EOH
end
