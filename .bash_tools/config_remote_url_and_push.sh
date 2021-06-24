
#!/bin/bash

remote_gitlab=origin
remote_github=origin-github

# 每个项目需要单独配置此项 ./remote_config
shellDir=$(dirname $0)
cd $shellDir
echo -e "shellDir:$shellDir\npwd:$(pwd)"

git_root_path=$(pwd)/../

show_local_config()
{
	gitlab_url=$(cat .remote_config|grep gitlab|sed -n '1p')
	github_url=$(cat .remote_config|grep github|sed -n '1p')

	echo -e  "---------读取到本地配置:------------\ngitlab_url:$gitlab_url\ngithub_url:$github_url\n----------------------------\n"	
}




config_remote_url_and_push()
{
	remote_name=$1
	remote_url=$2
	echo -e "--------------尝试配置远程仓库[$remote_name]:$remote_url (如果git尚未配置$remote_name) ----------"
	if [[ $remote_url == "" ]]; then
		echo -e "remote_url为空！！"
	else
		if [ -z "$(git config remote.${remote_name}.url)" ]; then
			# 修改remote.origin.url
			echo -e "--------------修改前 remote.[${remote_name}].url:$(git config remote.${remote_name}.url) ----------"
			echo -e "检测到未配置remote.${remote_name}.url"
			git remote add $remote_name $remote_url
			echo -e "--------------修改后 remote.[${remote_name}].url:$(git config remote.${remote_name}.url) ----------"
		else
			echo -e "--------------读取到仓库配置非空 remote.[${remote_name}].url:$(git config remote.${remote_name}.url) ----------"
		fi

		

		# git add;git commit;git push
		if [[ $remote_name == $remote_github ]]; then
			# 无需重复执行git add; git commit等操作
			echo -e "无需重复执行git add; git commit等操作"
		else
			echo -e "--------------执行git add;git commit;git push.... ----------"
			cd $git_root_path/
			git add .
			git commit -m ".";
		fi
		echo -e "--------------	同步到远程仓库/分支([$remote_name/master])..."
		echo -e "🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀[master]․․․․․․․․․>[$remote_name/master]🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀"
		git push $remote_name master
		echo -e '-----------------things done!!!---------------\n\n'
		
	fi
}

main()
{
	echo -e "====================== 执行git push 操作开始 ======================"
	echo -e "====================== pwd:🏠🏠🏠🏠🏠🏠🏠🏠🏠🏠[$(pwd)]🏠🏠🏠🏠🏠🏠🏠🏠🏠\n脚本执行开始时间:$(date) =========================="

	show_local_config
	
	config_remote_url_and_push $remote_gitlab $gitlab_url
	config_remote_url_and_push $remote_github $github_url
	
	echo -e "====================== 执行git push 操作结束 ======================"
	echo -e "====================== pwd:[$(pwd)] 脚本执行结束时间:$(date) =========================="
	echo -e "✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅\n\n"

}

main	