#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "truncate table games,teams"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $OPPONENT != "opponent" ]]
  then
    TEAM_CHECK=$($PSQL "select name from teams where name='$OPPONENT'")
    if [[ -z $TEAM_CHECK ]]
    then
      echo "$($PSQL "insert into teams(name) values('$OPPONENT')")"
    fi
    TEAM_CHECK=$($PSQL "select name from teams where name='$WINNER'")
    if [[ -z $TEAM_CHECK ]]
    then
      echo "$($PSQL "insert into teams(name) values('$WINNER')")"
    fi
  fi
done
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    echo "$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")"
  fi
done