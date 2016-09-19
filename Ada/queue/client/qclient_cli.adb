with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io ;

with gnat.command_line ;
with GNAT.Source_Info ; use GNAT.Source_Info ;

with Queue ;
package body qclient_cli is                          -- [cli/$_cli]

    procedure SwitchHandler
      (Switch    : String;
       Parameter : String;
       Section   : String) is
    begin
       put ("SwitchHandler " & Switch ) ;
       put (" Parameter " & Parameter) ;
       put (" Section " & Section);
       new_line ;
    end SwitchHandler ;

    procedure ProcessCommandLine is
        Config : GNAT.Command_Line.Command_Line_Configuration;
    begin
       GNAT.Command_Line.Set_Usage( Config ,
				   Help => NAME & " " & 
				      VERSION & " " & 
				      Compilation_ISO_Date & " " &
				      Compilation_Time ,
				    Usage => "submit the job to the queue manager");
      GNAT.Command_Line.Define_Switch
        (Config,
         Switch      => "-h",
         Long_Switch => "--help" ,
         Help        => "generate this help message" );
      GNAT.Command_Line.Define_Switch (Config,
                       verbose'access ,
                       Switch => "-v",
                       Long_Switch => "--verbose",
                       Help => "Output extra verbose information");
        GNAT.Command_Line.Define_Switch (Config,
                       ServerNodeName'access ,
                       Switch => "-s:",
                       Long_Switch => "--server:",
                       Help => "Server Node Name");
        GNAT.Command_Line.Define_Switch (Config,
                       ServerPortNumber'access ,
                       Switch => "-p?",
                       Long_Switch => "--port?",
                       Initial => Queue.DefaultPort ,
                       Default => Queue.DefaultPort ,
                                         Help => "Port Number") ;
      
        GNAT.Command_Line.Define_Switch (Config,
                       LogDestination'access ,
                       Switch => "-L:",
                       Long_Switch => "--log-destination:",
					 Help => "Email Address to send the logs to") ;
        GNAT.Command_Line.Define_Switch (Config,
					 EnvironmentFile'access ,
					 Switch => "-env:",
					 Long_Switch => "--environment-file:",
					 Help => "Port Number") ;
        GNAT.Command_Line.Define_Switch (Config,
					 DeleteOption'access ,
                                         Switch => "-d",
                                         Long_Switch => "--delete-job",
                                         Help => "Delete a job") ;
      
        GNAT.Command_Line.Define_Switch (Config,
					 ListOption'access ,
					 Switch => "-list",
                                         Help => "List known jobs") ;
      
        GNAT.Command_Line.Define_Switch (Config,
					 AtOption'access ,
                                         Switch => "-T:",
                                         Long_Switch => "--At-time:" ,
                                         Help => "Execute at the specified time: (next hour[:minute[:second]])") ;
        GNAT.Command_Line.Define_Switch (Config,
					 HourlyOption'access ,
                                         Switch => "-H:",
                                         Long_Switch => "--Hourly:" ,
                                         Help => "Execute hourly at the specified time: (:minute[:second])") ;      
        GNAT.Command_Line.Define_Switch (Config,
					 WeeklyOption'access ,
                                         Switch => "-W:",
                                         Long_Switch => "--Weekly:" ,
                                         Help => "Execute at the specified time (with -T) on specified days: (Sunday,Monday..Saturday)") ; 
        GNAT.Command_Line.Define_Switch (Config,
					 MonthlyOption'access ,
                                         Switch => "-M:",
                                         Long_Switch => "--Monthly:" ,
                                         Help => "Execute at the specified time (with -T) on specified day of the month") ; 
         
        GNAT.Command_Line.Getopt(config,SwitchHandler'access);
 
    end ProcessCommandLine;

    function GetNextArgument return String is
    begin
        return GNAT.Command_Line.Get_Argument(Do_Expansion => True) ;
    end GetNextArgument ;
    
   procedure ShowCommandLineArguments is
      use GNAT.Strings ;
    begin
       Put("Verbose ") ;
       Put(Boolean'Image( Verbose ) );
       New_Line ;
       Put("Server Node Name ");
       Put(ServerNodeName.all); 
       New_Line ;
       Put("Server Port ") ;
       Put(ServerPortNumber) ;
       New_Line ;
       Put("Log destination ");
       Put(LogDestination.all) ;
       New_Line ;
       Put("Environment File ");
       Put(EnvironmentFile.all) ;
       New_Line ;
       Put("List Option ");
       Put(Boolean'Image( ListOption ) );
       New_Line ;
      if AtOption /= null
      then
         put("At time option ");
         put(AtOption.all) ;
      end if ;
    end ShowCommandLineArguments ;
    
end qclient_cli ;                                   -- [cli/$_cli]
