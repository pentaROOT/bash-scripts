#!/bin/bash
echo -e "#---------------------------------------------------------------#"
echo -e "# Name         = CurlooProxy                                   #"
echo -e "# Author       = @pentaROOT                                    #"
echo -e "# Website      = https://pentaroot.com                         #"
echo -e "#---------------------------------------------------------------#"\\n

#Set Script Name variable

SCRIPT=`basename ${BASH_SOURCE[0]}`

# Help function

function HELP {
  echo -e "Basic usage: ./CurloopProxy.sh -u <URL/IP_Address> -w <PATH_TO_WORDLIST>"\\n
  echo -e "The following switches are recognized:"\\n
  echo "-u 	--Sets the value for the URL/IP to use. Required."
  echo "-w 	--Sets the path of the wordlist to use. Required."
  echo "-p 	--Sets the value for the proxy to use. Format: <IP>:<port>"
  echo '-e	--Sets options for extensions. Format: "ext,ext,ext"'
  echo -e "-h	--Displays this help message."\\n
  echo -e 'Example: ./CurloopProxy.sh -u http://example.com -w /usr/share/wordlists/common.txt -p 127.0.0.1:8080 -e "txt,php,aspx"'\\n
  exit 1
}

# Booleans for required getopts

u_flag=false
w_flag=false
p_flag=false
e_flag=false

# Start getopts 

while getopts "e:u:w:p:h" optKey; do
	case $optKey in
		u)
			u=$OPTARG; u_flag=true
			;;
		w)
			w=$OPTARG; w_flag=true
			;;
		p)
			p=$OPTARG; p_flag=true
			;;
		e)
			set -f
			IFS=','
			array=($OPTARG); e_flag=true
			;;
		h|*)
			HELP
			;;
	esac
done

shift $((OPTIND - 1))

if [[ $u_flag == false ]];then
	echo -e "		The -u flag must be set"\\n\\n
	HELP
elif [[ $w_flag == false ]];then
	echo -e "		The -w flag must be set"\\n\\n
	HELP
else
	:
fi

if [[ $e_flag == true ]];then
	cnt=${#array[@]}
	for ((i=0;i<cnt;i++)); do
		array[i]=".${array[i]}"
	done
	array=("" "/" "${array[@]}")
else
	array=("" "/")
fi

if [[ "${u: -1}" == "/" ]];then
	u="${u::-1}"
fi

if [ "${p_flag}" == true ];then
	echo "Flags set:"
	echo "URL = ${u}"
	echo "Wordlist = ${w}"
	echo "Proxy = ${p}"
	echo -n "Extensions = "
	for i in "${array[@]}"; do
		echo -n "${i},"
	done
	printf "\b \n"\\n
else
	echo "Flags set:"
	echo "URL = ${u}"
	echo "Wordlist = ${w}"
        echo -n "Extensions = "
        for i in "${array[@]}"; do
                echo -n "${i},"
        done
	printf "\b \n"\\n
fi

# Check if curl is installed

if ! [ -x "$(command -v curl)" ]; then
  echo 'Error: curl is not installed.' >&2
  exit 1
fi

# Perform curl requests

while read line; do
	for ext in "${array[@]}";do
        	if [ "${p_flag}" == true ];then
			request=$(curl -s --silent --write-out %{http_code} --output /dev/null --socks4 "${p}" "${u}"/"${line}""${ext}")
		else
			request=$(curl -s --silent --write-out %{http_code} --output /dev/null "${u}"/"${line}""${ext}")
		fi

		if [[ $request == 404* ]];then
	                :
		elif [[ $request == 403* ]];then
	                :
	        else
	                echo "$line$ext $request"
	        fi
	done
done < "${w}"

echo ""
