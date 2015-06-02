pragma Ada_95;
with System;
package ada_main is
   pragma Warnings (Off);

   gnat_argc : Integer;
   gnat_argv : System.Address;
   gnat_envp : System.Address;

   pragma Import (C, gnat_argc);
   pragma Import (C, gnat_argv);
   pragma Import (C, gnat_envp);

   gnat_exit_status : Integer;
   pragma Import (C, gnat_exit_status);

   GNAT_Version : constant String :=
                    "GNAT Version: 4.6" & ASCII.NUL;
   pragma Export (C, GNAT_Version, "__gnat_version");

   Ada_Main_Program_Name : constant String := "_ada_asyslogs" & ASCII.NUL;
   pragma Export (C, Ada_Main_Program_Name, "__gnat_ada_main_program_name");

   procedure adafinal;
   pragma Export (C, adafinal, "adafinal");

   procedure adainit;
   pragma Export (C, adainit, "adainit");

   procedure Break_Start;
   pragma Import (C, Break_Start, "__gnat_break_start");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer;
   pragma Export (C, main, "main");

   type Version_32 is mod 2 ** 32;
   u00001 : constant Version_32 := 16#fafb445b#;
   pragma Export (C, u00001, "asyslogsB");
   u00002 : constant Version_32 := 16#ba46b2cd#;
   pragma Export (C, u00002, "system__standard_libraryB");
   u00003 : constant Version_32 := 16#1e2e640d#;
   pragma Export (C, u00003, "system__standard_libraryS");
   u00004 : constant Version_32 := 16#3ffc8e18#;
   pragma Export (C, u00004, "adaS");
   u00005 : constant Version_32 := 16#df111b7b#;
   pragma Export (C, u00005, "ada__calendar__delaysB");
   u00006 : constant Version_32 := 16#ab1c3be0#;
   pragma Export (C, u00006, "ada__calendar__delaysS");
   u00007 : constant Version_32 := 16#0f244912#;
   pragma Export (C, u00007, "ada__calendarB");
   u00008 : constant Version_32 := 16#0bc00dc5#;
   pragma Export (C, u00008, "ada__calendarS");
   u00009 : constant Version_32 := 16#9229643d#;
   pragma Export (C, u00009, "ada__exceptionsB");
   u00010 : constant Version_32 := 16#e3df9d67#;
   pragma Export (C, u00010, "ada__exceptionsS");
   u00011 : constant Version_32 := 16#95643e9a#;
   pragma Export (C, u00011, "ada__exceptions__last_chance_handlerB");
   u00012 : constant Version_32 := 16#03cf4fc2#;
   pragma Export (C, u00012, "ada__exceptions__last_chance_handlerS");
   u00013 : constant Version_32 := 16#23e1f70b#;
   pragma Export (C, u00013, "systemS");
   u00014 : constant Version_32 := 16#30ec78bc#;
   pragma Export (C, u00014, "system__soft_linksB");
   u00015 : constant Version_32 := 16#e2ebe502#;
   pragma Export (C, u00015, "system__soft_linksS");
   u00016 : constant Version_32 := 16#0d2b82ae#;
   pragma Export (C, u00016, "system__parametersB");
   u00017 : constant Version_32 := 16#bfbc74f1#;
   pragma Export (C, u00017, "system__parametersS");
   u00018 : constant Version_32 := 16#72905399#;
   pragma Export (C, u00018, "system__secondary_stackB");
   u00019 : constant Version_32 := 16#378fd0a5#;
   pragma Export (C, u00019, "system__secondary_stackS");
   u00020 : constant Version_32 := 16#ace32e1e#;
   pragma Export (C, u00020, "system__storage_elementsB");
   u00021 : constant Version_32 := 16#d92c8a93#;
   pragma Export (C, u00021, "system__storage_elementsS");
   u00022 : constant Version_32 := 16#4f750b3b#;
   pragma Export (C, u00022, "system__stack_checkingB");
   u00023 : constant Version_32 := 16#80434b27#;
   pragma Export (C, u00023, "system__stack_checkingS");
   u00024 : constant Version_32 := 16#a7343537#;
   pragma Export (C, u00024, "system__exception_tableB");
   u00025 : constant Version_32 := 16#8120f83b#;
   pragma Export (C, u00025, "system__exception_tableS");
   u00026 : constant Version_32 := 16#ff3fa16b#;
   pragma Export (C, u00026, "system__htableB");
   u00027 : constant Version_32 := 16#cc3e5bd4#;
   pragma Export (C, u00027, "system__htableS");
   u00028 : constant Version_32 := 16#8b7dad61#;
   pragma Export (C, u00028, "system__string_hashB");
   u00029 : constant Version_32 := 16#057d2f9f#;
   pragma Export (C, u00029, "system__string_hashS");
   u00030 : constant Version_32 := 16#6a8a6a74#;
   pragma Export (C, u00030, "system__exceptionsB");
   u00031 : constant Version_32 := 16#86f01d0a#;
   pragma Export (C, u00031, "system__exceptionsS");
   u00032 : constant Version_32 := 16#b012ff50#;
   pragma Export (C, u00032, "system__img_intB");
   u00033 : constant Version_32 := 16#213a17c9#;
   pragma Export (C, u00033, "system__img_intS");
   u00034 : constant Version_32 := 16#dc8e33ed#;
   pragma Export (C, u00034, "system__tracebackB");
   u00035 : constant Version_32 := 16#4266237e#;
   pragma Export (C, u00035, "system__tracebackS");
   u00036 : constant Version_32 := 16#4900ab7d#;
   pragma Export (C, u00036, "system__unsigned_typesS");
   u00037 : constant Version_32 := 16#907d882f#;
   pragma Export (C, u00037, "system__wch_conB");
   u00038 : constant Version_32 := 16#9c0ad936#;
   pragma Export (C, u00038, "system__wch_conS");
   u00039 : constant Version_32 := 16#22fed88a#;
   pragma Export (C, u00039, "system__wch_stwB");
   u00040 : constant Version_32 := 16#b11bf537#;
   pragma Export (C, u00040, "system__wch_stwS");
   u00041 : constant Version_32 := 16#5d4d477e#;
   pragma Export (C, u00041, "system__wch_cnvB");
   u00042 : constant Version_32 := 16#82f45fe0#;
   pragma Export (C, u00042, "system__wch_cnvS");
   u00043 : constant Version_32 := 16#f77d8799#;
   pragma Export (C, u00043, "interfacesS");
   u00044 : constant Version_32 := 16#75729fba#;
   pragma Export (C, u00044, "system__wch_jisB");
   u00045 : constant Version_32 := 16#d686c4f4#;
   pragma Export (C, u00045, "system__wch_jisS");
   u00046 : constant Version_32 := 16#ada34a87#;
   pragma Export (C, u00046, "system__traceback_entriesB");
   u00047 : constant Version_32 := 16#71c0194a#;
   pragma Export (C, u00047, "system__traceback_entriesS");
   u00048 : constant Version_32 := 16#22d03640#;
   pragma Export (C, u00048, "system__os_primitivesB");
   u00049 : constant Version_32 := 16#93307b22#;
   pragma Export (C, u00049, "system__os_primitivesS");
   u00050 : constant Version_32 := 16#ee80728a#;
   pragma Export (C, u00050, "system__tracesB");
   u00051 : constant Version_32 := 16#d1fc9fa1#;
   pragma Export (C, u00051, "system__tracesS");
   u00052 : constant Version_32 := 16#e4a307eb#;
   pragma Export (C, u00052, "ada__command_lineB");
   u00053 : constant Version_32 := 16#df5044bd#;
   pragma Export (C, u00053, "ada__command_lineS");
   u00054 : constant Version_32 := 16#af50e98f#;
   pragma Export (C, u00054, "ada__stringsS");
   u00055 : constant Version_32 := 16#33d0a981#;
   pragma Export (C, u00055, "ada__strings__unboundedB");
   u00056 : constant Version_32 := 16#f805faca#;
   pragma Export (C, u00056, "ada__strings__unboundedS");
   u00057 : constant Version_32 := 16#c8b98bb0#;
   pragma Export (C, u00057, "ada__strings__searchB");
   u00058 : constant Version_32 := 16#b5a8c1d6#;
   pragma Export (C, u00058, "ada__strings__searchS");
   u00059 : constant Version_32 := 16#96e9c1e7#;
   pragma Export (C, u00059, "ada__strings__mapsB");
   u00060 : constant Version_32 := 16#24318e4c#;
   pragma Export (C, u00060, "ada__strings__mapsS");
   u00061 : constant Version_32 := 16#b71e6964#;
   pragma Export (C, u00061, "system__bit_opsB");
   u00062 : constant Version_32 := 16#c30e4013#;
   pragma Export (C, u00062, "system__bit_opsS");
   u00063 : constant Version_32 := 16#12c24a43#;
   pragma Export (C, u00063, "ada__charactersS");
   u00064 : constant Version_32 := 16#051b1b7b#;
   pragma Export (C, u00064, "ada__characters__latin_1S");
   u00065 : constant Version_32 := 16#07116dec#;
   pragma Export (C, u00065, "ada__tagsB");
   u00066 : constant Version_32 := 16#21b957c3#;
   pragma Export (C, u00066, "ada__tagsS");
   u00067 : constant Version_32 := 16#68f8d5f8#;
   pragma Export (C, u00067, "system__val_lluB");
   u00068 : constant Version_32 := 16#33f2fc0f#;
   pragma Export (C, u00068, "system__val_lluS");
   u00069 : constant Version_32 := 16#46a1f7a9#;
   pragma Export (C, u00069, "system__val_utilB");
   u00070 : constant Version_32 := 16#284c6214#;
   pragma Export (C, u00070, "system__val_utilS");
   u00071 : constant Version_32 := 16#b7fa72e7#;
   pragma Export (C, u00071, "system__case_utilB");
   u00072 : constant Version_32 := 16#8efd9783#;
   pragma Export (C, u00072, "system__case_utilS");
   u00073 : constant Version_32 := 16#c4857ee1#;
   pragma Export (C, u00073, "system__compare_array_unsigned_8B");
   u00074 : constant Version_32 := 16#f9da01c6#;
   pragma Export (C, u00074, "system__compare_array_unsigned_8S");
   u00075 : constant Version_32 := 16#9d3d925a#;
   pragma Export (C, u00075, "system__address_operationsB");
   u00076 : constant Version_32 := 16#e39f1e9c#;
   pragma Export (C, u00076, "system__address_operationsS");
   u00077 : constant Version_32 := 16#dbb36d26#;
   pragma Export (C, u00077, "system__finalization_implementationB");
   u00078 : constant Version_32 := 16#bdfa5ab4#;
   pragma Export (C, u00078, "system__finalization_implementationS");
   u00079 : constant Version_32 := 16#386436bc#;
   pragma Export (C, u00079, "system__restrictionsB");
   u00080 : constant Version_32 := 16#db039e46#;
   pragma Export (C, u00080, "system__restrictionsS");
   u00081 : constant Version_32 := 16#1358602f#;
   pragma Export (C, u00081, "ada__streamsS");
   u00082 : constant Version_32 := 16#01cb6d81#;
   pragma Export (C, u00082, "system__finalization_rootB");
   u00083 : constant Version_32 := 16#2d16f6f3#;
   pragma Export (C, u00083, "system__finalization_rootS");
   u00084 : constant Version_32 := 16#a6e358bc#;
   pragma Export (C, u00084, "system__stream_attributesB");
   u00085 : constant Version_32 := 16#e89b4b3f#;
   pragma Export (C, u00085, "system__stream_attributesS");
   u00086 : constant Version_32 := 16#b46168d5#;
   pragma Export (C, u00086, "ada__io_exceptionsS");
   u00087 : constant Version_32 := 16#7cc77cc0#;
   pragma Export (C, u00087, "ada__finalizationB");
   u00088 : constant Version_32 := 16#01acb175#;
   pragma Export (C, u00088, "ada__finalizationS");
   u00089 : constant Version_32 := 16#7a8f4ce5#;
   pragma Export (C, u00089, "ada__text_ioB");
   u00090 : constant Version_32 := 16#78993766#;
   pragma Export (C, u00090, "ada__text_ioS");
   u00091 : constant Version_32 := 16#7a48d8b1#;
   pragma Export (C, u00091, "interfaces__c_streamsB");
   u00092 : constant Version_32 := 16#40dd1af2#;
   pragma Export (C, u00092, "interfaces__c_streamsS");
   u00093 : constant Version_32 := 16#13cbc5a8#;
   pragma Export (C, u00093, "system__crtlS");
   u00094 : constant Version_32 := 16#5efa797c#;
   pragma Export (C, u00094, "system__file_ioB");
   u00095 : constant Version_32 := 16#2e96f0e6#;
   pragma Export (C, u00095, "system__file_ioS");
   u00096 : constant Version_32 := 16#a2230cb9#;
   pragma Export (C, u00096, "interfaces__cB");
   u00097 : constant Version_32 := 16#ebbc3ca7#;
   pragma Export (C, u00097, "interfaces__cS");
   u00098 : constant Version_32 := 16#7401caa7#;
   pragma Export (C, u00098, "interfaces__c__stringsB");
   u00099 : constant Version_32 := 16#739e0600#;
   pragma Export (C, u00099, "interfaces__c__stringsS");
   u00100 : constant Version_32 := 16#621b06ef#;
   pragma Export (C, u00100, "system__crtl__runtimeS");
   u00101 : constant Version_32 := 16#f74220e8#;
   pragma Export (C, u00101, "system__os_libB");
   u00102 : constant Version_32 := 16#a6d80a38#;
   pragma Export (C, u00102, "system__os_libS");
   u00103 : constant Version_32 := 16#4cd8aca0#;
   pragma Export (C, u00103, "system__stringsB");
   u00104 : constant Version_32 := 16#940bbdcf#;
   pragma Export (C, u00104, "system__stringsS");
   u00105 : constant Version_32 := 16#fcde1931#;
   pragma Export (C, u00105, "system__file_control_blockS");
   u00106 : constant Version_32 := 16#b90c86f6#;
   pragma Export (C, u00106, "ada__finalization__list_controllerB");
   u00107 : constant Version_32 := 16#b97dfd74#;
   pragma Export (C, u00107, "ada__finalization__list_controllerS");
   u00108 : constant Version_32 := 16#fd2ad2f1#;
   pragma Export (C, u00108, "gnatS");
   u00109 : constant Version_32 := 16#d2940bdd#;
   pragma Export (C, u00109, "gnat__directory_operationsB");
   u00110 : constant Version_32 := 16#d67f5739#;
   pragma Export (C, u00110, "gnat__directory_operationsS");
   u00111 : constant Version_32 := 16#833355f1#;
   pragma Export (C, u00111, "ada__characters__handlingB");
   u00112 : constant Version_32 := 16#3006d996#;
   pragma Export (C, u00112, "ada__characters__handlingS");
   u00113 : constant Version_32 := 16#7a69aa90#;
   pragma Export (C, u00113, "ada__strings__maps__constantsS");
   u00114 : constant Version_32 := 16#914b496f#;
   pragma Export (C, u00114, "ada__strings__fixedB");
   u00115 : constant Version_32 := 16#dc686502#;
   pragma Export (C, u00115, "ada__strings__fixedS");
   u00116 : constant Version_32 := 16#10f589ff#;
   pragma Export (C, u00116, "gnat__os_libS");
   u00117 : constant Version_32 := 16#f2d6107a#;
   pragma Export (C, u00117, "loggingB");
   u00118 : constant Version_32 := 16#56db7edc#;
   pragma Export (C, u00118, "loggingS");
   u00119 : constant Version_32 := 16#82106b28#;
   pragma Export (C, u00119, "ada__calendar__formattingB");
   u00120 : constant Version_32 := 16#7ece677a#;
   pragma Export (C, u00120, "ada__calendar__formattingS");
   u00121 : constant Version_32 := 16#e3cca715#;
   pragma Export (C, u00121, "ada__calendar__time_zonesB");
   u00122 : constant Version_32 := 16#74a1fd86#;
   pragma Export (C, u00122, "ada__calendar__time_zonesS");
   u00123 : constant Version_32 := 16#7993dbbd#;
   pragma Export (C, u00123, "system__val_intB");
   u00124 : constant Version_32 := 16#6b44dd34#;
   pragma Export (C, u00124, "system__val_intS");
   u00125 : constant Version_32 := 16#e6965fe6#;
   pragma Export (C, u00125, "system__val_unsB");
   u00126 : constant Version_32 := 16#59a84646#;
   pragma Export (C, u00126, "system__val_unsS");
   u00127 : constant Version_32 := 16#90617b06#;
   pragma Export (C, u00127, "system__val_realB");
   u00128 : constant Version_32 := 16#ddc8801a#;
   pragma Export (C, u00128, "system__val_realS");
   u00129 : constant Version_32 := 16#0be1b996#;
   pragma Export (C, u00129, "system__exn_llfB");
   u00130 : constant Version_32 := 16#a265e9e4#;
   pragma Export (C, u00130, "system__exn_llfS");
   u00131 : constant Version_32 := 16#7391917c#;
   pragma Export (C, u00131, "system__powten_tableS");
   u00132 : constant Version_32 := 16#5e196e91#;
   pragma Export (C, u00132, "ada__containersS");
   u00133 : constant Version_32 := 16#f9bed2d3#;
   pragma Export (C, u00133, "ada__text_io__text_streamsB");
   u00134 : constant Version_32 := 16#e220fbb4#;
   pragma Export (C, u00134, "ada__text_io__text_streamsS");
   u00135 : constant Version_32 := 16#9c36c67f#;
   pragma Export (C, u00135, "gnat__time_stampB");
   u00136 : constant Version_32 := 16#818aa6bf#;
   pragma Export (C, u00136, "gnat__time_stampS");
   u00137 : constant Version_32 := 16#39591e91#;
   pragma Export (C, u00137, "system__concat_2B");
   u00138 : constant Version_32 := 16#d83105f7#;
   pragma Export (C, u00138, "system__concat_2S");
   u00139 : constant Version_32 := 16#ae97ef6c#;
   pragma Export (C, u00139, "system__concat_3B");
   u00140 : constant Version_32 := 16#55cbf561#;
   pragma Export (C, u00140, "system__concat_3S");
   u00141 : constant Version_32 := 16#aea093dd#;
   pragma Export (C, u00141, "system__concat_9B");
   u00142 : constant Version_32 := 16#c761305c#;
   pragma Export (C, u00142, "system__concat_9S");
   u00143 : constant Version_32 := 16#5b942b2e#;
   pragma Export (C, u00143, "system__concat_8B");
   u00144 : constant Version_32 := 16#c9f0f82d#;
   pragma Export (C, u00144, "system__concat_8S");
   u00145 : constant Version_32 := 16#ec38a9a5#;
   pragma Export (C, u00145, "system__concat_7B");
   u00146 : constant Version_32 := 16#3fb60411#;
   pragma Export (C, u00146, "system__concat_7S");
   u00147 : constant Version_32 := 16#c9fdc962#;
   pragma Export (C, u00147, "system__concat_6B");
   u00148 : constant Version_32 := 16#e42b021f#;
   pragma Export (C, u00148, "system__concat_6S");
   u00149 : constant Version_32 := 16#def1dd00#;
   pragma Export (C, u00149, "system__concat_5B");
   u00150 : constant Version_32 := 16#33d839aa#;
   pragma Export (C, u00150, "system__concat_5S");
   u00151 : constant Version_32 := 16#3493e6c0#;
   pragma Export (C, u00151, "system__concat_4B");
   u00152 : constant Version_32 := 16#21be14b5#;
   pragma Export (C, u00152, "system__concat_4S");
   u00153 : constant Version_32 := 16#71efeffb#;
   pragma Export (C, u00153, "system__strings__stream_opsB");
   u00154 : constant Version_32 := 16#8453d1c6#;
   pragma Export (C, u00154, "system__strings__stream_opsS");
   u00155 : constant Version_32 := 16#3042afdd#;
   pragma Export (C, u00155, "ada__streams__stream_ioB");
   u00156 : constant Version_32 := 16#9fa60b9d#;
   pragma Export (C, u00156, "ada__streams__stream_ioS");
   u00157 : constant Version_32 := 16#595ba38f#;
   pragma Export (C, u00157, "system__communicationB");
   u00158 : constant Version_32 := 16#a1cf5921#;
   pragma Export (C, u00158, "system__communicationS");
   u00159 : constant Version_32 := 16#1889a610#;
   pragma Export (C, u00159, "calendarS");
   u00160 : constant Version_32 := 16#d77e40d8#;
   pragma Export (C, u00160, "logging__clientB");
   u00161 : constant Version_32 := 16#81c5294c#;
   pragma Export (C, u00161, "logging__clientS");
   u00162 : constant Version_32 := 16#e821ce72#;
   pragma Export (C, u00162, "gnat__socketsB");
   u00163 : constant Version_32 := 16#86014510#;
   pragma Export (C, u00163, "gnat__socketsS");
   u00164 : constant Version_32 := 16#bfb75d1b#;
   pragma Export (C, u00164, "gnat__sockets__linker_optionsS");
   u00165 : constant Version_32 := 16#2aaedf83#;
   pragma Export (C, u00165, "gnat__sockets__thinB");
   u00166 : constant Version_32 := 16#1553a4f4#;
   pragma Export (C, u00166, "gnat__sockets__thinS");
   u00167 : constant Version_32 := 16#43a82adc#;
   pragma Export (C, u00167, "gnat__task_lockS");
   u00168 : constant Version_32 := 16#75a2bfb3#;
   pragma Export (C, u00168, "system__task_lockB");
   u00169 : constant Version_32 := 16#012a3608#;
   pragma Export (C, u00169, "system__task_lockS");
   u00170 : constant Version_32 := 16#28ed06f8#;
   pragma Export (C, u00170, "gnat__sockets__thin_commonB");
   u00171 : constant Version_32 := 16#d1cc7274#;
   pragma Export (C, u00171, "gnat__sockets__thin_commonS");
   u00172 : constant Version_32 := 16#7268f812#;
   pragma Export (C, u00172, "system__img_boolB");
   u00173 : constant Version_32 := 16#d63886e0#;
   pragma Export (C, u00173, "system__img_boolS");
   u00174 : constant Version_32 := 16#4e4d89d2#;
   pragma Export (C, u00174, "system__pool_sizeB");
   u00175 : constant Version_32 := 16#f193f761#;
   pragma Export (C, u00175, "system__pool_sizeS");
   u00176 : constant Version_32 := 16#d21112bd#;
   pragma Export (C, u00176, "system__storage_poolsB");
   u00177 : constant Version_32 := 16#60952fce#;
   pragma Export (C, u00177, "system__storage_poolsS");
   u00178 : constant Version_32 := 16#b186e71d#;
   pragma Export (C, u00178, "system__os_constantsS");
   u00179 : constant Version_32 := 16#e7ab42e6#;
   pragma Export (C, u00179, "logging__serverB");
   u00180 : constant Version_32 := 16#72212c6b#;
   pragma Export (C, u00180, "logging__serverS");
   u00181 : constant Version_32 := 16#530669a4#;
   pragma Export (C, u00181, "logging__client__streamB");
   u00182 : constant Version_32 := 16#4dbbff71#;
   pragma Export (C, u00182, "logging__client__streamS");
   u00183 : constant Version_32 := 16#a6fc8110#;
   pragma Export (C, u00183, "system__taskingB");
   u00184 : constant Version_32 := 16#61a61d3d#;
   pragma Export (C, u00184, "system__taskingS");
   u00185 : constant Version_32 := 16#e28875aa#;
   pragma Export (C, u00185, "system__task_primitivesS");
   u00186 : constant Version_32 := 16#c9494811#;
   pragma Export (C, u00186, "system__os_interfaceB");
   u00187 : constant Version_32 := 16#732a7471#;
   pragma Export (C, u00187, "system__os_interfaceS");
   u00188 : constant Version_32 := 16#6470edba#;
   pragma Export (C, u00188, "system__linuxS");
   u00189 : constant Version_32 := 16#52a12383#;
   pragma Export (C, u00189, "system__task_primitives__operationsB");
   u00190 : constant Version_32 := 16#e8297115#;
   pragma Export (C, u00190, "system__task_primitives__operationsS");
   u00191 : constant Version_32 := 16#2a8bb2a4#;
   pragma Export (C, u00191, "system__interrupt_managementB");
   u00192 : constant Version_32 := 16#8aeaffc0#;
   pragma Export (C, u00192, "system__interrupt_managementS");
   u00193 : constant Version_32 := 16#17ae9ccc#;
   pragma Export (C, u00193, "system__multiprocessorsB");
   u00194 : constant Version_32 := 16#1b4d6878#;
   pragma Export (C, u00194, "system__multiprocessorsS");
   u00195 : constant Version_32 := 16#cf99f883#;
   pragma Export (C, u00195, "system__stack_checking__operationsB");
   u00196 : constant Version_32 := 16#49df1cef#;
   pragma Export (C, u00196, "system__stack_checking__operationsS");
   u00197 : constant Version_32 := 16#3d54d5f6#;
   pragma Export (C, u00197, "system__task_infoB");
   u00198 : constant Version_32 := 16#6cfdb051#;
   pragma Export (C, u00198, "system__task_infoS");
   u00199 : constant Version_32 := 16#0a363cc0#;
   pragma Export (C, u00199, "system__tasking__debugB");
   u00200 : constant Version_32 := 16#71f06032#;
   pragma Export (C, u00200, "system__tasking__debugS");
   u00201 : constant Version_32 := 16#1eab0e09#;
   pragma Export (C, u00201, "system__img_enum_newB");
   u00202 : constant Version_32 := 16#a4e63cfb#;
   pragma Export (C, u00202, "system__img_enum_newS");
   u00203 : constant Version_32 := 16#9777733a#;
   pragma Export (C, u00203, "system__img_lliB");
   u00204 : constant Version_32 := 16#32aea2da#;
   pragma Export (C, u00204, "system__img_lliS");
   u00205 : constant Version_32 := 16#06417083#;
   pragma Export (C, u00205, "system__img_lluB");
   u00206 : constant Version_32 := 16#00c9abbe#;
   pragma Export (C, u00206, "system__img_lluS");
   u00207 : constant Version_32 := 16#3b607801#;
   pragma Export (C, u00207, "system__stack_usageB");
   u00208 : constant Version_32 := 16#abdf2d5b#;
   pragma Export (C, u00208, "system__stack_usageS");
   u00209 : constant Version_32 := 16#d7aac20c#;
   pragma Export (C, u00209, "system__ioB");
   u00210 : constant Version_32 := 16#bda30044#;
   pragma Export (C, u00210, "system__ioS");
   u00211 : constant Version_32 := 16#959cf892#;
   pragma Export (C, u00211, "system__tasking__rendezvousB");
   u00212 : constant Version_32 := 16#d056c48f#;
   pragma Export (C, u00212, "system__tasking__rendezvousS");
   u00213 : constant Version_32 := 16#b59e6e78#;
   pragma Export (C, u00213, "system__tasking__entry_callsB");
   u00214 : constant Version_32 := 16#687efea4#;
   pragma Export (C, u00214, "system__tasking__entry_callsS");
   u00215 : constant Version_32 := 16#4d3e0469#;
   pragma Export (C, u00215, "system__tasking__initializationB");
   u00216 : constant Version_32 := 16#7f6b69f1#;
   pragma Export (C, u00216, "system__tasking__initializationS");
   u00217 : constant Version_32 := 16#ff133197#;
   pragma Export (C, u00217, "system__soft_links__taskingB");
   u00218 : constant Version_32 := 16#da1c0a98#;
   pragma Export (C, u00218, "system__soft_links__taskingS");
   u00219 : constant Version_32 := 16#17d21067#;
   pragma Export (C, u00219, "ada__exceptions__is_null_occurrenceB");
   u00220 : constant Version_32 := 16#c4bf5e73#;
   pragma Export (C, u00220, "ada__exceptions__is_null_occurrenceS");
   u00221 : constant Version_32 := 16#48087e79#;
   pragma Export (C, u00221, "system__tasking__protected_objectsB");
   u00222 : constant Version_32 := 16#e2c8a7eb#;
   pragma Export (C, u00222, "system__tasking__protected_objectsS");
   u00223 : constant Version_32 := 16#7a9a5f5e#;
   pragma Export (C, u00223, "system__tasking__protected_objects__entriesB");
   u00224 : constant Version_32 := 16#a416dd28#;
   pragma Export (C, u00224, "system__tasking__protected_objects__entriesS");
   u00225 : constant Version_32 := 16#9fcca227#;
   pragma Export (C, u00225, "system__tasking__protected_objects__operationsB");
   u00226 : constant Version_32 := 16#eb309cf0#;
   pragma Export (C, u00226, "system__tasking__protected_objects__operationsS");
   u00227 : constant Version_32 := 16#88081561#;
   pragma Export (C, u00227, "system__tasking__queuingB");
   u00228 : constant Version_32 := 16#ee1cad28#;
   pragma Export (C, u00228, "system__tasking__queuingS");
   u00229 : constant Version_32 := 16#f488ba38#;
   pragma Export (C, u00229, "system__tasking__utilitiesB");
   u00230 : constant Version_32 := 16#0ef27416#;
   pragma Export (C, u00230, "system__tasking__utilitiesS");
   u00231 : constant Version_32 := 16#bd6fc52e#;
   pragma Export (C, u00231, "system__traces__taskingB");
   u00232 : constant Version_32 := 16#becc801d#;
   pragma Export (C, u00232, "system__traces__taskingS");
   u00233 : constant Version_32 := 16#14757b6f#;
   pragma Export (C, u00233, "system__tasking__stagesB");
   u00234 : constant Version_32 := 16#84f88b56#;
   pragma Export (C, u00234, "system__tasking__stagesS");
   u00235 : constant Version_32 := 16#57a37a42#;
   pragma Export (C, u00235, "system__address_imageB");
   u00236 : constant Version_32 := 16#820d6a31#;
   pragma Export (C, u00236, "system__address_imageS");
   u00237 : constant Version_32 := 16#00dc945f#;
   pragma Export (C, u00237, "ada__real_timeB");
   u00238 : constant Version_32 := 16#5bfb6637#;
   pragma Export (C, u00238, "ada__real_timeS");
   u00239 : constant Version_32 := 16#763c483e#;
   pragma Export (C, u00239, "system__arith_64B");
   u00240 : constant Version_32 := 16#748dd1fb#;
   pragma Export (C, u00240, "system__arith_64S");
   u00241 : constant Version_32 := 16#0936cab5#;
   pragma Export (C, u00241, "system__memoryB");
   u00242 : constant Version_32 := 16#e96a4b1e#;
   pragma Export (C, u00242, "system__memoryS");

   --  BEGIN ELABORATION ORDER
   --  ada%s
   --  ada.characters%s
   --  ada.characters.handling%s
   --  ada.characters.latin_1%s
   --  ada.command_line%s
   --  gnat%s
   --  interfaces%s
   --  system%s
   --  system.address_operations%s
   --  system.address_operations%b
   --  system.arith_64%s
   --  system.case_util%s
   --  system.case_util%b
   --  system.exn_llf%s
   --  system.exn_llf%b
   --  system.htable%s
   --  system.img_bool%s
   --  system.img_bool%b
   --  system.img_enum_new%s
   --  system.img_enum_new%b
   --  system.img_int%s
   --  system.img_int%b
   --  system.img_lli%s
   --  system.img_lli%b
   --  system.io%s
   --  system.io%b
   --  system.linux%s
   --  system.multiprocessors%s
   --  system.os_primitives%s
   --  system.os_primitives%b
   --  system.parameters%s
   --  system.parameters%b
   --  system.crtl%s
   --  interfaces.c_streams%s
   --  interfaces.c_streams%b
   --  system.powten_table%s
   --  system.restrictions%s
   --  system.restrictions%b
   --  system.standard_library%s
   --  system.exceptions%s
   --  system.exceptions%b
   --  system.storage_elements%s
   --  system.storage_elements%b
   --  system.stack_checking%s
   --  system.stack_checking%b
   --  system.stack_checking.operations%s
   --  system.stack_usage%s
   --  system.string_hash%s
   --  system.string_hash%b
   --  system.htable%b
   --  system.strings%s
   --  system.strings%b
   --  system.traceback_entries%s
   --  system.traceback_entries%b
   --  ada.exceptions%s
   --  system.arith_64%b
   --  ada.exceptions.is_null_occurrence%s
   --  ada.exceptions.is_null_occurrence%b
   --  system.soft_links%s
   --  system.stack_checking.operations%b
   --  system.traces%s
   --  system.traces%b
   --  system.unsigned_types%s
   --  system.img_llu%s
   --  system.img_llu%b
   --  system.val_int%s
   --  system.val_llu%s
   --  system.val_real%s
   --  system.val_uns%s
   --  system.val_util%s
   --  system.val_util%b
   --  system.val_uns%b
   --  system.val_real%b
   --  system.val_llu%b
   --  system.val_int%b
   --  system.wch_con%s
   --  system.wch_con%b
   --  system.wch_cnv%s
   --  system.wch_jis%s
   --  system.wch_jis%b
   --  system.wch_cnv%b
   --  system.wch_stw%s
   --  system.wch_stw%b
   --  ada.exceptions.last_chance_handler%s
   --  ada.exceptions.last_chance_handler%b
   --  gnat.time_stamp%s
   --  system.address_image%s
   --  system.bit_ops%s
   --  system.bit_ops%b
   --  system.compare_array_unsigned_8%s
   --  system.compare_array_unsigned_8%b
   --  system.concat_2%s
   --  system.concat_2%b
   --  system.concat_3%s
   --  system.concat_3%b
   --  system.concat_4%s
   --  system.concat_4%b
   --  system.concat_5%s
   --  system.concat_5%b
   --  system.concat_6%s
   --  system.concat_6%b
   --  system.concat_7%s
   --  system.concat_7%b
   --  system.concat_8%s
   --  system.concat_8%b
   --  system.concat_9%s
   --  system.concat_9%b
   --  system.exception_table%s
   --  system.exception_table%b
   --  ada.containers%s
   --  ada.io_exceptions%s
   --  ada.strings%s
   --  ada.strings.maps%s
   --  ada.strings.fixed%s
   --  ada.strings.maps.constants%s
   --  ada.strings.search%s
   --  ada.strings.search%b
   --  ada.tags%s
   --  ada.streams%s
   --  interfaces.c%s
   --  system.multiprocessors%b
   --  gnat.time_stamp%b
   --  interfaces.c.strings%s
   --  system.crtl.runtime%s
   --  system.os_constants%s
   --  system.os_interface%s
   --  system.os_interface%b
   --  system.interrupt_management%s
   --  system.stream_attributes%s
   --  system.stream_attributes%b
   --  system.task_info%s
   --  system.task_info%b
   --  system.task_primitives%s
   --  system.interrupt_management%b
   --  system.tasking%s
   --  system.task_primitives.operations%s
   --  system.tasking%b
   --  system.tasking.debug%s
   --  system.tasking.debug%b
   --  system.task_primitives.operations%b
   --  system.traces.tasking%s
   --  system.traces.tasking%b
   --  ada.calendar%s
   --  ada.calendar%b
   --  ada.calendar.delays%s
   --  ada.calendar.delays%b
   --  ada.calendar.time_zones%s
   --  ada.calendar.time_zones%b
   --  ada.calendar.formatting%s
   --  calendar%s
   --  gnat.directory_operations%s
   --  system.communication%s
   --  system.communication%b
   --  system.memory%s
   --  system.memory%b
   --  system.standard_library%b
   --  system.secondary_stack%s
   --  interfaces.c.strings%b
   --  interfaces.c%b
   --  ada.tags%b
   --  ada.strings.fixed%b
   --  ada.strings.maps%b
   --  system.soft_links%b
   --  system.stack_usage%b
   --  ada.command_line%b
   --  ada.characters.handling%b
   --  system.secondary_stack%b
   --  ada.calendar.formatting%b
   --  system.address_image%b
   --  system.finalization_root%s
   --  system.finalization_root%b
   --  system.finalization_implementation%s
   --  system.finalization_implementation%b
   --  ada.finalization%s
   --  ada.finalization%b
   --  ada.strings.unbounded%s
   --  ada.strings.unbounded%b
   --  system.storage_pools%s
   --  system.storage_pools%b
   --  ada.finalization.list_controller%s
   --  ada.finalization.list_controller%b
   --  gnat.sockets%s
   --  gnat.sockets.linker_options%s
   --  gnat.sockets.thin_common%s
   --  gnat.sockets.thin_common%b
   --  system.file_control_block%s
   --  ada.streams.stream_io%s
   --  system.file_io%s
   --  ada.streams.stream_io%b
   --  system.os_lib%s
   --  system.os_lib%b
   --  system.file_io%b
   --  gnat.os_lib%s
   --  gnat.directory_operations%b
   --  gnat.sockets.thin%s
   --  system.pool_size%s
   --  system.pool_size%b
   --  system.soft_links.tasking%s
   --  system.soft_links.tasking%b
   --  system.strings.stream_ops%s
   --  system.strings.stream_ops%b
   --  system.task_lock%s
   --  system.task_lock%b
   --  gnat.sockets%b
   --  gnat.task_lock%s
   --  gnat.sockets.thin%b
   --  system.tasking.entry_calls%s
   --  system.tasking.initialization%s
   --  system.tasking.initialization%b
   --  system.tasking.protected_objects%s
   --  system.tasking.protected_objects%b
   --  system.tasking.utilities%s
   --  system.traceback%s
   --  ada.exceptions%b
   --  system.traceback%b
   --  ada.real_time%s
   --  ada.real_time%b
   --  ada.text_io%s
   --  ada.text_io%b
   --  ada.text_io.text_streams%s
   --  ada.text_io.text_streams%b
   --  system.tasking.protected_objects.entries%s
   --  system.tasking.protected_objects.entries%b
   --  system.tasking.queuing%s
   --  system.tasking.queuing%b
   --  system.tasking.utilities%b
   --  system.tasking.rendezvous%s
   --  system.tasking.protected_objects.operations%s
   --  system.tasking.protected_objects.operations%b
   --  system.tasking.rendezvous%b
   --  system.tasking.entry_calls%b
   --  system.tasking.stages%s
   --  system.tasking.stages%b
   --  logging%s
   --  logging%b
   --  logging.client%s
   --  logging.client%b
   --  logging.client.stream%s
   --  logging.client.stream%b
   --  logging.server%s
   --  logging.server%b
   --  asyslogs%b
   --  END ELABORATION ORDER

end ada_main;
