#!/usr/bin/env bash

# 房间内 100 个人，每人有 100 块
# 每分钟随机给另一个人 1 块
# 最后这个房间内的财富分布是怎样的？
# spark 命令来自 https://github.com/holman/spark

declare -ia p

declare -i times=0
declare -i max=100
declare -i min=100

max_min() {
    max=${p[0]}
    min=${p[1]}
    for num in ${p[*]}; do
        (( max = num > max ? num : max ))
        (( min = num < min ? num : min ))
    done
}

for(( i = 0; i < 100; i++ )); do
    p[i]=100
done

while [[ ${times} -lt 10000 ]]; do
    let times++
    for(( i = 0; i < 100; i++)); do
        let other=${RANDOM}%100
        while [[ ${other} -eq ${i} ]]; do
            let other=${RANDOM}%100
        done

        if [[ p[i] -gt 0 ]]; then
            let p[i]=p[i]-1
            let p[other]=p[other]+1
        fi
    done

    max_min

    printf "\r%s -times:%d -max:%d -min:%d" $(spark ${p[*]}) ${times} ${max} ${min}
done
