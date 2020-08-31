# Webserver in Bash

This is a repo which provides a docker image which runs a bash-based webserver.

# Why?

Because [Go makes it too easy.](https://yourbasic.org/golang/http-server-example/)
Because Code As Art.
Because I can.

# What about security?

Don't run this in production. Or test. Or dev. 

# How do I use this?

Don't.

But if you really, really wanted to:

1. Build and push the docker image
2. Mount your file dir in `/var/www` on the docker image
3. Run the image, exposing port 80
4. Browse your new website

The Makefile provides commands:
- The `test` just checks that we can hit the webserver multiple times.
- The `run` will keep the webserver running.
