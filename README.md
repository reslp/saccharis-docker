# Saccharis-docker

This is a Docker container for the [Saccharis](https://github.com/DallasThomas/SACCHARIS) pipline to characterize CAZymes.


## Requirements

- Docker
- A local copy of the `cazy_extract.pl` script which contains an individual NCBI API. You can get one [here](https://www.ncbi.nlm.nih.gov/account/).


## Modifications to cazy_extract.pl

A description of what you have to do can also be found on the Saccharin Github page: https://github.com/DallasThomas/SACCHARIS

- Sign up for an NCBI account and get a personal API key.
- Change the lines 31-33 in your local `cazy_extract.pl` file according to the information from your NCBI account.
- When you run the container, bindmount the directory containing the modified `cazy_extract.pl` to your containers `/usr/local/external` directory.


## Run the saccharin container

In this example the folder where this command is executed contains a folder called `bin` which contains the modified `cazy_extract.pl` file.

```
$ docker run --rm -it -v $(pwd):/data -v $(pwd)/bin:/usr/local/external reslp/saccharis:1 Saccharis.pl -d /data -g characterized  -f GH5 -t 8
```
