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
           Ram1Addr : out  STD_LOGIC_VECTOR (17 downto 0);
           Ram1Data : inout  STD_LOGIC_VECTOR (15 downto 0);
           Ram1OE : out  STD_LOGIC;
           Ram1WE : out  STD_LOGIC;
           Ram1EN : out  STD_LOGIC;
           DYP1 : out  STD_LOGIC_VECTOR (6 downto 0));
end ram;

architecture Behavioral of ram is
	--signal state1 : std_logic_vector(4 downto 0);
	signal state2 : std_logic_vector(3 downto 0);
	
begin
	process(clk, rst)
		--variable DriAddr : std_logic_vector(17 downto 0) := "000000000000000000";
		--variable WriteData, ReadDate : std_logic_vector(15 downto 0) := "0000000000000000";
		variable RW : std_logic := '1';	--'1'表示读数据
	begin
		if(rst = '0') then
			OutputL <= (others => '0');
			Ram1Addr <= (others => '0');
			Ram1Data <= (others => 'Z');
			Ram1OE <= '1';
			Ram1WE <= '1';
			Ram1EN <= '1';
			DYP1 <= (others => '0');
			--state1 <= (others => '0');
			state2 <= (others => '0');
		else
			if(clk'event and clk = '1') then
				case state2 is
					when "0000" => 
						RW := InputSW(0); 
						if(RW = '1') then 
							state2 <= "1001";	--读数据
						else
							state2 <= "0001";	--写数据
						end if;
					--***************写数据**************************************
					when "0001" => 
						Ram1EN <= '0';
						Ram1OE <= '1';
						Ram1WE <= '1';
						Ram1Data <= InputSW;
						OutputL(7 downto 0) <= InputSW(7 downto 0);
						state2 <= "0010";
					when "0010" =>
						OutputL(15 downto 8) <= InputSW(7 downto 0);
						Ram1Addr <= "00" & InputSW;
						state2 <= "0011";
					when "0011" =>
						Ram1WE <= '0';
						state2 <= "0100";
					when "0100" =>
						Ram1EN <= '1';
						Ram1OE <= '1';
						Ram1WE <= '1';
						state2 <= "0000";
					--***************读数据**************************************
					when "1001" =>
						Ram1EN <= '0';
						Ram1OE <= '0';
						Ram1Addr <= "00" & InputSW;
						OutputL(15 downto 8) <= InputSW(7 downto 0);
						state2 <= "1010";
					when "1010" =>
						OutputL(7 downto 0) <= Ram1Data(7 downto 0);
						state2 <= "1011";
					when "1011" =>
						Ram1EN <= '1';
						Ram1OE <= '1';
						state2 <= "0000";
					when others => null;
				end case;
			end if;
		end if;
	end process; 
end Behavioral;

