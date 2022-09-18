#!/bin/bash

# Runs tests
test() {
    echo -e "\033[32mRunning tests...\033[0m"
    ng test
}

# Runs lit
lint() {
    echo -e "\033[32mRunning lint...\033[0m"
    if [[ $1 == "format" ]]; then
        npx --no-install lint-staged && npx --no-install pretty-quick --staged
    else
        ng lint
    fi
}

# Installs ESLint and creates config file, runs ESLint
eslint() {
    echo -e "\033[32mInstalling ESLint...\033[0m"
    npm init @eslint/config
    echo -e "\033[32mRunning ESLint...\033[0m"
    npx eslint ./src/app/**
}

# Runs npm audit fix
npm_audit() {
    echo -e "\033[32mRunning npm audit...\033[0m"
    npm audit fix
}

npm_audit
lint
eslint
test

help() {
	echo -e "\033[33m----------Help----------\033[0m"
	echo -e "\033[32mtest\033[0m - Runs tests"
	echo -e "\033[32mlint\033[0m - Runs lit"
    echo -e "\033[32mnpm_audit\033[0m - Runs npm audit fix"
    echo -e "\033[32meslint\033[0m - Installs ESLint and creates config file, runs ESLint"
	echo -e "\033[33m------------------------\033[0m"
}

"$@"
