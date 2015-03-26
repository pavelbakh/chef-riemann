#
# Cookbook Name:: riemann
# Recipe:: dashboard
#
# Copyright (C) 2015 SoftDirect Ltd
# Copyright (C) 2015 Pavel Bakhmetev
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'build-essential::default'

iptables_ng_rule 'riemann-dash' do
  rule ["--protocol tcp --dport #{node['riemann']['dashboard']['port']} --match state --state NEW --jump ACCEPT"]
end

user node['riemann']['dashboard']['user'] do
  home node['riemann']['dashboard']['home']
  shell "/bin/bash"
  system true
end

directory node['riemann']['dashboard']['home'] do
  user node['riemann']['dashboard']['user']
end

[ 'ruby', 'ruby-devel', 'rubygems' ].each do |pkg|
  package pkg do
    action :install
  end
end

gem_package 'bundler' do
  action :install
end

cookbook_file "#{node['riemann']['dashboard']['home']}/Gemfile" do
  source "dashboard/Gemfile"
  mode "0755"
end

template "/etc/init.d/riemann-dash" do
  source "dashboard/riemann-dash.erb"
  owner "root"
  group "root"
  mode "0711"
end

execute 'bundle install --path vendor/bundle' do
  cwd node['riemann']['dashboard']['home']
  user node['riemann']['dashboard']['user']
  not_if 'bundle check'
end

template "#{node['riemann']['dashboard']['home']}/config.yml" do
  source "dashboard/config.yml.erb"
  owner node['riemann']['dashboard']['user']
  mode '0644'
end

template "#{node['riemann']['dashboard']['home']}/config.ru" do
  source "dashboard/config.ru.erb"
  owner node['riemann']['dashboard']['user']
end

service "riemann-dash" do
  supports :restart => true, :start => true, :stop => true, :reload => false
  action [:enable, :start]
end
