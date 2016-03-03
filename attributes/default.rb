# Cookbook Name: apacheee
# Attribute: default

default['apacheee']['version']            = '2.4.18'
default['apacheee']['apr_version']        = '1.5.2'
default['apacheee']['apr_util_version']   = '1.5.4'
default['apacheee']['root']               = '/etc/httpd'
default['apacheee']['exec']               = '/usr'
default['apacheee']['user']               = 'httpd'
default['apacheee']['pid']                = '/var/run/httpd.pid'
default['apacheee']['log']                = '/var/log/httpd'
default['apacheee']['conf']               = '/etc/httpd/conf'
default['apacheee']['configure_cookbook'] = 'apacheee'
default['apacheee']['init_cookbook']      = 'apacheee'
default['apacheee']['logrotate_cookbook'] = 'apacheee'
