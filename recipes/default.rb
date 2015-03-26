#
# Cookbook Name:: riemann
# Recipe:: default
#
# Copyright (C) 2015 SoftDirect Ltd
# Copyright (C) 2015 Pavel Bakhmetev
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'iptables-ng'

iptables_ng_rule 'ssh' do
  rule '--protocol tcp --dport 22 --match state --state NEW --jump ACCEPT'
end

include_recipe 'riemann::server'
#include_recipe 'riemann::dashboard'
