CREATE DATABASE number_guess;

\c number_guess

-- Create Users and Games Table

CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  username VARCHAR(22) UNIQUE NOT NULL
);

CREATE TABLE games (
  game_id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(user_id) NOT NULL,
  number_of_guesses INT NOT NULL
);
