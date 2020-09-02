
export PIP_MIRRORS_URL="https://mirrors.aliyun.com/pypi/simple"
function use()
{
    echo "---------------------------------"
    echo "use: base start.sh ver                  # 显示版本"
    echo "use: base start.sh service              # 启动主服务"
    echo "use: base start.sh service update       # 启动主服务并更新"
    echo "use: base start.sh client               # 客户端测试"
    echo "---------------------------------"
}

cmd=${1}
param=${2}

case $cmd in
    ver)
        python -v
        exit 0
    ;;

esac
  use
exit 0;