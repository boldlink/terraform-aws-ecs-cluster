#!/bin/bash

# Install AWS SSM agent for different OS versions
os_type=$(uname -m)
os_release=$(grep -oP '(?<=^ID=).+' /etc/os-release | tr -d '"')

if [ "$${os_type}" == "x86_64" ]; then
	if [ "$${os_release}" == "amzn" ]; then
		sudo yum update -y
		sudo yum install wget -y
		wget ${ssm_urls.amazon_linux_x86_64}
		sudo rpm --install amazon-ssm-agent.rpm
	elif [ "$${os_release}" == "debian" ] || [ "$${os_release}" == "ubuntu" ]; then
		mkdir ${ssm_temp_dir} && cd ${ssm_temp_dir}
		sudo apt-get update
		sudo apt-get install wget -y
		wget ${ssm_urls.debian_ubuntu_x86_64}
		sudo dpkg -i amazon-ssm-agent.deb

	elif [ "$${os_release}" == "centos" ] && [ "$(grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"' | awk -F. '{print $1}')" == "8" ] || [ "$(grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"' | awk -F. '{print $1}')" == "9" ]; then
		sudo dnf update -y
		sudo dnf install wget -y
		wget ${ssm_urls.centos_rhel_x86_64}
		sudo rpm --install amazon-ssm-agent.rpm

	elif [ "$${os_release}" == "centos" ] && [ "$(grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"' | awk -F. '{print $1}')" == "7" ]; then
		sudo yum update -y
		sudo yum install wget -y
		wget ${ssm_urls.centos_rhel_x86_64}
		sudo rpm --install amazon-ssm-agent.rpm

	elif [ "$${os_release}" == "centos" ] && [ "$(grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"' | awk -F. '{print $1}')" == "6" ]; then
		sudo yum update -y
		sudo yum install wget -y
		wget ${ssm_urls.centos6_x86_64}
		sudo rpm --install amazon-ssm-agent-${ssm_agent_version_centos6}.rpm

	elif [ "$${os_release}" == "ubuntu" ]; then
		sudo apt-get update
		sudo apt-get install wget -y
		mkdir ${ssm_temp_dir} && cd ${ssm_temp_dir}
		if command -v snap >/dev/null 2>&1; then
			wget ${ssm_urls.ubuntu_snap_x86_64}
			sudo snap install --dangerous --classic amazon-ssm-agent.snap
		else
			wget ${ssm_urls.debian_ubuntu_x86_64}
			sudo dpkg -i amazon-ssm-agent.deb
		fi

	elif [ "$${os_release}" == "sles" ] || [ "$${os_release}" == "opensuse-leap" ]; then
		sudo zypper update -y
		sudo zypper install wget -y
		wget ${ssm_urls.suse_x86_64}
		sudo rpm --install amazon-ssm-agent.rpm

	elif [ "$${os_release}" == "rhel" ]; then
		sudo yum update -y
		sudo yum install wget -y
		wget ${ssm_urls.centos_rhel_x86_64}
		sudo rpm --install amazon-ssm-agent.rpm
	fi

elif [ "$${os_type}" == "aarch64" ]; then
	if [ "$${os_release}" == "amzn" ]; then
		sudo yum update -y
		sudo yum install wget -y
		wget ${ssm_urls.amazon_linux_arm64}
		sudo rpm --install amazon-ssm-agent.rpm
	elif [ "$${os_release}" == "debian" ] || [ "$${os_release}" == "ubuntu" ]; then
		mkdir ${ssm_temp_dir} && cd ${ssm_temp_dir}
		sudo apt-get update
		sudo apt-get install wget -y
		wget ${ssm_urls.debian_ubuntu_arm64}
		sudo dpkg -i amazon-ssm-agent.deb

	elif [ "$${os_release}" == "centos" ] && [ "$(grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"' | awk -F. '{print $1}')" == "8" ] || [ "$(grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"' | awk -F. '{print $1}')" == "9" ]; then
		sudo dnf update -y
		sudo dnf install wget -y
		wget ${ssm_urls.centos_rhel_arm64}
		sudo rpm --install amazon-ssm-agent.rpm

	elif [ "$${os_release}" == "centos" ] && [ "$(grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"' | awk -F. '{print $1}')" == "7" ]; then
		sudo yum update -y
		sudo yum install wget -y
		wget ${ssm_urls.centos_rhel_arm64}
		sudo rpm --install amazon-ssm-agent.rpm

	elif [ "$${os_release}" == "ubuntu" ]; then
		sudo apt-get update
		sudo apt-get install wget -y
		mkdir ${ssm_temp_dir} && cd ${ssm_temp_dir}
		if command -v snap >/dev/null 2>&1; then
			wget ${ssm_urls.ubuntu_snap_arm64}
			sudo snap install --dangerous --classic amazon-ssm-agent.snap
		else
			wget ${ssm_urls.debian_ubuntu_arm64}
			sudo dpkg -i amazon-ssm-agent.deb
		fi

	elif [ "$${os_release}" == "sles" ] || [ "$${os_release}" == "opensuse-leap" ]; then
		sudo zypper update -y
		sudo zypper install wget -y
		wget ${ssm_urls.suse_arm64}
		sudo rpm --install amazon-ssm-agent.rpm

	elif [ "$${os_release}" == "rhel" ]; then
		sudo yum update -y
		sudo yum install wget -y
		wget ${ssm_urls.centos_rhel_arm64}
		sudo rpm --install amazon-ssm-agent.rpm
	fi
fi

# Start the SSM agent
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
