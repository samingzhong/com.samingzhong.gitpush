
#!/bin/bash

echo -e "====================== pwd:[$(pwd)] 脚本执行开始时间:$(date) =========================="

# 每个项目需要单独配置此项 ./remote_config
shellDir=$(dirname $0)
cd $shellDir
echo -e "shellDir:$shellDir\npwd:$(pwd)"

git_root_path=$(pwd)/../

gitlab_url=$(cat .remote_config|grep gitlab|sed -n '1p')
github_url=$(cat .remote_config|grep github|sed -n '1p')

echo -e  "---------读取到本地配置:------------\ngitlab_url:$gitlab_url\ngithub_url:$github_url\n--------------\n"


config_remote_url_and_push()
{
	remote_name=$1
	remote_url=$2
	echo -e "--------------配置远程仓库[$remote_name]:$remote_url ----------"
	if [[ $remote_url == "" ]]; then
		echo -e "remote_url为空！！"
	else
		if [[ $(git config remote.${remote_name}.url) == "" ]]; then
			# 修改remote.origin.url
			echo -e "--------------修改前 remote.[${remote_name}].url:$(git config remote.${remote_name}.url) ----------"
			echo -e "未配置remote.${remote_name}.url"
			git remote add $remote_name $remote_url
			echo -e "--------------修改后 remote.[${remote_name}].url:$(git config remote.${remote_name}.url) ----------"
		else
			echo -e "--------------读取仓库配置 remote.[${remote_name}].url:$(git config remote.${remote_name}.url) ----------"
		fi

		

		# git add;git commit;git push
		if [[ $remote_name == "origin-github" ]]; then
			# 无需重复执行git add; git commit等操作
			echo -e "无需重复执行git add; git commit等操作"
		else
			echo -e "--------------执行git add;git commit;git push.... ----------"
			cd $git_root_path/
			git add .
			git commit -m ".";
		fi
		echo -e "----同步到远程仓库/分支([$remote_name/master])..."
		git push -f $remote_name master
		echo -e '-----------------things done!!!---------------\n'
		
	fi
}

config_remote_url_and_push origin $gitlab_url
config_remote_url_and_push origin-github $github_url

echo -e "====================== pwd:[$(pwd)] 脚本执行结束时间:$(date) ==========================\n\n"
