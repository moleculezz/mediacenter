#
# Cookbook Name:: mediacenter
# Recipe:: sabnzbdplus
#
# Copyright (c) 2016 G. Arends, All Rights Reserved.

include_recipe 'mediacenter::default'

directory "#{node['mediacenter']['directory']}/downloads" do
  owner node['mediacenter']['user']
  group node['mediacenter']['group']
  mode '0755'
  action :create
end

apt_repository 'sabnzbdplus' do
  uri 'ppa:jcfp/nobetas'
  distribution node['lsb']['codename']
end

package 'sabnzbdplus'

template '/etc/default/sabnzbdplus' do
  source 'sabnzbdplus.default.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables :user => node['mediacenter']['user'], :port => node['mediacenter']['sabnzbdplus_port']
end

service 'sabnzbdplus' do
  action [ :enable, :start, :restart ]
end
