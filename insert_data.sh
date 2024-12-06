#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#read lines step by step into games file
cat games.csv | while IFS="," read YEAR ROUND WIN LOSE WIN_GOAL LOSE_GOAL
do
  if [[ $YEAR != 'year' ]] 
  then
    WIN_T_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
    # if not found WINNER
    if [[ -z $WIN_T_ID ]] 
      then
        # echo INSERT WIN
        $($PSQL "INSERT INTO teams(name) VALUES('$WIN')")
      fi
    # if not found LOOSER
    LOSE_T_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$LOSE'")
    if [[ -z $LOSE_T_ID ]] 
      then
        # echo INSERT LOOSER
        $($PSQL "INSERT INTO teams(name) VALUES('$LOSE')")
      fi

    # check, if thar row isn't hold table
    WIN_T_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
    LOSE_T_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$LOSE'")
    HOLDIT=$($PSQL "SELECT game_id FROM games WHERE year=$YEAR AND round='$ROUND' AND winner_id=$WIN_T_ID AND opponent_id=$LOSE_T_ID AND winner_goals=$LOSE_GOAL AND opponent_goals=$LOSE_GOAL")
    if [[ -z $HOLDIT ]]
      then
        echo $YEAR, $ROUND, $WIN_T_ID, $LOSE_T_ID, $WIN_GOAL, $LOSE_GOAL
        echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WIN_T_ID, $LOSE_T_ID, $WIN_GOAL, $LOSE_GOAL)")
      fi
  fi
done
