# bash-scripts

Random bash scripts I've created. Feel free to reach out with any questions @pentaroot or visit me at https://pentaroot.com.

*****

CurlooProxy.sh:
For when you are using a proxy and can't get any other brute-force URI scanner to work through that proxy (i.e. dirbuster, gobuster, dirb, etc.); or anytime you want a quick, command-line, URI brute-forcer.

Example usage: ./CurloopProxy.sh http://example.com /usr/share/wordlists/common.txt -p 127.0.0.1:8080 -e "txt,php,aspx"
