#!/bin/bash

#CUDA_VISIBLE_DEVICES=3 th MainLoadFeature.lua -feature_list ./result_128D.out -model './Results/WedMar2314:56:452016/Embedding.t715'
CUDA_VISIBLE_DEVICES=3 th MainLoadFeature.lua -feature_list ./result_128D.out -model './Results/FriApr817:32:232016/tripletnet.best.t7' 
