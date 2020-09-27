@echo off

call env.bat

docker-compose -f stack.yml stop
