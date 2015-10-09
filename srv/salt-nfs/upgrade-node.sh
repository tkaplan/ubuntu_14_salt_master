#!/bin/bash
npm cache clean -f
npm install -g n
n stable

ln -sf /usr/local/n/versions/node/**/bin/node /usr/local/bin/node
ln -sf /usr/local/n/versions/node/**/bin/npm /usr/local/bin/npm

export PATH=$PATH:/usr/local/n/versions/node/4.0.0/bin
export NODE_PATH=$NODE_PATH:/usr/local/n/versions/node/4.0.0/lib/node_modules
