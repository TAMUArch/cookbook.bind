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

template ::File.join(node['bind']['dir'], 'named.conf') do
  source 'named.conf.erb'
  mode 0644
  owner 'root'
  group 'root'
  notifies :restart, "service[#{node['bind']['service']}]"
end

template ::File.join(node['bind']['db_dir'], 'named.conf.default-zones') do
  source 'named.conf.default-zones.erb'
  mode 0644
  owner 'root'
  group 'root'
end

%w(
  db.0
  db.127
  db.255
  db.local
  db.root
).each do |db|
  cookbook_file ::File.join(node['bind']['db_dir'], db) do
    source db
    owner 'root'
    group 'root'
    mode 0644
  end
end

service node['bind']['service'] do
  action [:enable, :start]
end
