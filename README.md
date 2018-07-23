gam\_ic\_course\_sync
=========================
Consists of a few powershell scripts that query your Infinite Campus database for students in courses along with the teacher. It will then use GAM to create classes and sync the rosters to the classes automatically.

Requirements
-------------------------
* [GAM](https://github.com/jay0lee/GAM)
* ODBC connection to your Infinite Campus database
* Student and Teacher emails stored in Infinite Campus


Installation
-------------------------
1. Setup GAM
2. Clone this repository
3. Copy `config.sample.ps1` to `config.ps1` and change variables to fit your environment
4. Run the `getclasses.ps1` script. This will return all the information to build the courses and rosters.
5. Create the classes by running `createclasses.ps1`. (Hopefully this will only have to be run once after school has started. I don't know how GAM reacts to trying to create courses twice)
6. Run `setclassrooms.ps1` for your initial classroom sync.
7. To keep classes in sync throughout the year you should create a Scheduled Task to run `getclasses.ps1` and `setclassrooms.ps1` once a day to account for students coming in and out of classes.
