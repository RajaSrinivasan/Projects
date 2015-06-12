
with Ada.Interrupts.Names;
with Ada.Real_Time; use Ada.Real_Time;
with Registers;     use Registers;
with STM32F4;       use STM32F4;
with STM32F4.GPIO;  use STM32F4.GPIO;

package body Button is

   protected Button is
      pragma Interrupt_Priority;
      function Current_Counter return Counter_Type ;
   private
      procedure Interrupt_Handler;
      pragma Attach_Handler
         (Interrupt_Handler,
          Ada.Interrupts.Names.EXTI0_Interrupt);

      Last_Time : Time := Clock;
      counter : Counter_Type := Counter_Type'first ;
   end Button;

   Debounce_Time : constant Time_Span := Milliseconds (500);

   protected body Button is

      function Current_Counter return Counter_Type is
      begin
         return counter ;
      end Current_Counter ;

      procedure Interrupt_Handler is
         Now : constant Time := Clock;
      begin
         --  Clear interrupt
         EXTI.PR (0) := 1;

         --  Debouncing
         if Now - Last_Time >= Debounce_Time then
            counter := counter + 1 ;
            Last_Time := Now;
         end if;

      end Interrupt_Handler;

   end Button;

   function Current_Counter return Counter_Type is
   begin
      return Button.Current_Counter ;
   end Current_Counter ;

   procedure Initialize is
      RCC_AHB1ENR_GPIOA : constant Word := 16#01#;
   begin
      --  Enable clock for GPIO-A
      RCC.AHB1ENR := RCC.AHB1ENR or RCC_AHB1ENR_GPIOA;

      --  Configure PA0
      GPIOA.MODER (0) := Mode_IN;
      GPIOA.PUPDR (0) := No_Pull;

      --  Select PA for EXTI0
      SYSCFG.EXTICR1 (0) := 0;

      --  Interrupt on rising edge
      EXTI.FTSR (0) := 0;
      EXTI.RTSR (0) := 1;
      EXTI.IMR (0) := 1;
   end Initialize;

begin
   Initialize;
end Button;
