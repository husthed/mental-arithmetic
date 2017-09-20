#! /bin/bash

_arrayBased10=(1 2 3 4 5 6 7 8 9 10)
  
function rand() {    
    min=$1    
    max=$(($2-$min+1))    
    num=$RANDOM
    echo $(($num%$max+$min))    
}    

############################
# test rand
# $1 -- test loop number
# $2 -- the start number
# $3 -- the stop number
############################
function try_rand() {
    c=0
    printf "测试随机数生成器：区间为[%d, %d] 共%d次\n" $1 $2 $3
    while [ $c -lt $3 ]
    do
        c=$(($c+1))
        rnd=$(rand $1 $2)    
	    printf "第%d个随机数为: %d\n" $c $rnd
    done
}

LOG_FILE_NAME=".metal_arithmetic.log"

################################
# log function
# print log message into a file
################################
function log() {
    #printf "$*" | tee -a .metal_arithmetic.log
    printf "$*\n" >> ${LOG_FILE_NAME}
}

function callCalc() {
    v=""
    operand1=$2
    operand2=$3
    operator=$4
    while [ ${#v} -eq 0 ]
    do
        read -p "$1 ${operand1}${operator}${operand2}=" v
    done

    r=$(echo "${operand1}${operator}${operand2}"|bc)
    f=$(echo "${r} == ${v}"|bc)

    if [ ${f} = 1 ]; then
        log "✔ ${operand1}${operator}${operand2}=${v}"
    else
        log "✘ ${operand1}${operator}${operand2}=${v}(${r})"
    fi
    return ${f}
}

function _callAdd() {
    log "$(date)"

    c=0
    right=0
    startTime=$(date +%s)
    while [ $c -lt 10 ]
    do
        c=$(($c+1))
        length=${#_arrayBased10[@]}
        pos=$(($(rand 1 ${length})-1))
        operand1=${_arrayBased10[${pos}]}
        pos=$(($(rand 1 ${length})-1))
        operand2=${_arrayBased10[${pos}]}
        lastPos=$((${length}-1))
        while [ ${pos} -lt ${lastPos} ]
        do
            _arrayBased10[${pos}]=${_arrayBased10[$((${pos}+1))]}
            pos=$((${pos}+1))
        done
        unset _arrayBased10[${lastPos}]

        callCalc $c $operand1 $operand2 "+"
        right=$(($?+$right))

        #echo $r $right
    done

    endTime=$(date +%s)
    t=$(calTime $startTime $endTime)
    log "总共10题，正确${right}题, ${t}"

    tail -n 12 ${LOG_FILE_NAME}
}

function _callAddSub() {
    log "$(date)"

    minN=$1
    maxN=$2
    c=0
    right=0
    startTime=$(date +%s)
    while [ $c -lt 10 ]
    do
        c=$(($c+1))
        operand1=$(($(rand $minN $maxN)))
        operand2=$(($(rand $minN $maxN)))
        operator=$(($(rand $minN $maxN)))
        oddeven=$((operator / 2 * 2)) 
        if [ $operator -eq $oddeven ] 
        then
            operator="+"
        else
            operator="-"
            if [ $operand1 -lt $operand2 ]
            then
                oddeven=$operand1
                operand1=$operand2
                operand2=$oddeven
            fi
        fi

        callCalc $c $operand1 $operand2 $operator
        right=$(($?+$right))

        #echo $r $right
    done

    endTime=$(date +%s)
    t=$(calTime $startTime $endTime)
    log "总共10题，正确${right}题, ${t}"

    tail -n 12 ${LOG_FILE_NAME}
}

function callAddSub() {
    printf "\t\t加减\n"
    printf "\t1 加法口诀（1～10）\n"
    printf "\t2 两位数的加减法\n"
    printf "\t3 三位数的加减法\n"
    printf "\t4 综合\n"

    read -p "请输入选项1，2, 3或者4: " index

    if [ $index == "1" ] 
    then
        _callAdd
    elif [ $index == "2" ] 
    then
        _callAddSub 10 99
    elif [ $index == "3" ] 
    then
        _callAddSub 100 999
    elif [ $index == "4" ] 
    then
        _callAddSub 1 999
    else
        echo "选项未知，退出程序"
        exit
    fi

    return 0;
}

function _callMul() {
    log "$(date)"

    c=0
    right=0
    startTime=$(date +%s)
    while [ $c -lt 10 ]
    do
        c=$(($c+1))
        length=${#_arrayBased10[@]}
        pos=$(($(rand 1 ${length})-1))
        operand1=${_arrayBased10[${pos}]}
        pos=$(($(rand 1 ${length})-1))
        operand2=${_arrayBased10[${pos}]}
        lastPos=$((${length}-1))
        while [ ${pos} -lt ${lastPos} ]
        do
            _arrayBased10[${pos}]=${_arrayBased10[$((${pos}+1))]}
            pos=$((${pos}+1))
        done
        unset _arrayBased10[${lastPos}]

        callCalc $c $operand1 $operand2 "*"
        right=$(($?+$right))

        #echo $r $right
    done

    endTime=$(date +%s)
    t=$(calTime $startTime $endTime)
    log "总共10题，正确${right}题, ${t}"

    tail -n 12 ${LOG_FILE_NAME}
}

function _callMulDiv() {
    log "$(date)"

    minN=$1
    maxN=$2
    c=0
    right=0
    startTime=$(date +%s)
    while [ $c -lt 10 ]
    do
        c=$(($c+1))
        operand1=$(($(rand $minN $maxN)))
        operand2=$(($(rand $minN $maxN)))
        result=$(echo "${operand1}*${operand2}"|bc)
        operator=$(($(rand $minN $maxN)))
        oddeven=$((operator / 2 * 2)) 
        if [ $operator -eq $oddeven ] 
        then
            callCalc ${c} ${operand1} ${operand2} "*"
        else
            callCalc ${c} ${result} ${operand2} "/"
        fi

        right=$(($?+$right))

        #echo $r $right
    done

    endTime=$(date +%s)
    t=$(calTime $startTime $endTime)
    log "总共10题，正确${right}题, ${t}"

    tail -n 12 ${LOG_FILE_NAME}
}

function callMulDiv() {
    printf "\t\t乘除\n"
    printf "\t1 乘法口诀（1～10）\n"
    printf "\t2 综合\n"

    read -p "请输入选项1或者2: " index

    if [ $index == "1" ] 
    then
        _callMul
    elif [ $index == "2" ] 
    then
        _callMulDiv 2 99
    else
        echo "选项未知，退出程序"
        exit
    fi

    return 0;
}

function _doNormal() {
    #try_rand 1 3 10
    if [ $# = 1 ]
    then
        rnd=$(rand 1 3)
        case ${rnd} in
            "1") 
                operand1=25;;
            "2")
                operand1=125;;
            "3")
                operand1=3.14;;
            *)
                echo "错误的随机数\n"
                operand1=25;;
        esac
    elif [ $# = 2 ]
    then
        operand1=$2
    fi

    length=${#_arrayBased10[@]}
    pos=$(($(rand 1 ${length})-1))
    operand2=${_arrayBased10[${pos}]}
    lastPos=$((${length}-1))
    while [ ${pos} -lt ${lastPos} ]
    do
        _arrayBased10[${pos}]=${_arrayBased10[$((${pos}+1))]}
        pos=$((${pos}+1))
    done
    unset _arrayBased10[${lastPos}]

    callCalc $1 $operand1 $operand2 "*"
    return $?
}

function calTime() {
    startTime=$1
    endTime=$2
    t=$(($endTime - $startTime))
    hour=$(($t / 60 / 60))
    minute=$((($t - $hour * 60 * 60) / 60))
    second=$(($t - $hour * 60 * 60 - $minute * 60))

    echo "耗时$hour时$minute分$second秒"
    return 0
}

function _callNormal() {
    log "$(date)"

    c=0
    right=0
    startTime=$(date +%s)
    if [ $# == 0 ]
    then
        while [ $c -lt 10 ]
        do
            c=$(($c+1))
            _doNormal $c
            right=$(($?+$right))
            #echo $r $right
        done
    elif [ $# == 1 ]
    then
        while [ $c -lt 10 ]
        do
            c=$(($c+1))
            _doNormal $c $1
            right=$(($?+$right))
            #echo $r $right
        done
    fi

    endTime=$(date +%s)
    t=$(calTime $startTime $endTime)
    log "总共10题，正确${right}题, ${t}"

    tail -n 12 ${LOG_FILE_NAME}
}

function callNormal(){
    printf "\t\t常规计算\n"
    printf "\t1 25\n"
    printf "\t2 125\n"
    printf "\t3 3.14\n"
    printf "\t4 综合\n"

    read -p "请输入选项1，2, 3或者4: " index

    if [ $index == "1" ] 
    then
        _callNormal 25
    elif [ $index == "2" ] 
    then
        _callNormal 125
    elif [ $index == "3" ] 
    then
        _callNormal 3.14
    elif [ $index == "4" ] 
    then
        _callNormal
    else
        echo "选项未知，退出程序"
        exit
    fi
}

function _main(){
    clear
    printf "\t\t口心算\n"
    printf "\t1 加减\n"
    printf "\t2 乘除\n"
    printf "\t3 常规计算\n"

    read -p "请输入选项1，2或者3: " index

    if [ $index == "1" ] 
    then
        callAddSub
    elif [ $index == "2" ] 
    then
        callMulDiv
    elif [ $index == "3" ] 
    then
        callNormal
    else
        echo "选项未知，退出程序"
        exit
    fi
}

_main

