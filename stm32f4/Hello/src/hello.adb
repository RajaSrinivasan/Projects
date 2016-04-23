
--  The file declares the main procedure for the demonstration.
--
--  All the action is to be found in driver.adb
--  Each time you push the Button
--  Different pattern of the 4 LEDs is displayed
--
--  Use st-util in a command window and then download and execute.
with Driver;               pragma Unreferenced (Driver);
--  The Driver package contains the task that actually controls the app so
--  although it is not referenced directly in the main procedure, we need it
--  in the closure of the context clauses so that it will be included in the
--  executable.

with Last_Chance_Handler;  pragma Unreferenced (Last_Chance_Handler);
--  The "last chance handler" is the user-defined routine that is called when
--  an exception is propagated. We need it in the executable, therefore it
--  must be somewhere in the closure of the context clauses.

with System;

procedure Hello is
   pragma Priority (System.Priority'First);
begin
   loop
      null;
   end loop;
end Hello;
