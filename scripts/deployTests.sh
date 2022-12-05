#!/bin/bash

# exit when any command fails
set -e

#creamos una variable que tiene el nombre de nuestra network
NETWORK_NAME="testing"

#Agregamos logs para verlos por consola
echo "--------------COMPILE-------------------"
echo "truffle compile --network $NETWORK_NAME"
truffle compile --network $NETWORK_NAME

echo "--------------COMPILE-------------------"
echo "truffle migrate --network $NETWORK_NAME"
truffle migrate --network $NETWORK_NAME

echo "--------------COMPILE-------------------"
echo "truffle test --network $NETWORK_NAME"
truffle test --network $NETWORK_NAME