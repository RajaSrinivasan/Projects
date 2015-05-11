with Ada.Text_IO; use Ada.Text_IO;

with ConfigParser; use ConfigParser;

procedure CreateConfig is
   config : ConfigParser.Config_Type;
begin
   config := ConfigParser.Create;

   ConfigParser.Add_Section (config, "default");

   ConfigParser.Add_Option (config, "default", "CommentLeader", "#");
   ConfigParser.Add_Option (config, "default", "SectionBracket", "[]");
   ConfigParser.Write ("PreProc.ini", config, True);

   Put_Line (ConfigParser.Get (config, "default", "CommentLeader"));
   Put_Line (ConfigParser.Get (config, "default", "SectionBracket"));

   ConfigParser.Remove_Option (config, "default", "SectionBracket");
   ConfigParser.Write ("PreProc2.ini", config, False);
end CreateConfig;
