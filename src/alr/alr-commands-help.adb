with AAA.Enum_Tools;
with AAA.Table_IO;
with AAA.Text_IO;

with Alire.Projects;

package body Alr.Commands.Help is

   type Help_Topics is (Identifiers);
   --  Enumeration used to index available help topics.

   -----------------------
   -- One_Liner_Summary --
   -----------------------

   function One_Liner_Summary (Topic : Help_Topics) return String
   is (case Topic is
          when Identifiers => "Naming rules for crate and index names"
      );

   -----------------
   -- Description --
   -----------------
   --  Descriptions are given as string vectors so they can be reformatted into
   --  paragraphs.

   function Description (Topic : Help_Topics) return Alire.Utils.String_Vector
   is
     (case Topic is
         when Identifiers =>
            Alire.Projects.Naming_Convention
     );

   ------------------
   -- Display_Help --
   ------------------

   procedure Display_Help (Keyword : String) is

      ------------
      -- Format --
      ------------

      procedure Format (Text : Alire.Utils.String_Vector) is
      begin
         for Line of Text loop
            AAA.Text_IO.Put_Paragraph (Line,
                                       Line_Prefix => " ");
         end loop;
         New_Line;
      end Format;

      --------------
      -- Is_Topic --
      --------------

      function Is_Topic is new AAA.Enum_Tools.Is_Valid (Help_Topics);

   begin
      if Is_Command (Keyword) then
         Display_Usage (What_Command (Keyword));

      elsif Is_Topic (Keyword) then
         New_Line;
         Put_Line (Help_Topics'Value (Keyword)'Img);
         New_Line;
         Format (Description (Identifiers));

      else
         Trace.Error ("No help found for: " & Keyword);
         Display_Valid_Keywords;
         OS_Lib.Bailout (1);
      end if;
   end Display_Help;

   ----------------------------
   -- Display_Valid_Keywords --
   ----------------------------

   procedure Display_Valid_Keywords is
   begin
      New_Line;
      Display_Valid_Commands;
      New_Line;
      Display_Valid_Topics;
   end Display_Valid_Keywords;

   --------------------------
   -- Display_Valid_Topics --
   --------------------------

   procedure Display_Valid_Topics is
      Tab   : constant String (1 .. 6) := (others => ' ');
      Table : AAA.Table_IO.Table;
   begin
      Put_Line ("Help topics: ");
      New_Line;
      for Topic in Help_Topics'Range loop
         Table.New_Row;
         Table.Append (Tab);
         Table.Append (Alire.Utils.To_Lower_Case (Topic'Img));
         Table.Append (One_Liner_Summary (Topic));
      end loop;
      Table.Print (Separator => "  ");
   end Display_Valid_Topics;

   -------------
   -- Execute --
   -------------

   overriding
   procedure Execute (Cmd : in out Command) is
      pragma Unreferenced (Cmd);
   begin
      if Num_Arguments /= 1 then
         Trace.Error ("Please specific a single help keyword:");
         Display_Valid_Keywords;
         OS_Lib.Bailout (1);
      end if;

      Display_Help (Argument (1));
   end Execute;

end Alr.Commands.Help;
