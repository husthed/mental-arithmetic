##############################################
# real work for calculate power
##############################################
function _doPower() {
    length=${#_arrayPower[@]}
    pos=$(($(rand 1 ${length})-1))
    operand1=${_arrayPower[${pos}]}
    lastPos=$((${length}-1))
    while [ ${pos} -lt ${lastPos} ]
    do
        _arrayPower[${pos}]=${_arrayPower[$((${pos}+1))]}
        pos=$((${pos}+1))
    done
    unset _arrayPower[${lastPos}]

    result=$(echo "${operand1}*${operand1}"|bc)
    operator=$(($(rand 1 999)))
    oddeven=$((operator / 2 * 2)) 

    if [ $operator -eq $oddeven ] 
    then
        callCalc $1 ${operand1} ${operand1} "*"
    else
        callCalc $1 ${operand1} ${operand1} "*"
        #callCalc $1 ${result} ${operand1} "/"
    fi

    return $?
}

##############################################
# interface to do n*n
##############################################
function _callPower() {
    log "$(date)"

    c=0
    right=0
    startTime=$(date +%s)
    while [ $c -lt 10 ]
    do
        c=$(($c+1))
        _doPower $c
        right=$(($?+$right))
        #echo $r $right
    done

    endTime=$(date +%s)
    t=$(calTime $startTime $endTime)
    log "总共10题，正确${right}题, ${t}"

    #tail -n 12 ${LOG_FILE_NAME}
    echo -e ${LOG_BUFFER} | tee -a ${LOG_FILE_NAME}
}

##############################################
# real work for calculate 3.14
##############################################
function _doPI() {
    operand1=3.14

    length=${#_arrayPI[@]}
    pos=$(($(rand 1 ${length})-1))
    operand2=${_arrayPI[${pos}]}
    lastPos=$((${length}-1))
    while [ ${pos} -lt ${lastPos} ]
    do
        _arrayPI[${pos}]=${_arrayPI[$((${pos}+1))]}
        pos=$((${pos}+1))
    done
    unset _arrayPI[${lastPos}]

    result=$(echo "${operand1}*${operand2}"|bc)
    operator=$(($(rand 1 999)))
    oddeven=$((operator / 2 * 2)) 

    if [ $operator -eq $oddeven ] 
    then
        callCalc $1 ${operand1} ${operand2} "*"
    else
        callCalc $1 ${result} ${operand1} "/"
    fi

    return $?
}

##############################################
# interface to do 3.14 multi/div
##############################################
function _callPI() {
    log "$(date)"

    c=0
    right=0
    startTime=$(date +%s)
    while [ $c -lt 10 ]
    do
        c=$(($c+1))
        _doPI $c
        right=$(($?+$right))
        #echo $r $right
    done

    endTime=$(date +%s)
    t=$(calTime $startTime $endTime)
    log "总共10题，正确${right}题, ${t}"

    #tail -n 12 ${LOG_FILE_NAME}
    echo -e ${LOG_BUFFER} | tee -a ${LOG_FILE_NAME}
}

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
    f=$(echo "${operand1} == 125"|bc)
    if [ ${f} == 1 ]; then
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
function callNormal() {
    printf "\t\t常规计算\n"
    printf "\t1 25\n"
    printf "\t2 125\n"
    printf "\t3 3.14\n"
    printf "\t4 n*n\n"
    printf "\t5 综合\n"

    read -p "请输入选项1，2, 3, 4或者5: " index

    if [ $index == "1" ] 
    then
        _callNormal 25
    elif [ $index == "2" ] 
    then
        _callNormal 125
    elif [ $index == "3" ] 
    then
        _callPI
    elif [ $index == "4" ] 
    then
        _callPower
    elif [ $index == "5" ] 
    then
        _callNormal
    else
        echo "选项未知，退出程序"
        exit
    fi
}
