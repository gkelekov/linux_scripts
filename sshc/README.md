# SSH Quick Connect

SSH Quick Connect is bash script for semi-automatic connection to all your servers using SSH connection.
It is created for - 2 click access and login to any SSH server you need.

#### Usage
  - Type **“sshc”** (or whatever alias you have configurated) in your terminal.
  - You will be prompted to select numbers of your DC and your server, and will be automatically connected via SSH to selected server.


#### Installation:
  - Download or "git pull" **sshc.sh** and **.sshconf** file.
  - Edit your bash or zsh rc file (.zshrc or .bashrc – found in home directory), by adding 1 line at the end of the file:
    ```sh
    alias sshc='bash file_path/sshc.sh'
    ```
    Be sure to add correct path to file.
  - Now edit your **.sshconf** file and add your DC’s, users, user keys, user passwords, and all servers you want to connect to. 
    Users are added in “conn” section, dc’s in “dc” section, particular server within their DC sections. 
    **Note**: be sure that name of DC in server dc sections are same as names in.
    Example: If your  AWS dc is named **“AWS”** 
    ```sh
    {
    "id": "dc0",
    "dcname": "AWS",
    "dcinfo": "AWS Frankfurt DC"
    },
    ```
    this **same name** MUST be used in servers section
    ```sh
    "AWS":  [
                {
                "id": "server0",
                "servername": "some_server_name",
                "serverip": "192.168.0.1",
                "serveruser": "1"
                }
    ```
  - SSH connection to servers is established via ssh password or user key. Predefined are only 2 users, one with password and one using key.
    If you need more add them to **.sshconf** and also in 
    ```sh
    connectServer ()
    ```
    function. (don’t forget to add new elif block for new user)
  - Also, for now, when adding new server in **.sshconfig**, requires also new line insert into **sshc.sh** file (adding new case with server number)
    ```sh
    "${server[1]}") 
	connectServer ${user[1]} ${server[1]} ${ip[1]}
	;;
    ```

Use/reconfigure/edit freely for your personal use.
