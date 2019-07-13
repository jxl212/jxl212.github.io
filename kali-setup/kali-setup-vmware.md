# My Kali Setup
from https://docs.kali.org/general-use/kali-linux-sources-list-repositories

# sources.list
> **Kali Rolling is the primary repository that most users should be using**

> Kali Rolling users are expected to have the following entries in their sources.list:
```bash
    deb http://http.kali.org/kali kali-rolling main non-free contrib
```

---
## Installing VMware Tools in Kali Linux Rolling
> install open-vm-tools in Kali, first make sure you are fully updated, and then enter the following:

```bash
apt update && apt -y full-upgrade

# Reboot now in case you have updated to a new kernel. Once rebooted:
apt -y --reinstall install open-vm-tools-desktop fuse
reboot
```

## Adding Support for Shared Folders
> Unfortunately, shared folders will not work out of the box. To enable this feature for your current session, you will need to execute the following script after logging in:

[enable-shared-folders](scripts/enable-shared-folders.sh)
```bash
cat <<EOF > /usr/local/sbin/mount-shared-folders
#!/bin/sh
vmware-hgfsclient | while read folder; do
  vmwpath="/mnt/hgfs/\${folder}"
  echo "[i] Mounting \${folder}   (\${vmwpath})"
  sudo mkdir -p "\${vmwpath}"
  sudo umount -f "\${vmwpath}" 2>/dev/null
  sudo vmhgfs-fuse -o allow_other -o auto_unmount ".host:/\${folder}" "\${vmwpath}"
done
sleep 2s
EOF
sudo chmod +x /usr/local/sbin/mount-shared-folders
```
