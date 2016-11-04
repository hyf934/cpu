----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:45:36 10/25/2016 
-- Design Name: 
-- Module Name:    CK - Behavioral 
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

entity CK is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           InputSW : in  STD_LOGIC_VECTOR (7 downto 0);
           OutputL : out  STD_LOGIC_VECTOR (7 downto 0);
           Ram1Data : inout  STD_LOGIC_VECTOR (7 downto 0);
           Ram1OE : out  STD_LOGIC;
           Ram1WE : out  STD_LOGIC;
           Ram1EN : out  STD_LOGIC;
           data_ready : in  STD_LOGIC;
           rdn : inout  STD_LOGIC;
           tbre : in  STD_LOGIC;
           tsre : in  STD_LOGIC;
           wrn : inout  STD_LOGIC);
end CK;

architecture Behavioral of CK is
begin
	process(clk, rst)
	variable xx: integer := 0;
	variable state: integer :=0;
	variable tmp: STD_LOGIC_VECTOR (7 downto 0):="00000000";
	begin
		if(rst = '0') then --≥ı ºªØ
			wrn <= '1';
			Ram1OE <= '1';
			Ram1EN <= '1';
			Ram1WE <= '1';
			state := 0;
			xx :=0;
		else
			if(clk'event and clk = '1') then
			--fenpin
				if(xx=1023)then
					xx:=0;
					case state is
						when 0 =>
							Ram1OE <='1';
							Ram1EN <='1';
							Ram1WE <='1';
							wrn  <='1';
							state:=state+1;
						when 1 => 
							rdn  <='1';
							Ram1Data <="ZZZZZZZZ";
							state:=state+1;
						when 2 =>
							if(data_ready='1')then
								rdn<='0';
								state:=3;
							else
								state := 1;
							end if;
						when 3 =>
							OutputL <=Ram1Data;
							tmp:=Ram1Data;
							rdn <= '1';
							wrn<='1';
							state:=state+1;
						when 4 =>
							tmp := tmp + 1;
							state:=state+1;
						when 5 => 
							wrn<='0';
							Ram1data<=tmp;
							OutputL<=tmp;
							state:=state+1;
						when 6 =>
							wrn<='1';
							state:=state+1;
		
						when 7 =>
							if (tbre = '1') then
								state:=state+1;

							end if;
						when 8 =>					
							if (tsre = '1') then 
								state:=0;
								
							end if;
						when others=>
					end case;
				else
				  xx:=xx+1;
				end if;
			end if;
		end if;
	end process;
end Behavioral;

