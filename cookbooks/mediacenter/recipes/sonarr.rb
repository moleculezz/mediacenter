#
# Cookbook Name:: mediacenter
# Recipe:: sonarr
#
# Copyright (c) 2016 G. Arends, All Rights Reserved.

include_recipe 'mediacenter::default'
include_recipe 'mediacenter::sabnzbdplus'

directory "#{node['mediacenter']['configs']}/sonarr" do
  owner node['mediacenter']['user']
  group node['mediacenter']['group']
  mode '0755'
  action :create
end

directory "#{node['mediacenter']['directory']}/downloads/sonarr" do
  owner node['mediacenter']['user']
  group node['mediacenter']['group']
  mode '0755'
  action :create
end

directory "#{node['mediacenter']['directory']}/media/tv" do
  owner node['mediacenter']['user']
  group node['mediacenter']['group']
  mode '0755'
  action :create
end

apt_repository 'sonarr' do
  uri 'http://apt.sonarr.tv'
  components ['main']
  distribution 'master'
  key 'FDA5DFFC'
  keyserver 'keyserver.ubuntu.com'
  action :add
end

package 'nzbdrone'

template '/lib/systemd/system/sonarr.service' do
  source 'sonarr.service.erb'
  owner 'root'
  group 'root'
  mode 0755
  variables :user => node['mediacenter']['user'], :group => node['mediacenter']['group'], :config => "#{node['mediacenter']['configs']}/sonarr"
end

service 'sonarr' do
  action [ :enable, :start, :restart ]
end
