nexus
=============

[![Build Status](https://travis-ci.org/hw-cookbooks/nexus.png?branch=master)](https://travis-ci.org/hw-cookbooks/nexus)

Quick Start
-----------


Attributes
----------

* `node['nexus']['option']` – Description of option. *(default: something)*

Resources
---------

### nexus

The `nexus` resource defines a something.

```ruby
nexus 'name' do
  option 'a'
end
```

* `option` – Description of option. *(default: node['nexus']['option'])*
