#!/bin/bash
echo "Running user data..." > /home/ec2-user/user_data.log
yum install -y vim  >> /home/ec2-user/user_data.log 
sudo yum install -y python3 >> /home/ec2-user/user_data.log 
sudo -u ec2-user pip3 install --user ansible
echo "User data completed." >> /home/ec2-user/user_data.log
echo "Ansible version:" >> /home/ec2-user/user_data.log
ansible --version >> /home/ec2-user/user_data.log
sudo -u ec2-user pip3 install --user ansible

#!/bin/bash
cd /tmp
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

#!/bin/bash
curl -fsSL https://tailscale.com/install.sh | sh


    #!/bin/bash

    # Define variables
    VOLUME_DEVICE="/dev/xvdh" # Adjust based on your volume's device name
    MOUNT_POINT="/data" # Desired mount point

    # Check if the volume is already formatted
    if ! file -s "$VOLUME_DEVICE" | grep -q filesystem; then
        echo "Formatting $VOLUME_DEVICE with XFS..."
        sudo mkfs -t xfs "$VOLUME_DEVICE"
    else
        echo "$VOLUME_DEVICE is already formatted."
    fi

    # Create the mount point if it doesn't exist
    if [ ! -d "$MOUNT_POINT" ]; then
        echo "Creating mount point $MOUNT_POINT..."
        sudo mkdir -p "$MOUNT_POINT"
    fi

    # Add an entry to /etc/fstab for automatic mounting on reboot
    # Use UUID for robust mounting
    UUID=$(sudo blkid -s UUID -o value "$VOLUME_DEVICE")
    if ! grep -q "$MOUNT_POINT" /etc/fstab; then
        echo "Adding entry to /etc/fstab..."
        echo "UUID=$UUID $MOUNT_POINT xfs defaults,nofail 0 2" | sudo tee -a /etc/fstab
    else
        echo "$MOUNT_POINT already in /etc/fstab."
    fi

    # Mount the volume
    echo "Mounting $VOLUME_DEVICE to $MOUNT_POINT..."
    sudo mount -a


    sudo tailscale up --advertise-routes=10.0.3.0/24 --accept-dns=false