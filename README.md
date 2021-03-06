# [docker-centos-desktop-visualstudiocode](https://code.visualstudio.com)


<span style="float: right; padding-right: 20px; width: 600px; text-align: right; ">
<img src="http://i.imgur.com/MBKce09.png" style="margin-bottom: 35px; margin-right: 20px">
![docker](http://i.imgur.com/rAuZnDH.png)
</span>

Self-contained container deployment running on CentOS over VNC & RDP. 

This image comes with Visual Studio Code (insiders edition) and dependencies pre-installed. Start up the container, connect with a VNC client and you're up and running. There are several open-source VNC clients such as [TightVNC](www.tightvnc.com), [TigerVNC](tigervnc.org) and [Realvnc](https://www.realvnc.com/).
<!--![vscode](http://code.visualstudio.com/images/typescript_Languages_typescript.png)-->


## Connecting to the container over VNC

![vnc](http://i.imgur.com/7OycbKd.png)

## Building the Docker Image

```bash
$ cd docker-centos-desktop-visualstudiocode
$ docker build -t appsoa/docker-centos-desktop-visualstudiocode .          
```

## Starting the Container
You can remove a previously started vscode container by running `docker rm -f vscode`.

```bash
docker run -id  -e CONF_VNC_PASS=changeme \
                -e CONF_VNC_PORT=5901 \
                -p 5901:5901 \
                --name vscode \
                 appsoa/docker-centos-desktop-visualstudiocode


```

## Gaining a shell
As the default user "user" `docker exec -it vscode /bin/bash`. You can pass the `-u 0` argument if you need a root shell `docker exec -it -u 0 vscode /bin/bash`
## Create a persistent volume
Each container user has a persistent directory for maintaining settings & state.

0. Create a template/standard basic image:

    ```bash
    $ gcloud compute    disks create \
                        disk-name \
                        --description "Persistent Volume for user home directory." \
                        --size 10 \
                        --image user-template
    ```
0. Create disk image:

    ```
    $ gcloud compute images delete user-image -q
    $ gcloud compute images create user-image --source-disk user-template
    Created [https://www.googleapis.com/compute/v1/projects/virtualmachines-154415/global/images/algolab-user-image].
    NAME                PROJECT                 FAMILY  DEPRECATED  STATUS
    user-image  virtualmachines-154415                      READY
    ```

0. Attach new disk to a running VM
    
    If you need to make changes to the file system you can mount the new disk to any running vm.
    You will first use the gcloud cli to attach the disk and then perform a mount command on the host os.

    ```bash
    $ gcloud compute instances attach-disk large --disk algolab-user-template
    ```

0. Mount disk and update file(s)/directory(s):

    ```bash
    $ mount -o discard,defaults /dev/disk/by-id/google-persistent-disk-2 /home/user123
    $ ls -la /home/user123
    total 24
    drwxr-xr-x. 3 root root  4096 Jan 19 19:30 .
    drwxr-xr-x. 9 root root  4096 Jan 19 19:32 ..
    drwx------. 2 root root 16384 Jan 19 19:30 lost+found
    ```
0. Detach disk:

    ```bash
    $ gcloud compute instances detach-disk vm-instance-id --disk disk-name
    ```
0. Create a new, empty & formatted persistent disk

    After creating the persistent disk via the gcloud cli you will then format the disk using `mkfs.ext4`.
    Once formatted you can (optionally) mount the disk and make changes to the filesystem.

    ```bash
    $ gcloud compute instances attach-disk vm-instance-id --disk user-template
    $ gcloud compute instances detach-disk vm-instance-id --disk user-template
    
    $ sudo mkfs.ext4 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/disk/by-id/google-persistent-disk-2
        
        mke2fs 1.42.9 (28-Dec-2013)
        Discarding device blocks: done
        Filesystem label=
        OS type: Linux
        Block size=4096 (log=2)
       
        Stride=0 blocks, Stripe width=0 blocks
        32768000 inodes, 131072000 blocks
        6553600 blocks (5.00%) reserved for the super user
        First data block=0
        Maximum filesystem blocks=2279604224
        4000 block groups
        32768 blocks per group, 32768 fragments per group
        8192 inodes per group
        Superblock backups stored on blocks:
                32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
                4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
                102400000
    
        Allocating group tables: done
        Writing inode tables: done
        Creating journal (32768 blocks): done
        Writing superblocks and filesystem accounting information: done
    ```