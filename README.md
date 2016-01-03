Netgear Readyshare Cookbook
===========================
[![Cookbook Version](https://img.shields.io/cookbook/v/netgear-readyshare.svg)][cookbook]
[![Build Status](https://img.shields.io/travis/RoboticCheese/netgear-readyshare-chef.svg)][travis]
[![Code Climate](https://img.shields.io/codeclimate/github/RoboticCheese/netgear-readyshare-chef.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/RoboticCheese/netgear-readyshare-chef.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/netgear-readyshare
[travis]: https://travis-ci.org/RoboticCheese/netgear-readyshare-chef
[codeclimate]: https://codeclimate.com/github/RoboticCheese/netgear-readyshare-chef
[coveralls]: https://coveralls.io/r/RoboticCheese/netgear-readyshare-chef

A Chef cookbook for installing Netgear's ReadySHARE tools for certain
USB-equipped Netgear routers.

Requirements
============

Just an OS X or Windows PC and a supported Netgear router and Chef 12.5 or
newer.

Usage
=====

Either add the default recipe to your run_list or use the provided resources in
a recipe in your own.

Recipes
=======

***default***

Installs Netgear ReadySHARE for USB printers (aka "Netgear USB Control Center"
on OS X).

Resources
=========

***netgear_readyshare_printer_app***

Install the Netgear ReadySHARE for USB printers app (aka "Netgear USB Control
Center" on OS X).

Syntax:

    netgear_readyshare_printer_app 'default' do
        action :install
    end

Actions:

| Action     | Description     |
|------------|-----------------|
| `:install` | Install the app |
| `:remove`  | Remove the app  |

Attributes:

| Attribute  | Default        | Description          |
|------------|----------------|----------------------|
| action     | `:install`     | Action(s) to perform |

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for the new feature; ensure they pass (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

License & Authors
=================
- Author: Jonathan Hartman <j@p4nt5.com>

Copyright 2015-2016 Jonathan Hartman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
