default['mediacenter']['user'] = 'kodi'
default['mediacenter']['group'] = 'kodi'
default['mediacenter']['directory'] = '/srv'
default['mediacenter']['configs'] = "/home/#{node['mediacenter']['user']}/.config"
default['mediacenter']['x11']['allowed_users'] = "anybody"
default['mediacenter']['sabnzbdplus_port'] = '8081'
