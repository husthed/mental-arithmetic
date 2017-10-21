############################
# The addition formula
############################
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
    done

    endTime=$(date +%s)
    t=$(calTime $startTime $endTime)
    log "总共10题，正确${right}题, ${t}"

    #tail -n 12 ${LOG_FILE_NAME}
    echo -e ${LOG_BUFFER} | tee -a ${LOG_FILE_NAME}
}

########################################################
# calculate the addition and subtraction
########################################################
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

    #tail -n 12 ${LOG_FILE_NAME}
    echo -e ${LOG_BUFFER} | tee -a ${LOG_FILE_NAME}
}
 
#####################################
# main entry for add/sub
# 支持
# 1 加法口诀,从1+1到10+10
# 2 两位数的加减法,即操作数为10~99之间的数,比如
#   23+15=? 50-27=?
# 3 三位数的加减法,即操作数为100~999之间的数,比如
#   129+243=? 998-384=?
# 4 综合,即操作数为1~999之间的数,比如
#   20+400=? 400-20
#####################################
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
