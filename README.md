# AD Lab generator
This scripts create a random set of users and groups, from de defined lists inside of .\code\data\

## Scripts
We have 3 scripts:
1. .\code\generate_schema.ps1
	- Creates a random schema of users and groups.
	- You can manually set the domain name inside the script by changing the variable
		```powershell
		# Set up domain name for testing...
		$domain = "xyz.local"
		```
	- You can pass a name for the json file that is generated in the command line. by default it's set to ad_schema.json
		```powershell
		.\generate_schema.ps1 -OutJSONFile {your_file}
		```
2. .\code\gen_ad.ps1
	- As imagined, this script populates the DC using the file created using generate_schema.ps1 script.
	- You can pass a name for the json file to be used in the command line. by default it's set to ad_schema.json
		```powershell
		.\gen_ad.ps1 -JSONFile {your_file}
		```
3. .\code\del_ad.ps1
	- As imagined, this script removes from the DC the users and groups using the file same file used to create it in the first place.
	- You can pass a name for the json file to be used in the command line. by default it's set to ad_schema.json
		```powershell
		.\del_ad.ps1 -JSONFile {your_file}
		```

## References
I created this script step by step. I tried to recreate what was shown by John Hammond (@johnhammond010) in his video series about AD. It follows the same structure as he did in his videos, but I changed some things my self to practice my powershell-fu...

JH repo -> https://github.com/JohnHammond/active_directory

Other references to create this scripts is VulnAD script -> https://github.com/safebuffer/vulnerable-AD

