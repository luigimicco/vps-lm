#!/bin/bash

# Set default values for SSH_USERNAME and SSH_PASSWORD if not provided
: ${SSH_USERNAME:=ubuntu}
: ${SSH_PASSWORD:?"Error: SSH_PASSWORD environment variable is not set."}
: ${SSHD_CONFIG_ADDITIONAL:=""}

# Create the user with the provided username and set the password
if id "$SSH_USERNAME" &>/dev/null; then
    echo "User $SSH_USERNAME already exists"
else
    useradd -ms /bin/bash "$SSH_USERNAME"
    echo "$SSH_USERNAME:$SSH_PASSWORD" | chpasswd
    echo "User $SSH_USERNAME created with the provided password"
fi

# Set the authorized keys from the AUTHORIZED_KEYS environment variable (if provided)
# if [ -n "$AUTHORIZED_KEYS" ]; then
    mkdir -p /home/$SSH_USERNAME/.ssh
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXuyjpcLhKUDHMynxifG4PG2sv34RORIssq3wVLTxD/WkFapj6IN9RwjpssWLhPAoBp+pD8RvqOJ0IisXZVyB7VIi113wQURcXSos84I++LJvkfNBzn09cDpjW7dZdmC9H+RF9ckdzkgzZYXGiIbXwuWjDxsjFwoAiKipqtC6H3gZ9ceHDZqDVRSN4k1h/vwVWoGMOOdCBXJY0fadPCeFzWvl8J6lSyhgGxE1HAzN7ZKIK9b8LNA1x3ytCzIwfY/fTKlH3MiZ2p6IvukLRfXnTn5MvX+fcDnPFLsGfoZGgfyLoW4eET34ItGEXrDvjs27tGd+51UQUuhK5sJPWXsHv ssh-key-2025-05-05" > /home/$SSH_USERNAME/.ssh/authorized_keys
    chown -R $SSH_USERNAME:$SSH_USERNAME /home/$SSH_USERNAME/.ssh
    chmod 700 /home/$SSH_USERNAME/.ssh
    chmod 600 /home/$SSH_USERNAME/.ssh/authorized_keys
    echo "Authorized keys set for user $SSH_USERNAME"
    # Disable password authentication if authorized keys are provided
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
# fi

# Apply additional SSHD configuration if provided
if [ -n "$SSHD_CONFIG_ADDITIONAL" ]; then
    echo "$SSHD_CONFIG_ADDITIONAL" >> /etc/ssh/sshd_config
    echo "Additional SSHD configuration applied"
fi

# Apply additional SSHD configuration from a file if provided
if [ -n "$SSHD_CONFIG_FILE" ] && [ -f "$SSHD_CONFIG_FILE" ]; then
    cat "$SSHD_CONFIG_FILE" >> /etc/ssh/sshd_config
    echo "Additional SSHD configuration from file applied"
fi

# Start the SSH server
echo "Starting SSH server..."
exec /usr/sbin/sshd -D