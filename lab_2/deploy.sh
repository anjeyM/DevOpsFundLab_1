# cat /tmp/check_connectivity.sh
#!/bin/bash
source .env

# Build server
cd ./server
npm run build

if [[ -f $APP_SERVER_ZIP_PATH ]]; then
    rm $APP_SERVER_ZIP_PATH
fi

echo -e "\033[32mZipping server dist folder...\033[0m"
cd ./dist
zip -r server-app.zip . -i *

# Build Client
cd ../../client
npm run build

if [[ -f $APP_CLIENT_ZIP_PATH ]]; then
    rm $APP_CLIENT_ZIP_PATH
fi

echo -e "\033[32mZipping client dist folder...\033[0m"
cd ./dist/app
zip -r client-app.zip . -i *

# Checking server connection
timeout $CONNECT_TIMEOUT bash -c "</dev/tcp/$SERVER/$PORT"
if [ $? == 0 ];then
    echo "SSH Connection to $SERVER over port $PORT is possible"

    cd ../../../
    echo -e "\033[32mCopying server dist folder + package.json...\033[0m"
    scp -C -r -P $PORT $APP_SERVER_DIST $SERVER:/var/app
    scp -C -P $PORT ./server/package.json $SERVER:/var/app

    echo -e "\033[32mCopying client dist folder...\033[0m"
    scp -C -P $PORT $APP_CLIENT_DIST $SERVER:/var/www
else
   echo "SSH connection to $SERVER over port $PORT is not possible"
fi

"$@"