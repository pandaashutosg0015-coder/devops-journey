#!/bin/bash

# 1. Ask for user input
echo "Enter your name:"
read NAME

# 2. Greet the user
echo "Welcome to devops automation, $NAME!"

# 3. System checks
echo "--- Disk Space ---"
df -h

echo "--- Memory Usage ---"
free -h
