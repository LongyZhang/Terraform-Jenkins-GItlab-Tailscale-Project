0: run sudo taislacle up on Jenkins ,gitlab and docker machine. and authenticate it 


1: add the tailscale ip address into the security group of jenkins machine , it allow the traffic from local machine to jenkins


2: download docker and docker compose on the gitlab machine

3: configure docker-compose.yml

version: '3.1'
services:
  gitlab:
    image: gitlab/gitlab-ce:latest
    restart: always
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'http://10.0.3.25:80'
        gitlab_rails['gitlab_shell_ssh_port'] = 22
    ports:
      - "80:80"
      - "443:443"
      - "22:22"
    volumes:
      - gitlab-config:/etc/gitlab
      - gitlab-logs:/var/log/gitlab
      - gitlab-data:/var/opt/gitlab

volumes:
  gitlab-config:
  gitlab-logs:
  gitlab-data:


4: docker exec -it gitlab_docker-gitlab-1 bash

cat /etc/gitlab/initial_root_password to get root password

sudo tailscale set --advertise-routes=10.0.5.0/24


