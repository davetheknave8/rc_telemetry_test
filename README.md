# rc_telemetry_test

## Project Description
This script triggers several processes on the computer that runs it, including:
  - File creation
  - File Modification
  - File Deletion
  - Running a process
  - Network connection and data transmission

Running this script will perform these five events, and output a log in JSON format with details about each.

## How to Get Started
This is a pretty straightforward Ruby project, but there are just a few things to know to get it working properly.
  
  1. Clone this repository, and `cd` into the this directory.
  2. Before running the script, run `bundle install` to install require gems.
  3. After the second step, you are ready to run the script. To run, type the command `bash telemetry/activate-events`.
  4. After the script runs, you will be able to see the output in terminal, as well as in the logs folder within the repository.

  ** Optional **
  This script accepts two parameters. The first parameter should be a path to an executable script, the second parameter should be a 
  path to a folder that a file can be saved in. These two arguments are optional, but must be passed in order.
  


  
  ** UPDATE 8/2 **
  
  There was an issue on Linux for one of the methods used, and while troubleshooting I found another bug that logged all events as having the same PID. The commits done on 8/2 were to add Linux support (tested and working now), and also to fix the assignment of PIDs so that each event has a unique one. Please pull the most recent changes to see the fixes.
