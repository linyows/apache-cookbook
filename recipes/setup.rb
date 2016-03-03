# Cookbook Name: apacheee
# Recipe: setup

if node['platform_family'] == 'rhel' && node['platform_version'].to_i >= 7
  execute 'systemctl daemon-reload for httpd' do
    command 'systemctl daemon-reload'
    action :nothing
  end

  template '/usr/lib/systemd/system/httpd.service' do
    source 'systemd.httpd.service.erb'
    owner 'root'
    group node['root_group']
    mode '0755'
    cookbook node['apacheee']['systemd_cookbook']
    notifies :run, 'execute[systemctl daemon-reload for httpd]'
  end
else
  template '/etc/init.d/httpd' do
    source 'sysvinit.httpd.erb'
    owner 'root'
    group node['root_group']
    mode '0755'
    cookbook node['apacheee']['sysvinit_cookbook']
  end
end

template '/etc/sysconfig/httpd' do
  source 'sysconfig.httpd.erb'
  owner 'root'
  group 'root'
  mode '0644'
  cookbook node['apacheee']['sysconfig_cookbook']
  notifies :restart, 'service[httpd]'
end

user node['apacheee']['user'] do
  system true
  shell '/bin/false'
  home '/var/www'
end

template '/etc/logrotate.d/httpd' do
  source 'logrotate.httpd.erb'
  owner  'root'
  group  node['root_group']
  mode   '0644'
  cookbook node['apacheee']['logrotate_cookbook']
end
