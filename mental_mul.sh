############################################################
# 乘法口诀
############################################################
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

    #tail -n 12 ${LOG_FILE_NAME}
    echo -e ${LOG_BUFFER} | tee -a ${LOG_FILE_NAME}
}

########################################################
# calculate the multiply and divide
########################################################
function _callMulDiv() {
    log "$(date)"

    minN=$1
    maxN=$2
    num=$3
    c=0
    right=0
    startTime=$(date +%s)
    while [ $c -lt 10 ]
    do
        c=$(($c+1))
        if [ $num -eq 1 ]
        then
            length=${#_arrayBased10[@]}
            pos=$(($(rand 1 ${length})-1))
            operand1=${_arrayBased10[${pos}]}
            lastPos=$((${length}-1))
            while [ ${pos} -lt ${lastPos} ]
            do
                _arrayBased10[${pos}]=${_arrayBased10[$((${pos}+1))]}
                pos=$((${pos}+1))
            done
            unset _arrayBased10[${lastPos}]
        else
            operand1=$(($(rand $minN $maxN)))
        fi

        operand2=$(($(rand $minN $maxN)))
        result=$(echo "${operand1}*${operand2}"|bc)
        operator=$(($(rand $minN $maxN)))
        oddeven=$((operator / 2 * 2)) 

        if [ $operator -eq $oddeven ] 
        then
            callCalc ${c} ${operand1} ${operand2} "*"
        else
            callCalc ${c} ${result} ${operand1} "/"
        fi

        right=$(($?+$right))

        #echo $r $right
    done

    endTime=$(date +%s)
    t=$(calTime $startTime $endTime)
    log "总共10题，正确${right}题, ${t}"

    #tail -n 12 ${LOG_FILE_NAME}
    echo -e ${LOG_BUFFER} | tee -a ${LOG_FILE_NAME}
}

#####################################
# main entry for mul/div
# 支持
# 1 乘法口诀,从1*1到10*10
# 2 两位数的乘除法,即一个操作数为1~10之间的数,
#   另外一个操作数为10~99之间的数,比如
#   24*7=? 280/7=?
# 3 三位数的乘除法,即一个操作数为1~10之间的数,
#   另外一个操作数为100~999之间的数,比如
#   129*5=? 620/5=?
# 4 综合,即操作数为1~999之间的数,比如
#   230*201=?
#####################################
function callMulDiv() {
    printf "\t\t乘除\n"
    printf "\t1 乘法口诀（1～10）\n"
    printf "\t2 两位数乘除法\n"
    printf "\t3 三位数乘除法\n"
    printf "\t4 综合\n"

    read -p "请输入选项1，2, 3或者4: " index

    if [ $index == "1" ] 
    then
        _callMul
    elif [ $index == "2" ] 
    then
        _callMulDiv 10 99 1
    elif [ $index == "3" ] 
    then
        _callMulDiv 100 999 1
    elif [ $index == "4" ] 
    then
        _callMulDiv 2 999 2
    else
        echo "选项未知，退出程序"
        exit
    fi

    return 0;
}
