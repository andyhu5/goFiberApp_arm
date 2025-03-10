windows10 install ssh server

I'll guide you through setting up SSH from Ubuntu Linux to a Windows 10 OpenSSH server without using a password (using key-based authentication instead).

Here's a step-by-step process:

## On Ubuntu (SSH Client)

1. Generate SSH keys if you don't have them:

   ```bash
   ssh-keygen -t ed25519
   ```

   (Press Enter at all prompts to accept defaults)

2. Copy your public key:

   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

   Select and copy the output (starts with "ssh-ed25519" and ends with your username@hostname)

## On Windows 10 (SSH Server)

1. Ensure OpenSSH Server is installed:

   - Go to Settings > Apps > Optional features
   - Check if "OpenSSH Server" is listed
   - If not, click "Add a feature" and install it

2. Start and enable the OpenSSH Server service:

   ```powershell
   # Run PowerShell as Administrator
   Start-Service sshd
   Set-Service -Name sshd -StartupType 'Automatic'
   ```

3. Create/configure the authorized_keys file:

   ```powershell
   # Create .ssh directory if it doesn't exist
   New-Item -Path "$env:USERPROFILE\.ssh" -ItemType Directory -Force
   
   # Create or edit the authorized_keys file
   # Paste your copied public key into this file
   notepad "$env:USERPROFILE\.ssh\authorized_keys"
   ```

4. Set proper permissions:

   ```powershell
   # Restrict permissions on the .ssh directory
   icacls "$env:USERPROFILE\.ssh" /inheritance:r
   icacls "$env:USERPROFILE\.ssh" /grant:r "$($env:USERNAME):(F)"
   
   # Restrict permissions on the authorized_keys file
   icacls "$env:USERPROFILE\.ssh\authorized_keys" /inheritance:r
   icacls "$env:USERPROFILE\.ssh\authorized_keys" /grant:r "$($env:USERNAME):(F)"
   icacls "$env:USERPROFILE\.ssh\authorized_keys" /grant:r "system:(F)"
   ```

5. Verify the SSH server configuration:

   - Edit the file `C:\ProgramData\ssh\sshd_config`

   - Ensure these lines are uncommented (remove # if present):

     ```
     PubkeyAuthentication yes
     
     AuthorizedKeysFile .ssh/authorized_keys
     
     # 注释掉这两行;
     #Match Group administrators
     #       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys
     
     ```

   - Restart the SSH service:

     ```powershell
     Restart-Service sshd
     ```

## Connect from Ubuntu to Windows

Now test the connection:

```bash
ssh username@windows-ip-address
```

Replace "username" with your Windows username and "windows-ip-address" with your Windows machine's IP address.

If you still get a password prompt, you can use verbose mode to troubleshoot:

```bash
ssh -v username@windows-ip-address
```

This will give you more information about what might be going wrong with the key-based authentication.

## Debug

`ssh -i ~/.ssh/id_ed25519 -v sheng@192.168.2.10`

-v 可以发现ssh通讯细节

-i 指定公钥文件