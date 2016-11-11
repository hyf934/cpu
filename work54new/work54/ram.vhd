----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:43:20 10/24/2016 
-- Design Name: 
-- Module Name:    ram - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

USE ieee.std_logic_signed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ram is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           InputSW : in  STD_LOGIC_VECTOR (15 downto 0);
           OutputL : out  STD_LOGIC_VECTOR (15 downto 0);
           Ram1Addr, Ram2Addr : out  STD_LOGIC_VECTOR (17 downto 0);
           Ram1Data, Ram2Data : inout  STD_LOGIC_VECTOR (15 downto 0);
           Ram1OE, Ram2OE : out  STD_LOGIC;
           Ram1WE, Ram2WE : out  STD_LOGIC;
           Ram1EN, Ram2EN : out  STD_LOGIC;
           DYP1 : out  STD_LOGIC_VECTOR (6 downto 0));
end ram;

architecture Behavioral of ram is

begin
	process(clk, rst)
		--variable DriAddr : std_logic_vector(17 downto 0) := "000000000000000000";
		variable data : std_logic_vector(15 downto 0);
		variable addr, addr0 : std_logic_vector(17 downto 0);
		variable RW : std_logic := '1';	--'1'表示读数据
		variable i: integer :=0;
		variable state: integer :=0;
	begin
	
		if(rst = '0') then
			OutputL <= (others => '1');
			Ram1Addr <= (others => '0');
			Ram1Data <= (others => '0');
			data := (others => '0');
			addr := (others => '0');
			Ram1OE <= '1';
			Ram1WE <= '1';
			Ram1EN <= '0';
			Ram2Addr <= (others => '0');
			Ram2Data <= (others => '0');
			Ram2OE <= '1';
			Ram2WE <= '1';
			Ram2EN <= '0';
			DYP1 <= (others => '0');
			state:=0;
			i:=0;
		else
			if(clk'event and clk = '1') then
				case state is
					when 0 => 
						addr(15 downto 0):=InputSW;
					--	addr0:=InputSW;
					   state:=1;
					when 1 =>
						data:= InputSW;
						state:=2;
						Ram1Addr <= addr;
						Ram1Data <= InputSW;
					when 2=>	
       				Ram1WE <= '1';
                  state:=3;
					when 3=>
						Ram1Addr <= addr;
						Ram1Data <= data;
						state:=4;
					when 4 => 					     
						Ram1WE<= '0';
					   data:=data+1;
						addr:=addr+1;
						i:=i+1;
						if(i < 10) then
							state:=2;
						else
						   i:=0;
							state:=5;
						end if;
					when 5 =>
						Ram1Data <= "ZZZZZZZZZZZZZZZZ";
					   Ram1WE <= '1';
						Ram1OE <= '0';
						state:=6;
						Ram1Addr<=addr;
					when 6 =>
						OutputL<=Ram1Data;
						i:=i+1;
						addr:=addr-1;
						Ram1Addr<=addr;
						if(i = 10) then
						  state:=7;
						  i:=0;
						end if;
					when 7 =>
						Ram2WE<='1';
						state:=8;
						Ram1Addr<=addr;
					when 8=>
						Ram2Addr <= addr;
						Ram2Data <= Ram1Data-'1';
						state:=9;
					when 9=>
						Ram2WE<='0';
						addr:=addr+1;
						i:=i+1;
						if(i<10)then
							state:=7;
							i:=i+1;
						else
							state:=10;
							i:=0;
						end if;
					when 10=>
						Ram2Data <= "ZZZZZZZZZZZZZZZZ";
					   Ram2WE <= '1';
						Ram2OE <= '0';
						state:=11;
						Ram2Addr<=addr;
					when 11 =>
						OutputL<=Ram2Data;
						i:=i+1;
						addr:=addr-1;
						Ram1Addr<=addr;
						if(i = 10) then
						  state:=12;
						  i:=0;
						end if;					
					when others => null;
				end case;
			end if;
		end if;
		case state is
			when 0=> DYP1 <= "0111111";
			when 1=> DYP1 <= "0000110";
			when 2=> DYP1 <= "1011011";
			when 3=> DYP1 <= "1001111";
			when 4=> DYP1 <= "1100110";
			when 5=> DYP1 <= "1101101";
			when 6=> DYP1 <= "1111101";
			when 7=> DYP1 <= "0000111";
			when 8=> DYP1 <= "1111111";
			when 9=> DYP1 <= "1101111";
			when 10 => DYP1 <= "1111111";
			when 11 => DYP1 <= "0001111";
			when others=> DYP1 <= "0000000";
		end case;

	end process; 
end Behavioral;

