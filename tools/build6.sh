#!/bin/bash
# uso: build6.sh <prefixo> <peças...>   (rode da raiz do repositório; "asm_" -> build/asm6, "" -> build/print6)
pre="$1"; shift; SCAD=${SCAD:-scad/camcorder_rig_v6.scad}
dir=$([ -n "$pre" ] && echo build/asm6 || echo build/print6)
mkdir -p $dir
for p in "$@"; do
  ( s=$(date +%s); openscad -q -D "PART=\"${pre}$p\"" -o $dir/$p.stl "$SCAD" > $dir/$p.log 2>&1; rc=$?; [ -s $dir/$p.stl ] || rc=1; echo "$p $(( $(date +%s)-s ))s exit=$rc" ) &
done
wait
