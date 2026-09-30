#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

SHOW_DATA()
{
  if [[ -z $1 ]]
    then
      echo I could not find that element in the database.
    else
    echo "$1" | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME NUM MASS MELTING BOILING TYPE_ID
    do
      TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID ")
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi 
}

MAIN_MENU()
{
  ARG=$1

  #if ARG not a number
  if [[ ! $ARG =~ ^[0-9]+$ ]]
  then
    #if ARG lenght is greater than 2
    if [[ $( echo -n "$ARG" | wc -m ) -gt 2 ]]
    then
      #get data by name
      DATA=$($PSQL "SELECT * FROM elements JOIN properties ON elements.atomic_number=properties.atomic_number WHERE name = '$ARG' ")
      SHOW_DATA "$DATA"
    else
      #get data by symbol
      DATA=$($PSQL "SELECT * FROM elements JOIN properties ON elements.atomic_number=properties.atomic_number WHERE symbol = '$ARG' ")
      SHOW_DATA "$DATA"
    fi
  else
    #get data by atomic_number
    DATA=$($PSQL "SELECT * FROM elements JOIN properties ON elements.atomic_number=properties.atomic_number WHERE elements.atomic_number= $ARG ")
    SHOW_DATA "$DATA"
  fi

}

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  MAIN_MENU "$1"
fi
