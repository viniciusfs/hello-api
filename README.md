# Hello API

An really cool greetings API.


## Running

    $ pip install -r requeriments.txt
    $ python hello.py


## Testing

    $ curl -s http://localhost:5000/api/v1/hello
    $ curl -s -H "content-type: application/json" -d '{"name":"muxiCLOUD"}' http://localhost:5000/api/v1/hello
