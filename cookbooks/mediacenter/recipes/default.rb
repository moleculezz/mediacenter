#
# Cookbook Name:: mediacenter
# Recipe:: default
#
# Copyright (c) 2016 G. Arends, All Rights Reserved.

include_recipe 'apt'

execute "Create Media Center User" do
  command "adduser --disabled-password --disabled-login --gecos '' #{node['mediacenter']['user']}"
  not_if "grep #{node['mediacenter']['user']} /etc/passwd", :user => node['mediacenter']['user']
end

# Add kodi user to required groups
groups = ['cdrom', 'audio', 'video', 'plugdev', 'users', 'dialout', 'dip', 'input', 'netdev']
groups.each do | grp |
  group grp do
    action :modify
    members node['mediacenter']['user']
    append true
  end
end

directory node['mediacenter']['directory'] do
  owner node['mediacenter']['user']
  group node['mediacenter']['group']
  mode '0755'
  action :create
end
