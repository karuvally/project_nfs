#!/usr/bin/env python3
# VM-Manage, v0.1
# Copyright 2018, Aswin Babu Karuvally

# import serious stuff
import argparse
import os


# manage VMs
def manage_vm(operation, config_data):
    pass


# read configuration file
def read_config(config_file_path):
    pass


# the main function
def main():
    # essential variables
    config_file_path = '/home/' + os.getlogin() + '/.config/vm_manage.conf'

    # read and parse config file
    config_data = read_config(config_file_path)

    # prepare rsa key if required

    # setup the arguments
    parser = argparse.ArgumentParser(description=
    'VM-Manage v0.1, manage VBox VMs scattered across systems')

    parser.add_argument('operation', choices=['start', 'stop'],
    help='choose whether to start or stop VMs')

    # parse arguments, pass to function
    arguments = parser.parse_args()
    manage_vm(arguments.operation, config_data)

    # read list of VMs from file
    # copy ssh keys
    # perform action based on argument


# run the main function
main()
