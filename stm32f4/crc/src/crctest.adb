with System ;
with stm32f4 ;
with registers ;
with stm32f4.crc ;
with ada.real_time ; use ada.real_time ;
with testdata ;

procedure crctest is
   use stm32f4 ;
   tempcrc : stm32f4.word ;
   pragma Unreferenced (tempcrc);
   block : array (1..11) of stm32f4.word ;
   sleep_time : time_span := milliseconds(500);
   now : time ;
begin
   STM32F4.CRC.Initialize ;
   tempcrc := stm32F4.crc.compute(System'To_Address(STM32F4.RCC_Base),registers.RCC'Size/8 ) ;

   for byteval in stm32f4.byte'range
   loop
      block := (others => word(byteval)) ;
      tempcrc := stm32f4.crc.compute(block'address,block'size/8) ;
      -- testdata.crctable(integer(byteval)) := tempcrc ;
   end loop ;
   loop
      tempcrc := stm32F4.crc.compute(System'To_Address(STM32F4.RCC_Base),registers.RCC'Size/8 ) ;
      now := clock + sleep_time ;
      delay until now ;
   end loop ;
end crctest ;
