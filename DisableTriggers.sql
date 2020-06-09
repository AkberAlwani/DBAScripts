A single trigger
Usually if you need to disable a single trigger it’s for something like a load, or maybe you just don’t need it anymore and feel like creating some zombie code.

DISABLE TRIGGER Schema.TriggerName ON Schema.TableName;
All triggers for a table
This is going to be for pretty much the same reasons, although the load reason will be more often and the zombie code less often.

DISABLE TRIGGER ALL ON Schema.TableName;
As a side note you can get a list of all triggers on a table by using one of the following:

EXEC sp_helptrigger TS_Membership;

SELECT object_name(parent_id) AS parent_name, * FROM sys.triggers
WHERE parent_id = object_id('TableName');
You’ll notice that they each provide slightly different information, and of course the system view provides more than the sp_help function.

Now, any time you are disabling a group of triggers and there is any chance you will need to enable them again I HIGHLY recommend checking them out ahead of time to see if any of them are already disabled. When you are done you probably want to leave things the way they were when you started right? No bringing that zombie code back to life accidentally.

All triggers for a database
The only time I’ve ever seen this done is when you have to do a full reload of the DB and don’t want to mess with a bunch of triggers that are going to be changing data or loading log tables that you are going to be pulling from the source location anyway. As I said above, if you are going to do this you ABSOLUTELY (can’t say that often or strongly enough) need to check if any of them are disabled, make a list, and re-disable them when you are done enabling all of them.

Why not only enable the ones you care about? Well, you can, but it’s probably easier to mass enable then disable the few that you need to stay disabled.

EXEC sp_msforeachtable 'DISABLE TRIGGER ALL ON ?';
Ok, a bunch of you are looking at me funny going But we were told not to use those sp_msforeach… stored procedures? And yea, it is undocumented, don’t use it in any production code. But this is a situation where no one is going to be in the database (you aren’t making mass changes in a database with people in it are you?), and you are going to double check that you hit everything when you are done. Or, if you want you can use Aaron Bertrand’s (b/t) replacement for sp_msforeachdb as a template and build your own.

Database level triggers (DDL triggers for example)
If you look at these, particularly the all version you might think this a simpler way to disable all of the triggers in the database. It’s not. It disables database scoped triggers. i.e. DDL triggers. Not DML triggers which are scoped to tables etc.

One

USE dbname;
DISABLE TRIGGER TriggerName ON DATABASE;
All

USE dbname;
DISABLE TRIGGER ALL ON DATABASE;
Server level triggers (Logon triggers for example)
Same as database level triggers. These commands only affect server scoped triggers.

One

DISABLE TRIGGER TriggerName ON SERVER;
All

DISABLE TRIGGER ALL ON SERVER;