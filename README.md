# Chicken Breast

![](./markdown/team-logo.png)

## The Team

**CodeRunner Team**
- Jordan Pisarek
- Jared McDowall

**Game Development Team**
- Jamie Shin
- Sun Lee
- Borim Jang
- Jordan Pisarek
- Kishora Tono

**Database Design**
- Jared McDowall

## Project Information
Our project is split into two parts, implementing a spatial skills test using Moodle, with the CodeRunner plugin, and implementation a prototype spatial skills game using Godot.

CodeRunner will be using traditional methods of spatial skills testing, using questions from studies and other tests. The reasoning behind using CodeRunner is the ease of use and the accessibility behind it as it is used by the tertiary sector. 

The game is a prototype that will be aimed at reinventing spatial skills testing, to make it more fun and engaging. The idea is to be able to test spatial skills without it feeling like a test. 

Most of the group planning and collaboration was done through a shared Google drive. Discussions were held through Discord and in-person.

**CodeRunner Technologies:**
- Moodle
- CodeRunner plugin for Moodle

**Game Technologies:**
- Godot
- Blender

## Installation and Configuration

### CodeRunner

We expect that you will have access to the CodeRunner test server, as the quiz is only available on that server. As long as you have been added to the COMPSCI373-S1-2023 course, you will be able to find the quiz. Once logged in, please proceed to COMPSCI 373 course, and find the Team 32's quiz. Alternatively, [click here](https://coderunner.connect.test.amazon.auckland.ac.nz/mod/quiz/view.php?id=666), you will need to open the link in the browser you're logged into the server with. See usage information on how to start the quiz.

Alternatively, if you wish to add our CodeRunner questions to your own server. Download the [test xml file](https://github.com/uoa-compsci399-s2-2023/capstone-project-team-32/blob/main/quiz/test-COMSCI.373.S1.2023-Questions%20Team%2032-20230908-1515.xml), and navigate to the Question bank in the category you wish to add the questions to. Select import and configure the options as shown in the image to import.

![](./markdown/coderunnerImport.png)

### ThinkSpatial Game Install

For both **Windows** and **macOS**, follow the respective instructions below for installing and setting up the game.
To install the application, please download the file for your respective operating system in [Releases](https://github.com/uoa-compsci399-s2-2023/capstone-project-team-32/releases).

**Windows**

Once you have downloaded the zip file, open it and it will extract a file called `ThinkSpatial`. Open this file and the game should start running. There is nothing but your Windows machine that is needed, so long as you have a a graphics card installed.

Once you open the zip file, you should see a folder like below. Open it and run the executable file.
![](./markdown/image2.png)

**macOS**

Once you have downloaded the zip file, open it and it will extract a file called `ThinkSpatial`. Open the file and the game should start running. The unzipped file should look like below.

You may need to change you security settings to allow the application to run. Follow the usually process for macOS to do this.

![](./markdown/macDownload.png)

## Usage Examples - CodeRunner Quiz
To start the quiz, click the attempt quiz button.
![](./markdown/coderunner-1.png)

There will be a pop-up informing you of the 60-minute time-limit, click start attempt when ready.
![](./markdown/coderunner2.png)

Once clicked, you will then be directed to the start of the quiz.
![](./markdown/coderunner3.png)

There are 33 questions, which each new section introduces by an example question that is already done for you. Follow the instructions of the questions and enter the answer into the response field.
![](./markdown/coderunner4.png)

You can submit your answer, by clicking the check button. However, there is a penalty for each time you click the check button, and the answer is wrong. Do not click the check button, unless you are sure your answer is correct.
![](./markdown/coderunner5.png)

Once you have finished your attempt, then click the submit all button at the end of the quiz. If you do not finish in time, CodeRunner will submit all you have done and mark it automatically.
![](./markdown/coderunner6.png)

## Usage Examples - ThinkSpatial Game

Once you open the game on either Windows or macOS, you will see the below screen. You will see multiple objects that you can click on, all object on the counters are minigames, select any that you wish to play. To quit, click the door on the left.
![](./markdown/ThinkSpatial-menu.png)

When you click on the objects, you will be taken to the game. There are four games to choose from, and you will see one of the following when entering the game.

![](./markdown/miro.png)
![](./markdown/vantage.png)
![](./markdown/game-borim.png)

The third game (spatial memory) was developed using C#, while the first, second and last games were developed in GDscript.

![](./markdown/game-kishoraSun.png)

The first three games have instructions, although the last one does not.

## Future Plans

**Database Addition**

We would like to add a database to the game, storing all the data collected within the game. Making it simple for the teacher or admin to access player data and analyse and compare across all players. Thus, we have designed a database that we would like to implement in the future. Allowing for teacher and admin access, with data from each minigame stored in separate tables for each player.

Database design is in the database folder, and everything is included in the [Database file](https://github.com/uoa-compsci399-s2-2023/capstone-project-team-32/tree/main/database). 

**Game Extension**

Due to the complexity of our project, there are many other extensions we would like to implement into the game in the future, that time did not allow us to complete. These include creating a mobile application and studying the effectiveness of the game and alongside the full implementation and integration of the database design.
