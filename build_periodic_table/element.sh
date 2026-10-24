#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# If no args passed
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# checks if args is number (atomic_number) or text (symbol/name)
if [[ $1 =~ ^[0-9]+$ ]]
then
  QUERY_CONDITION="e.atomic_number = $1"
else
  # LOWER for searching symbol or name case-insensitive (safe if user using lower case for symbol)
  QUERY_CONDITION="e.symbol ILIKE '$1' OR e.name ILIKE '$1'"
fi

# run query with join
# we take : atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
ELEMENT_DATA=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE $QUERY_CONDITION;")

# if the arg not found in database
if [[ -z $ELEMENT_DATA ]]
then
  echo "I could not find that element in the database."
  exit
fi

# Parsing query result
IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$ELEMENT_DATA"

# print result
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
