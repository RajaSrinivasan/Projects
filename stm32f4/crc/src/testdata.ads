-- pragma Restrictions (No_Elaboration_Code);
with STM32F4 ;
package testdata is
      pragma Elaborate_Body(testdata) ;
   crctable : array (1..11) of STM32F4.Word ;
end testdata ;
