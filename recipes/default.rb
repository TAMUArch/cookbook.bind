#
# Cookbook Name:: bind
# Recipe:: default
#
# Copyright 2013, Texas A&M
#
# All rights reserved - Do Not Redistribute
#

package node['bind']['package_name'] do
  action [:install]
end

template ::File.join(node['bind']['dir'], 'named.conf.options') do
  source 'named.conf.options.erb'
  mode 0644
  owner 'root'
  group 'root'
  notifies :restart, "service[#{node['bind']['service']}]"
end

service node['bind']['service'] do
  action [:enable, :start]
end
