##############################################
# real work for calculate 25/125/3.14
##############################################
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

    #callCalc $1 $operand1 $operand2 "*"

    result=$(echo "${operand1}*${operand2}"|bc)
    operator=$(($(rand 1 999)))
    oddeven=$((operator / 2 * 2)) 

    # for 125, only do multiply now
    if [ $operand1 -eq 125 ]
    then
        oddeven=$operator
    fi

    if [ $operator -eq $oddeven ] 
    then
        callCalc $1 ${operand1} ${operand2} "*"
    else
        callCalc $1 ${result} ${operand1} "/"
    fi

    return $?
}

##############################################
# interface to do 25/125/3.14 multi/div
##############################################
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

    #tail -n 12 ${LOG_FILE_NAME}
    echo -e ${LOG_BUFFER} | tee -a ${LOG_FILE_NAME}
}

#####################################
# main entry for 常规练习
# 支持
# 1 25的乘除法
# 2 125的乘除法
# 3 3.14的乘除法
# 4 综合: 25/125/3.14的乘除法
#####################################
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
