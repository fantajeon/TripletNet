#!/bin/bash

#CUDA_VISIBLE_DEVICES=3 th Main.lua -load /data1/fantajeon/torch/TripletNet/Results/FriMar1817:20:512016/Weights.t718 
#CUDA_VISIBLE_DEVICES=2 th Main.lua -port 8802
CUDA_VISIBLE_DEVICES=2 th Main.lua -port 8802 -distance_ratio 0.001 -distance_increment 0.0003 -increment_policy
