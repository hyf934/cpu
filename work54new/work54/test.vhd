--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:14:42 10/25/2016
-- Design Name:   
-- Module Name:   F:/work2/work54/test.vhd
-- Project Name:  work54
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ram
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ram
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         InputSW : IN  std_logic_vector(15 downto 0);
         OutputL : OUT  std_logic_vector(15 downto 0);
         Ram1Addr : OUT  std_logic_vector(17 downto 0);
         Ram1Data : INOUT  std_logic_vector(15 downto 0);
         Ram1OE : OUT  std_logic;
         Ram1WE : OUT  std_logic;
         Ram1EN : OUT  std_logic;
         DYP1 : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal InputSW : std_logic_vector(15 downto 0) := (others => '0');

	--BiDirs
   signal Ram1Data : std_logic_vector(15 downto 0);

 	--Outputs
   signal OutputL : std_logic_vector(15 downto 0);
   signal Ram1Addr : std_logic_vector(17 downto 0);
   signal Ram1OE : std_logic;
   signal Ram1WE : std_logic;
   signal Ram1EN : std_logic;
   signal DYP1 : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ram PORT MAP (
          clk => clk,
          rst => rst,
          InputSW => InputSW,
          OutputL => OutputL,
          Ram1Addr => Ram1Addr,
          Ram1Data => Ram1Data,
          Ram1OE => Ram1OE,
          Ram1WE => Ram1WE,
          Ram1EN => Ram1EN,
          DYP1 => DYP1
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		rst <= '1';
		InputSW <= "0000000000000000"; --W
		wait for 10 ns;
		
		InputSW <= "0000000010001000"; --写入的数据
		wait for 10 ns;
		InputSW <= "1000100001100000"; --地址
		wait for 30 ns;
		rst <= '0';
		wait for 10 ns;
		rst <= '1';
		InputSW <= "0000000000000001"; --R
		wait for 10 ns;
		InputSW <= "1000100001100000"; --地址
      wait;
   end process;

END;
