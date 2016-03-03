# Cookbook Name: apacheee
# Recipe: default

include_recipe 'apacheee::source'
include_recipe 'apacheee::setup'

service 'httpd' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end
