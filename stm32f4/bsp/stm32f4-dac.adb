with System ;
package body STM32F4.DAC is
   DACMAP : DAC_Map_Type
     with Volatile ,
     Address => System'To_Address( stm32f4.DAC_Base ) ;
   pragma Import(Ada, DACMAP) ;

   procedure Enable( channel : Channel_Number_Type ;
                     format : DATAFormat_Type ;
                     Trigger : TriggerEvents_Type ) is
      newcr : DAC_CR_Type ;
      newcrword : word  ;
      for newcrword'address use newcr'Address ;
   begin
      case channel is
         when 0 =>
            newcr.TSEL1 := trigger ;
            newcr.TEN1 := 1 ;
            newcr.BOFF1 := 1 ;
            newcr.EN1 := 1 ;
         when 1 =>
            newcr.TSEL2 := Trigger ;
            newcr.TEN2 := 1 ;
            newcr.BOFF2 := 1 ;
            newcr.EN2 := 1 ;
      end case ;
      DACMAP.CR := newcrword ;
   end Enable ;

end STM32F4.DAC ;
