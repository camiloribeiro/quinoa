quinoa
=====

[![Gem Version](https://badge.fury.io/rb/quinoa.png)](http://badge.fury.io/rb/quinoa)
[![Build Status](https://travis-ci.org/camiloribeiro/quinoa.png?branch=master)](https://travis-ci.org/camiloribeiro/quinoa)
[![Code Climate](https://codeclimate.com/github/camiloribeiro/quinoa.png)](https://codeclimate.com/github/camiloribeiro/quinoa)
[![Dependency Status](https://gemnasium.com/camiloribeiro/quinoa.png)](https://gemnasium.com/camiloribeiro/quinoa)
[![Coverage Status](https://coveralls.io/repos/camiloribeiro/quinoa/badge.png)](https://coveralls.io/r/camiloribeiro/quinoa)
[![endorse](https://api.coderwall.com/camiloribeiro/endorsecount.png)](https://coderwall.com/camiloribeiro)

![alt tag](http://i.huffpost.com/gen/1821327/images/n-QUINOA-large570.jpg)

Quinoa is a service-object model framework built on top of rest-client (https://github.com/rest-client/rest-client). 
The idea is to define a rest endpoint and some details about it only once, and than reuse it with different payloads or properties.

For example, if I want to define a rest endpoint for the url http://www.camiloribeiro.com with the content-type application/json and send two different body payloads, I could do it like this:

      camilo_test = Quinoa::Service.new "http://camiloribeiro.com"
      camilo_test.content_type = "application/json"

      camilo_test.body = '{ "foo":"bar"}'
      result1 = camilo_test.post!

      camilo_test.body = '{ "bar":"foo"}'
      result2 = camilo_test.post!

Now if I want to change and use another endpoint in the same url, I can do something like this:

      camilo_test.path = /new_endpoint
      result3 = camilo_test.get!

To read the response it is as easy as setting the initial data:

      result1.response_content_type
      => "application/json"

      result2.response_body
      => "{ "some":"body"}


LICENSE
=======

Copyright 2015 Camilo Ribeiro camilo@camiloribeiro.com

This file is part of Quinoa.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
