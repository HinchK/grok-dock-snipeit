#!/bin/bash
#isExistHttps = `pgrep httpd`
#if [[ -n  $isExistHttps ]]; then
#    service httpd stop
#fi
isExistHttps = `pgrep nginx`
if [[ -n  $isExistHttps ]]; then
    service nginx stop
fi
