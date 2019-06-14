#!/bin/bash

##Default setting
CHANNEL_NAME="default"
CC_NAME="smartrooves_cc"
CC_VERSION="v10"
REST_ADDR="https://DC6CD508163343B6821EDF6A568BF8DB.blockchain.ocp.oraclecloud.com:443/restproxy1"
USER=""
PASSWORD=""


## Get dealer network config from user
# echo "We need the following details to initialize the ledger."
# echo -n "Enter A channel name and press [ENTER]: "
# read -e CHANNEL_NAME
# echo -n "Enter B channel name and press [ENTER]: "
# echo -n "Enter Chaincode Name and press [ENTER]: "
# read -e CC_NAME
# echo -n "Enter Chaincode version and press [ENTER]: "
# read -e CC_VERSION
# echo -n "Enter address of your BCS REST proxy and press [ENTER]: "
# read -e REST_ADDR
# echo -n "Enter port of your BCS REST proxy and press [ENTER]: "
# read -e REST_PORT
if [[ "$USER" == "" ]]; then
  #statements
  echo -n "Enter username of your BCS REST proxy and press [ENTER]: "
  read -e USER
fi
if [[ "$PASSWORD" == "" ]]; then
  #statements
  echo -n "Enter password of your BCS REST proxy and press [ENTER]: "
  read -s PASSWORD
fi

echo

starttime=$(date +%s)

#check the response
checkRep(){
  res=${@:1}
  if [[  $res = *Failure* ]]; then
    if [[ $res = *exists* ]]; then
      echo "Things already exists. Continue...."
    else
      echo "Request Failure, please check the response message and try again."
      exit
    fi
  fi

  if [[ $res = *Success* ]]; then
    echo "Request Success, Continue..."
  fi
}

echo "Set Initial State of the Ledger"

echo "Invocation - create a new apartment"
echo
RESPONSE=$(curl -H "Content-type:application/json" -X POST -u $USER:$PASSWORD \
-d '{"channel":"'"$CHANNEL_NAME"'","chaincode":"'"$CC_NAME"'","method":"initApartment","args":["apt00001", "4", "EastPoint Dublin 3", "15000", "10000", "false", "false", "true", "null", "Gov"],"chaincodeVer":"'"$CC_VERSION"'"}' \
$REST_ADDR/bcsgw/rest/v1/transaction/invocation);
echo $RESPONSE
checkRep $RESPONSE
echo
echo

echo "Invocation - create a new tenant"
echo
RESPONSE=$(curl -H "Content-type:application/json" -X POST -u $USER:$PASSWORD \
-d '{"channel":"'"$CHANNEL_NAME"'","chaincode":"'"$CC_NAME"'","method":"initTenant","args":["12234234VA", "James", "Dublin", "05/03/1980", "single", "1", "5500", "1500", "true", "null"],"chaincodeVer":"'"$CC_VERSION"'"}' \
$REST_ADDR/bcsgw/rest/v1/transaction/invocation);
echo $RESPONSE
checkRep $RESPONSE
echo
echo

echo "Query - getAvailableApartments"
echo
RESPONSE=$(curl -H "Content-type:application/json" -X POST -u $USER:$PASSWORD \
-d '{"channel":"'"$CHANNEL_NAME"'","chaincode":"'"$CC_NAME"'","method":"getAvailableApartments","args":[],"chaincodeVer":"'"$CC_VERSION"'"}' \
$REST_ADDR/bcsgw/rest/v1/transaction/query);
echo $RESPONSE
checkRep $RESPONSE
echo
echo

echo "Query - getAvailableApartments (via querySmartRooves)"
echo
RESPONSE=$(curl -H "Content-type:application/json" -X POST -u $USER:$PASSWORD \
-d '{"channel":"'"$CHANNEL_NAME"'","chaincode":"'"$CC_NAME"'","method":"querySmartRooves","args":["SELECT json_extract(valueJson, '\''$.apartmentId'\'') as apartmentId FROM <STATE> WHERE json_extract(valueJson, '\''$.docType'\'', '\''$.assigned'\'') = '\''[\"apartment\",false]'\''"],"chaincodeVer":"'"$CC_VERSION"'"}' \
$REST_ADDR/bcsgw/rest/v1/transaction/query);
echo $RESPONSE
checkRep $RESPONSE
echo
echo

echo "Query - getAvailableTenants"
echo
RESPONSE=$(curl -H "Content-type:application/json" -X POST -u $USER:$PASSWORD \
-d '{"channel":"'"$CHANNEL_NAME"'","chaincode":"'"$CC_NAME"'","method":"getAvailableTenants","args":[],"chaincodeVer":"'"$CC_VERSION"'"}' \
$REST_ADDR/bcsgw/rest/v1/transaction/query);
echo $RESPONSE
checkRep $RESPONSE
echo
echo

echo "Query - getAvailableTenants (via querySmartRooves)"
echo
RESPONSE=$(curl -H "Content-type:application/json" -X POST -u $USER:$PASSWORD \
-d '{"channel":"'"$CHANNEL_NAME"'","chaincode":"'"$CC_NAME"'","method":"querySmartRooves","args":["SELECT json_extract(valueJson, '\''$.ppsNumber'\'') as ppsNumber FROM <STATE> WHERE json_extract(valueJson, '\''$.docType'\'', '\''$.apartmentId'\'') = '\''[\"tenant\",\"null\"]'\''"],"chaincodeVer":"'"$CC_VERSION"'"}' \
$REST_ADDR/bcsgw/rest/v1/transaction/query);
echo $RESPONSE
checkRep $RESPONSE
echo
echo
