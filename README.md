# lime_pick
GIT 提交记录摘取器，支持将任何 git 提交记录合并到新分支，常用于将 dev 分支的提交拆分为小分支便于代码审查。

这是一个 shell 脚本，linux 版本已实现，windows  版筹划中。

在脚本第一行配置项目路径后方可使用。

## linux 调用

```shell
./lime_pick.sh
```

你也可以使用 source 调用

```shell
source lime_pick.sh
```

## windows 调用

双击 line_pick.bat 文件即可

## 快速上手

整个操作过程分为三步：

- 输入一个新分支

- 输入要摘取的提交 ID（每行一个）

- 推送到远端


**输入一个新分支**

输入分支名后，如果该分支已经存在，会显示容错提示：

> o: use old branch
>
> n: delete old branch and create new branch
>
> e: exit 0

输入 o 则使用 checkout 切换到老分支，输入 n，会删除旧分支后创建新分支，输入 e，则退出脚本。

**输入要摘取的提交 ID**

输入提交 ID 按下回车后， 会使用 cherry-pick 指令将对应提交记录摘取到当前分支，摘取后可以继续输入新的提交 ID，直到输入 n（next）指令进入下一步。

**推送到远端**

输入 y，执行推送操作，输入 n 退出，此时可以到项目目录查看提交记录。
