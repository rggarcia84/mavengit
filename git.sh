#!/bin/bash

if [ -e "/tmp/.ssh/id_rsa" ]; then
	cp /tmp/.ssh/id_rsa ~/.ssh/id_rsa
	chmod 400 ~/.ssh/id_rsa
fi

if [ ${DEBUG} = TRUE ]; then
	echo "Started GIT Client"
fi

if [ -d "${GIT_ROOT}/.git" ]; then
	
	if [ ${DEBUG} = TRUE ]; then
  	      echo "Repository already exists. Pulling instead of cloning"
	fi

	cd ${GIT_ROOT}
	git pull --all > /dev/null 2>&1
	exit $?
fi

if [ ${METHOD} = "http" ]; then
	CLONE_URL="https://${SERVICE}/${USERNAME}/${REPOSITORY}.git"
else
	CLONE_URL="git@${SERVICE}:${USERNAME}/${REPOSITORY}.git"
fi

if [ -z ${DEPTH} ]; then
	echo "No DEPTH value"
	exit 1
fi

if [ -z ${BRANCH} ]; then 
        echo "No BRANCH value"
        exit 1
fi

if [ ${DEBUG} = TRUE ]; then
	echo ${CLONE_URL}
	git clone --depth ${DEPTH} --branch ${BRANCH} ${CLONE_URL} ${GIT_ROOT} -vvv 2>&1
else
	git clone --depth ${DEPTH} --branch ${BRANCH} ${CLONE_URL} ${GIT_ROOT} > /dev/null 2>&1
fi

# Check if error.
if [ $? -ne 0 ]; then
	echo "Clone error"
	exit 1
fi

cd ${GIT_ROOT} > /dev/null 2>&1
git checkout ${SHA} > /dev/null 2>&1

# Check if error.
if [ $? -ne 0 ]; then
	echo "Checkout error";
        exit 1
fi

git reset ${SHA} > /dev/null 2>&1

# Check if error.
if [ $? -ne 0 ]; then
	echo "Reset error"
        exit 1
fi
