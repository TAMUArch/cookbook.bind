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

include_recipe 'bind::databag'

template ::File.join(node['bind']['dir'], 'named.conf') do
  source 'named.conf.erb'
  mode 0o0644
  owner 'root'
  group 'root'
  notifies :restart, "service[#{node['bind']['service']}]"
end

template ::File.join(node['bind']['db_dir'], 'named.conf.default-zones') do
  source 'named.conf.default-zones.erb'
  mode 0o0644
  owner 'root'
  group 'root'
  notifies :restart, "service[#{node['bind']['service']}]"
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
    mode 0o0644
  end
end

template "#{node['bind']['dir']}/named.conf.local" do
  source 'named.conf.local.erb'
  mode 0o0644
  group 'root'
  owner 'root'
  notifies :reload, "service[#{node['bind']['service']}]"
end

template "#{node['bind']['dir']}/named.conf.options" do
  source 'named.conf.options.erb'
  mode 0o0644
  group 'root'
  owner 'root'
  notifies :reload, "service[#{node['bind']['service']}]"
end

service node['bind']['service'] do
  action [:enable, :start]
end
