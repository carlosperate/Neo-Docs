# Get the sources

## Install git
Open a terminal and write:

``` bash
sudo apt-get update
sudo apt-get install git
```

## Get kernel sources
Create a develop folder

``` bash
mkdir udooneo-dev
cd udooneo-dev
```

get the sources:

``` bash
git clone https://github.com/UDOOboard/linux_kernel
```

Switch to the last kernel branch:

``` bash
cd linux_kernel
git checkout imx_3.14.28_1.0.0_ga_neo
git pull origin imx_3.14.28_1.0.0_ga_neo
```



