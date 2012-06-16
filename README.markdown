# Ruby Wrapper for BlueBoxGroup API

This ruby library consumes the BlueBoxGroup APIs.

Currently supported:

 - [Load Balancing](https://boxpanel.bluebox.net/public/the_vault/index.php/Load_Balancing_API)
 - [Servers](https://boxpanel.bluebox.net/public/the_vault/index.php/Servers_API)

## Example Usage

You need to specify your `BBG_API_KEY` in your environment first.

```bash
    $ export BBG_API_KEY=123456:abcdefg
```

Where `123456` is your customer id and `abcdefg` is your api key. See
the [Optain your api
key](https://boxpanel.bluebox.net/public/the_vault/index.php/Load_Balancing_API#Step_1:_Obtain_your_API_Key)
section for more information.

Then load up the API in irb:

```irb
 $ irb -r './lib/boxcutter'
 1.9.3p194 :001 > apps = Boxcutter::LoadBalancer::Application.all
  => [#<Application id:'88888888-cccc-4444-8888-dddddddddddd' name:'example.com' ip_v4:'192.168.1.1' ip_v6:'::1'>]
```

Command-line script to remove a machine from a load balancer.

```bash
    $ ./bin/remove_machine.rb -h
    Options:
       --backend, -b <s>:   Service backend name (default: default)
       --hostname, -n <s>:  Machine hostname to remove
       --dryrun, -d:        Don't actually remove the server from the backend
       --help, -h:          Show this message
```

Command-line script to add a machine to a load balancer. This script
assumes you have two services, one for http and one for https. It will
add the machine to each service, but with the port set to 80.

```bash
    $ ./bin/add_machine.rb -h
    Options:
       --backend, -b <s>:   Service backend name (default: default)
       --hostname, -n <s>:  Machine hostname to remove
       --dryrun, -d:        Don't actually remove the server from the backend
       --help, -h:          Show this message
```

This is definately a work in progress. The goal is to use this wrapper
to add and remove servers from the load balancer during a deploy for
zero downtime.

## License

(The MIT License)

Copyright © 2012 Donald Plummer

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
‘Software’), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
