#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# If no arguments
if [[ -z $1 ]]
then 
  echo "Please provide an element as an argument."
  exit 0
fi

# If the argument is a positive int
if [[ $1 =~ ^[0-9]+$ ]]
then
  WHERE_CLAUSE="e.atomic_number = $1"
else
  WHERE_CLAUSE="e.symbol = '$1' OR e.name = '$1'"
fi

#Consult database joining
ELEMENT_DATA=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p USING(atomic_number) JOIN types t USING(type_id) WHERE $WHERE_CLAUSE;")

# if not founds
if [[ -z $ELEMENT_DATA ]]
then
  echo "I could not find that element in the database."
  exit 0
fi

# output
echo "$ELEMENT_DATA" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING BOILING
do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
done