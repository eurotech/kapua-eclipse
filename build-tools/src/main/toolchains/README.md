# Pre-configured Maven toolchain configurations

Maven uses [toolchains](https://maven.apache.org/guides/mini/guide-using-toolchains.html) in order to manage different JDK versions during build time.

As those toolchains reference local directories, those file can look different for each local system setup.

This directory contains a few pre-configured toolchains for well known configurations. You can either use
those directly or create a new toolchain file which works for you.

## Fedora/RHEL/CentOS

- `fedora-rhel-centos.xml`

This file is for Fedora/RHEL/CentOS based distributions. In order to install required JDKs issue
the following commands with root privileges:

    yum install java-1.8.0-openjdk-devel java-11-openjdk-devel

Or (when using `dnf` instead of `yum`):

    dnf install java-1.8.0-openjdk-devel java-11-openjdk-devel

Open the file, modify the jdk path in order to match your machine configuration, and then copy this file to `~/.m2/toolchains.xml` to use it.

## Ubuntu

- `ubuntu.xml`

This file is for Ubuntu based distributions. In order to install required JDKs issue
the following commands with root privileges:

    apt install openjdk-11-jdk
    apt install openjdk-8-jdk

## MacOS

- `macos.xml`

This file is for MacOS based distributions. In order to install required JDKs issue
the following commands with root privileges:

    brew install openjdk@8 openjdk@11 openjdk@17

Open the file, modify the jdk path in order to match your machine configuration, and then copy this file to `~/.m2/toolchains.xml` to use it.