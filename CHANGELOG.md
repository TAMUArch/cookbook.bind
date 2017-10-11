# CHANGELOG for bind

## 2.2.0:

* Change default zone SOA serial to YYYYMMDDHH
* Add Ubuntu-16.04 as tested platform
* Have default recipe call databag recipe
* Reorganize how named.conf files are organized

## 2.1.0:

* Added default zones
* Added support for SLES
* Added support for ACLs
* Moved options into named.conf

## 2.0.3:

* fixed bug with reverse records not being complete

## 2.0.2:

* fixed formatting issue with db files

## 2.0.1:

* retain created serial number as an attribute

## 2.0.0:

* lots of cleanup
* fixed foodcritic issues
* added record parsing to zone lwrp
* added ability to do reverse dns creation
* automatic serial generation
* data bag has own recipe
* fixed minitest for Ubuntu

## 1.1.0:

* Added initial Centos/RHEL support
* Added minitest support

## 1.0.0:

* Added bind_zone lwrp
* Added test-kitchen support
* wrote up useful readme
* Changed the versioning scheme

## 13.3.0:

* Initial release of bind
