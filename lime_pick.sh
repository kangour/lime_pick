project_path=~/servers # project directory, it must be a git project


# lime_pick：GIT 提交记录摘取器，支持将任何 git 提交记录合并到新分支，常用于将 dev 分支的提交拆分为小分支便于代码审查。
#
# 作者：不才
# 邮箱：laobingm@qq.com
# 流程：切换 master 分支，输入新分支，输入提交 ID，推送
#
# 待做1：启动时添加参数，实现快速拆分支
#       参数格式：分支名 提交ID1 提交ID2 ...(用空格隔开)
# 待做2：用 -r 参数读取文本，实现批量拆分支
#       文本每行代表一个分支
#       每行格式：分支名 提交ID1 提交ID2 ...(用空格隔开)
#
# 日期：2019年5月22日
# 更新：
# 协作：


# operate confirm
# $1: tip, -z null adjuctment
function confirm(){
    while(( 1 == 1 ))
    do
        read -p "    $1？y/n：" answer
        if [ -z $answer ]
        then
            continue
        fi
        if [ $answer == 'Y' -o $answer == 'y' ]
        then
            echo true
        elif [ $answer == 'N' -o $answer == 'n' ]
        then
            echo false
        else
            continue
        fi
        break
    done
}

# wait enter some content
# $1: description
function input(){
    while(( 1 == 1 ))
    do
        read -p "    enter a $1：" answer
        if [ $answer ]
        then
            echo $answer
            break
        else
            continue
        fi
    done
}

# check if the branch already exists, -w exact modal
# $1: branch name
function check_branch_exist(){
    res=`git branch -a | grep -w $1`
    length=${#res}
    if [ $length == 0 ]
    then
        echo false
    else
        echo true
    fi
}

# if branch switch fails, exit
# $1: branch name
function branch_switch_status(){
    current_branch=`git rev-parse --abbrev-ref HEAD`
    if [ $current_branch != $1 ]
    then
        echo fatal: switch to the $1
        exit -1
    fi
}

# switch old branch
# $1: branch name
function checkout_branch(){
    git checkout $1
    branch_switch_status $1
}

# switch new branch
# $1: branch name
function checkout_new_branch(){
    git checkout -b $1
    branch_switch_status $1
}

# delete location branch
# $1: branch
function delete_branch(){
    checkout_branch master
    git branch -D $1
}

# init & status display
cd $project_path
git fetch
git remote prune origin
checkout_branch master

echo ''
git branch
echo ''
git log --oneline -5
echo ''

# input new branch name
echo create a new branch based on master
echo ''
branch_name=`input 'new branch name'`

# check the next step: switch old, create new or exit
echo ''
exist_branch=`check_branch_exist $branch_name`
if [ $exist_branch == true ]
then
    echo warning: $branch_name already exists
    echo ''
    echo o: use old branch
    echo n: delete old branch and create new branch
    echo e: exit 0
    echo ''
    while(( 1 == 1 ))
    do
        step_code=`input 'next step'`
        echo ''
        if [ $step_code == o ]
        then
            checkout_branch $branch_name
            break
        elif [ $step_code == n ]
        then
            delete_branch $branch_name
            checkout_new_branch $branch_name
            break
        elif [ $step_code == e ]
        then
            echo beby!
            exit 0
        else
            echo bad code
        fi
    done
else
    checkout_new_branch $branch_name
fi
echo ''

# pick commit records to branch
while(( 1 == 1 ))
echo n: next step
echo ''
do
    commit_id=`input 'picking commit id'`
    if [ $commit_id != n ]
    then
        git cherry-pick $commit_id
        echo branch $branch_name merged $commit_id
    else
        echo ''
        answer=$(confirm 'pick done')
        echo ''
        if [ $answer == true ]
        then
            echo pick done
            break
        else
            continue
        fi
    fi
done

# push branch to origin repository
echo ''
answer=$(confirm 'push now')
echo ''
if [ $answer == true ]
then
    git push --set-upstream origin $branch_name
else
    echo no push
fi
echo ''
echo lime_pick runs successfully!
