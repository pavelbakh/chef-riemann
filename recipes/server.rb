#
# Cookbook Name:: riemann
# Recipe:: server
#
# Copyright (C) 2015 SoftDirect Ltd
# Copyright (C) 2015 Pavel Bakhmetev
#
# All rights reserved - Do Not Redistribute
#

iptables_ng_rule 'riemann' do
  rule ["--protocol tcp --dport #{node['riemann']['server']['listen_port']} --match state --state NEW --jump ACCEPT",
        "--protocol udp --dport #{node['riemann']['server']['listen_port']} --match state --state NEW --jump ACCEPT",
        "--protocol tcp --dport #{node['riemann']['server']['websocket_port']} --match state --state NEW --jump ACCEPT",
        "--protocol udp --dport #{node['riemann']['server']['websocket_port']} --match state --state NEW --jump ACCEPT"]
end

user node['riemann']['server']['user'] do
  home node['riemann']['server']['home']
  shell "/bin/bash"
  system true
end

# Installs riemann package:
if platform?("redhat", "centos", "fedora", "amazon", "scientific")
  include_recipe "yum-epel"

  remote_file "/tmp/riemann-#{node[:riemann][:server][:version]}-1.noarch.rpm" do
    source "http://aphyr.com/riemann/riemann-#{node[:riemann][:server][:version]}-1.noarch.rpm"
    mode 0644
  end

#  gem_package "riemann-tools"
  yum_package "java-1.7.0-openjdk"
  yum_package "daemonize"

  package "riemann" do
    action :install
    source "/tmp/riemann-#{node[:riemann][:server][:version]}-1.noarch.rpm"
    provider Chef::Provider::Package::Rpm
  end

end

directory "/var/log/riemann/" do
  mode 0755
  owner node['riemann']['server']['user']
  group node['riemann']['server']['user']
  action :create
end

directory "/usr/lib/riemann" do
  mode 0775
  owner 'riemann'
  group 'riemann'
  action :create
end

service "riemann" do
  supports :restart => true
  action [:enable, :start]
end

template "/etc/riemann/riemann.config" do
  source "server/riemann.config.erb"
  owner "root"
  group "root"
  mode 0644

  notifies :restart, resources(:service => 'riemann')
  variables :bind_ip => node[:riemann][:server][:bind_ip]
end
