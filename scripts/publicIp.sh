#!/bin/bash
wget -q -O - http://checkip.dyndns.org | grep -Eo '\<[[:digit:]]{1,3}(\.[[:digit:]]{1,3}){3}\>'
