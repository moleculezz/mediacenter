#
# Cookbook Name:: mediacenter
# Recipe:: kodi
#
# Copyright (c) 2016 G. Arends, All Rights Reserved.

include_recipe 'apt'
include_recipe 'mediacenter::default'

%w{python-software-properties software-properties-common
  xorg xserver-xorg-legacy alsa-utils lm-sensors libmpeg2-4
  vainfo dbus-x11 udisks2 openbox}.each do | pkg |
  package pkg
end

# Installed by Kodi if Kodi is installed first.
%w{mesa-utils libmad0 avahi-daemon
  libnfs8 }.each do | pkg |
  package pkg
end

# Already installed
# librtmp1
# libva1
# i965-va-driver
# linux-firmware

# Optional or not needed?
# %w{git-core lirc}.each do | pkg |
#   package pkg
# end

# lirc - Linux Infrared Remote Control

# configure X-Server

template "/etc/X11/Xwrapper.config" do
  source "Xwrapper.config.erb"
  variables({
     :allowed_users => node['mediacenter']['x11']['allowed_users'],
     :needs_root_rights => 'yes'
  })
end

template "/etc/polkit-1/localauthority/50-local.d/custom-actions.pkla" do
  source "custom-actions.pkla.erb"
  variables :user => node['mediacenter']['user']
end

# Should it be in /lib/systemd/system/kodi.service with symlink instead?
template '/etc/systemd/system/kodi.service' do
  source 'kodi.service.erb'
  owner 'root'
  group 'root'
  mode 0755
  variables :user => node['mediacenter']['user'], :group => node['mediacenter']['group']
end

# Allow kodi to prioritize threads.
ulimit_domain node['mediacenter']['user'] do
  rule do
    item :nice
    type '-'
    value -1
  end
end

# Fake display-manager.service to not make plymouth or something else complain.
link '/etc/systemd/system/display-manager.service' do
  to '/etc/systemd/system/kodi.service'
end

# Install Kodi
include_recipe 'kodi::default'

# As we use openbox as our display manager, we need to auto start kodi
directory '/home/kodi/.config/openbox' do
  owner node['mediacenter']['user']
  group node['mediacenter']['group']
  recursive true
end

template "/home/kodi/.config/openbox/autostart" do
  source "autostart.erb"
end

service 'kodi' do
  provider Chef::Provider::Service::Systemd
  action :start
end
