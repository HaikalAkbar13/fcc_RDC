#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# read username
echo "Enter your username:"
read USERNAME

# check username in database
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

if [[ -z $USER_ID ]]
then
  # if user not in database
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  # inser new user
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  # get user_id
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
else
  # if user in database take game statistics
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games WHERE user_id=$USER_ID")
  
  # clear strailing space from query result
  GAMES_PLAYED=$(echo $GAMES_PLAYED | xargs)
  BEST_GAME=$(echo $BEST_GAME | xargs)
  
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# generate random number from 1 to 1000
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
GUESS_COUNT=0

# first guess
echo "Guess the secret number between 1 and 1000:"
read GUESS

# loop until correct guess
while true
do
  # check the input for valid integer
  if ! [[ $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    read GUESS
    continue
  fi

  # add number of tries
  GUESS_COUNT=$((GUESS_COUNT + 1))

  # check gt or lt secret number
  if [[ $GUESS -eq $SECRET_NUMBER ]]
  then
    break
  elif [[ $GUESS -gt $SECRET_NUMBER ]]
  then
    echo "It's lower than that, guess again:"
    read GUESS
  else
    echo "It's higher than that, guess again:"
    read GUESS
  fi
done

# save result in the database
INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(user_id, number_of_guesses) VALUES($USER_ID, $GUESS_COUNT)")

# win message
echo "You guessed it in $GUESS_COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"
