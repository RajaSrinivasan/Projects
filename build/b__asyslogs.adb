pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__asyslogs.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__asyslogs.adb");

with System.Restrictions;

package body ada_main is
   pragma Warnings (Off);

   procedure Do_Finalize;
   pragma Import (C, Do_Finalize, "system__standard_library__adafinal");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   procedure adainit is
      E208 : Boolean; pragma Import (Ada, E208, "system__stack_usage_E");
      E015 : Boolean; pragma Import (Ada, E015, "system__soft_links_E");
      E136 : Boolean; pragma Import (Ada, E136, "gnat__time_stamp_E");
      E025 : Boolean; pragma Import (Ada, E025, "system__exception_table_E");
      E132 : Boolean; pragma Import (Ada, E132, "ada__containers_E");
      E086 : Boolean; pragma Import (Ada, E086, "ada__io_exceptions_E");
      E054 : Boolean; pragma Import (Ada, E054, "ada__strings_E");
      E060 : Boolean; pragma Import (Ada, E060, "ada__strings__maps_E");
      E113 : Boolean; pragma Import (Ada, E113, "ada__strings__maps__constants_E");
      E066 : Boolean; pragma Import (Ada, E066, "ada__tags_E");
      E081 : Boolean; pragma Import (Ada, E081, "ada__streams_E");
      E097 : Boolean; pragma Import (Ada, E097, "interfaces__c_E");
      E099 : Boolean; pragma Import (Ada, E099, "interfaces__c__strings_E");
      E198 : Boolean; pragma Import (Ada, E198, "system__task_info_E");
      E008 : Boolean; pragma Import (Ada, E008, "ada__calendar_E");
      E006 : Boolean; pragma Import (Ada, E006, "ada__calendar__delays_E");
      E122 : Boolean; pragma Import (Ada, E122, "ada__calendar__time_zones_E");
      E110 : Boolean; pragma Import (Ada, E110, "gnat__directory_operations_E");
      E019 : Boolean; pragma Import (Ada, E019, "system__secondary_stack_E");
      E083 : Boolean; pragma Import (Ada, E083, "system__finalization_root_E");
      E078 : Boolean; pragma Import (Ada, E078, "system__finalization_implementation_E");
      E088 : Boolean; pragma Import (Ada, E088, "ada__finalization_E");
      E056 : Boolean; pragma Import (Ada, E056, "ada__strings__unbounded_E");
      E177 : Boolean; pragma Import (Ada, E177, "system__storage_pools_E");
      E107 : Boolean; pragma Import (Ada, E107, "ada__finalization__list_controller_E");
      E163 : Boolean; pragma Import (Ada, E163, "gnat__sockets_E");
      E171 : Boolean; pragma Import (Ada, E171, "gnat__sockets__thin_common_E");
      E105 : Boolean; pragma Import (Ada, E105, "system__file_control_block_E");
      E156 : Boolean; pragma Import (Ada, E156, "ada__streams__stream_io_E");
      E095 : Boolean; pragma Import (Ada, E095, "system__file_io_E");
      E102 : Boolean; pragma Import (Ada, E102, "system__os_lib_E");
      E166 : Boolean; pragma Import (Ada, E166, "gnat__sockets__thin_E");
      E175 : Boolean; pragma Import (Ada, E175, "system__pool_size_E");
      E154 : Boolean; pragma Import (Ada, E154, "system__strings__stream_ops_E");
      E216 : Boolean; pragma Import (Ada, E216, "system__tasking__initialization_E");
      E222 : Boolean; pragma Import (Ada, E222, "system__tasking__protected_objects_E");
      E238 : Boolean; pragma Import (Ada, E238, "ada__real_time_E");
      E090 : Boolean; pragma Import (Ada, E090, "ada__text_io_E");
      E134 : Boolean; pragma Import (Ada, E134, "ada__text_io__text_streams_E");
      E224 : Boolean; pragma Import (Ada, E224, "system__tasking__protected_objects__entries_E");
      E228 : Boolean; pragma Import (Ada, E228, "system__tasking__queuing_E");
      E234 : Boolean; pragma Import (Ada, E234, "system__tasking__stages_E");
      E118 : Boolean; pragma Import (Ada, E118, "logging_E");
      E161 : Boolean; pragma Import (Ada, E161, "logging__client_E");
      E182 : Boolean; pragma Import (Ada, E182, "logging__client__stream_E");
      E180 : Boolean; pragma Import (Ada, E180, "logging__server_E");

      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Zero_Cost_Exceptions : Integer;
      pragma Import (C, Zero_Cost_Exceptions, "__gl_zero_cost_exceptions");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Leap_Seconds_Support : Integer;
      pragma Import (C, Leap_Seconds_Support, "__gl_leap_seconds_support");

      procedure Install_Handler;
      pragma Import (C, Install_Handler, "__gnat_install_handler");

      Handler_Installed : Integer;
      pragma Import (C, Handler_Installed, "__gnat_handler_installed");
   begin
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      System.Restrictions.Run_Time_Restrictions :=
        (Set =>
          (False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, True, 
           False, False, False, False, False, False, False, False, 
           False),
         Value => (0, 0, 0, 0, 0, 0, 0),
         Violated =>
          (False, True, True, True, True, True, False, True, 
           True, True, True, True, True, False, False, True, 
           False, False, True, True, False, True, True, True, 
           True, True, True, False, True, True, False, True, 
           False, False, True, False, False, True, False, True, 
           False, True, True, False, True, False, True, True, 
           False, True, False, True, False, True, True, True, 
           False, False, True, False, True, True, True, True, 
           True, False, False, True, True, True, False, False, 
           False),
         Count => (0, 1, 2, 3, 0, 0, 0),
         Unknown => (False, False, False, True, False, False, False));
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Zero_Cost_Exceptions := 1;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;
      Leap_Seconds_Support := 0;

      if Handler_Installed = 0 then
         Install_Handler;
      end if;

      System.Stack_Usage'Elab_Spec;
      System.Exception_Table'Elab_Body;
      E025 := True;
      Ada.Containers'Elab_Spec;
      E132 := True;
      Ada.Io_Exceptions'Elab_Spec;
      E086 := True;
      Ada.Strings'Elab_Spec;
      E054 := True;
      Ada.Strings.Maps'Elab_Spec;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E113 := True;
      Ada.Tags'Elab_Spec;
      Ada.Streams'Elab_Spec;
      E081 := True;
      Interfaces.C'Elab_Spec;
      E136 := True;
      Interfaces.C.Strings'Elab_Spec;
      System.Task_Info'Elab_Spec;
      E198 := True;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E008 := True;
      Ada.Calendar.Delays'Elab_Body;
      E006 := True;
      Ada.Calendar.Time_Zones'Elab_Spec;
      E122 := True;
      Gnat.Directory_Operations'Elab_Spec;
      E099 := True;
      E097 := True;
      Ada.Tags'Elab_Body;
      E066 := True;
      E060 := True;
      System.Soft_Links'Elab_Body;
      E015 := True;
      E208 := True;
      System.Secondary_Stack'Elab_Body;
      E019 := True;
      System.Finalization_Root'Elab_Spec;
      E083 := True;
      System.Finalization_Implementation'Elab_Spec;
      System.Finalization_Implementation'Elab_Body;
      E078 := True;
      Ada.Finalization'Elab_Spec;
      E088 := True;
      Ada.Strings.Unbounded'Elab_Spec;
      E056 := True;
      System.Storage_Pools'Elab_Spec;
      E177 := True;
      Ada.Finalization.List_Controller'Elab_Spec;
      E107 := True;
      Gnat.Sockets'Elab_Spec;
      Gnat.Sockets.Thin_Common'Elab_Spec;
      E171 := True;
      System.File_Control_Block'Elab_Spec;
      E105 := True;
      Ada.Streams.Stream_Io'Elab_Spec;
      E156 := True;
      System.Os_Lib'Elab_Body;
      E102 := True;
      System.File_Io'Elab_Body;
      E095 := True;
      Gnat.Directory_Operations'Elab_Body;
      E110 := True;
      System.Pool_Size'Elab_Spec;
      E175 := True;
      System.Strings.Stream_Ops'Elab_Body;
      E154 := True;
      Gnat.Sockets'Elab_Body;
      E163 := True;
      Gnat.Sockets.Thin'Elab_Body;
      E166 := True;
      System.Tasking.Initialization'Elab_Body;
      E216 := True;
      System.Tasking.Protected_Objects'Elab_Body;
      E222 := True;
      Ada.Real_Time'Elab_Spec;
      Ada.Real_Time'Elab_Body;
      E238 := True;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E090 := True;
      Ada.Text_Io.Text_Streams'Elab_Spec;
      E134 := True;
      System.Tasking.Protected_Objects.Entries'Elab_Spec;
      E224 := True;
      System.Tasking.Queuing'Elab_Body;
      E228 := True;
      System.Tasking.Stages'Elab_Body;
      E234 := True;
      logging'elab_spec;
      logging'elab_body;
      E118 := True;
      logging.client'elab_spec;
      logging.client'elab_body;
      E161 := True;
      logging.client.stream'elab_spec;
      E182 := True;
      logging.server'elab_spec;
      logging.server'elab_body;
      E180 := True;
   end adainit;

   procedure adafinal is
   begin
      Do_Finalize;
   end adafinal;

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure initialize (Addr : System.Address);
      pragma Import (C, initialize, "__gnat_initialize");

      procedure finalize;
      pragma Import (C, finalize, "__gnat_finalize");

      procedure Ada_Main_Program;
      pragma Import (Ada, Ada_Main_Program, "_ada_asyslogs");

      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      gnat_argc := argc;
      gnat_argv := argv;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Break_Start;
      Ada_Main_Program;
      Do_Finalize;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   /home/srini/Documents/Projects/build/logging.o
   --   /home/srini/Documents/Projects/build/logging-client.o
   --   /home/srini/Documents/Projects/build/logging-client-stream.o
   --   /home/srini/Documents/Projects/build/logging-server.o
   --   /home/srini/Documents/Projects/build/asyslogs.o
   --   -L/home/srini/Documents/Projects/build/
   --   -L/usr/lib/gcc/x86_64-linux-gnu/4.6/adalib/
   --   -shared
   --   -lgnarl-4.6
   --   -lgnat-4.6
   --   -lpthread
--  END Object file/option list   

end ada_main;
