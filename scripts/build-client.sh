#!/bin/bash

ENV_CONFIGURATION="production"

# Installs dependencies
install() {
    npm i
}

# Starts a project
start() {
    ng serve
}

# Builds a project
build() {
    APP_ZIP=../dist/client-app.zip
    if [[ $1 == "prod" ]] || [[ $ENV_CONFIGURATION == "production" ]]; then
        if [[ -f $APP_ZIP ]]; then
            rm $APP_ZI
        fi
        echo -e "\033[32mRunning production build...\033[0m"
        ng build --aot=true --configuration production
        echo -e "\033[32mZipping dist folder...\033[0m"
        cd ./dist
        zip -r -m client-app.zip ../dist/app/*
    else
        ng build
    fi
}


# Runs tests
test() {
    ng test
}

# Runs lit
lint() {
    if [[ $1 == "format" ]]; then
        npx --no-install lint-staged && npx --no-install pretty-quick --staged
    else
        ng lint
    fi
}

help() {
	echo -e "\033[33m----------Help----------\033[0m"
	echo -e "\033[32minstall\033[0m - Installs dependencies"
	echo -e "\033[32mstart\033[0m - Starts a project"
	echo -e "\033[32mbuild\033[0m - Builds a project"
	echo -e "\033[32mtest\033[0m - Runs tests"
	echo -e "\033[32mlint\033[0m - Runs lit"
	echo -e "\033[33m------------------------\033[0m"
}

"$@"
