# Codespaces VNC
### a simple script to run a vnc server with xfce in a codespace
please keep in mind that you're risking your github account by doing this
### steps:

1. create a codespace
2. in the terminal, run:
```bash
chmod +x setup.sh
sudo ./setup.sh
```
(keep in mind it'll take a while since it has to download a lot of packages)

3. when prompted, set a user and root password
4. choose sddm when you're asked to choose a display manager
5. switch to the ports tab and open port 6080 in a new tab
6. when you get to the "directory listing" screen, click vnc.html
7. click connect, then open settings and set the scaling mode to local scaling
8. done! now do whatever you want
if your codespace shuts down, just reopen it and run reboot.sh
