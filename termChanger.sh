#!/bin/bash

#Made by --CyberR8x--

#Colores
redColour="\e[31m"
greenColour="\e[32m"
yellowColour="\e[33m"
blueColour="\e[34m"
defaultColour="\e[0m"


trap ctrl_c INT

function ctrl_c(){
	
	clear
	echo -e "${redColour} Leving ... ${defaultColour}"

}

function check_dependencies(){
	clear
	echo -e "${yellowColour}[*]${defaultColour} Updating repositories..."
	sleep 1
	apt update -y > /dev/null 2>&1
	programs_to_use=(curl git zsh bat vim)


	clear
	echo -e "${yellowColour}[*]${defaultColour} Checking programs...\n"
	for program in ${programs_to_use[@]}
	do
		sleep 1
		which $program > /dev/null
		if [[ $(echo $?) -eq 0 ]]
		then
			echo -e -n "${yellowColour}[*]${defaultColour} $program"
			echo -e "${greenColour} (V)${defaultColour}"
		else
			echo -e -n "${yellowColour}[*]${defaultColour} $program"
			echo -e "${redColour} (X)${defaultColour}"
			echo -e "\t${greenColour}[+]${defaultColour}${redColour} Installing ${defaultColour}$program...\n"
			sudo apt install $program -y > /dev/null 2>&1
		fi
	done
	sleep 1
}
 



check_dependencies

if [[ $(id -u) -ne 0 ]];then
	echo -e "${redColour}This Script needs root privileges (Use root or sudo)${defaultColour}"
	exit 1
fi

clear
echo -e "${yellowColour}[*]${defaultColour} Changing default shell to zsh...";sleep 1
chsh -s $(which zsh)

clear
echo -e "${yellowColour}[*]${defaultColour} Installing ohmyzsh...";sleep 1
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"


clear; cd $HOME
echo -e "${yellowColour}[*]${defaultColour} Installing PowerLevel10k...";sleep 1
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

clear
#Change theme robby to powerlevel10k
sed -i 's/robbyrussell/powerlevel10k\/powerlevel10k/g' .zshrc



#Plugins for zsh
clear
echo -e "${yellowColour}[*]${defaultColour} Adding plugins to zsh..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions > /dev/null 2>&1
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting > /dev/null 2>&1
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use > /dev/null 2>&1


#Insert plugins in .zshrc
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting you-should-use)/' .zshrc


#Insert repositories
clear

read -p "Do you want to add an alternative repository for apt (y/n): " alternative

if [[ $alternative == 'y' || $alternative == 'Y' ]]
then
  echo -e "${yellowColour}[*]${defaultColour} Adding repositories"; sleep 1
  echo "deb http://deb.debian.org/debian stable main" >> /etc/apt/sources.list
fi

#Modify cat
echo "alias cat='batcat'" >> .zshrc

#Creating directory for nvim config
clear
echo -e "${yellowColour}[*]${defaultColourr} Creating directory for nvim config"

mkdir -p .config/nvim/ && cd .config/nvim && echo -e "set syntax=java \nset autoindent \nset number" >> init.vim

clear
echo -e "${blueColour}[+] Reboot your terminal and enjoy it! ${defaultColour}"
