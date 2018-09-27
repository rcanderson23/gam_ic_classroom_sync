gam\_ic\_classroom\_sync
=========================
Consists of a few powershell functions that query your Infinite Campus database for students in courses along with the teacher. It will then use GAM to create classes and sync the rosters to the classes automatically.

Requirements
-------------------------
* SqlServer Powershell Module 
* [GAM](https://github.com/jay0lee/GAM)
* ODBC connection to your Infinite Campus database
* Student and Teacher emails stored in Infinite Campus


Installation
-------------------------
0. Install SqlServer module if required (`Install-Module -Name SqlServer`)
1. Setup GAM
2. Clone this repository
3. Copy `config.sample.ps1` to `config.ps1` and change variables to fit your environment
4. Read through the examples to see what you want to use in your environment.
5. Create a script that fits your environment.

Gotchas
-------------------------
* Using the `Set-GAMClasses` to modify classes to `Archived` is a one-way operation. You will not be able to revert to Active or Provisioned.