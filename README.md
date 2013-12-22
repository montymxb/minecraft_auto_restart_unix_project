minecraft_auto_restart_unix_project
===================================

Shell Scripts for auto restarting minecraft_server

This is a project created by Superkelp and mxb to free you from your minecraft server woes!

We cannot promise that this will be stable or functional across all UNIX based platforms due to the irregularities and custom setups
of each and every user's machine. However we can do our best at helping to fix issues that you may encounter.
If you do encounter a problem please email mxb.atria@gmail.com with a description of the error, and if possible
the terminal output associated with your problem.



------GETTING STARTED------

There are two ways you can go about getting started.

Get the file named install.sh, run it, and it will automatically pull all dependencies.
OR
You can also simply pull or clone the github project down and then run install.sh.

**NOTE if you do not know how to pull/clone from github (or are not familiar at all) google it!

After running the install.sh file it is important to note that.....you're done! If everything ran smoothly:
--you should have the latest minecraft_server.jar and it should have quickly run the server to setup all auto generated files.
--Ruby should be installed to allow server.rb to be run (if you didn't already have it)



------STARTING YOUR SERVER------

In order to start your server you must run server.rb.
You can run server.rb from the terminal directly if needed using either:
./server.rb
OR
ruby server.rb
**NOTE you must cd (change directory) into the folder this file is in first



------CONFIGURING YOUR SERVER------

Now that you're all setup you may configure properties.cfg in order to customize the behavior of your auto-managed minecraft server.
Here is a brief description of what each property controls:
CYCLES = time in hours before server restarts

MESSAGES = hash (array) of messages (its ok if you dont know what this is) where each key corresponds to the minute of a server's uptime. At that minute the corresponding value (message) will be broadcasted to all players on the server. You can add as many messages as you want.

MINECRAFTJARNAME = The name of your minecraft .jar file. The default is minecraft_server.jar, however if your name is different this is where you would put your unique jar file's name (ie. minecraft_server.1.7.2.jar).

BACKUPDIRECTORY = Name of the FOLDER where automatic world backups will be placed periodically.

MAXBACKUPS = Maximum number of backups to keep in the backup directory, if the maximum is reached the oldest save will be deleted.

POSTBACKUP = Seconds to wait after backing up, (before restarting the server)




------HELP------

**Sometimes on running install.sh (particularly on Mac) a minecraft server used to autogen files is left running in the background. We're working on fixing this.
*If this happens you can either:
-kill the proper Java process in the Activity Monitor (Mac) or equivalent program
OR
-restart your computer

**If install.sh does not run and terminal tells you that there is some sort of a permission issue. Run this in the terminal:
chmod a+x install.sh
*This will give read & write access for install.sh so that i can actually check for and install dependencies.
*Note that you must be in the directory that install.sh is in for this to work by using cd.

**We really shouldn't have to say this, but this will NOT work on windows, the server interaction on UNIX is in BASH, which is not a scripting language available in MS-DOS.
*Future support for Windows is questionable. Windows generally (although not always) requires more unique configuration in order to allow for a minecraft server to run smoothly.
