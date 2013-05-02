Bind Cookbook
=============
This cookbook is to install and configure the bind9 service. It is currently a
work in progress and is subject to major changes. The idea behind
this cookbook is to use with the TAMUArch dhcp cookbook and data bags so 
you only have to edit records once for both dhcp and dns.

Requirements
------------
Most testing of this cookbook is done with Ubuntu 12.04 but this cookbook 
should work with later and earlier versions of Ubuntu.  

#### packages
- `bind9` - bind9 is the currently used bind version.

Attributes
----------
#### bind::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['bind']['soa']</tt></td>
    <td>String</td>
    <td>Start of Authority Record</td>
    <td><tt>node[:fqdn]</tt></td>
  </tr>
  <tr>
    <td><tt>['bind']['soa_email']</tt></td>
    <td>String</td>
    <td>Start of Authority Record Email</td>
    <td><tt>root.#{node[:fqdn]}</tt></td>
  </tr>
  <tr>
    <td><tt>['bind']['ttl']</tt></td>
    <td>String</td>
    <td>default zone duration of record cache</td>
    <td><tt>604800</tt></td>
  </tr> 
  <tr>
    <td><tt>['bind']['refresh']</tt></td>
    <td>String</td>
    <td>default zone refresh interval</td>
    <td><tt>604800</tt></td>
  </tr>
  <tr>
    <td><tt>['bind']['retry']</tt></td>
    <td>String</td>
    <td>default zone retry interval</td>
    <td><tt>86400</tt></td>
  </tr>
  <tr>
    <td><tt>['bind']['expire']</tt></td>
    <td>String</td>
    <td>default zone expire intervals</td>
    <td><tt>2419200</tt></td>
  </tr>
</table>

Resources/Providers
-------------------
# bind_zone
#### Actions
- :create: creates the zone
- :delete: deletes the zone

#### Attribute Parameters
- zone_name: name attribute. the name of the zone
- nameservers: array of nameservers to use in the zone
- records: a hash of records for the zone
- refresh_time: zone refresh interval
- retry_time: zone retry iterval
- expire_time: zone expire interval
- cache_minimum: zone cache interval
- serial: custom serial to be used for the zone 


Usage
-----
#### bind::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `bind` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[bind]"
  ]
}
```

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Jim Rosser 
