# Team 32 - Game Database

## Database Overview:

### MVP

The database will have six tables in total. There will be one for the player, this will consist of all the players that have either signued up or played the game. 

Then there will be another table for each games that a particular player will play. For instance, if the player attempts six games, even if they have not completeed the whole game - the entry will be in the database. These entries will provide an overview of the attempt of the game.

The last four tables will be used for each section of the game. So there are four sections of the game with each section collecting its own set of data, thus each section must be stored seperately. These sections are targeting different spatial skills, and thus combining into one overall attempt would not be beneficial. These sections will have detailed information about level that the user completes. Although, not all of the sections have levels.

The player can play many games, but a game cannot exist without the player. There is one game for all the four sections, and the sections comprise a part of the overall game. These four sections do not know about each other, there is no need to transfer any data across sections, rather just store the information in the section table with reference to the gameID.

### Future Implementation
There could be an opportunity to include a teacher/admin class, allowing the teacher to access all data from the players in a simplified format - only seeing overviews.

Another implementation is to include a login service, so that we can be sure that a player is who they say they are, this can be used in schools and universities - using third party authentication like University of Auckland SSO.

Add functionality for data to be transferred directly from Godot to the server, via C#.

## Database Design
Currently I am still designing the database, but this section indicates what is currently done. A UML diagram, along with descriptions of the games and the variables that they are using.

### Database UML (Provisional)

![](./GameDB-UML.jpg)

### Database Tables

#### Player Table

- playerID:int (Primary Key)
    - a random integer assigned by the database.
    - used for one-to-many relationship with other tables.
- playerName:str (Optional)
    - used to link primary key to a particular player.
    - player gives a string name.
    - without which, players are annoymous and double ups may occur. 
    - Optional until future implementation of login service, have no capacity to force and maintain username yet.

Have a table for each game, so four tables and link them through unique ID. All variables that are not used by other tables will be protected and thus not accessible by other classes. There are getter and setter methods, so that the values can be changed appropriately. 

The username will be used to link the key to specific people, as the key is randomly generated, there is no way to be sure who scores what. Implementing a forced username with login credentials is part of the future implementation.

*It may be beneficial to add an interface between Player and Game tables, but this will be explored further before going ahead with it.*

#### Game Table (Attempts)
The game table (attempts by the player) is where all the attempts by the player will be stored. It will store basic information like the gameID, a link to playerID. The idea with this table is to act like an interface between Player and Game. This way we are able to have many games per player, but also be able to store many levels for each section. Some of the sections in the game have levels to them, some do not. So it it needed that we have a way to store both information from each level per section, then link those to the game attempt. Then the game attempt will be linked to the player.

#### Section 1 (Developed by Jamie)

Jamie's game has three variables that will need to be stored by the database. They are:

- time:dbl
    - time taken to solve the maze.
    - increases incrementally.
- score:int
    - score after solving the maze.
    - made up of multiple different scoring.
    - there are different bonus, like distance and time.
- turn:int
    - the number of turns taken.
    - increases incrementally.
- date:dttm
    - database creates this value, based on the entry of the data to the table.
    - private, cannot be accessed outside of the table.
    - used to avoid duplicates, and track progress more accurately.
- playerID:int (Foreign Key)
    - cannot be changed by the table, used to maintain one-to-many relationship.

The game already has functions to collect the information above, the database just needs to store them. 

#### Section 2 (Developed by Jordan)
Jordan's game has a few more variables that will need to be collected and sotred in the database, they differ to Jamie's game.

- time:dbl
    - time taken to solve the puzzle.
    - increases.
- movementTime:int
    - tracks how fast a user moves.
    - increases.
- levelNum:int
    - the level that the player got to.
    - increases incrementally.
- numLives:int
    - number of lives that are remaining.
    - decrements.
- date:dttm
    - database creates this value, based on the entry of the data to the table.
    - private, cannot be accessed outside of the table.
    - used to avoid duplicates, and track progress more accurately.
- playerID:int (Foreign Key)
    - cannot be changed by the table, used to maintain one-to-many relationship.

Again, Jordan's game has the variables included in the game the database will need to collect and store these variables. 

#### Section 3 (Co-developed by Kishora & Sun) 
This game is being co-developed by Kishora and Sun. This game will only have to variabels in its table:

- score:int
    - the total score from the game..
- time:dbl
    - the total time taken to solve the game.
- date:dttm
    - database creates this value, based on the entry of the data to the table.
    - private, cannot be accessed outside of the table.
    - used to avoid duplicates, and track progress more accurately.
- playerID:int (Foreign Key)
    - cannot be changed by the table, used to maintain one-to-many relationship.

The database will only need to collect and store the data.

#### Section 4 (Developed by Borim) 
Borim's game will only have one vairable that will need to be collected and sotred by the database.

- score:int
    - the total score from solving the game.
- date:dttm
    - database creates this value, based on the entry of the data to the table.
    - private, cannot be accessed outside of the table.
    - used to avoid duplicates, and track progress more accurately.
- playerID:int (Foreign Key)
    - cannot be changed by the table, used to maintain one-to-many relationship.

These will be updated as the games get closer to being finished. We will need to think of further information that can be collected and analysed to give insight into whether people are doing well in one spatial skill and not so in the other.
