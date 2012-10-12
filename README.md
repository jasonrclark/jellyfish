# Jellyfish

by Lin Jen-Shin ([godfat](http://godfat.org))

## LINKS:

* [github](https://github.com/godfat/jellyfish)
* [rubygems](https://rubygems.org/gems/jellyfish)
* [rdoc](http://rdoc.info/github/godfat/jellyfish)

## DESCRIPTION:

Pico web framework for building API-centric web applications, either
Rack applications or Rack middlewares. Under 200 lines of code.

## DESIGN:

* Learn the HTTP way instead of using some pointless helpers
* Learn the Rack way instead of wrapping Rack functionalities, again
* Learn regular expression for routes instead of custom syntax
* Embrace simplicity over convenience
* Don't make things complicated only for _some_ convenience, but
  _great_ convenience, or simply stay simple for simplicity.

## FEATURES:

* Minimal
* Simple
* No templates
* No ORM
* No `dup` in `call`
* Regular expression routes, e.g. `get %r{/(\d+)}`
* String routes, e.g. `get '/'`
* Build for either Rack applications or Rack middlewares

## WHY?

Because Sinatra is too complex and inconsistent for me.

## REQUIREMENTS:

* Tested with MRI (official CRuby) 1.9.3, Rubinius and JRuby.

## INSTALLATION:

    gem install jellyfish

## SYNOPSIS:

### Hello Jellyfish, your lovely config.ru

``` ruby
require 'jellyfish'
class Tank
  include Jellyfish
  get '/' do
    "Jelly Kelly\n"
  end
end
use Rack::ContentLength
run Tank.new
```

### Regular expression routes

``` ruby
require 'jellyfish'
class Tank
  include Jellyfish
  get %r{^/(?<id>\d+)$} do |match|
    "Jelly ##{match[:id]}\n"
  end
end
use Rack::ContentLength
run Tank.new
```

### Different HTTP status and custom headers

``` ruby
require 'jellyfish'
class Tank
  include Jellyfish
  post '/' do
    headers       'X-Jellyfish-Life' => '100'
    headers_merge 'X-Jellyfish-Mana' => '200'
    body "Jellyfish 100/200\n"
    status 201
    'return is ignored in this case'
  end
end
use Rack::ContentLength
run Tank.new
```

### Redirect helper

``` ruby
require 'jellyfish'
class Tank
  include Jellyfish
  get '/lookup' do
    found "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}/"
  end
end
use Rack::ContentLength
run Tank.new
```

### Crash-proof

``` ruby
require 'jellyfish'
class Tank
  include Jellyfish
  get '/crash' do
    raise 'crash'
  end
end
use Rack::ContentLength
run Tank.new
```

### Custom error handler

``` ruby
require 'jellyfish'
class Tank
  include Jellyfish
  handle NameError do |e|
    status 403
    "No one hears you: #{e.backtrace.first}\n"
  end
  get '/yell' do
    yell
  end
end
use Rack::ContentLength
run Tank.new
```

### Jellyfish as a middleware

``` ruby
require 'jellyfish'
class Heater
  include Jellyfish
  get '/status' do
    "30\u{2103}\n"
  end
end

class Tank
  include Jellyfish
  get '/' do
    "Jelly Kelly\n"
  end
end

use Rack::ContentLength
use Heater
run Tank.new
```

### One huge tank

``` ruby
require 'jellyfish'
class Heater
  include Jellyfish
  get '/status' do
    "30\u{2103}\n"
  end
end

class Tank
  include Jellyfish
  get '/' do
    "Jelly Kelly\n"
  end
end

HugeTank = Rack::Builder.new do
  use Rack::ContentLength
  use Heater
  run Tank.new
end

run HugeTank
```

### Raise exceptions

``` ruby
require 'jellyfish'
class Protector
  include Jellyfish
  handle Exception do |e|
    "Protected: #{e}\n"
  end
end

class Tank
  include Jellyfish
  handle_exceptions false # default is true, setting false here would make
                          # the outside Protector handle the exception
  get '/' do
    raise "Oops, tank broken"
  end
end

use Rack::ContentLength
use Protector
run Tank.new
```

## CONTRIBUTORS:

* Lin Jen-Shin (@godfat)

## LICENSE:

Apache License 2.0

Copyright (c) 2012, Lin Jen-Shin (godfat)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
