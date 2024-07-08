#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c";

echo -e "\n~~~~ My Salon ~~~~";
echo -e "\nWelcome to the salon, what service do you request?";
MAIN_MENU(){
  if [[ $1 ]] 
  then
    echo -e "\n$1"
  fi
  LIST_SERVICES=$($PSQL "SELECT * FROM services")
  echo "$LIST_SERVICES" | while read SERVICE_ID BAR SERVICE
  do
    ID=$(echo $SERVICE_ID | sed 's/ //g')
    NAME=$(echo $SERVICE | sed 's/ //g')
    echo "$ID) $SERVICE"
  done
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    [1-3]) NEXT ;;
        *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}
  #SERVICES=$($PSQL "select service_id, name from services order by service_id");
  
  #echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  #do
  #  echo "$SERVICE_ID) $SERVICE_NAME"
  #done

NEXT(){
  SERVICE_NAME_SELECTED=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_NAME_SELECTED ]]
  then 
    MAIN_MENU
  fi

  echo -e "\nWhat is your phone number"
  read CUSTOMER_PHONE

  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "\nI dont have you info, what is your name?"
    read CUSTOMER_NAME
    CUSTOMER_SET=$($PSQL "insert into customers(name, phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  fi

  CUSTOMER_ID=$($PSQL "select customer_id from customers where name='$CUSTOMER_NAME'")

  echo -e "\nWhat time would you like your $SERVICE_NAME_SELECTED, $CUSTOMER_NAME?"
  read SERVICE_TIME
  APPOINTMET_SET=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  echo -e "\nI have put you down for a $SERVICE_NAME_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
  
  echo -e "\nThank you for stopping in.\n"
}

MAIN_MENU