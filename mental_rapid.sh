############################
# 个位数为1/9的乘法速算
############################
function _callUnitDigit() {
    log "$(date)"

    echo -e $2
    c=0
    right=0
    startTime=$(date +%s)
    while [ $c -lt 10 ]
    do
        c=$(($c+1))
        length=${#_arraySingleDigital[@]}
        pos=$(($(rand 1 ${length})-1))
        operand1=${_arraySingleDigital[${pos}]}
        pos=$(($(rand 1 ${length})-1))
        operand2=${_arraySingleDigital[${pos}]}
        #lastPos=$((${length}-1))
        #while [ ${pos} -lt ${lastPos} ]
        #do
        #    _arraySingleDigital[${pos}]=${_arraySingleDigital[$((${pos}+1))]}
        #    pos=$((${pos}+1))
        #done
        #unset _arraySingleDigital[${lastPos}]

        callCalc $c $((operand1 * 10 + $1)) $((operand2 * 10 + $1)) "*"
        right=$(($?+$right))
    done

    endTime=$(date +%s)
    t=$(calTime $startTime $endTime)
    log "总共10题，正确${right}题, ${t}"

    #tail -n 12 ${LOG_FILE_NAME}
    echo -e ${LOG_BUFFER} | tee -a ${LOG_FILE_NAME}
}

############################
# 十位数为1/9的乘法速算
############################
function _callTenDigit() {
    log "$(date)"

    echo -e $2
    c=0
    right=0
    startTime=$(date +%s)
    while [ $c -lt 10 ]
    do
        c=$(($c+1))
        length=${#_arraySingleDigital[@]}
        pos=$(($(rand 1 ${length})-1))
        operand1=${_arraySingleDigital[${pos}]}
        pos=$(($(rand 1 ${length})-1))
        operand2=${_arraySingleDigital[${pos}]}
        #lastPos=$((${length}-1))
        #while [ ${pos} -lt ${lastPos} ]
        #do
        #    _arraySingleDigital[${pos}]=${_arraySingleDigital[$((${pos}+1))]}
        #    pos=$((${pos}+1))
        #done
        #unset _arraySingleDigital[${lastPos}]

        callCalc $c $((operand1 + $1)) $((operand2 + $1)) "*"
        right=$(($?+$right))
    done

    endTime=$(date +%s)
    t=$(calTime $startTime $endTime)
    log "总共10题，正确${right}题, ${t}"

    #tail -n 12 ${LOG_FILE_NAME}
    echo -e ${LOG_BUFFER} | tee -a ${LOG_FILE_NAME}
}

############################
# 补数乘法速算
############################
function _callSupplement() {
    log "$(date)"

    echo -e $2
    c=0
    right=0
    startTime=$(date +%s)
    while [ $c -lt 10 ]
    do
        c=$(($c+1))
        length=${#_arraySingleDigital[@]}
        pos=$(($(rand 1 ${length})-1))
        operand1=${_arraySingleDigital[${pos}]}
        pos=$(($(rand 1 ${length})-1))
        operand2=${_arraySingleDigital[${pos}]}
        #lastPos=$((${length}-1))
        #while [ ${pos} -lt ${lastPos} ]
        #do
        #    _arraySingleDigital[${pos}]=${_arraySingleDigital[$((${pos}+1))]}
        #    pos=$((${pos}+1))
        #done
        #unset _arraySingleDigital[${lastPos}]

        if [ $1 -eq 0 ]
        then
            # 头相同,尾互补
            h=$((operand1 * 10))
            t=$((10 - operand2))
            operand1=$((h + operand2))
            operand2=$((h + t))
        elif [ $1 -eq 1 ]
        then
            # 尾相同,头互补
            h=$((10 - operand1))
            operand1=$((operand1 * 10 + operand2))
            operand2=$((h * 10 + operand2))
        elif [ $1 -eq 2 ]
        then
            # 互补数乘叠数
            operand1=$((operand1 * 10 + 10 - operand1))
            operand2=$((operand2 * 10 + operand2))
        fi
        callCalc $c ${operand1} ${operand2} "*"
        right=$(($?+$right))
    done

    endTime=$(date +%s)
    t=$(calTime $startTime $endTime)
    log "总共10题，正确${right}题, ${t}"

    #tail -n 12 ${LOG_FILE_NAME}
    echo -e ${LOG_BUFFER} | tee -a ${LOG_FILE_NAME}
}

############################
# 给定一个数,任意一个两位数随机
############################
function _callRandom() {
    log "$(date)"

    operand2=$1
    echo -e $2
    c=0
    right=0
    startTime=$(date +%s)
    while [ $c -lt 10 ]
    do
        c=$(($c+1))
        length=${#_arraySingleDigital[@]}
        pos=$(($(rand 1 ${length})-1))
        i=${_arraySingleDigital[${pos}]}
        pos=$(($(rand 1 ${length})-1))
        j=${_arraySingleDigital[${pos}]}
        operand1=$(echo "${i}*10+${j}"|bc)

        callCalc $c ${operand1} ${operand2} "*"
        right=$(($?+$right))
    done

    endTime=$(date +%s)
    t=$(calTime $startTime $endTime)
    log "总共10题，正确${right}题, ${t}"

    #tail -n 12 ${LOG_FILE_NAME}
    echo -e ${LOG_BUFFER} | tee -a ${LOG_FILE_NAME}
}

#####################################
# main entry for 乘法速算
#####################################
function callRapid() {
    printf "\t\t速算\n"
    printf "\t1 个位数为1\t2 十位数为1\n"
    printf "\t3 个位数为9\t4 十位数为9\n"
    printf "\t5 头相同,尾互补\t6 尾相同,头互补\n"
    printf "\t7 互补数乘叠数\t8 xy*99\n"
    printf "\t9 10x*10y\t10 xy*叠数??????\n"

    _arraySingleDigital=(1 2 3 4 5 6 7 8 9)
  
    read -p "请输入选项1，2, 3, 4, 5, 6, 7, 8或者9: " index

    if [ $index == "1" ] 
    then
        _callUnitDigit 1 "x1*y1的速算口诀:\n头乘头，头加头，尾是1（头加头如果超过10要进位）"
    elif [ $index == "2" ] 
    then
        _callTenDigit 10 "1x*1y的速算口诀:\n头是1，尾加尾，尾乘尾（超过10要进位）"
    elif [ $index == "3" ] 
    then
        _callUnitDigit 9 "x9*y9的速算口诀:\n头数各加1 ，相乘再乘10，减去相加数，最后再放1"
    elif [ $index == "4" ] 
    then
        _callTenDigit 90 "9x*9y的速算口诀:\n\t方法1:尾数相加再加80作为头,100减大家，结果相互乘,占两位.\n\t方法2:100减前数，再被后数减。100减大家，结果相互乘，占2位"
    elif [ $index == "5" ] 
    then
        _callSupplement 0 "头相同,尾互补速算口诀:\n头乘头加1，尾乘尾占2位."
    elif [ $index == "6" ] 
    then
        _callSupplement 1 "尾相同,头互补速算口诀:\n头乘头加尾，尾乘尾占2位."
    elif [ $index == "7" ] 
    then
        _callSupplement 2 "互补数乘叠数速算口诀:\n头加1再乘头，尾乘尾占2位."
    elif [ $index == "8" ] 
    then
        _callRandom 99 "xy*99速算公式:\nxy*99=(xy-1)*100+(100-xy)=xy*100-xy."
    elif [ $index == "9" ] 
    then
        _callTenDigit 100 "10x*10y速算公式:\n10x*10y=(10x+y)*100+(x*y)."
    elif [ $index == "10" ] 
    then
        #_callRandom  "xy*叠数:\n"
        echo "Nothing to do"
    else
        echo "选项未知，退出程序"
        exit
    fi

    return 0;
}
