#! /bin/bash
. ./mental_comm.sh
. ./mental_add.sh
. ./mental_mul.sh
. ./mental_normal.sh
. ./mental_rapid.sh

function _main(){
    clear
    while :
    do
        printf "\t\t口心算\n"
        printf "\t1 加减\n"
        printf "\t2 乘除\n"
        printf "\t3 常规计算\n"
        printf "\t4 速算\n"
        printf "\t5 退出\n"

        read -p "请输入选项1，2, 3, 4或者5: " index

        if [ $index == "1" ] 
        then
            callAddSub
        elif [ $index == "2" ] 
        then
            callMulDiv
        elif [ $index == "3" ] 
        then
            callNormal
        elif [ $index == "4" ] 
        then
            callRapid
        else
            echo "选项未知，退出程序"
            exit
        fi
    done
}

_main
