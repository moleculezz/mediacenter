#
# Cookbook Name:: mediacenter
# Recipe:: couchpotato
#
# Copyright (c) 2016 G. Arends, All Rights Reserved.

include_recipe 'mediacenter::default'
include_recipe 'mediacenter::sabnzbdplus'

%w{git python-lxml python-pip}.each do | pkg |
  package pkg
end

python_package 'pyopenssl' do
  action :install
  options "--cache-dir '/tmp/.pipcache'"
end

directory "#{node['mediacenter']['directory']}/downloads/complete/movies" do
  owner node['mediacenter']['user']
  group node['mediacenter']['group']
  mode '0755'
  action :create
end

directory "#{node['mediacenter']['directory']}/media/movies" do
  owner node['mediacenter']['user']
  group node['mediacenter']['group']
  mode '0755'
  action :create
end

# Create the directory first because git doesn't allow me to clone inside a directory which is owned by root.
directory "/opt/couchpotato" do
  owner node['mediacenter']['user']
  group node['mediacenter']['group']
  mode '0755'
  action :create
end

git '/opt/couchpotato' do
  repository 'https://github.com/CouchPotato/CouchPotatoServer.git'
  action :checkout
  revision 'master'
  user node['mediacenter']['user']
  group node['mediacenter']['group']
end

template '/lib/systemd/system/couchpotato.service' do
  source 'couchpotato.service.erb'
  owner 'root'
  group 'root'
  mode 0755
  variables :user => node['mediacenter']['user'], :group => node['mediacenter']['group'], :config => "#{node['mediacenter']['configs']}/sonarr"
end

service 'couchpotato' do
  action [ :enable, :start, :restart ]
end

git "#{node['mediacenter']['configs']}/nzbtomedia" do
  repository 'https://github.com/clinton-hall/nzbToMedia.git'
  action :checkout
  revision 'master'
  user node['mediacenter']['user']
  group node['mediacenter']['group']
end
