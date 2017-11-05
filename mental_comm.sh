
# log file which record the result
LOG_FILE_NAME=".metal_arithmetic.log"
LOG_BUFFER=""

# array which has 10 elements from 1 to 10
_arrayBased10=(1 2 3 4 5 6 7 8 9 10)
_arraySingleDigital=(1 2 3 4 5 6 7 8 9)
_arrayPI=(2 3 4 5 6 7 8 9 16 25 36)
_arrayPower=(2 3 4 5 6 7 8 9 11 12 13 14 15 16 17 18 19)
  
############################
# generate random number
# $1 -- the start number
# $2 -- the stop number
############################
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

################################
# log function
# print log message into a file
################################
function log() {
    #printf "$*" | tee -a .metal_arithmetic.log
    #printf "$*\n" >> ${LOG_FILE_NAME}
    LOG_BUFFER="${LOG_BUFFER}$*\n"
}

################################
# calculate the expression
# $1 -- index of the expression
# $2 -- the first operand 
# $3 -- the second operand 
# $4 -- operator for expression: +-*/
################################
function callCalc() {
    v=""
    operand1=$2
    operand2=$3
    operator=$4

    # user must input a valid value
    while [ ${#v} -eq 0 ]
    do
        read -p "$1 ${operand1}${operator}${operand2}=" v
    done

    # calculate the result of expression
    r=$(echo "${operand1}${operator}${operand2}"|bc)
    # compare the result user input and computer calculates
    f=$(echo "${r} == ${v}"|bc)

    if [ ${f} = 1 ]; then
        log "✔ ${operand1}${operator}${operand2}=${v}"
    else
        log "✘ ${operand1}${operator}${operand2}=${v}(${r})"
    fi
    # return the compare result
    return ${f}
}

################################
# calculate the total time to spend
# $1 -- begin time 
# $2 -- end time
# return the total time to used
################################
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
