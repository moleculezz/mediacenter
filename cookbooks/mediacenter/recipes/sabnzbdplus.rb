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

directory "#{node['mediacenter']['directory']}/downloads/complete" do
  owner node['mediacenter']['user']
  group node['mediacenter']['group']
  mode '0755'
  action :create
end

directory "#{node['mediacenter']['configs']}/sabnzbdplus" do
  owner node['mediacenter']['user']
  group node['mediacenter']['group']
  mode '0755'
  action :create
end

apt_repository 'sabnzbdplus' do
  uri 'ppa:jcfp/nobetas'
  distribution node['lsb']['codename']
end

apt_repository 'sabnzbdplus-addons' do
    uri 'ppa:jcfp/sab-addons'
    distribution node['lsb']['codename']
end

package %w(sabnzbdplus python-sabyenc)

template '/etc/default/sabnzbdplus' do
  source 'sabnzbdplus.default.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables :user => node['mediacenter']['user'], :port => node['mediacenter']['sabnzbdplus_port'], :config => "#{node['mediacenter']['configs']}/sabnzbdplus"
end

service 'sabnzbdplus' do
  action [ :enable, :start, :restart ]
end
