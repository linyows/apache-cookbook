# Cookbook Name: apacheee
# Recipe: source

httpd_version = node['apacheee']['version']
apr_version = node['apacheee']['apr_version']
apr_util_version = node['apacheee']['apr_util_version']

cache_path = Chef::Config[:file_cache_path]

include_recipe 'build-essential::default'

%w(
  pcre-devel
  openssl-devel
).each { |name| package name }

remote_file "#{cache_path}/apr-#{apr_version}.tar.gz" do
  source "http://archive.apache.org/dist/apr/apr-#{apr_version}.tar.gz"
  action :create_if_missing
end

bash "expand apr-#{apr_version}" do
  not_if "test -d #{cache_path}/apr-#{apr_version}"
  code <<-CODE
    cd "#{cache_path}"
    tar xvf apr-#{apr_version}.tar.gz
  CODE
end

bash "install apr-#{apr_version}" do
  not_if 'test -f /usr/local/apr/lib/pkgconfig/apr-1.pc'
  code <<-CODE
    cd #{cache_path}/apr-#{apr_version}
    ./configure
    make && make install
  CODE
end

remote_file "#{cache_path}/apr-util-#{apr_util_version}.tar.gz" do
  source "http://archive.apache.org/dist/apr/apr-util-#{apr_util_version}.tar.gz"
  action :create_if_missing
end

bash "expand apr-util-#{apr_util_version}" do
  not_if "test -d #{cache_path}/apr-util-#{apr_util_version}"
  code <<-CODE
    cd "#{cache_path}"
    tar xvf apr-util-#{apr_util_version}.tar.gz
  CODE
end

bash "install apr-util-#{apr_util_version}" do
  not_if 'test -f /usr/local/apr/lib/pkgconfig/apr-util-1.pc'
  code <<-CODE
    cd #{cache_path}/apr-util-#{apr_util_version}
    ./configure --with-apr=/usr/local/apr
    make && make install
  CODE
end

remote_file "#{cache_path}/httpd-#{httpd_version}.tar.gz" do
  source "http://archive.apache.org/dist/httpd/httpd-#{httpd_version}.tar.gz"
  action :create_if_missing
end

bash "expand httpd-#{httpd_version}" do
  not_if "test -d #{cache_path}/httpd-#{httpd_version}"
  code <<-CODE
    cd "#{cache_path}"
    tar xvf httpd-#{httpd_version}.tar.gz
  CODE
end

template "#{cache_path}/httpd-#{httpd_version}/configure_with_options" do
  source 'httpd.configure_with_options.erb'
  mode '0755'
  cookbook node['apacheee']['configure_cookbook']
end

bash "install httpd-#{httpd_version}" do
  code <<-CODE
    cd #{cache_path}/httpd-#{httpd_version}
    ./configure_with_options
    make && make install
  CODE
  not_if "#{node['apacheee']['exec']}/bin/apachectl -v 2>&1 | grep -q #{httpd_version}"
end
