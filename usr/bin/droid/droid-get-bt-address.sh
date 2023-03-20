#!/bin/sh

cp $(/usr/bin/getprop ro.vendor.bt.bdaddr_path) /var/lib/bluetooth/board-address
