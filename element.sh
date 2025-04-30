#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# This script retrieves information about a chemical element by atomic number, symbol, or name

# Check if an argument was provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit
fi

# Determine if input is a number
if [[ $1 =~ ^[0-9]+$ ]]; then
  ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius 
                   FROM elements 
                   JOIN properties USING(atomic_number) 
                   JOIN types USING(type_id) 
                   WHERE atomic_number=$1;")
else
  ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius 
                   FROM elements 
                   JOIN properties USING(atomic_number) 
                   JOIN types USING(type_id) 
                   WHERE symbol='$1' OR name='$1';")
fi

# If not found
if [[ -z $ELEMENT ]]; then
  echo "I could not find that element in the database."
  exit
fi

# Parse the result
IFS="|" read ATOMIC_NUMBER SYMBOL NAME TYPE MASS MELT BOIL <<< "$ELEMENT"

# Display the output
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
Updated element.sh to handle more queries
Updated element.sh to handle more queries
